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
    
    weak var delegate: UserListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
        
        // register custom usercell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()

    }
    
    func fetchUser() {
        // asynchronously retrieve all documents
        AppDelegate.db.collection("users").addSnapshotListener { (querySnap, error) in
            if let error = error {
                print("Error fetching user documents: \(error)")
            } else {
                // remove old cached user data before refreshing
                self.users.removeAll()
                
                for document in querySnap!.documents {
                    // the document data is a dictionary storing user info
                    let dataDic = document.data()
                    print("\(document.documentID) => \(dataDic)")
                    let user = User()
                    user.name = dataDic["name"] as? String
                    user.email = dataDic["email"] as? String
                    user.profileUrl = dataDic["profileUrl"] as? String
                    user.id = document.documentID  // the user id 
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].email
        
        // profile image
        if let imageUrlStr = users[indexPath.row].profileUrl {
            // load image using imageview custom extension with a cache image capability, habahaba!!!
            cell.profileImageView.loadCachedImageWithUrl(imageUrlStr: imageUrlStr)

        } else { // if the user dont have a profile image url, set its image to nil to present image mis-reuse
            cell.profileImageView.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            // push the chat log view controller to navigation stack
            // delegate?.pushViewControllerWithUser...
            self.delegate?.didSelectUser(user: self.users[indexPath.row])
        }
    }

}
