//
//  StackOverFlowUserDataService.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/29/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import Foundation
//i had to use it a class instead of struct for objc purpose
class BadgeCounts: NSObject {
    var bronzeCount: Int = 0
    var silver: Int = 0
    var gold: Int = 0
    @objc init(bronze: Int, silver: Int, gold: Int) {
        self.bronzeCount = bronze;
        self.silver = silver;
        self.gold = gold;
    }
}

class SOFErrorData: NSObject {
    var errorName:String
    var errorId: Int
    var errorMessage: String
    @objc init(errorName: String, errorId: Int, errorMessage: String) {
        self.errorName = errorName
        self.errorId = errorId
        self.errorMessage = errorMessage
    }
}

class SOFUserData: NSObject {
    var displayName: String
    var reputation: Int
    var badgeCounts : BadgeCounts
    var imageURL : String

    @objc init(displayName: String, reputation: Int, badgeCounts: BadgeCounts, imageURL: String) {
        self.displayName = displayName
        self.reputation = reputation
        self.badgeCounts = badgeCounts
        self.imageURL = imageURL
        super.init()
    }
}

struct SOFUserDataSerializer {

    static func parseBadgeCounts(json: [String: Any]?) -> BadgeCounts? {
        let silver = json?.intForKey(key: "silver")
        let gold = json?.intForKey(key: "gold")
        let bronze = json?.intForKey(key: "bronze")
        return  BadgeCounts(bronze: bronze ?? 0, silver: silver ?? 0, gold: gold ?? 0)
    }
    
    static func parseError(json: [String: Any]? ) -> SOFErrorData? {
        let errorName = json?.stringForKey(key: "error_name")
        let errorId = json?.intForKey(key: "error_id")
        let errorMessage = json?.stringForKey(key: "error_message")
        if let errorName = errorName, let errorId = errorId, let errorMessage =
            errorMessage {
            return SOFErrorData(errorName: errorName, errorId: errorId, errorMessage: errorMessage)
        }
        return nil
    }

    static func parseUsers(json: [String:Any]?) -> [SOFUserData]? {
        guard let json = json, let userItems = json["items"] as? [[String:Any]] else {
            return nil
        }
        var userList: [SOFUserData] = [SOFUserData]()
        userItems.forEach({ items in
            let displayName = items.stringForKey(key: "display_name")
            let reputation = items.intForKey(key: "reputation")
            let badgeCountJson = items.jsonDictionaryForKey(key: "badge_counts")
            let imageURL = items.stringForKey(key: "profile_image")
            guard let badgeCount = SOFUserDataSerializer.parseBadgeCounts(json: badgeCountJson) else { return }
            let userData = SOFUserData(displayName: displayName, reputation: reputation, badgeCounts: badgeCount, imageURL: imageURL)
            userList.append(userData)
        })
        return userList
    }
}

class SOFUserDataService {
    
    static let userEndpoint = "/users"
    let urlParam = "site=stackoverflow"
    typealias userDataCompletion = ([SOFUserData]?, SOFErrorData?) -> Void
    
    func assembleCompleteURL(page: Int) -> URL? {
        return URL(string: "\(APIClient.BaseUrl)\(SOFUserDataService.userEndpoint)?pagesize=\(page)&\(urlParam)")
    }
    
    func getUsers(with pageSize: Int,  completion: @escaping userDataCompletion ){
        let apiClient = APIClient()
        apiClient.get(url: assembleCompleteURL(page: pageSize)) { data, resp, error in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
            let users =  SOFUserDataSerializer.parseUsers(json: json )
            if(users?.count == 0 || users == nil){
                let error = SOFUserDataSerializer.parseError(json: json)
                completion(nil,error)
            }else {
                completion(users,nil)
            }
        }
    }
}
