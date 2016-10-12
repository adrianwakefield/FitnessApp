//
//  ShopModel.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 7/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import Foundation

class ShopItemModel {
    
    let name: String?
    let desc: String?
    let damage: Int?
    let health: Int?
    let levelNeeded: Int?
    let goldNeeded: Int?
    let id: String?
    let image: String?
    
    init(name: String, desc: String, damage: Int, health: Int, levelNeeded: Int, goldNeeded: Int, id: String, image: String) {
        self.name = name
        self.desc = desc
        self.damage = damage
        self.health = health
        self.levelNeeded = levelNeeded
        self.goldNeeded = goldNeeded
        self.id = id
        self.image = image
    }
}
