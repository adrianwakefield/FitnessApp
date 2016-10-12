//
//  RegisterVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 16/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterVC: UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // KEYBOARD OBSERVER FUNCTIONS
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size.height
        loginViewCenterConstraint?.isActive = false
        loginViewBottomConstraint = loginView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -(keyboardHeight+15))
        loginViewBottomConstraint?.isActive = true
    }
    
    func keyboardWillHide(_ notification: Notification) {
        loginViewBottomConstraint?.isActive = false
        loginViewCenterConstraint?.isActive = true
    }
    
    // VIEW CREATION
    
    lazy var backButton: UIImageView = {
        let backButton = UIImageView()
        backButton.image = UIImage(named: "backButton")
        backButton.image = backButton.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.tintColor = .white
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterVC.goBackToLoginScreen)))
        return backButton
    }()
    
    let runningImage: UIImageView = {
        let runningImage = UIImageView()
        runningImage.image = UIImage(named: "bg")
        runningImage.contentMode = .scaleAspectFill
        runningImage.isUserInteractionEnabled = true
        runningImage.translatesAutoresizingMaskIntoConstraints = false
        return runningImage
    }()
    
    let loginView: UIView = {
        let loginView = UIView()
        loginView.backgroundColor = .white
        loginView.layer.cornerRadius = 10
        loginView.layer.masksToBounds = true
        loginView.translatesAutoresizingMaskIntoConstraints = false
        return loginView
    }()
    
    let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "REGISTER"
        welcomeLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightUltraLight)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        return welcomeLabel
    }()
    
    let nameView: UIView = {
        let nameView = UIView()
        nameView.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        nameView.layer.borderWidth = 1
        nameView.translatesAutoresizingMaskIntoConstraints = false
        return nameView
    }()

    let usernameView: UIView = {
        let usernameView = UIView()
        usernameView.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        usernameView.layer.borderWidth = 1
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        return usernameView
    }()
    
    let passwordView: UIView = {
        let passwordView = UIView()
        passwordView.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        passwordView.layer.borderWidth = 1
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        return passwordView
    }()
    
    let nameImage: UIImageView = {
        let nameImage = UIImageView()
        nameImage.image = UIImage(named: "user")
        nameImage.translatesAutoresizingMaskIntoConstraints = false
        return nameImage
    }()
    
    let userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "email")
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()
    
    let passwordImage: UIImageView = {
        let passwordImage = UIImageView()
        passwordImage.image = UIImage(named: "lock")
        passwordImage.translatesAutoresizingMaskIntoConstraints = false
        return passwordImage
    }()
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        nameTextField.placeholder = "NAME"
        nameTextField.autocorrectionType = .no
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    let usernameTextField: UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.placeholder = "EMAIL"
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        return usernameTextField
    }()
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = UIColor(red: 120/255, green: 189/255, blue: 214/255, alpha: 1)
        loginButton.setTitleColor(.black, for: UIControlState())
        loginButton.setTitle("REGISTER", for: UIControlState())
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(RegisterVC.handleUserSignup), for: .touchUpInside)
        return loginButton
    }()
    
    // USER REGISTRATION / SIGNUP FUNCTIONS
    
    func handleUserSignup() {
        guard let name = nameTextField.text, let email = usernameTextField.text, let password = passwordTextField.text else {
            print("error in getting values from register screen")
            return
        }
        
        // Send user info to server
        APIService.sharedInstance.createNewUser(name: name, email: email, password: password) { (success) in
            if success == true {
                self.segueToProfileScreen()
            }
            else {
                print("Error creating new user")
            }
        }
    }
    
    // DISPLAY OTHER SCREEN FUNCTIONS

    func segueToProfileScreen() {
        let vc = MyProfileVC()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }

    func goBackToLoginScreen() {
        let vc = LoginVC()
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(runningImage)
        runningImage.addSubview(backButton)
        runningImage.addSubview(loginView)
        loginView.addSubview(welcomeLabel)
        loginView.addSubview(nameView)
        nameView.addSubview(nameImage)
        nameView.addSubview(nameTextField)
        loginView.addSubview(usernameView)
        usernameView.addSubview(userImage)
        usernameView.addSubview(usernameTextField)
        loginView.addSubview(passwordView)
        passwordView.addSubview(passwordImage)
        passwordView.addSubview(passwordTextField)
        loginView.addSubview(loginButton)
    }
    
    var loginViewBottomConstraint: NSLayoutConstraint?
    var loginViewCenterConstraint: NSLayoutConstraint?
    
    func setupConstraints() {
        runningImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runningImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        runningImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        runningImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: runningImage.leftAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginView.centerXAnchor.constraint(equalTo: runningImage.centerXAnchor).isActive = true
        loginViewCenterConstraint = loginView.centerYAnchor.constraint(equalTo: runningImage.centerYAnchor)
        loginViewCenterConstraint?.isActive = true
        loginView.widthAnchor.constraint(equalTo: runningImage.widthAnchor, constant: -70).isActive = true
        loginView.heightAnchor.constraint(equalTo: runningImage.heightAnchor, multiplier: 1/2).isActive = true
        
        welcomeLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 15).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: nameView.topAnchor, constant: -15).isActive = true
        
        nameView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: usernameView.topAnchor, constant: -15).isActive = true
        nameView.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameImage.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 10).isActive = true
        nameImage.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        nameImage.widthAnchor.constraint(equalTo: nameImage.heightAnchor).isActive = true
        nameImage.heightAnchor.constraint(equalTo: nameView.heightAnchor, multiplier: 1/2).isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo: nameImage.rightAnchor, constant: 10).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: nameView.rightAnchor, constant: -10).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameView.heightAnchor, constant: -10).isActive = true
        
        usernameView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        usernameView.bottomAnchor.constraint(equalTo: passwordView.topAnchor, constant: -15).isActive = true
        usernameView.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        usernameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        userImage.leftAnchor.constraint(equalTo: usernameView.leftAnchor, constant: 10).isActive = true
        userImage.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor).isActive = true
        userImage.heightAnchor.constraint(equalTo: usernameView.heightAnchor, multiplier: 1/2).isActive = true
        
        usernameTextField.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: usernameView.rightAnchor, constant: -10).isActive = true
        usernameTextField.heightAnchor.constraint(equalTo: usernameView.heightAnchor, constant: -10).isActive = true
        
        passwordView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        passwordView.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -15).isActive = true
        passwordView.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        passwordView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordImage.leftAnchor.constraint(equalTo: passwordView.leftAnchor, constant: 10).isActive = true
        passwordImage.centerYAnchor.constraint(equalTo: passwordView.centerYAnchor).isActive = true
        passwordImage.widthAnchor.constraint(equalTo: passwordImage.heightAnchor).isActive = true
        passwordImage.heightAnchor.constraint(equalTo: passwordView.heightAnchor, multiplier: 1/2).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: passwordImage.rightAnchor, constant: 10).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: passwordView.centerYAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: passwordView.rightAnchor, constant: -10).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: passwordView.heightAnchor, constant: -10).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -15).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
