//
//  ComposeMessageController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/7.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
    
    var users = [User]()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
        
        fetchUser()

    }
    
    func fetchUser() {
        // asynchronously retrieve all documents
        AppDelegate.db.collection("users").getDocuments { (querySnap, error) in
            if let error = error {
                print("Error fetching user documents: \(error)")
            } else {
                for document in querySnap!.documents {
                    // the document data is a dictionary storing user info
                    let dataDic = document.data()
                    print("\(document.documentID) => \(dataDic)")
                    let user = User()
                    user.name = dataDic["name"] as? String
                    user.email = dataDic["email"] as? String
                    self.users.append(user)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = users[indexPath.row].name
        cell?.detailTextLabel?.text = users[indexPath.row].email
        
        return cell!
    }

}
