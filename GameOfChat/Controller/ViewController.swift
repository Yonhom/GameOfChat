//
//  ViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/6.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a logout bar buttom item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注销登录", style: .plain, target: self, action: #selector(logout))
        
        // to see if there is a current user. if not jump to login page
        if Auth.auth().currentUser == nil {
            logout()
        }
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
        present(loginVC, animated: true, completion: nil)
    }

}

