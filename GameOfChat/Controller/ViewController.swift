//
//  ViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/6.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a logout bar buttom item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注销登录", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

