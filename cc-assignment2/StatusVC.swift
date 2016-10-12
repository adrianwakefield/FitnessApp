//
//  StatusVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 16/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class StatusVC: UIViewController {
    
    enum Result {
        case success
        case fail
    }
    
    var distanceTravelled: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        setupViews()
        setupConstraints()
        setupLabels()
    }
    
    func setupLabels() {
        APIService.sharedInstance.returnUser(id: (APPDELEGATE.currentUser?.id!)!) { (success) in
            if success == true {
                self.goldEarnedAmount.text = "\((APPDELEGATE.currentUser?.gold!)!)"
                self.expGainedAmount.text = "\((APPDELEGATE.currentUser?.expCurrent!)!)"
            }
        }
        
    }
    
    // VIEW CREATION
    
    let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .white
        topView.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1).cgColor
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        topView.layer.shadowOpacity = 0.8
        topView.layer.shadowRadius = 3.0
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    let gameStatsLabel: UILabel = {
        let gameStatsLabel = UILabel()
        gameStatsLabel.text = "Quest Statistics"
        gameStatsLabel.textAlignment = .center
        gameStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        return gameStatsLabel
    }()
    
    let questNameLabel: UILabel = {
        let questNameLabel = UILabel()
        questNameLabel.text = "- My First Quest -"
        questNameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
        questNameLabel.textAlignment = .center
        questNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return questNameLabel
    }()
    
    let summaryView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .white
        topView.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1).cgColor
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        topView.layer.shadowOpacity = 0.8
        topView.layer.shadowRadius = 5.0
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    let summaryTitleView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    let questSummaryLabel: UILabel = {
        let questSummaryLabel = UILabel()
        questSummaryLabel.text = "QUEST SUMMARY"
        questSummaryLabel.textColor = .white
        questSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        return questSummaryLabel
    }()
    
    let amountHeaderLabel: UILabel = {
        let amountHeaderLabel = UILabel()
        amountHeaderLabel.text = "Amount"
        amountHeaderLabel.font = UIFont.boldSystemFont(ofSize: 12)
        amountHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountHeaderLabel
    }()
    
    let expGainedLabel: UILabel = {
        let expGainedLabel = UILabel()
        expGainedLabel.text = "New EXP Amount:"
        expGainedLabel.font = UIFont.boldSystemFont(ofSize: 12)
        expGainedLabel.translatesAutoresizingMaskIntoConstraints = false
        return expGainedLabel
    }()
    
    let expGainedAmount: UILabel = {
        let expGainedAmount = UILabel()
        expGainedAmount.text = "20 EXP"
        expGainedAmount.font = UIFont.systemFont(ofSize: 12)
        expGainedAmount.translatesAutoresizingMaskIntoConstraints = false
        return expGainedAmount
    }()
    
    let goldEarnedLabel: UILabel = {
        let goldEarnedLabel = UILabel()
        goldEarnedLabel.text = "New GOLD Amount:"
        goldEarnedLabel.font = UIFont.boldSystemFont(ofSize: 12)
        goldEarnedLabel.translatesAutoresizingMaskIntoConstraints = false
        return goldEarnedLabel
    }()
    
    let goldEarnedAmount: UILabel = {
        let goldEarnedAmount = UILabel()
        goldEarnedAmount.text = "0"
        goldEarnedAmount.font = UIFont.systemFont(ofSize: 12)
        goldEarnedAmount.translatesAutoresizingMaskIntoConstraints = false
        return goldEarnedAmount
    }()
    
    let distanceTravelledLabel: UILabel = {
        let goldEarned = UILabel()
        goldEarned.text = "Distance Travelled:"
        goldEarned.font = UIFont.boldSystemFont(ofSize: 12)
        goldEarned.translatesAutoresizingMaskIntoConstraints = false
        return goldEarned
    }()
    
    lazy var distanceTravelledAmount: UILabel = {
        let distanceTravelledAmount = UILabel()
        let formattedVersion = String(format:"%.2f", self.distanceTravelled!/1000)
        distanceTravelledAmount.text = "\(formattedVersion) KM"
        distanceTravelledAmount.font = UIFont.systemFont(ofSize: 12)
        distanceTravelledAmount.translatesAutoresizingMaskIntoConstraints = false
        return distanceTravelledAmount
    }()
    
    let separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        return separatorLine
    }()
    
    let summaryDescription: UILabel = {
        let summaryDescription = UILabel()
        summaryDescription.numberOfLines = 3
        summaryDescription.font = UIFont.systemFont(ofSize: 13)
        summaryDescription.textAlignment = .center
        //summaryDescription.text = "You have successfully completed this quest and have unlocked the next level."
        summaryDescription.translatesAutoresizingMaskIntoConstraints = false
        return summaryDescription
    }()
    
    lazy var returnToProfileButton: UIButton = {
        let returnToProfileButton = UIButton(type: .system)
        returnToProfileButton.setTitle("RETURN TO PROFILE", for: UIControlState())
        returnToProfileButton.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        returnToProfileButton.setTitleColor(.white, for: UIControlState())
        returnToProfileButton.translatesAutoresizingMaskIntoConstraints = false
        returnToProfileButton.addTarget(self, action: #selector(StatusVC.returnToProfile), for: .touchUpInside)
        returnToProfileButton.layer.cornerRadius = 5
        return returnToProfileButton
    }()
    
    
    // DISPLAY OTHER SCREENS FUNCTIONS
    
    func returnToProfile() {
        APIService.sharedInstance.returnUser(id: (APPDELEGATE.currentUser?.id!)!) { (success) in
            if success == true {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(topView)
        view.addSubview(summaryView)
        summaryView.addSubview(summaryTitleView)
        summaryTitleView.addSubview(questSummaryLabel)
        summaryView.addSubview(amountHeaderLabel)
        summaryView.addSubview(expGainedLabel)
        summaryView.addSubview(expGainedAmount)
        summaryView.addSubview(goldEarnedLabel)
        summaryView.addSubview(goldEarnedAmount)
        summaryView.addSubview(distanceTravelledLabel)
        summaryView.addSubview(distanceTravelledAmount)
        summaryView.addSubview(separatorLine)
        summaryView.addSubview(summaryDescription)
        topView.addSubview(gameStatsLabel)
        topView.addSubview(questNameLabel)
        view.addSubview(returnToProfileButton)
    }
    
    func setupConstraints() {
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        gameStatsLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        gameStatsLabel.centerYAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        gameStatsLabel.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        gameStatsLabel.heightAnchor.constraint(equalToConstant: gameStatsLabel.intrinsicContentSize.height).isActive = true
        
        questNameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        questNameLabel.topAnchor.constraint(equalTo: gameStatsLabel.bottomAnchor, constant: 5).isActive = true
        questNameLabel.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        questNameLabel.heightAnchor.constraint(equalToConstant: questNameLabel.intrinsicContentSize.height).isActive = true
        
        summaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        summaryView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        summaryView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 40).isActive = true
        summaryView.bottomAnchor.constraint(equalTo: returnToProfileButton.topAnchor, constant: -40).isActive = true
        
        summaryTitleView.centerXAnchor.constraint(equalTo: summaryView.centerXAnchor).isActive = true
        summaryTitleView.widthAnchor.constraint(equalTo: summaryView.widthAnchor).isActive = true
        summaryTitleView.topAnchor.constraint(equalTo: summaryView.topAnchor).isActive = true
        summaryTitleView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        questSummaryLabel.leftAnchor.constraint(equalTo: summaryTitleView.leftAnchor, constant: 30).isActive = true
        questSummaryLabel.centerYAnchor.constraint(equalTo: summaryTitleView.centerYAnchor).isActive = true
        questSummaryLabel.widthAnchor.constraint(equalToConstant: questSummaryLabel.intrinsicContentSize.width).isActive = true
        questSummaryLabel.heightAnchor.constraint(equalToConstant: questSummaryLabel.intrinsicContentSize.height).isActive = true
        
        amountHeaderLabel.centerXAnchor.constraint(equalTo: expGainedAmount.centerXAnchor).isActive = true
        amountHeaderLabel.topAnchor.constraint(equalTo: summaryTitleView.bottomAnchor, constant: 30).isActive = true
        amountHeaderLabel.widthAnchor.constraint(equalToConstant: amountHeaderLabel.intrinsicContentSize.width).isActive = true
        amountHeaderLabel.heightAnchor.constraint(equalToConstant: amountHeaderLabel.intrinsicContentSize.height).isActive = true
        
        expGainedLabel.rightAnchor.constraint(equalTo: distanceTravelledLabel.rightAnchor).isActive = true
        expGainedLabel.topAnchor.constraint(equalTo: amountHeaderLabel.bottomAnchor, constant: 30).isActive = true
        expGainedLabel.widthAnchor.constraint(equalToConstant: expGainedLabel.intrinsicContentSize.width).isActive = true
        expGainedLabel.heightAnchor.constraint(equalToConstant: expGainedLabel.intrinsicContentSize.height).isActive = true
        
        expGainedAmount.centerXAnchor.constraint(equalTo: goldEarnedAmount.centerXAnchor).isActive = true
        expGainedAmount.centerYAnchor.constraint(equalTo: expGainedLabel.centerYAnchor).isActive = true
        expGainedAmount.widthAnchor.constraint(equalToConstant: expGainedAmount.intrinsicContentSize.width).isActive = true
        expGainedAmount.heightAnchor.constraint(equalToConstant: expGainedAmount.intrinsicContentSize.height).isActive = true
        
        goldEarnedLabel.rightAnchor.constraint(equalTo: distanceTravelledLabel.rightAnchor).isActive = true
        goldEarnedLabel.topAnchor.constraint(equalTo: expGainedLabel.bottomAnchor, constant: 30).isActive = true
        goldEarnedLabel.widthAnchor.constraint(equalToConstant: goldEarnedLabel.intrinsicContentSize.width).isActive = true
        goldEarnedLabel.heightAnchor.constraint(equalToConstant: goldEarnedLabel.intrinsicContentSize.height).isActive = true
        
        goldEarnedAmount.rightAnchor.constraint(equalTo: summaryView.rightAnchor, constant: -80).isActive = true
        goldEarnedAmount.centerYAnchor.constraint(equalTo: goldEarnedLabel.centerYAnchor).isActive = true
        goldEarnedAmount.widthAnchor.constraint(equalToConstant: 40).isActive = true
        goldEarnedAmount.heightAnchor.constraint(equalToConstant: goldEarnedAmount.intrinsicContentSize.height).isActive = true
        
        distanceTravelledLabel.leftAnchor.constraint(equalTo: summaryView.leftAnchor, constant: 30).isActive = true
        distanceTravelledLabel.topAnchor.constraint(equalTo: goldEarnedLabel.bottomAnchor, constant: 30).isActive = true
        distanceTravelledLabel.widthAnchor.constraint(equalToConstant: distanceTravelledLabel.intrinsicContentSize.width).isActive = true
        distanceTravelledLabel.heightAnchor.constraint(equalToConstant: distanceTravelledLabel.intrinsicContentSize.height).isActive = true
        
        distanceTravelledAmount.centerXAnchor.constraint(equalTo: goldEarnedAmount.centerXAnchor).isActive = true
        distanceTravelledAmount.centerYAnchor.constraint(equalTo: distanceTravelledLabel.centerYAnchor).isActive = true
        distanceTravelledAmount.widthAnchor.constraint(equalToConstant: distanceTravelledAmount.intrinsicContentSize.width).isActive = true
        distanceTravelledAmount.heightAnchor.constraint(equalToConstant: distanceTravelledAmount.intrinsicContentSize.height).isActive = true
        
        separatorLine.centerXAnchor.constraint(equalTo: summaryView.centerXAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: distanceTravelledLabel.bottomAnchor, constant: 30).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: summaryView.widthAnchor, constant: -60).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        summaryDescription.centerXAnchor.constraint(equalTo: summaryView.centerXAnchor).isActive = true
        summaryDescription.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 30).isActive = true
        summaryDescription.widthAnchor.constraint(equalTo: summaryView.widthAnchor, constant: -60).isActive = true
        summaryDescription.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        returnToProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        returnToProfileButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40).isActive = true
        returnToProfileButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        returnToProfileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
