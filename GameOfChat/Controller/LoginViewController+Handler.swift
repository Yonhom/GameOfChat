//
//  LoginViewController+Handler.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/8.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - profile image picking related
    @objc func pickProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // the selected image can be edit with the system's editor
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // set the picked image to the login logo
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            loginLogo.image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            loginLogo.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - form layout related
    @objc func loginRegisterSegmentToggled() {
        print("\(loginRegisterSegment.titleForSegment(at: loginRegisterSegment.selectedSegmentIndex)!) selected!")
        
        // button title
        loginOrRegisterBtn.setTitle(loginRegisterSegment.titleForSegment(at: loginRegisterSegment.selectedSegmentIndex), for: .normal)
        
        // dynamic container height
        let inputContainterHeight = self.loginRegisterSegment.selectedSegmentIndex == 0 ? 100.0 : 150.0
        self.inputContainerViewHeightConstraint?.constant = CGFloat(inputContainterHeight)
        
        // dynamic textfield height
        if self.loginRegisterSegment.selectedSegmentIndex == 0 {
            self.nameFieldHeightZeroConstraint?.isActive = true
            self.nameFieldHeightConstraint?.isActive = false
            
            self.emailFieldHeightConstraint?.isActive = false
            self.emailFieldHeightHalfOfContainerConstraint?.isActive = true
            
            self.passwordFieldHeightConstraint?.isActive = false
            self.passwordFieldHeightHalfOfContainerConstraint?.isActive = true
        } else {
            self.nameFieldHeightZeroConstraint?.isActive = false
            self.nameFieldHeightConstraint?.isActive = true
            
            self.emailFieldHeightConstraint?.isActive = true
            self.emailFieldHeightHalfOfContainerConstraint?.isActive = false
            
            self.passwordFieldHeightConstraint?.isActive = true
            self.passwordFieldHeightHalfOfContainerConstraint?.isActive = false
        }
        
        // animation all the constraints changes
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    // MARK: - register/login action 
    @objc func loginOrRegisterClicked() {
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            login()
        } else {
            register()
        }
        
    }
    
}
