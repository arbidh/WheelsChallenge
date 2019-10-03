//
//  SOFViewController.h
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//
#import<UIKit/UIkit.h>
#import"SOFSharedBlocks.h"
@class SOFUserViewModel;
@class SOFUserViewController;
@class SOFSharedBlocks;
@interface SOFAddViewController : UIViewController

@property(nonatomic, weak) SOFUserViewModel* userViewModel;

-(instancetype)initWithVM:(SOFUserViewModel*)model;

@property(nonatomic, copy) UserListBlock userBlock;

@end


