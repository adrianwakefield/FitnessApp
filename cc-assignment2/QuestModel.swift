//
//  QuestModel.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 24/09/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import Foundation

class QuestModel {
    
    enum QuestResult {
        case success
        case fail
    }
    
    let name: String?
    let desc: String?
    let healthCurrent: Int?
    let healthMax: Int?
    let monsterName: String?
    var questLogs: [QuestLogModel] = []
    let isEnabled: Bool?
    let region: String?
    let image: String?
    
    init(name: String, desc: String, healthCurrent: Int, healthMax: Int, monsterName: String, questLogs: [QuestLogModel], isEnabled: Bool, region: String, image: String) {
        self.name = name
        self.desc = desc
        self.healthCurrent = healthCurrent
        self.healthMax = healthMax
        self.monsterName = monsterName
        self.questLogs += questLogs
        self.isEnabled = isEnabled
        self.region = region
        self.image = image
    }
}
