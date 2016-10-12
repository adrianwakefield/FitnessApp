//
//  MenuView.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 8/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, desc: String, imageName: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.5).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        setupViews()
        setupConstraints()
        viewShopLabel.text = title
        viewDescLabel.text = desc
        viewShopImage.image = UIImage(named: imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewShopImage: UIImageView = {
        let viewShopImage = UIImageView()
        viewShopImage.image = UIImage(named: "")
        viewShopImage.translatesAutoresizingMaskIntoConstraints = false
        return viewShopImage
    }()
    
    let viewShopLabel: UILabel = {
        let viewShopLabel = UILabel()
        viewShopLabel.text = " "
        viewShopLabel.numberOfLines = 1
        viewShopLabel.textAlignment = .center
        viewShopLabel.font = UIFont.boldSystemFont(ofSize: 17)
        viewShopLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewShopLabel
    }()
    
    let viewDescLabel: UILabel = {
        let viewDescLabel = UILabel()
        viewDescLabel.text = " "
        viewDescLabel.numberOfLines = 5
        viewDescLabel.textAlignment = .center
        viewDescLabel.font = UIFont.systemFont(ofSize: 13)
        viewDescLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewDescLabel
    }()
    
    func setupViews() {
        addSubview(viewShopImage)
        addSubview(viewDescLabel)
        addSubview(viewShopLabel)
    }
    
    func setupConstraints() {
        viewShopImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        viewShopImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewShopImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        viewShopImage.heightAnchor.constraint(equalTo: viewShopImage.widthAnchor).isActive = true
        
        viewShopLabel.bottomAnchor.constraint(equalTo: viewDescLabel.topAnchor).isActive = true
        viewShopLabel.leftAnchor.constraint(equalTo: viewShopImage.rightAnchor, constant: 15).isActive = true
        viewShopLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        viewShopLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewDescLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        viewDescLabel.leftAnchor.constraint(equalTo: viewShopImage.rightAnchor, constant: 15).isActive = true
        viewDescLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        viewDescLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
}
