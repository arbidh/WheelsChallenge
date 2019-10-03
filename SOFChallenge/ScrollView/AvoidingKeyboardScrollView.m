//
//  AvoidingKeyboardController.m
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

#import "AvoidingKeyboardScrollView.h"
#import "AvoidingKeyboardController.h"

@interface AvoidingKeyboardScrollView ()

@property (nonatomic, strong) AvoidingKeyboardController *avoidingKeyboardController;

@end

@implementation AvoidingKeyboardScrollView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.avoidingKeyboardController = [[AvoidingKeyboardController alloc] initWithScrollView:self];
}

#pragma mark - Public

- (void)scrollToView:(UIView *)view {
    [self.avoidingKeyboardController scrollToView:view];
}

@end

