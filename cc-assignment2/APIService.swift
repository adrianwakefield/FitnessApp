//
//  APIService.swift
//  cc-assignment2
//
//  Created by Adrian Wakefield on 7/10/2016.
//  Copyright © 2016 Adrian Wakefield. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    
    static let sharedInstance = APIService()

    // LOCATION API
    
    func getCurrentRegionFromCoordinates(latitude: String, longitude: String, completionHandler: @escaping (Bool, String) -> ()) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true"
        Alamofire.request(url).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                let cityName = jsonResult["results"][0]["address_components"][2]["long_name"].stringValue
                completionHandler(true, cityName)
            }
        }
    }

    // GAME API
    
    let BASE_URL = "https://adroit-chemist-144605.appspot.com/"
    
    // Login user
    
    func getLeaderboard(type: String, completionHandler: @escaping (Bool, [UserModel]) -> ()) {
        let url = BASE_URL + "Get\(type)board/"
        Alamofire.request(url).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                var userArray: [UserModel] = []
                for (_, object) in jsonResult {
                    let name = object["Name"].stringValue
                    let email = object["Email"].stringValue
                    let healthCurrent = object["HealthCurrent"].intValue
                    let healthMax = object["HealthMax"].intValue
                    let expCurrent = object["ExpCurrent"].intValue
                    let expMax = object["ExpMax"].intValue
                    let gold = object["Gold"].intValue
                    let distanceTotal = object["DistanceTotal"].intValue
                    let level = object["Level"].intValue
                    let id = object["ID"].stringValue
                    let user = UserModel(id: id, name: name, email: email, healthCurrent: healthCurrent, healthMax: healthMax, expCurrent: expCurrent, expMax: expMax, gold: gold, distanceTotal: distanceTotal, level: level)
                    userArray.append(user)
                }

                completionHandler(true, userArray)
            }
        }
    }
    
    func loginUser(email: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        let url = BASE_URL + "LoginUser/"
        let parameters = ["email": email, "password": password]
        Alamofire.request(url, method: .get, parameters: parameters).responseString(completionHandler: { (responseString) in
            if responseString.description.isEmpty != true {
                let id = responseString.result.value!
                let idWithoutQuotes = id.replacingOccurrences(of: "\"", with: "")
                print(idWithoutQuotes)
                UserDefaults.standard.set(idWithoutQuotes, forKey: "userId")
                self.returnUser(id: idWithoutQuotes, completionHandler: { (success) in
                    if success == true {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                })
            }
            else {
                completionHandler(false)
            }
        })
    }
    
    // Create a new user
    /* Name, email, password fields */
    
    func createNewUser(name: String, email: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        let url = BASE_URL + "CreateUser/"
        let parameters = ["email": email, "password": password, "name": name]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                // return id
                let id = jsonResult["id"].stringValue
                UserDefaults.standard.set(id, forKey: "userId")
                self.returnUser(id: id, completionHandler: { (success) in
                    if success == true {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                })
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    // Return user
    /* id field */
    
    func returnUser(id: String, completionHandler: @escaping (Bool) -> ()) {
        let url = BASE_URL + "ReturnUser/"
        let parameters = ["id": id]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                let name = jsonResult["Name"].stringValue
                let email = jsonResult["Email"].stringValue
                let healthCurrent = jsonResult["HealthCurrent"].intValue
                let healthMax = jsonResult["HealthMax"].intValue
                let expCurrent = jsonResult["ExpCurrent"].intValue
                let expMax = jsonResult["ExpMax"].intValue
                let gold = jsonResult["Gold"].intValue
                let distanceTotal = jsonResult["DistanceTotal"].intValue
                let level = jsonResult["Level"].intValue
                let user = UserModel(id: id, name: name, email: email, healthCurrent: healthCurrent, healthMax: healthMax, expCurrent: expCurrent, expMax: expMax, gold: gold, distanceTotal: distanceTotal, level: level)
                APPDELEGATE.currentUser = user
                print(APPDELEGATE.currentUser?.expCurrent!)
                print(APPDELEGATE.currentUser?.expMax!)
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    // Return region quest
    /* region field */
    
    func returnRegionQuest(region: String, completionHandler: @escaping (Bool, QuestModel) -> ()) {
        let url = BASE_URL + "Region/\(region)"
        Alamofire.request(url).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                let name = jsonResult["Name"].stringValue
                let desc = jsonResult["Desc"].stringValue
                let healthCurrent = jsonResult["HealthCurrent"].intValue
                let healthMax = jsonResult["HealthMax"].intValue
                let monsterName = jsonResult["MonsterName"].stringValue
                let isEnabled = jsonResult["IsEnabled"].boolValue
                let region = jsonResult["Region"].stringValue
                let image = jsonResult["Image"].stringValue
                var questLogArray: [QuestLogModel] = []
                
                let questLogs = jsonResult["QuestLogs"].arrayValue
                for eachLog in questLogs {
                    let name = eachLog["Name"].stringValue
                    let content = eachLog["Content"].stringValue
                    let questLogItem = QuestLogModel(name: name, content: content)
                    questLogArray.append(questLogItem)
                }
                
                let quest = QuestModel(name: name, desc: desc, healthCurrent: healthCurrent, healthMax: healthMax, monsterName: monsterName, questLogs: questLogArray, isEnabled: isEnabled, region: region, image: image)
                completionHandler(true, quest)
            }
        }
    }
        
    // Region attack
    /* region, id, km's travelled fields */
    
    func performRegionAttack(region: String, kms: Int, completionHandler: @escaping (Bool) -> ()) {
        let url = BASE_URL + "RegionAttack/"
        let userId = (APPDELEGATE.currentUser?.id!)!
        let parameters = ["region": region, "id": userId, "km": "\(kms)"]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                print("performRegionAttack Result = \(jsonResult)")
                completionHandler(true)
            }
        }
    }
    
    
    // Return shop by adding all shop items to shop instance
    
    func getShop(completionHandler: @escaping (Bool, [ShopItemModel]) -> ()) {
        let url = BASE_URL + "Shop/"
        Alamofire.request(url).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                var shopItems: [ShopItemModel] = []
                for (_, object) in jsonResult {
                    let name = object["Name"].stringValue
                    let desc = object["Desc"].stringValue
                    let damage = object["Damage"].intValue
                    let health = object["Health"].intValue
                    let levelNeeded = object["LevelNeeded"].intValue
                    let goldNeeded = object["GoldNeeded"].intValue
                    let id = object["ID"].stringValue
                    let image = object["Image"].stringValue
                    let shopItem = ShopItemModel(name: name, desc: desc, damage: damage, health: health, levelNeeded: levelNeeded, goldNeeded: goldNeeded, id: id, image: image)
                    shopItems.append(shopItem)
                }
                completionHandler(true, shopItems)
            }
            
        }
    }
    
    
    // Create shop item
    func createShopItem(name: String, desc: String, health: Int, damage: Int, level: Int, gold: Int, completionHandler: @escaping (Bool) -> ()) {
        let url = BASE_URL + "Shop/Create/"
        let parameters = ["name": name, "desc": desc, "health": health, "damage": damage, "level": level, "gold": gold] as [String : Any]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                
            }
        }
    }
    
    
    
    // Add user item
    func addUserItemToInventory(itemID: String, completionHandler: @escaping (Bool, String) -> ()) {
        let url = BASE_URL + "AddUserItem/"
        let userId = (APPDELEGATE.currentUser?.id!)!
        let parameters = ["userID": userId, "itemID": itemID]
        Alamofire.request(url, method: .get, parameters: parameters).responseString { (responseString) in
            print("Reponse string = \(responseString.description)")
            if responseString.description.contains("Already has item") {
                completionHandler(false, "exists")
            }
            if responseString.description.contains("Too poor") {
                completionHandler(false, "poor")
            }
            else {
                completionHandler(true, "")
            }
        }
    }
    
    
    // Return user items - i.e: user's current inventory purchased
    func getUserItems(completionHandler: @escaping (Bool, [ShopItemModel]) -> ()) {
        let url = BASE_URL + "GetUserItems/"
        let userId = (APPDELEGATE.currentUser?.id!)!
        let parameters = ["userID": userId]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.data {
                let jsonResult = JSON(data: jsonData)
                var inventoryItems: [ShopItemModel] = []
                // Get JSON response info - call not working
                if (jsonResult["Items"].null != nil) {
                    completionHandler(true, inventoryItems)
                }
                else {
                    for (_, object) in jsonResult["Items"] {
                        let name = object["Name"].stringValue
                        let desc = object["Desc"].stringValue
                        let damage = object["Damage"].intValue
                        let health = object["Health"].intValue
                        let levelNeeded = object["LevelNeeded"].intValue
                        let goldNeeded = object["GoldNeeded"].intValue
                        let id = object["ID"].stringValue
                        let image = object["Image"].stringValue
                        let item = ShopItemModel(name: name, desc: desc, damage: damage, health: health, levelNeeded: levelNeeded, goldNeeded: goldNeeded, id: id, image: image)
                        inventoryItems.append(item)
                    }
                    completionHandler(true, inventoryItems)
                }
            }
        }
        
    }
}
