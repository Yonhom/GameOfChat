//
//  FirebaseUtil.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/9.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class FirebaseUtil {
    // @escaping tell the compiler that the completion block can be stored and captured by this function
    static func fetchCurrentUserInfoWithCompletionCallBack(completion: @escaping (User?, Error?) -> ()) {
        if let curUser = Auth.auth().currentUser {
            AppDelegate.db.collection("users").document(curUser.uid).getDocument {
                (docShot, error) in
                if error != nil {
                    completion(nil, error)
                    return
                }
                let dataDic = docShot!.data()
                if let dataDic = dataDic {
                    let tempUser = User()
                    tempUser.name = dataDic["name"] as? String
                    tempUser.email = dataDic["email"] as? String
                    tempUser.profileUrl = dataDic["profileUrl"] as? String
                    completion(tempUser, nil)
                }
                completion(nil, nil)
            }
        } else {
            completion(nil, nil)
        }
    }
}


