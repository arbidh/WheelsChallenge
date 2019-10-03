//
//  SOFAddUserViewModel.m
//  SOFChallenge
//
//  Created by Arbi on 02/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

#import "SOFAddUserViewModel.h"


@implementation SOFAddUserViewModel

#pragma comment Validation

- (BOOL)validateNameTextField:(NSString*)text {
    return text != nil && ![text isEqual:@""];
}

- (BOOL)validateBadges:(int)goldBadgeCount silverBadgeCount:(int)silverBadgeCount
     bronzeBadgeCount:(int)bronzeBadgeCount
{
    BOOL goldCountTest = goldBadgeCount % 5 == 0;
    BOOL silverCountTest = silverBadgeCount % 5 == 0;
    BOOL brozeCountTest = bronzeBadgeCount % 5 == 0;
    BOOL fullTest = goldCountTest && brozeCountTest && silverCountTest;
    return  fullTest;
}

- (BOOL)validateReputation:(NSString*)text {
    int reputation = [text intValue];
    return reputation % 2 != 0;
}

- (BOOL)validateAllValuesWithReputation:(NSString*)reputation name:(NSString*)name badgeCountGold:(int)badgeCountGold badgeSilver:(int)badgeCountSilver badgeCountBronze:(int)badgeCountBronze {
    return ([self validateReputation:reputation] &&
    [self validateBadges:badgeCountGold silverBadgeCount:badgeCountSilver bronzeBadgeCount:badgeCountBronze] &&
            [self validateNameTextField:name]);
}

-(NSArray*)addUserWithSOFUserData:(SOFUserData*)userData userArray:(NSArray<SOFUserData*>*)userlist {
    
    NSMutableArray<SOFUserData*>* newUserArray = [NSMutableArray arrayWithArray:userlist];
    [newUserArray addObject:userData];
    return newUserArray;
    
}

@end
