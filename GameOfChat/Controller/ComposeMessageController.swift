//
//  ComposeMessageController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/7.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
        
        fetchUser()

    }
    
    func fetchUser() {
        
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

}
