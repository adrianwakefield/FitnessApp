//
//  MyProfileVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 30/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        setupUserInformation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let topProfileView: UIView = {
        let topProfileView = UIView()
        topProfileView.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        topProfileView.translatesAutoresizingMaskIntoConstraints = false
        return topProfileView
    }()
    
    let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Name of User"
        usernameLabel.textColor = .white
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    let levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.text = "Level 1"
        levelLabel.textAlignment = .center
        levelLabel.textColor = .white
        levelLabel.font = UIFont.boldSystemFont(ofSize: 17)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        return levelLabel
    }()
    
    let healthImageView: UIImageView = {
        let healthImageView = UIImageView()
        healthImageView.image = UIImage(named: "hearts_filled")?.withRenderingMode(.alwaysTemplate)
        healthImageView.tintColor = .red
        healthImageView.translatesAutoresizingMaskIntoConstraints = false
        return healthImageView
    }()
    
    let healthProgressBar: UIProgressView = {
        let healthProgressBar = UIProgressView()
        healthProgressBar.trackTintColor = .white
        healthProgressBar.progressTintColor = .red
        healthProgressBar.layer.cornerRadius = 5
        healthProgressBar.layer.masksToBounds = true
        healthProgressBar.translatesAutoresizingMaskIntoConstraints = false
        return healthProgressBar
    }()
    
    let expImageView: UIImageView = {
        let expImageView = UIImageView()
        expImageView.image = UIImage(named: "exp")?.withRenderingMode(.alwaysTemplate)
        expImageView.tintColor = .yellow
        expImageView.translatesAutoresizingMaskIntoConstraints = false
        return expImageView
    }()
    
    let expProgressBar: UIProgressView = {
        let expProgressBar = UIProgressView()
        expProgressBar.layer.cornerRadius = 5
        expProgressBar.layer.masksToBounds = true
        expProgressBar.trackTintColor = .white
        expProgressBar.progressTintColor = .yellow
        expProgressBar.translatesAutoresizingMaskIntoConstraints = false
        return expProgressBar
    }()
    
    let goldImage: UIImageView = {
        let goldImage = UIImageView()
        goldImage.image = UIImage(named: "coins_filled")?.withRenderingMode(.alwaysTemplate)
        goldImage.tintColor = .yellow
        goldImage.translatesAutoresizingMaskIntoConstraints = false
        return goldImage
    }()
    
    let goldAmountLabel: UILabel = {
        let goldAmountLabel = UILabel()
        goldAmountLabel.text = "0"
        goldAmountLabel.textColor = .white
        goldAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        return goldAmountLabel
    }()
    
    let distanceImage: UIImageView = {
        let distanceImage = UIImageView()
        distanceImage.image = UIImage(named: "distance")?.withRenderingMode(.alwaysTemplate)
        distanceImage.tintColor = .black
        distanceImage.translatesAutoresizingMaskIntoConstraints = false
        return distanceImage
    }()
    
    let distanceTravelledLabel: UILabel = {
        let distanceTravelledLabel = UILabel()
        distanceTravelledLabel.text = "0 KM"
        distanceTravelledLabel.textColor = .white
        distanceTravelledLabel.translatesAutoresizingMaskIntoConstraints = false
        return distanceTravelledLabel
    }()
    
    lazy var viewShopMenu: MenuView = {
        let viewShopMenu = MenuView(title: "VIEW SHOP", desc: "View the store and purchase items to use in your battles. As your experience and rewards increase, you can unlock more and more items.", imageName: "shop")
        viewShopMenu.translatesAutoresizingMaskIntoConstraints = false
        viewShopMenu.isUserInteractionEnabled = true
        viewShopMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewShop)))
        return viewShopMenu
    }()
    
    lazy var viewInventoryMenu: MenuView = {
        let viewInventoryMenu = MenuView(title: "VIEW INVENTORY", desc: "View your purchased items and use them during your battles. By dealing more damage ", imageName: "sword")
        viewInventoryMenu.translatesAutoresizingMaskIntoConstraints = false
        viewInventoryMenu.isUserInteractionEnabled = true
        viewInventoryMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewInventory)))
        return viewInventoryMenu
    }()
    
    lazy var viewRegionQuestButton: UIButton = {
        let viewRegionQuestButton = UIButton(type: .system)
        viewRegionQuestButton.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        viewRegionQuestButton.setTitleColor(.black, for: UIControlState())
        viewRegionQuestButton.setTitle("VIEW REGION QUEST", for: UIControlState())
        viewRegionQuestButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        viewRegionQuestButton.layer.cornerRadius = 5
        viewRegionQuestButton.translatesAutoresizingMaskIntoConstraints = false
        viewRegionQuestButton.addTarget(self, action: #selector(handleViewQuest), for: .touchUpInside)
        return viewRegionQuestButton
    }()
    
    lazy var viewLeaderBoardButton: UIButton = {
        let viewLeaderBoardButton = UIButton(type: .system)
        viewLeaderBoardButton.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        viewLeaderBoardButton.setTitleColor(.black, for: UIControlState())
        viewLeaderBoardButton.setTitle("VIEW LEADERBOARD", for: UIControlState())
        viewLeaderBoardButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        viewLeaderBoardButton.layer.cornerRadius = 5
        viewLeaderBoardButton.translatesAutoresizingMaskIntoConstraints = false
        viewLeaderBoardButton.addTarget(self, action: #selector(viewLeaderBoard), for: .touchUpInside)
        return viewLeaderBoardButton
    }()
    
    lazy var logoutButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: UIControlState())
        loginButton.setTitle("LOGOUT", for: UIControlState())
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return loginButton
    }()
    
    func handleLogout() {
        APPDELEGATE.currentUser = nil
        UserDefaults.standard.removeObject(forKey: "userId")
        dismiss(animated: true, completion: nil)
    }
    
    func setupUserInformation() {
        APIService.sharedInstance.returnUser(id: (APPDELEGATE.currentUser?.id!)!) { (success) in
            self.usernameLabel.text = (APPDELEGATE.currentUser?.name!)!
            self.levelLabel.text = "Level \((APPDELEGATE.currentUser?.level!)!)"
            self.healthProgressBar.progress = Float((APPDELEGATE.currentUser?.healthCurrent!)! / (APPDELEGATE.currentUser?.healthMax!)!)
            self.expProgressBar.progress = Float((APPDELEGATE.currentUser?.expCurrent!)! / (APPDELEGATE.currentUser?.expMax!)!)
            self.goldAmountLabel.text = "\((APPDELEGATE.currentUser?.gold!)!)"
            self.distanceTravelledLabel.text = "\((APPDELEGATE.currentUser?.distanceTotal!)!) KM"
        }
    }
    
    func viewShop() {
        let vc = ShopVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func viewInventory() {
        let vc = InventoryVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleViewQuest() {
        let vc = QuestVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func viewLeaderBoard() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let vc = LeaderboardVC(collectionViewLayout: layout)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        view.addSubview(topProfileView)
        topProfileView.addSubview(logoutButton)
        topProfileView.addSubview(usernameLabel)
        topProfileView.addSubview(avatarImageView)
        topProfileView.addSubview(levelLabel)
        topProfileView.addSubview(healthImageView)
        topProfileView.addSubview(healthProgressBar)
        topProfileView.addSubview(expImageView)
        topProfileView.addSubview(expProgressBar)
        topProfileView.addSubview(goldImage)
        topProfileView.addSubview(goldAmountLabel)
        topProfileView.addSubview(distanceImage)
        topProfileView.addSubview(distanceTravelledLabel)
        view.addSubview(viewShopMenu)
        view.addSubview(viewInventoryMenu)
        view.addSubview(viewLeaderBoardButton)
        view.addSubview(viewRegionQuestButton)
    }
    
    func setupConstraints() {
        topProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topProfileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topProfileView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topProfileView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        logoutButton.rightAnchor.constraint(equalTo: topProfileView.rightAnchor, constant: -10).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 10).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameLabel.centerXAnchor.constraint(equalTo: topProfileView.centerXAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topProfileView.topAnchor, constant: 35).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        avatarImageView.centerYAnchor.constraint(equalTo: topProfileView.centerYAnchor).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: topProfileView.leftAnchor, constant: 15).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        
        levelLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        levelLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 0).isActive = true
        levelLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        levelLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        healthImageView.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor).isActive = true
        healthImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15).isActive = true
        healthImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        healthImageView.heightAnchor.constraint(equalTo: healthImageView.widthAnchor).isActive = true
        
        expImageView.centerXAnchor.constraint(equalTo: healthImageView.centerXAnchor).isActive = true
        expImageView.topAnchor.constraint(equalTo: healthImageView.bottomAnchor, constant: 20).isActive = true
        expImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        expImageView.heightAnchor.constraint(equalTo: healthImageView.widthAnchor).isActive = true

        healthProgressBar.leftAnchor.constraint(equalTo: healthImageView.rightAnchor, constant: 10).isActive = true
        healthProgressBar.rightAnchor.constraint(equalTo: topProfileView.rightAnchor, constant: -20).isActive = true
        healthProgressBar.centerYAnchor.constraint(equalTo: healthImageView.centerYAnchor).isActive = true
        healthProgressBar.heightAnchor.constraint(equalTo: healthImageView.heightAnchor, constant: -10).isActive = true
        
        expProgressBar.leftAnchor.constraint(equalTo: expImageView.rightAnchor, constant: 10).isActive = true
        expProgressBar.rightAnchor.constraint(equalTo: topProfileView.rightAnchor, constant: -20).isActive = true
        expProgressBar.centerYAnchor.constraint(equalTo: expImageView.centerYAnchor).isActive = true
        expProgressBar.heightAnchor.constraint(equalTo: healthImageView.heightAnchor, constant: -10).isActive = true
        
        goldImage.centerXAnchor.constraint(equalTo: healthImageView.centerXAnchor, constant: -20).isActive = true
        goldImage.topAnchor.constraint(equalTo: expImageView.bottomAnchor, constant: 20).isActive = true
        goldImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        goldImage.heightAnchor.constraint(equalTo: goldImage.widthAnchor).isActive = true

        goldAmountLabel.leftAnchor.constraint(equalTo: goldImage.rightAnchor, constant: 10).isActive = true
        goldAmountLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        goldAmountLabel.centerYAnchor.constraint(equalTo: goldImage.centerYAnchor).isActive = true
        goldAmountLabel.heightAnchor.constraint(equalTo: goldImage.heightAnchor, constant: -10).isActive = true
        
        distanceImage.leftAnchor.constraint(equalTo: goldAmountLabel.rightAnchor, constant: 20).isActive = true
        distanceImage.topAnchor.constraint(equalTo: expImageView.bottomAnchor, constant: 20).isActive = true
        distanceImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        distanceImage.heightAnchor.constraint(equalTo: distanceImage.widthAnchor).isActive = true
        
        distanceTravelledLabel.leftAnchor.constraint(equalTo: distanceImage.rightAnchor, constant: 10).isActive = true
        distanceTravelledLabel.rightAnchor.constraint(equalTo: topProfileView.rightAnchor, constant: -5).isActive = true
        distanceTravelledLabel.centerYAnchor.constraint(equalTo: distanceImage.centerYAnchor).isActive = true
        distanceTravelledLabel.heightAnchor.constraint(equalTo: distanceImage.heightAnchor, constant: -10).isActive = true
        
        viewShopMenu.topAnchor.constraint(equalTo: topProfileView.bottomAnchor, constant: 10).isActive = true
        viewShopMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewShopMenu.widthAnchor.constraint(equalTo: viewRegionQuestButton.widthAnchor).isActive = true
        viewShopMenu.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        viewInventoryMenu.topAnchor.constraint(equalTo: viewShopMenu.bottomAnchor, constant: 10).isActive = true
        viewInventoryMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewInventoryMenu.widthAnchor.constraint(equalTo: viewRegionQuestButton.widthAnchor).isActive = true
        viewInventoryMenu.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        viewLeaderBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLeaderBoardButton.bottomAnchor.constraint(equalTo: viewRegionQuestButton.topAnchor, constant: -10).isActive = true
        viewLeaderBoardButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        viewLeaderBoardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewRegionQuestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewRegionQuestButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        viewRegionQuestButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        viewRegionQuestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
