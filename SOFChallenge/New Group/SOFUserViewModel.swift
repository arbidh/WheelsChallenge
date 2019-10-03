//
//  StackOverFlowUserViewModel.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/29/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import Foundation

@objc class SOFUserViewModel: NSObject {
    
    @objc var users: [SOFUserData]?
    
    @objc var chachedUsers: [SOFUserData]?
    
    @objc override init(){
        
    }
    @objc init(users:[SOFUserData]) {
        self.users = users
    }

}
