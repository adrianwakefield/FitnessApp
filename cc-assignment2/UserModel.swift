//
//  UserModel.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 24/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import Foundation

class UserModel {
    
    let id: String?
    let name: String?
    let email: String?
    let healthCurrent: Int?
    let healthMax: Int?
    let expCurrent: Int?
    let expMax: Int?
    let gold: Int?
    let distanceTotal: Int?
    let level: Int?
    
    init(id: String, name: String?, email: String?, healthCurrent: Int?, healthMax: Int?, expCurrent: Int?, expMax: Int?, gold: Int?, distanceTotal: Int?, level: Int?) {
        self.id = id
        self.name = name
        self.email = email
        self.healthCurrent = healthCurrent
        self.healthMax = healthMax
        self.expCurrent = expCurrent
        self.expMax = expMax
        self.gold = gold
        self.distanceTotal = distanceTotal
        self.level = level
    }
    
    
}
