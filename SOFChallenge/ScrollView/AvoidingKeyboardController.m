//
//  AvoidingKeyboardController.m
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AvoidingKeyboardController.h"

static CGFloat const TMAvoidingKeyboardMinimumScrollOffsetPadding = 20;

@interface AvoidingKeyboardController ()

@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) BOOL ignoringNotifications;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, weak) UIView *activeField;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation AvoidingKeyboardController

#pragma mark - Lifecycle

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        self.scrollView = scrollView;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
        self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)scrollToView:(UIView *)view {
    self.ignoringNotifications = YES;
    CGFloat visibleSpace = self.scrollView.bounds.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
    CGPoint idealOffset
    = CGPointMake(self.scrollView.contentOffset.x,
                  [self idealOffsetForView:view withViewingAreaHeight:visibleSpace]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:idealOffset animated:YES];
        self.ignoringNotifications = NO;
    });
}

#pragma mark - Private

#pragma mark - Notifications

- (void)scrollToActiveTextField:(NSNotification *)notification {
    UIView *firstResponder = notification.object;
    if (!firstResponder) {
        return;
    }
    self.activeField = firstResponder;
    if (!self.keyboardVisible) {
        return;
    }
    [self scrollToView:firstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [self.scrollView convertRect:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    if (self.ignoringNotifications) {
        return;
    }
    self.keyboardRect = keyboardRect;
    self.keyboardVisible = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.scrollView.contentInset = [self contentInsetForKeyboard];
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    if (self.activeField) {
        CGFloat viewableHeight = self.scrollView.bounds.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,
                                                      [self idealOffsetForView:self.activeField
                                                         withViewingAreaHeight:viewableHeight])
                                 animated:NO];
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardRect = [self.scrollView convertRect:[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect) ) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        return;
    }
    if (self.ignoringNotifications) {
        return;
    }
    if (!self.keyboardVisible) {
        return;
    }
    self.keyboardRect = CGRectZero;
    self.keyboardVisible = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [UIView commitAnimations];
}

#pragma mark - inset calculations

- (UIEdgeInsets)contentInsetForKeyboard {
    CGFloat keyboardScrollViewBottomMargin = MAX((CGRectGetMaxY(self.keyboardRect) - CGRectGetMaxY(self.scrollView.bounds)), 0);
    UIEdgeInsets newInset = self.scrollView.contentInset;
    newInset.bottom = self.keyboardRect.size.height - keyboardScrollViewBottomMargin;
    return newInset;
}


- (CGFloat)idealOffsetForView:(UIView *)view withViewingAreaHeight:(CGFloat)viewAreaHeight {
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat offset = 0.0;
    CGRect subviewRect = [view convertRect:view.bounds toView:self.scrollView];
    
    CGFloat padding = (viewAreaHeight - subviewRect.size.height) / 2;
    if (padding < TMAvoidingKeyboardMinimumScrollOffsetPadding) {
        padding = TMAvoidingKeyboardMinimumScrollOffsetPadding;
    }
    offset = subviewRect.origin.y - padding - self.scrollView.contentInset.top;
    
    CGFloat maxOffset = contentSize.height - viewAreaHeight - self.scrollView.contentInset.top;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    if (offset < -self.scrollView.contentInset.top) {
        offset = -self.scrollView.contentInset.top;
    }
    
    return offset;
}
@end

