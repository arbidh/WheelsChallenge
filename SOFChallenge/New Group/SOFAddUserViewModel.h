//
//  SOFAddUserViewModel.h
//  SOFChallenge
//
//  Created by Arbi on 02/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SOFUserData;
NS_ASSUME_NONNULL_BEGIN

@interface SOFAddUserViewModel : NSObject

- (BOOL)validateNameTextField:(NSString*)text;

- (BOOL)validateBadges:(int)goldBadgeCount silverBadgeCount:(int)silverBadgeCount
     bronzeBadgeCount:(int)bronzeBadgeCount;

- (BOOL)validateReputation:(NSString*)text;

- (BOOL)validateAllValuesWithReputation:(NSString*)reputation name:(NSString*)name badgeCountGold:(int)badgeCountGold badgeSilver:(int)badgeCountSilver badgeCountBronze:(int)badgeCountBronze;

-(NSArray*)addUserWithSOFUserData:(SOFUserData*)userData userArray:(NSArray<SOFUserData*>*)userlist;

@end

NS_ASSUME_NONNULL_END
