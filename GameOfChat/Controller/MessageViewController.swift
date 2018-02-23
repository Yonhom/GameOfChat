//
//  ViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/6.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UITableViewController {
    
    var cellId = "cellId"
    
    var messages = [Message]()
    
    // MARK: - message dictionary with unique user id
    var messageDic = [String:Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a logout bar buttom item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注销登录", style: .plain, target: self, action: #selector(logout))
        
        // add a 'fire up a chat' icon item
        let composeImage = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: composeImage, style: .plain, target: self, action: #selector(presentUserList))
        
        // to see if there is a current user. if not jump to login page
        if Auth.auth().currentUser == nil {
            logout()
            return
        }
        
        // add a user profile icon and name to the center of the navigation bar
        FirebaseUtil.fetchCurrentUserInfoWithCompletionCallBack { (user, error) in
            if error != nil {
                return
            }
            if let user = user {
                self.setupNaviBar(with: user)
            }
        }
        
        // fatch chat log
//        fetchChatLog()
        fetchChatLogForCurrentUser()
        
        // register reusable table view cell
        tableView.register(ImageTitleDetailCell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchChatLogForCurrentUser() {
        if let currentUid = Auth.auth().currentUser?.uid {
            AppDelegate.db.collection("user-messages").document(currentUid).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error!)
                    return
                }
                // when the new user has not sent or received any messages, the userMesData for that uid is nil, in this case, bail out
                if let userMesData = snapshot!.data() {
                    let messageIds = userMesData.keys
                    for messageId in messageIds {
                        print("message id related to current user: \(messageId)")
                        // use those message id related to the current user to fetch conversations
                        AppDelegate.db.collection("messages").document(messageId).addSnapshotListener({ (snapshot, error) in
                            
                            if let error = error {
                                print("Error fetching messages: \(error)")
                            } else  {
                                
                                let dataDic = snapshot!.data()!
                                let msg = Message()
                                msg.fromUser = dataDic["fromUser"] as? String
                                msg.toUser = dataDic["toUser"] as? String
                                msg.timeStamp = dataDic["timeStamp"] as? NSNumber
                                msg.message = dataDic["message"] as? String
                                // messages with unique user id
                                self.messageDic[msg.toUser!] = msg
                                // add the filter messages to messages array
                                self.messages = Array(self.messageDic.values)
                                self.messages.sort(by: { (message1, message2) -> Bool in
                                    return message1.timeStamp!.intValue > message2.timeStamp!.intValue
                                })
                                
                                self.tableView.reloadData()
                            }
                            
                        })
                    }
                }
            }
        }
        
    }
    
    @available(*, deprecated: 1.0, message: "Already unavailable, use fetchChatLogForCurrentUser() instead!")
    func fetchChatLog() {
        AppDelegate.db.collection("messages").addSnapshotListener { (queryShot, error) in
            
            if let error = error {
                print("Error fetching messages: \(error)")
            } else  {
                
                for document in queryShot!.documents {
                    let dataDic = document.data()
                    let msg = Message()
                    msg.fromUser = dataDic["fromUser"] as? String
                    msg.toUser = dataDic["toUser"] as? String
                    msg.timeStamp = dataDic["timeStamp"] as? NSNumber
                    msg.message = dataDic["message"] as? String
                    
                    // messages with unique user id
                    self.messageDic[msg.toUser!] = msg
                    // add the filter messages to messages array
                    self.messages = Array(self.messageDic.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timeStamp!.intValue > message2.timeStamp!.intValue
                    })
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func setupNaviBar(with user: User) {
        // this title view  size info will be reset,so has to create a custom view to size its size to be as big as possible if that occurred
        let titleView = TitleView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        navigationItem.titleView = titleView
        
        // set up a resizable container view for custom view, the resizable feature is for autolayout
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        // add a profile image to the container view
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.masksToBounds = true
        if let imageUrl = user.profileUrl {
            profileImageView.loadCachedImageWithUrl(imageUrlStr: imageUrl)
        }
        containerView.addSubview(profileImageView)
        // profile image constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // add user name title to the container view
        let nameLabel = UILabel()
        if let name = user.name {
            nameLabel.text = name
        }
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        // make the container view stay in the center of the titleView
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        
        // make the naviView responsive to touch
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLog)))
    }
    
    @objc func showChatLogWithUser(user: User) {
        let chatLogController = ChatLogViewController()
        chatLogController.withUser = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func presentUserList() {
        let userListController = UserListController()
        userListController.delegate = self
        let composeNavi = UINavigationController(rootViewController: userListController)
        present(composeNavi, animated: true, completion: nil)
    }
    
    @objc func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error {
                print("There is a error logging out: \(error)")
                return
            }
        }
        
        // clear cache data in messages & messageDic
        self.messages.removeAll()
        self.messageDic.removeAll()
        
        // refresh the table view
        tableView.reloadData()
        
        let loginVC = LoginViewController()
        // set the current controller as the login controller's delegate, so the login controller can send message to the message controller without knowing its existence
        loginVC.delegate = self
        present(loginVC, animated: true, completion: nil)
    }
    
    // MARK: - table view delegate & data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ImageTitleDetailCell
        // set the message to show in the cell
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
// MARK: - things done for login view controller
extension MessageViewController: LoginViewControllerDelegate {
    func loginViewControllerDidRegisterWithUser(user: User) {
        setupNaviBar(with: user)
        fetchChatLogForCurrentUser()  // every time a user logged fetch the message for that user
    }
    
    func loginViewControllerDidLoginWithUser(user: User) {
        setupNaviBar(with: user)
        fetchChatLogForCurrentUser()
    }
    
}

// MARK: - things done for chat list view controller
extension MessageViewController: UserListViewControllerDelegate {
    func didSelectUser(user: User) {
        // here a user from user list controller is tapped, we push a chat log controller for the user
        showChatLogWithUser(user: user)
    }
    
    
}




