//
//  ViewController.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 16/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        USERDEFAULTS.removeObject(forKey: "userId")
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        usernameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkIfUserIsLoggedIn() {
        if USERDEFAULTS.object(forKey: "userId") != nil {
            let userId = USERDEFAULTS.object(forKey: "userId") as! String
            print("userID = \(userId)")
            APIService.sharedInstance.returnUser(id: userId, completionHandler: { (success) in
                if success == true {
                    let vc = MyProfileVC()
                    let navVC = UINavigationController(rootViewController: vc)
                    self.present(navVC, animated: true, completion: nil)
                }
            })
        }
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
        welcomeLabel.text = "LOGIN"
        welcomeLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightUltraLight)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        return welcomeLabel
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
    
    let usernameTextField: UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        usernameTextField.placeholder = "EMAIL"
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        return usernameTextField
    }()

    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = UIColor(red: 120/255, green: 189/255, blue: 214/255, alpha: 1)
        loginButton.setTitleColor(.black, for: UIControlState())
        loginButton.setTitle("LOGIN", for: UIControlState())
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(LoginVC.handleLogin), for: .touchUpInside)
        return loginButton
    }()
    
    lazy var registerLabel: UIButton = {
        let registerLabel = UIButton(type: .system)
        registerLabel.setTitleColor(.black, for: UIControlState())
        registerLabel.titleLabel?.textAlignment = .center
        registerLabel.setTitle("Don't have an account? Register here.", for: UIControlState())
        registerLabel.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.addTarget(self, action: #selector(LoginVC.handleRegister), for: .touchUpInside)
        return registerLabel
    }()
    
    // LOGIN HANDLING FUNCTIONS
    
    func handleLogin() {
        validateLogin()
    }
    
    func validateLogin() {
        guard let emailField = usernameTextField.text, let passwordField = passwordTextField.text else {
            print("Error")
            return
        }
        
        if emailField.isEmpty == true || passwordField.isEmpty == true {
            print("Empty field(s)")
        }
            
        else {
            APIService.sharedInstance.loginUser(email: emailField, password: passwordField, completionHandler: { (success) in
                if success == true {
                    self.segueToProfile()
                }
                else {
                    print("error")
                }
            })
        }
    }
    
    func segueToProfile() {
        let vc = MyProfileVC()
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true, completion: nil)
    }

    // DISPLAYING OTHER SCREEN FUNCTIONS
    
    func handleRegister() {
        let vc = RegisterVC()
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(runningImage)
        runningImage.addSubview(loginView)
        loginView.addSubview(welcomeLabel)
        loginView.addSubview(usernameView)
        usernameView.addSubview(userImage)
        usernameView.addSubview(usernameTextField)
        loginView.addSubview(passwordView)
        passwordView.addSubview(passwordImage)
        passwordView.addSubview(passwordTextField)
        loginView.addSubview(loginButton)
        loginView.addSubview(registerLabel)
    }
    
    var loginViewBottomConstraint: NSLayoutConstraint?
    var loginViewCenterConstraint: NSLayoutConstraint?
    
    func setupConstraints() {
        runningImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runningImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        runningImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        runningImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        loginView.centerXAnchor.constraint(equalTo: runningImage.centerXAnchor).isActive = true
        loginViewCenterConstraint = loginView.centerYAnchor.constraint(equalTo: runningImage.centerYAnchor)
        loginViewCenterConstraint?.isActive = true
        loginView.widthAnchor.constraint(equalTo: runningImage.widthAnchor, constant: -70).isActive = true
        loginView.heightAnchor.constraint(equalTo: runningImage.heightAnchor, multiplier: 1/2).isActive = true
        
        welcomeLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 15).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: usernameView.topAnchor, constant: -15).isActive = true

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
        loginButton.bottomAnchor.constraint(equalTo: registerLabel.topAnchor, constant: -10).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        registerLabel.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -15).isActive = true
        registerLabel.widthAnchor.constraint(equalTo: loginView.widthAnchor, constant: -30).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

