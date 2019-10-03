//
//  AvoidingKeyboardController.h
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface AvoidingKeyboardController : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)scrollToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
