//
//  LoginViewController.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/6.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
        textField.clearButtonMode = .whileEditing
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
        textField.clearButtonMode = .whileEditing
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
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // register button
    lazy var loginOrRegisterBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(rgb: 0x516599)
        button.addTarget(self, action: #selector(loginOrRegisterClicked), for: .touchUpInside)
        return button
    }()
    
    // login/register segment
    lazy var loginRegisterSegment: UISegmentedControl = {
        let loginRegisterSegment = UISegmentedControl(items: ["登录", "注册"]);
        loginRegisterSegment.tintColor = UIColor.white
        loginRegisterSegment.selectedSegmentIndex = 1
        loginRegisterSegment.translatesAutoresizingMaskIntoConstraints = false
        
        loginRegisterSegment.addTarget(self, action: #selector(loginRegisterSegmentToggled), for: .valueChanged)
        
        return loginRegisterSegment
    }()
    
    func login() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("the form content format is not valid!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("There is a error signing in: \(error!)")
                return
            }
            
            // successfully signed in!
            print("SIgned in with email: \(user?.email)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func register() {
        guard let username = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("the form content format is not valid!")
            return
        }
        
        // create user with email and password, if successfully, the user is automatically signed in
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let err = error {
                print("There is a error creating new user: \(err)")
                return
            }
            
            if let user = user {
                print("This is the user info after the user is successfully registered or logged in: uid=\(user.uid), email=\(user.email!)")
                
                // save user info to firebase firestore
                var ref: DocumentReference? = nil
                ref = AppDelegate.db.collection("users").addDocument(data:[
                    "name" : username,
                    "email":email
                ]) { err in
                    if err != nil {
                        print("Error adding document: \(err)")
                        // removing (and signing out the current user if there is one) the user added to auth
                        user.delete(completion: { (error) in
                            print("Error deleting the ill-registered user: \(error)")
                        })
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        // jump to main page
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
            
        }
    }
    
    // logo image
    lazy var loginLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_logo"))
        imageView.contentMode = .scaleAspectFit
        // in gesture recognizer, to refer to self the property has to be a lazy variable, or the invocation wont work
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickProfileImage)))
        imageView.isUserInteractionEnabled = true

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
        
        // add the segment
        view.addSubview(loginRegisterSegment)
        setupRegisterLoginSegment()
        
        // add the logo
        view.addSubview(loginLogo)
        loginLogo.translatesAutoresizingMaskIntoConstraints = false
        setupLoginLogo()
        
        
    }
    
    func setupRegisterLoginSegment() {
        loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegment.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegment.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupLoginLogo() {
        loginLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLogo.bottomAnchor.constraint(equalTo: loginRegisterSegment.topAnchor, constant: -40).isActive = true
        loginLogo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginLogo.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginOrRegisterBtn() {
        loginOrRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrRegisterBtn.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginOrRegisterBtn.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginOrRegisterBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    /**
    *  height constraint for changing the height of the container elsewhere
     */
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    
    /**
     *  height constraint for changing the height of the name field elsewhere
     */
    var nameFieldHeightConstraint: NSLayoutConstraint?
    var nameFieldHeightZeroConstraint: NSLayoutConstraint?
    
    var emailFieldHeightConstraint: NSLayoutConstraint?
    var emailFieldHeightHalfOfContainerConstraint: NSLayoutConstraint?
    
    var passwordFieldHeightConstraint: NSLayoutConstraint?
    var passwordFieldHeightHalfOfContainerConstraint: NSLayoutConstraint?

    func setupInputContainerView() {
        // set up constraints for the input container
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        inputContainerViewHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightConstraint?.isActive = true
        
        // add nameTextField into input container
        inputContainerView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        // set up constraints for name text field
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        
        nameFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameFieldHeightConstraint?.isActive = true
        // the zero height constraint is for making the name field disappear when the login segment is selected
        nameFieldHeightZeroConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0/3)
        nameFieldHeightZeroConstraint?.isActive = false
        
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
        emailFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailFieldHeightConstraint?.isActive = true
        emailFieldHeightHalfOfContainerConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        emailFieldHeightHalfOfContainerConstraint?.isActive = false
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
        passwordFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordFieldHeightConstraint?.isActive = true
       passwordFieldHeightHalfOfContainerConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        passwordFieldHeightHalfOfContainerConstraint?.isActive = false
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

}


















