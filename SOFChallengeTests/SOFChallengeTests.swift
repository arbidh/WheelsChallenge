//
//  SOFChallengeTests.swift
//  SOFChallengeTests
//
//  Created by Arbi on 30/09/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

import XCTest
@testable import SOFChallenge

class SOFChallengeTests: XCTestCase {

    let userViewModel = SOFAddUserViewModel()

    
    func testValidBadgeCount() {
        
        let valid =  userViewModel.validateBadges(5, silverBadgeCount: 15, bronzeBadgeCount: 50)
        XCTAssertTrue(valid)
    }
    
    func testNotValidateBadgeCount() {
        let notValid =  userViewModel.validateBadges(1, silverBadgeCount: 5, bronzeBadgeCount: 2)
        XCTAssertFalse(notValid)
    }
    
    func testValidateNameText() {
        let valid =  userViewModel.validateNameTextField("at")
        XCTAssertTrue(valid)
    }
    
    func testValidate() {
        let notValid =  userViewModel.validateNameTextField("")
        XCTAssertFalse(notValid)
    }
    
    func testValidateReputationFailed() {
       let notValid =  userViewModel.validateReputation("2")
        XCTAssertFalse(notValid)
    }
    
    func testValidateReputationSuccedeed() {
        let valid =  userViewModel.validateReputation("3")
        XCTAssertTrue(valid)
    }
    
    func testAddUser() {
        
        let fakeBadgeCount = BadgeCounts(bronze: 5, silver: 15, gold: 20)
        
        let fakeData = SOFUserData(displayName: "hello", reputation: 5, badgeCounts: fakeBadgeCount , imageURL: "")
      
    
        let fakeBadgeCount1 = BadgeCounts(bronze: 5, silver: 15, gold: 23)
        
        let fakeData2 = SOFUserData(displayName: "hello", reputation: 5, badgeCounts: fakeBadgeCount1, imageURL: "")
        
        let list = [fakeData]
        
        let newArray = userViewModel.addUser(with: fakeData2, userArray: list)
        XCTAssert(newArray.count == 2, "succeeded in adding a user")
    }

}
