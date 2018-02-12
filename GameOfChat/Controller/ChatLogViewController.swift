//
//  ChatLogViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/12.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class ChatLogViewController: UIViewController {
    
    lazy var messageField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add a table view to the root view
        setupTableView()
        // add the message box
        setupMessageBox()
        
    }

    fileprivate func setupTableView() {
        let tableView = UITableView()
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
            let values = [
                "message" : message
            ]
            AppDelegate.db.collection("messages").addDocument(data: values, completion: { (error) in
                if let error = error {
                    print("Error sending message: \(error)")
                    return
                }
                // message sent successfully!!! we may retrieve it and show it in the chat window
            })
            
        } else {
            print("不能发送空消息！")
        }
    }

}

extension ChatLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

extension ChatLogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // send the message in the box
        messageField.resignFirstResponder()
        return true
    }
}
