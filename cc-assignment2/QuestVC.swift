//
//  QuestVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 16/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class QuestVC: UIViewController, CLLocationManagerDelegate {
    
    var currentQuest: QuestModel?
    var locManager = CLLocationManager()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        setupLocationManager()
    }
    
    // VIEW CREATION
    
    lazy var backButton: UIImageView = {
        let backButton = UIImageView()
        backButton.image = UIImage(named: "backButton")
        backButton.image = backButton.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.tintColor = .white
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QuestVC.goBackToProfileScreen)))
        return backButton
    }()
    
    let spaceImage: UIImageView = {
        let spaceImage = UIImageView()
        spaceImage.image = UIImage(named: "space_bg")
        spaceImage.isUserInteractionEnabled = true
        spaceImage.contentMode = .scaleAspectFill
        spaceImage.translatesAutoresizingMaskIntoConstraints = false
        return spaceImage
    }()
    
    let displayView: UIView = {
        let displayView = UIView()
        displayView.backgroundColor = .white
        displayView.layer.cornerRadius = 10
        displayView.translatesAutoresizingMaskIntoConstraints = false
        return displayView
    }()
    
    let monsterImage: UIImageView = {
        let monsterImage = UIImageView()
        monsterImage.image = UIImage(named: "troll")
        monsterImage.contentMode = .scaleAspectFit
        monsterImage.translatesAutoresizingMaskIntoConstraints = false
        return monsterImage
    }()
    
    let questTitleLabel: UILabel = {
        let questTitleLabel = UILabel()
        questTitleLabel.numberOfLines = 2
        questTitleLabel.text = " "
        questTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightLight)
        questTitleLabel.textAlignment = .center
        questTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return questTitleLabel
    }()
    
    let separatorLineOne: UIView = {
        let separatorLineOne = UIView()
        separatorLineOne.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineOne.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineOne
    }()
    
    let questDescription: UILabel = {
        let questDescription = UILabel()
        questDescription.text = " "
        questDescription.numberOfLines = 3
        questDescription.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        questDescription.textAlignment = .center
        questDescription.translatesAutoresizingMaskIntoConstraints = false
        return questDescription
    }()
    
    let separatorLineTwo: UIView = {
        let separatorLineTwo = UIView()
        separatorLineTwo.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineTwo.translatesAutoresizingMaskIntoConstraints = false
        return separatorLineTwo
    }()
    
    let previousActivity: UILabel = {
        let previousActivity = UILabel()
        previousActivity.text = " "
        previousActivity.numberOfLines = 0
        previousActivity.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        previousActivity.textAlignment = .center
        previousActivity.translatesAutoresizingMaskIntoConstraints = false
        return previousActivity
    }()
    
    lazy var startRunningButton: UIButton = {
        let startRunningButton = UIButton(type: .system)
        startRunningButton.setTitle("START ATTACK MODE", for: UIControlState())
        startRunningButton.backgroundColor = UIColor(red: 120/255, green: 189/255, blue: 214/255, alpha: 1)
        startRunningButton.setTitleColor(.black, for: UIControlState())
        startRunningButton.translatesAutoresizingMaskIntoConstraints = false
        startRunningButton.addTarget(self, action: #selector(QuestVC.beginQuest), for: .touchUpInside)
        startRunningButton.layer.cornerRadius = 5
        return startRunningButton
    }()
    
    // LOCATION FUNCTIONS
    
    func setupLocationManager() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            let latitude = String(currentLocation.coordinate.latitude)
            let longitude = String(currentLocation.coordinate.longitude)
            locManager.stopUpdatingLocation()
            getCurrentRegion(latitude: latitude, longitude: longitude)
        }
    }
    
    // RETRIEVE QUEST INFORMATION FUNCTIONS
    
    func getCurrentRegion(latitude: String, longitude: String) {
        APIService.sharedInstance.getCurrentRegionFromCoordinates(latitude: latitude, longitude: longitude) { (success, regionName) in
            if success == true {
                print(regionName)
                self.setupQuestInformation(regionName: "Melbourne")
            }
        }
    }
    
    func setupQuestInformation(regionName: String) {
        APIService.sharedInstance.returnRegionQuest(region: regionName) { (success, quest) in
            if success == true {
                self.currentQuest = quest
                // set quest information to labels
                self.questTitleLabel.text = quest.name!
                self.questDescription.text = quest.desc!
                for questLog in quest.questLogs {
                    self.previousActivity.text = self.previousActivity.text?.appending("\(questLog.content!)\n\n")
                }
            }
        }
    }
    
    // DISPLAY OTHER SCREENS FUNCTIONS
    
    func goBackToProfileScreen() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func beginQuest() {
        let vc = MapVC()
        vc.currentQuest = self.currentQuest
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(spaceImage)
        spaceImage.addSubview(backButton)
        spaceImage.addSubview(displayView)
        displayView.addSubview(monsterImage)
        displayView.addSubview(questTitleLabel)
        displayView.addSubview(separatorLineOne)
        displayView.addSubview(questDescription)
        displayView.addSubview(separatorLineTwo)
        displayView.addSubview(previousActivity)
        displayView.addSubview(startRunningButton)
    }
    
    func setupConstraints() {
        spaceImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spaceImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spaceImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        spaceImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: spaceImage.leftAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        displayView.centerXAnchor.constraint(equalTo: spaceImage.centerXAnchor).isActive = true
        displayView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 10).isActive = true
        displayView.widthAnchor.constraint(equalTo: spaceImage.widthAnchor, constant: -40).isActive = true
        displayView.heightAnchor.constraint(equalTo: spaceImage.heightAnchor, multiplier: 0.7).isActive = true
        
        monsterImage.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        monsterImage.centerYAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        monsterImage.widthAnchor.constraint(equalTo: displayView.widthAnchor, multiplier: 1/2).isActive = true
        monsterImage.heightAnchor.constraint(equalTo: monsterImage.widthAnchor).isActive = true
        
        questTitleLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        questTitleLabel.topAnchor.constraint(equalTo: monsterImage.bottomAnchor, constant: 20).isActive = true
        questTitleLabel.widthAnchor.constraint(equalTo: displayView.widthAnchor).isActive = true
        questTitleLabel.heightAnchor.constraint(equalToConstant: questTitleLabel.intrinsicContentSize.height).isActive = true
        
        separatorLineOne.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        separatorLineOne.topAnchor.constraint(equalTo: questTitleLabel.bottomAnchor, constant: 20).isActive = true
        separatorLineOne.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -40).isActive = true
        separatorLineOne.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        questDescription.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        questDescription.topAnchor.constraint(equalTo: separatorLineOne.bottomAnchor, constant: 20).isActive = true
        questDescription.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -40).isActive = true
        questDescription.heightAnchor.constraint(equalToConstant: questDescription.intrinsicContentSize.height).isActive = true
    
        separatorLineTwo.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        separatorLineTwo.topAnchor.constraint(equalTo: questDescription.bottomAnchor, constant: 20).isActive = true
        separatorLineTwo.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -40).isActive = true
        separatorLineTwo.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        previousActivity.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        previousActivity.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor, constant: 10).isActive = true
        previousActivity.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -20).isActive = true
        previousActivity.bottomAnchor.constraint(equalTo: startRunningButton.topAnchor, constant: -10).isActive = true
        
        startRunningButton.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        startRunningButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10).isActive = true
        startRunningButton.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -20).isActive = true
        startRunningButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
