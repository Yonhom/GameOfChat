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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a logout bar buttom item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注销登录", style: .plain, target: self, action: #selector(logout))
        
        // add a 'fire up a chat' icon item
        let composeImage = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: composeImage, style: .plain, target: self, action: #selector(openComposeMessagePage))
        
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
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(naviTitleTapped)))
    }
    
    @objc func naviTitleTapped() {
        print("navi title tapped!!!")
        let chatLogController = ChatLogViewController()
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func openComposeMessagePage() {
        let composeNavi = UINavigationController(rootViewController: UserListController())
        present(composeNavi, animated: true, completion: nil)
    }
    
    @objc func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error {
                print("There is a error logging out: \(error)")
            }
        }
        
        let loginVC = LoginViewController()
        // set the current controller as the login controller's delegate, so the login controller can send message to the message controller without knowing its existence
        loginVC.delegate = self
        present(loginVC, animated: true, completion: nil)
    }

}

extension MessageViewController: LoginViewControllerDelegate {
    func loginViewControllerDidRegisterWithUser(user: User) {
        setupNaviBar(with: user)
    }
    
    func loginViewControllerDidLoginWithUser(user: User) {
        setupNaviBar(with: user)
    }
    
    
    
    
}




