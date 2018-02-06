//
//  LoginViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/6.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // property initialized with a anonymous closure
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "姓名"
        return textField
    }()
    let nameTextFieldSeprator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xEEEEEE)
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "邮件"
        return textField
    }()
    let emailTextFieldSeprator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xEEEEEE)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "密码"
        return textField
    }()
    
    // register button
    let loginOrRegisterBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(rgb: 0x516599)
        return button
    }()
    
    // logo image
    let loginLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LOGIN_BG_COLOR
        
        // add a input container view
        view.addSubview(inputContainerView)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        setupInputContainerView()
        
        // add the register/login button
        view.addSubview(loginOrRegisterBtn)
        loginOrRegisterBtn.translatesAutoresizingMaskIntoConstraints = false
        setupLoginOrRegisterBtn()
        
        // add the logo
        view.addSubview(loginLogo)
        loginLogo.translatesAutoresizingMaskIntoConstraints = false
        setupLoginLogo()
    }
    
    func setupLoginLogo() {
        loginLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLogo.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -60).isActive = true
        loginLogo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginLogo.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginOrRegisterBtn() {
        loginOrRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrRegisterBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginOrRegisterBtn.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginOrRegisterBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func setupInputContainerView() {
        // set up constraints for the input container
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // add nameTextField into input container
        inputContainerView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        // set up constraints for name text field
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        // add and set constaints for the name text field separator
        inputContainerView.addSubview(nameTextFieldSeprator)
        nameTextFieldSeprator.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldSeprator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameTextFieldSeprator.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameTextFieldSeprator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldSeprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // add and set the constraints for email textfield and separator
        inputContainerView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        inputContainerView.addSubview(emailTextFieldSeprator)
        emailTextFieldSeprator.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldSeprator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailTextFieldSeprator.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldSeprator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldSeprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // add and set the password textfield to the input container view
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }

}


















