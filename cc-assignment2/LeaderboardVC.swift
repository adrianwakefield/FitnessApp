//
//  LeaderboardVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 11/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class LeaderboardVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let leaderCell = "leaderCell"
    var leaderboardDistance: [UserModel] = []
    var leaderboardGold: [UserModel] = []
    var leaderboardLevel: [UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        collectionView?.register(LeaderBoardCell.self, forCellWithReuseIdentifier: leaderCell)
        view.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        loadGoldLeaderboard()
        loadLevelLeaderboard()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: leaderCell, for: indexPath) as! LeaderBoardCell
        cell.backgroundColor = .white
        
        if indexPath.row == 0 {
            loadDistanceLeaderboard(completionHandler: { (userArray) in
                cell.configureCell(statsArray: userArray, index: indexPath.row)
            })
            
        }
        
        if indexPath.row == 1 {
            cell.configureCell(statsArray: leaderboardGold, index: indexPath.row)
        }
        
        if indexPath.row == 2 {
            cell.configureCell(statsArray: leaderboardLevel, index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func loadDistanceLeaderboard(completionHandler: @escaping ([UserModel]) -> ()) {
        APIService.sharedInstance.getLeaderboard(type: "Distance") { (success, leaderArray) in
            //self.leaderboardDistance = leaderArray
            completionHandler(leaderArray)
        }
    }
    
    func loadGoldLeaderboard() {
        APIService.sharedInstance.getLeaderboard(type: "Gold") { (success, leaderArray) in
            self.leaderboardGold = leaderArray
        }
    }
    
    func loadLevelLeaderboard() {
        APIService.sharedInstance.getLeaderboard(type: "Level") { (success, leaderArray) in
            self.leaderboardLevel = leaderArray
        }
    }
    
    let navbarView: UIView = {
        let navbarView = UIView()
        navbarView.backgroundColor = .white
        navbarView.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5).cgColor
        navbarView.layer.shadowRadius = 5.0
        navbarView.layer.shadowOpacity = 0.8
        navbarView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navbarView.translatesAutoresizingMaskIntoConstraints = false
        return navbarView
    }()
    
    let navBarTitle: UILabel = {
        let navBarTitle = UILabel()
        navBarTitle.text = "LEADERBOARD"
        navBarTitle.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        navBarTitle.textAlignment = .center
        navBarTitle.textColor = .black
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        return navBarTitle
    }()
    
    lazy var navBarBackButton: UIImageView = {
        let navBarBackButton = UIImageView()
        navBarBackButton.image = UIImage(named: "backButton")
        navBarBackButton.isUserInteractionEnabled = true
        navBarBackButton.translatesAutoresizingMaskIntoConstraints = false
        navBarBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segueToProfileScreen)))
        return navBarBackButton
    }()
    
    func segueToProfileScreen() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func setupViews() {
        view.addSubview(navbarView)
        navbarView.addSubview(navBarTitle)
        navbarView.addSubview(navBarBackButton)
    }
    
    func setupConstraints() {
        navbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navbarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navbarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        navBarTitle.centerXAnchor.constraint(equalTo: navbarView.centerXAnchor).isActive = true
        navBarTitle.centerYAnchor.constraint(equalTo: navbarView.centerYAnchor, constant: 5).isActive = true
        navBarTitle.widthAnchor.constraint(equalTo: navbarView.widthAnchor, constant: -60).isActive = true
        navBarTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navBarBackButton.leftAnchor.constraint(equalTo: navbarView.leftAnchor, constant: 20).isActive = true
        navBarBackButton.centerYAnchor.constraint(equalTo: navbarView.centerYAnchor, constant: 5).isActive = true
        navBarBackButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        navBarBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
}

class LeaderBoardCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()

    
    
    let mainLeaderBgView: UIView = {
        let mainLeaderBgView = UIView()
        mainLeaderBgView.backgroundColor = .white
        mainLeaderBgView.layer.cornerRadius = 10
        mainLeaderBgView.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5).cgColor
        mainLeaderBgView.layer.shadowRadius = 5.0
        mainLeaderBgView.layer.shadowOpacity = 0.8
        mainLeaderBgView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainLeaderBgView.translatesAutoresizingMaskIntoConstraints = false
        return mainLeaderBgView
    }()
    
    let titleLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        nameLabel.text = "NAME"
        nameLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.text = "AMOUNT"
        typeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        typeLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        return typeLabel
    }()

    let userNameOne: UILabel = {
        let userNameOne = UILabel()
        userNameOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        userNameOne.translatesAutoresizingMaskIntoConstraints = false
        return userNameOne
    }()
    
    let attributedLabelOne: UILabel = {
        let attributedLabelOne = UILabel()
        attributedLabelOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        attributedLabelOne.translatesAutoresizingMaskIntoConstraints = false
        return attributedLabelOne
    }()

    let separatorLineOne: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    let userNameTwo: UILabel = {
        let userNameOne = UILabel()
        userNameOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        userNameOne.translatesAutoresizingMaskIntoConstraints = false
        return userNameOne
    }()
    
    let attributedLabelTwo: UILabel = {
        let attributedLabelOne = UILabel()
        attributedLabelOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        attributedLabelOne.translatesAutoresizingMaskIntoConstraints = false
        return attributedLabelOne
    }()
    
    let separatorLineTwo: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    let userNameThree: UILabel = {
        let userNameOne = UILabel()
        userNameOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        userNameOne.translatesAutoresizingMaskIntoConstraints = false
        return userNameOne
    }()
    
    let attributedLabelThree: UILabel = {
        let attributedLabelOne = UILabel()
        attributedLabelOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        attributedLabelOne.translatesAutoresizingMaskIntoConstraints = false
        return attributedLabelOne
    }()
    
    let separatorLineThree: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    let userNameFour: UILabel = {
        let userNameOne = UILabel()
        userNameOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        userNameOne.translatesAutoresizingMaskIntoConstraints = false
        return userNameOne
    }()
    
    let attributedLabelFour: UILabel = {
        let attributedLabelOne = UILabel()
        attributedLabelOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        attributedLabelOne.translatesAutoresizingMaskIntoConstraints = false
        return attributedLabelOne
    }()
    
    let separatorLineFour: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    let userNameFive: UILabel = {
        let userNameOne = UILabel()
        userNameOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        userNameOne.translatesAutoresizingMaskIntoConstraints = false
        return userNameOne
    }()
    
    let attributedLabelFive: UILabel = {
        let attributedLabelOne = UILabel()
        attributedLabelOne.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        attributedLabelOne.translatesAutoresizingMaskIntoConstraints = false
        return attributedLabelOne
    }()
    
    let separatorLineFive: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    func configureCell(statsArray: [UserModel], index: Int) {
        userNameOne.text = statsArray[0].name!
        userNameTwo.text = statsArray[1].name!
        userNameThree.text = statsArray[2].name!
        userNameFour.text = statsArray[3].name!
        userNameFive.text = statsArray[4].name!
        
        if index == 0 {
            titleLabel.text = "DISTANCE RAN LEADERBOARD"
            typeLabel.text = "DISTANCE"
            attributedLabelOne.text = "\(statsArray[0].distanceTotal!)"
            attributedLabelTwo.text = "\(statsArray[1].distanceTotal!)"
            attributedLabelThree.text = "\(statsArray[2].distanceTotal!)"
            attributedLabelFour.text = "\(statsArray[3].distanceTotal!)"
            attributedLabelFive.text = "\(statsArray[4].distanceTotal!)"
        }
        if index == 1 {
            titleLabel.text = "GOLD EARNED LEADERBOARD"
            typeLabel.text = "GOLD"
            attributedLabelOne.text = "\(statsArray[0].gold!)"
            attributedLabelTwo.text = "\(statsArray[1].gold!)"
            attributedLabelThree.text = "\(statsArray[2].gold!)"
            attributedLabelFour.text = "\(statsArray[3].gold!)"
            attributedLabelFive.text = "\(statsArray[4].gold!)"
        }
        if index == 2 {
            titleLabel.text = "CURRENT LEVEL LEADERBOARD"
            typeLabel.text = "LEVEL"
            attributedLabelOne.text = "\(statsArray[0].level!)"
            attributedLabelTwo.text = "\(statsArray[1].level!)"
            attributedLabelThree.text = "\(statsArray[2].level!)"
            attributedLabelFour.text = "\(statsArray[3].level!)"
            attributedLabelFive.text = "\(statsArray[4].level!)"
        }
    }
    
    func setupViews() {
        contentView.addSubview(topView)
        contentView.addSubview(mainLeaderBgView)
        mainLeaderBgView.addSubview(titleLabel)
        mainLeaderBgView.addSubview(nameLabel)
        mainLeaderBgView.addSubview(typeLabel)
        mainLeaderBgView.addSubview(userNameOne)
        mainLeaderBgView.addSubview(attributedLabelOne)
        mainLeaderBgView.addSubview(separatorLineOne)
        mainLeaderBgView.addSubview(userNameTwo)
        mainLeaderBgView.addSubview(attributedLabelTwo)
        mainLeaderBgView.addSubview(separatorLineTwo)
        mainLeaderBgView.addSubview(userNameThree)
        mainLeaderBgView.addSubview(attributedLabelThree)
        mainLeaderBgView.addSubview(separatorLineThree)
        mainLeaderBgView.addSubview(userNameFour)
        mainLeaderBgView.addSubview(attributedLabelFour)
        mainLeaderBgView.addSubview(separatorLineFour)
        mainLeaderBgView.addSubview(userNameFive)
        mainLeaderBgView.addSubview(attributedLabelFive)
        mainLeaderBgView.addSubview(separatorLineFive)
    }
    
    func setupConstraints() {
        topView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/5).isActive = true
        
        
        mainLeaderBgView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30).isActive = true
        mainLeaderBgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainLeaderBgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        mainLeaderBgView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/4).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: mainLeaderBgView.topAnchor, constant: 15).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: mainLeaderBgView.leftAnchor, constant: 70).isActive = true
        nameLabel.topAnchor.constraint(equalTo: mainLeaderBgView.topAnchor, constant: 80).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.width).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        typeLabel.centerXAnchor.constraint(equalTo: mainLeaderBgView.rightAnchor, constant: -70).isActive = true
        typeLabel.topAnchor.constraint(equalTo: mainLeaderBgView.topAnchor, constant: 80).isActive = true
        typeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        userNameOne.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        userNameOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        userNameOne.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userNameOne.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attributedLabelOne.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor).isActive = true
        attributedLabelOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        attributedLabelOne.widthAnchor.constraint(equalToConstant: 60).isActive = true
        attributedLabelOne.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorLineOne.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        separatorLineOne.topAnchor.constraint(equalTo: userNameOne.bottomAnchor, constant: 20).isActive = true
        separatorLineOne.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor, constant: -30).isActive = true
        separatorLineOne.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userNameTwo.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        userNameTwo.topAnchor.constraint(equalTo: separatorLineOne.bottomAnchor, constant: 20).isActive = true
        userNameTwo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userNameTwo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attributedLabelTwo.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor).isActive = true
        attributedLabelTwo.topAnchor.constraint(equalTo: separatorLineOne.bottomAnchor, constant: 20).isActive = true
        attributedLabelTwo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        attributedLabelTwo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorLineTwo.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        separatorLineTwo.topAnchor.constraint(equalTo: userNameTwo.bottomAnchor, constant: 20).isActive = true
        separatorLineTwo.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor, constant: -30).isActive = true
        separatorLineTwo.heightAnchor.constraint(equalToConstant: 1).isActive = true

        userNameThree.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        userNameThree.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor, constant: 20).isActive = true
        userNameThree.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userNameThree.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attributedLabelThree.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor).isActive = true
        attributedLabelThree.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor, constant: 20).isActive = true
        attributedLabelThree.widthAnchor.constraint(equalToConstant: 60).isActive = true
        attributedLabelThree.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorLineThree.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        separatorLineThree.topAnchor.constraint(equalTo: userNameThree.bottomAnchor, constant: 20).isActive = true
        separatorLineThree.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor, constant: -30).isActive = true
        separatorLineThree.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userNameFour.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        userNameFour.topAnchor.constraint(equalTo: separatorLineThree.bottomAnchor, constant: 20).isActive = true
        userNameFour.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userNameFour.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attributedLabelFour.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor).isActive = true
        attributedLabelFour.topAnchor.constraint(equalTo: separatorLineThree.bottomAnchor, constant: 20).isActive = true
        attributedLabelFour.widthAnchor.constraint(equalToConstant: 60).isActive = true
        attributedLabelFour.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorLineFour.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        separatorLineFour.topAnchor.constraint(equalTo: userNameFour.bottomAnchor, constant: 20).isActive = true
        separatorLineFour.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor, constant: -30).isActive = true
        separatorLineFour.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        userNameFive.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        userNameFive.topAnchor.constraint(equalTo: separatorLineFour.bottomAnchor, constant: 20).isActive = true
        userNameFive.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userNameFive.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attributedLabelFive.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor).isActive = true
        attributedLabelFive.topAnchor.constraint(equalTo: separatorLineFour.bottomAnchor, constant: 20).isActive = true
        attributedLabelFive.widthAnchor.constraint(equalToConstant: 60).isActive = true
        attributedLabelFive.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorLineFive.centerXAnchor.constraint(equalTo: mainLeaderBgView.centerXAnchor).isActive = true
        separatorLineFive.topAnchor.constraint(equalTo: userNameFive.bottomAnchor, constant: 20).isActive = true
        separatorLineFive.widthAnchor.constraint(equalTo: mainLeaderBgView.widthAnchor, constant: -30).isActive = true
        separatorLineFive.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}
