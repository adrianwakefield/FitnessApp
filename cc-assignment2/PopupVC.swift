//
//  PopupVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 24/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
    
    var mapVCRef: MapVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        setupViews()
        setupConstraints()
    }
    
    // VIEW CREATION
    
    let popupView: UIView = {
        let popupView = UIView()
        popupView.layer.cornerRadius = 5
        popupView.backgroundColor = .white
        popupView.translatesAutoresizingMaskIntoConstraints = false
        return popupView
    }()
    
    let statusView: UIView = {
        let statusView = UIView()
        statusView.backgroundColor = .white
        statusView.layer.borderColor = UIColor(white: 0.0, alpha: 0.75).cgColor
        statusView.layer.borderWidth = 5
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    let statusImageView: UIImageView = {
        let statusImageView = UIImageView()
        statusImageView.image = UIImage(named: "trophy")
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        return statusImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Nice Run!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "Great job!\n Hit continue to view your stats."
        descLabel.numberOfLines = 3
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        return descLabel
    }()
    
    lazy var continueButton: UIButton = {
        let continueButton = UIButton(type: .system)
        continueButton.backgroundColor = UIColor(red: 120/255, green: 189/255, blue: 214/255, alpha: 1)
        continueButton.setTitle("Continue", for: UIControlState())
        continueButton.layer.cornerRadius = 5
        continueButton.setTitleColor(.white, for: UIControlState())
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(PopupVC.handleDismissPopup), for: .touchUpInside)
        return continueButton
    }()
    
    let continueButtonArrowImage: UIImageView = {
        let continueButtonArrowImage = UIImageView()
        continueButtonArrowImage.image = UIImage(named: "forward-arrow")?.withRenderingMode(.alwaysTemplate)
        continueButtonArrowImage.tintColor = .white
        continueButtonArrowImage.translatesAutoresizingMaskIntoConstraints = false
        return continueButtonArrowImage
    }()
    
    // DISPLAY OTHER SCREENS FUNCTIONS
    
    func handleDismissPopup() {
        self.dismiss(animated: true) { () -> Void in
            let vc = self.mapVCRef
            vc!.displayStatusPage()
        }
    }
    
    // VIEW & CONSTRAINT SETUP
    
    func setupViews() {
        view.addSubview(popupView)
        popupView.addSubview(statusView)
        statusView.addSubview(statusImageView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(descLabel)
        popupView.addSubview(continueButton)
        continueButton.addSubview(continueButtonArrowImage)
    }
    
    func setupConstraints() {
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2, constant: -20).isActive = true
        
        statusView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        statusView.centerYAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        statusView.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 1/2).isActive = true
        statusView.heightAnchor.constraint(equalTo: statusView.widthAnchor).isActive = true
        statusView.layer.cornerRadius = ((view.frame.width-80)/2)/2
        
        statusImageView.centerXAnchor.constraint(equalTo: statusView.centerXAnchor).isActive = true
        statusImageView.centerYAnchor.constraint(equalTo: statusView.centerYAnchor).isActive = true
        statusImageView.widthAnchor.constraint(equalTo: statusView.widthAnchor, multiplier: 1/2).isActive = true
        statusImageView.heightAnchor.constraint(equalTo: statusView.heightAnchor, multiplier: 1/2).isActive = true
        statusImageView.layer.masksToBounds = true
        
        titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -30).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: popupView.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true

        descLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -30).isActive = true
        descLabel.widthAnchor.constraint(equalTo: popupView.widthAnchor, constant: -30).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        continueButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -10).isActive = true
        continueButton.widthAnchor.constraint(equalTo: popupView.widthAnchor, constant: -20).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        continueButtonArrowImage.rightAnchor.constraint(equalTo: continueButton.rightAnchor, constant: -10).isActive = true
        continueButtonArrowImage.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor).isActive = true
        continueButtonArrowImage.widthAnchor.constraint(equalTo: continueButtonArrowImage.heightAnchor).isActive = true
        continueButtonArrowImage.heightAnchor.constraint(equalTo: continueButton.heightAnchor, constant: -30).isActive = true
    }
    
}
