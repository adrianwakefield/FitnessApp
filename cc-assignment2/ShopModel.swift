//
//  ShopModel.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 7/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import Foundation
import UIKit

class ShopModel {
    
    static let sharedInstance = ShopModel()
    
    var shopItems: [ShopItemModel] = []
    var shopImages: [UIImage] = []
    
    func loadShopImage(index: Int) {
        for item in shopItems {
            let imageURL = item.image!
            let url = URL(string: imageURL)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
                if error != nil {
                    print("error")
                }
                else {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.shopImages.append(image!)
                    }
                }
            })
            task.resume()
        }
        
    }

}
