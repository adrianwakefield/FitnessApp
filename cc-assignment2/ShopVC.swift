//
//  ShopVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 7/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

class ShopVC: UITableViewController, ShopItemCellDelegate {
    
    let shopItemCellId = "shopItemCellId"
    var shopItems: [ShopItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShopItemCell.self, forCellReuseIdentifier: shopItemCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "SHOP"
        loadShopItems()
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: shopItemCellId, for: indexPath) as! ShopItemCell
        cell.delegate = self
        cell.tag = indexPath.row
        
        cell.itemNameLabel.text = shopItems[indexPath.row].name!
        cell.itemDescLabel.text = shopItems[indexPath.row].desc!
        
        if let itemImageURL = shopItems[indexPath.row].image {
            let url = URL(string: itemImageURL)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.itemImage.image = UIImage(data: data!)
                }
                
            })
            task.resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func loadShopItems() {
        APIService.sharedInstance.getShop { (success, shopItems) in
            if success == true {
                self.shopItems = shopItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func purchaseButtonTapped(cell: ShopItemCell) {
        let index = cell.tag
        let itemID = shopItems[index].id!
        APIService.sharedInstance.addUserItemToInventory(itemID: itemID) { (success, error) in
            if success == true {
                cell.showPurchasedOverlay()
                cell.disablePurchaseButton()
            }
            else {
                if error == "poor" {
                    let popupVC = ErrorPopup()
                    popupVC.titleLabel.text = "ERROR"
                    popupVC.descLabel.text = "You do not have enough gold to purchase this item."
                    self.present(popupVC, animated: true, completion: nil)
                    print("Error adding item to user's inventory.")
                }
                if error == "exists" {
                    let popupVC = ErrorPopup()
                    popupVC.titleLabel.text = "ERROR"
                    popupVC.descLabel.text = "You already own this item. Check your inventory to view it."
                    self.present(popupVC, animated: true, completion: nil)
                    print("Error adding item to user's inventory.")
                }
                
            }
        }
    }

}

protocol ShopItemCellDelegate {
    func purchaseButtonTapped(cell: ShopItemCell)
}

class ShopItemCell: UITableViewCell {
    
    var delegate: ShopItemCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    let itemImage: UIImageView = {
        let itemImage = UIImageView()
        itemImage.image = UIImage(named: "")
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        return itemImage
    }()
    
    let itemNameLabel: UILabel = {
        let itemNameLabel = UILabel()
        itemNameLabel.text = " "
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemNameLabel
    }()
    
    let itemDescLabel: UILabel = {
        let itemDescLabel = UILabel()
        itemDescLabel.text = " "
        itemDescLabel.numberOfLines = 2
        itemDescLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        itemDescLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemDescLabel
    }()
    
    lazy var purchaseButton: UIButton = {
        let purchaseButton = UIButton(type: .system)
        purchaseButton.setTitle("BUY", for: .normal)
        purchaseButton.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        purchaseButton.layer.cornerRadius = 10
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        purchaseButton.addTarget(self, action: #selector(purchaseItem), for: .touchUpInside)
        return purchaseButton
    }()
    
    let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()
    
    let purchasedOverlayLabel: UILabel = {
        let purchasedOverlayLabel = UILabel()
        purchasedOverlayLabel.text = "PURCHASED"
        purchasedOverlayLabel.textColor = .white
        purchasedOverlayLabel.font = UIFont.boldSystemFont(ofSize: 20)
        purchasedOverlayLabel.translatesAutoresizingMaskIntoConstraints = false
        return purchasedOverlayLabel
    }()
    
    func purchaseItem() {
        delegate?.purchaseButtonTapped(cell: self)
    }
    
    func showPurchasedOverlay() {
        contentView.addSubview(overlayView)
        overlayView.addSubview(purchasedOverlayLabel)
        
        overlayView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        overlayView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true

        purchasedOverlayLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        purchasedOverlayLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        purchasedOverlayLabel.widthAnchor.constraint(equalToConstant: purchasedOverlayLabel.intrinsicContentSize.width).isActive = true
        purchasedOverlayLabel.heightAnchor.constraint(equalToConstant: purchasedOverlayLabel.intrinsicContentSize.height).isActive = true
    }
    
    func disablePurchaseButton() {
        purchaseButton.isUserInteractionEnabled = false
    }
    
    func setupViews() {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemDescLabel)
        contentView.addSubview(purchaseButton)
    }
    
    func setupConstraints() {
        itemImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        itemImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        itemNameLabel.leftAnchor.constraint(equalTo: itemImage.rightAnchor, constant: 30).isActive = true
        itemNameLabel.rightAnchor.constraint(equalTo: purchaseButton.leftAnchor, constant: -30).isActive = true
        itemNameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2).isActive = true
        itemNameLabel.heightAnchor.constraint(equalToConstant: itemNameLabel.intrinsicContentSize.height).isActive = true
        
        itemDescLabel.leftAnchor.constraint(equalTo: itemNameLabel.leftAnchor).isActive = true
        itemDescLabel.rightAnchor.constraint(equalTo: purchaseButton.leftAnchor, constant: -30).isActive = true
        itemDescLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemDescLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        purchaseButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        purchaseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        purchaseButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/2).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
