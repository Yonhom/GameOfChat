//
//  UserListViewControllerDelegate.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/22.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

protocol UserListViewControllerDelegate: class {
    
    func didSelectUser(user: User)
}
