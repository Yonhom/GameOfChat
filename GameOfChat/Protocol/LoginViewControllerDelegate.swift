//
//  LoginViewControllerDelegate.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/9.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidRegisterWithUser(user: User)
    
    func loginViewControllerDidLoginWithUser(user: User)
}
