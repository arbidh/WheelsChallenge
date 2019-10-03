//
//  SOFViewController.m
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//
#import "PureLayout.h"
#import "SOFAddViewController.h"
#import "AvoidingKeyboardScrollView.h"
#import "SOFAddUserViewModel.h"
#import "SOFChallenge-Swift.h"

@interface SOFAddViewController ()
@property(nonatomic, strong) AvoidingKeyboardScrollView* scrollView;
@property(nonatomic, strong) UIView * contentView;
@property(nonatomic, strong) NSArray<UIView*>* textFields;
@property(nonatomic, strong) UIButton* saveButton;
@property(nonatomic, strong) UIView* buttonContainer;
@property(nonatomic, strong) SOFFormField* nameView;
@property(nonatomic, strong) SOFFormField* reputationView;
@property(nonatomic, strong) SOFFormField* goldBadgeCountsView;
@property(nonatomic, strong) SOFFormField* silverBadgeCountsView;
@property(nonatomic, strong) SOFFormField* bronzeBadgeCountsView;
@property(nonatomic, copy) UserListBlock
block;
@property(nonatomic, strong) SOFAddUserViewModel* addUserViewModel;

@end

@implementation SOFAddViewController

-(instancetype)initWithVM:(SOFUserViewModel*)model{
    if(self = [super init]) {
        self.userViewModel = model;
        self.addUserViewModel = [SOFAddUserViewModel new];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.title = @"Add User";
    self.view.backgroundColor = UIColor.whiteColor;
    self.scrollView = [AvoidingKeyboardScrollView newAutoLayoutView];
    self.buttonContainer = [UIView newAutoLayoutView];
    //hide top separator line
    CGFloat topInset = -1;
    self.scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0, -topInset);
    [self addTextFields];
    [self.view addSubview:self.scrollView];
    self.saveButton = [self setupSaveButton];
    [self.buttonContainer addSubview:self.saveButton];
    [self.view addSubview:self.buttonContainer];
    [self setupConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (UIButton*)setupSaveButton {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:SOFConstants.saveUser forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blackColor;
    button.titleLabel.textColor = UIColor.whiteColor;
    button.titleLabel.font = [UIFont systemFontOfSize:24];
    [button addTarget:self action:@selector(didTapSave) forControlEvents:UIControlEventTouchDown];
    return button;
}

- (void)didTapSave{
    [self.saveButton setBackgroundColor:self.saveButton.isHighlighted ? UIColor.grayColor: UIColor.blackColor ];
    NSArray* users = self.userViewModel.users;
    int goldBadgeCount = [self.goldBadgeCountsView.textField.text intValue];
    int silverBadgeCount = [self.silverBadgeCountsView.textField.text intValue];
    int bronzeBadgeCount = [self.bronzeBadgeCountsView.textField.text intValue];
    if([self.addUserViewModel validateAllValuesWithReputation:self.reputationView.textField.text name:self.reputationView.textField.text badgeCountGold:goldBadgeCount badgeSilver:silverBadgeCount badgeCountBronze:bronzeBadgeCount]) {
        
        BadgeCounts* badgeCounts = [[BadgeCounts alloc]initWithBronze:bronzeBadgeCount silver:silverBadgeCount gold:goldBadgeCount];
        
        SOFUserData* userData = [[SOFUserData alloc]initWithDisplayName:self.nameView.textField.text reputation:self.reputationView.textField.text.floatValue badgeCounts:badgeCounts imageURL:@""];
        
        NSArray* newUserArray = [self.addUserViewModel addUserWithSOFUserData:userData userArray:users];
        
        SOFUserViewModel* viewModel = [[SOFUserViewModel alloc]initWithUsers:newUserArray];
        
        SOFUserViewController* userListController =(SOFUserViewController*)        self.navigationController.childViewControllers.firstObject;
        
        self.block = userListController.userBlock;
        self.block(viewModel);
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        [self presentError];
    }
}

- (void)presentError {
    UIAlertController* alertController = [[UIAlertController alloc]init];
    UIAlertAction* action = [UIAlertAction actionWithTitle: SOFConstants.errorGeneral style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion: nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)setupConstraints {
    [self.scrollView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:16];
    [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:-16];
    [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
    [self.buttonContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 16, 16, 16) excludingEdge:ALEdgeTop];
    [self.buttonContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scrollView];
    [self.saveButton autoCenterInSuperview];
    [self.saveButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
}

- (void)addTextFields {
    
    self.nameView =  [[SOFFormField alloc]initWithTitleText:SOFConstants.name placeholderText:@"display name" helperText:@"" errorText:@"" autoFillInputText:@""];
    [self.nameView.textField setKeyboardType:UIKeyboardTypeAlphabet];
    self.reputationView =  [[SOFFormField alloc]initWithTitleText:SOFConstants.reputation placeholderText:@"reputation" helperText:@"" errorText:@"" autoFillInputText:@""];
    [self.reputationView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    self.goldBadgeCountsView =  [[SOFFormField alloc]initWithTitleText:SOFConstants.goldBadgeCount placeholderText:SOFConstants.goldBadgeCount helperText:@"" errorText:@"Error" autoFillInputText:@""];
    [self.goldBadgeCountsView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    self.silverBadgeCountsView =  [[SOFFormField alloc]initWithTitleText:SOFConstants.sliverBadgeCount placeholderText:SOFConstants.sliverBadgeCount helperText:@"" errorText:@"" autoFillInputText:@""];
    [self.silverBadgeCountsView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    self.bronzeBadgeCountsView =  [[SOFFormField alloc]initWithTitleText:SOFConstants.bronzeBadgeCount placeholderText:SOFConstants.bronzeBadgeCount helperText:@"" errorText:@"" autoFillInputText:@""];
    [self.bronzeBadgeCountsView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.scrollView addSubview:self.silverBadgeCountsView];
    [self.scrollView addSubview:self.reputationView];
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.goldBadgeCountsView];
    [self.scrollView addSubview:self.bronzeBadgeCountsView];
    
    NSArray* fields = @[self.nameView,self.reputationView,self.goldBadgeCountsView,self.silverBadgeCountsView,self.bronzeBadgeCountsView];
    self.textFields =  [NSMutableArray arrayWithArray:fields];
    [self. textFields autoDistributeViewsAlongAxis:ALAxisVertical
                                         alignedTo:ALAttributeTrailing withFixedSpacing:0 insetSpacing:YES matchedSizes:NO];
    [self.textFields autoSetViewsDimensionsToSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 24, 120)];
    [self.textFields autoMatchViewsDimension:ALDimensionHeight];
}



@end
