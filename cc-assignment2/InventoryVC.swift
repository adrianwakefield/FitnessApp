//
//  InventoryVC.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 8/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import UIKit

protocol InventoryDelegate {
    func didSelectInventoryItem(item: ShopItemModel)
}

class InventoryVC: UITableViewController, InventoryCellDelegate {
    
    var delegate: InventoryDelegate?
    
    func didChooseInventoryItemFromCell(sender: UIButton) {
        let item = userInventory[sender.tag]
        delegate?.didSelectInventoryItem(item: item)
        dismiss(animated: true, completion: nil)
    }
    
    let inventoryCellId = "inventoryCellId"
    var userInventory: [ShopItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InventoryCell.self, forCellReuseIdentifier: inventoryCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MY INVENTORY"
        getInventory()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInventory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inventoryCellId, for: indexPath) as! InventoryCell
        cell.itemNameLabel.text = userInventory[indexPath.row].name!
        cell.delegate = self
        cell.itemDescLabel.text = userInventory[indexPath.row].desc!
        cell.useButton.tag = indexPath.row
        if let itemImageURL = userInventory[indexPath.row].image {
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
    
    func getInventory() {
        APIService.sharedInstance.getUserItems { (success, inventoryItems) in
            if success == true {
                self.userInventory = inventoryItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else {
                print("Error in retrieving user's inventory.")
            }
        }
    }
}

protocol InventoryCellDelegate {
    func didChooseInventoryItemFromCell(sender: UIButton)
}

class InventoryCell: UITableViewCell {
    
    var delegate: InventoryCellDelegate?
    
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
    
    lazy var useButton: UIButton = {
        let useButton = UIButton(type: .system)
        useButton.setTitle("USE", for: .normal)
        useButton.backgroundColor = UIColor(red: 119/255, green: 163/255, blue: 255/255, alpha: 1)
        useButton.layer.cornerRadius = 10
        useButton.setTitleColor(.white, for: .normal)
        useButton.translatesAutoresizingMaskIntoConstraints = false
        useButton.addTarget(self, action: #selector(useItem), for: .touchUpInside)
        return useButton
    }()

    func useItem(sender: UIButton) {
        delegate?.didChooseInventoryItemFromCell(sender: sender)
    }
    
    func setupViews() {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemDescLabel)
        contentView.addSubview(useButton)
    }
    
    func setupConstraints() {
        itemImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        itemImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        itemNameLabel.leftAnchor.constraint(equalTo: itemImage.rightAnchor, constant: 30).isActive = true
        itemNameLabel.rightAnchor.constraint(equalTo: useButton.leftAnchor, constant: -30).isActive = true
        itemNameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2).isActive = true
        itemNameLabel.heightAnchor.constraint(equalToConstant: itemNameLabel.intrinsicContentSize.height).isActive = true
        
        itemDescLabel.leftAnchor.constraint(equalTo: itemNameLabel.leftAnchor).isActive = true
        itemDescLabel.rightAnchor.constraint(equalTo: useButton.leftAnchor, constant: -30).isActive = true
        itemDescLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemDescLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        useButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        useButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        useButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/2).isActive = true
        useButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
