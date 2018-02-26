//
//  ChatLogViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/12.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController {
    
    /**
    * the info of the user with which the current user have engaged conversation
    * the user the current user is talking to
    */
    var withUser: User?
    var withUserMessages = [Message]()
    
    let cellId = "cellId"
    
    lazy var messageField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a table view to the root view
        setupTableView()
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // add the message box
        setupMessageBox()
        
        // set up the navigation bar title with the name of user with which the current user have engaged conversion
        title = withUser?.name
        
        // get all the messages the withUser is related to
        fetchMessagesRelatedToWithUser()
        
    }
    
    func fetchMessagesRelatedToWithUser() {
        if withUser == nil {
            print("withUser cannnot be nil!")
            return
        }
        AppDelegate.db.collection("user-messages").document(withUser!.id!).addSnapshotListener { (docShot, error) in
            if error != nil {
                print("error fetching user-messages: \(error)")
                return
            }
            
            let userMesData = docShot!.data()
            guard let messageIds = userMesData?.keys else { return }
            for messageId in messageIds {
                // get the message with all the message id
                AppDelegate.db.collection("messages").document(messageId).getDocument(completion: { (docShot, error) in
                    if error != nil {
                        print("error fetching withUser related messages: \(error)")
                        return
                    }
                    
                    let withUserMesData = docShot!.data()!
                    let message = Message()
                    message.fromUser = withUserMesData["fromUser"] as? String
                    message.toUser = withUserMesData["toUser"] as? String
                    message.timeStamp = withUserMesData["timeStamp"] as? NSNumber
                    message.message = withUserMesData["message"] as? String
                    
                    // if the current user id is in either the fromUser or the toUser, append the message to user messages
                    guard let currentId = Auth.auth().currentUser?.uid else{ return }
                    if (currentId == message.fromUser! || currentId == message.toUser!) {
                        self.withUserMessages.append(message)
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    var tableView: UITableView!

    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func setupMessageBox() {
        let messageBox = UIView()
        messageBox.translatesAutoresizingMaskIntoConstraints = false
        messageBox.backgroundColor = .white
        view.addSubview(messageBox)
        messageBox.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageBox.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageBox.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageBox.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // add a send btn to the message box
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        messageBox.addSubview(sendBtn)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.rightAnchor.constraint(equalTo: messageBox.rightAnchor).isActive = true
        sendBtn.topAnchor.constraint(equalTo: messageBox.topAnchor).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: messageBox.bottomAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // add a text field for sending message
        messageBox.addSubview(messageField)
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.leftAnchor.constraint(equalTo: messageBox.leftAnchor, constant: 8).isActive = true
        messageField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor, constant: -8).isActive = true
        messageField.topAnchor.constraint(equalTo: messageBox.topAnchor).isActive = true
        messageField.bottomAnchor.constraint(equalTo: messageBox.bottomAnchor).isActive = true
        
        // add a separator for the message box
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .lightGray
        messageBox.addSubview(seperator)
        seperator.leftAnchor.constraint(equalTo: messageBox.leftAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: messageBox.topAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: messageBox.rightAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
    }
    
    @objc func sendTapped() {
        // get the message in the message field and send it
        if let message = messageField.text, message != "" {
            
            // the message to send
            let fromId = Auth.auth().currentUser!.uid
            let toId = withUser!.id!
            let values = [
                "message" : message,
                "toUser" : toId,
                "fromUser" : fromId,
                "timeStamp" : NSDate().timeIntervalSince1970
                ] as [String : Any]
            
            var messageDocRef: DocumentReference?
            messageDocRef = AppDelegate.db.collection("messages").addDocument(data: values, completion: { (error) in
                if let error = error {
                    print("Error sending message: \(error)")
                    return
                }
                
                // add a user-messages nodes for tracking the message the current user care about
                // the message's id that the current user care about
                let messageId = messageDocRef!.documentID
                // add a new node under 'user-messages/curUid' for the reference to the message the current user just send
                AppDelegate.db.collection("user-messages").document(fromId).setData([messageId:1], options: SetOptions.merge()) // 'merge' will not overwrite the message with the same messageId
                // also add and associate receipient's id with the messageId, so when the receipient is logged in, even tho it may not have sent any message, it can still get the message sent to itself
                AppDelegate.db.collection("user-messages").document(toId).setData([messageId:1], options: SetOptions.merge())
            })
            
        } else {
            print("不能发送空消息！")
        }
    }

}

extension ChatLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withUserMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        cell.textLabel?.text = withUserMessages[indexPath.row].message
        return cell
    }

}

extension ChatLogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // send the message in the box
        messageField.resignFirstResponder()
        return true
    }
}
