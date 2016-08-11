//
//  SecondViewController.h
//  EventIn
//
//  Created by Yuvaraj on 19/07/16.
//  Copyright © 2016 Yuvaraj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SecondViewController : UIViewController

//Create an array that will be used for storing the dictionary of friends from facebook
@property (strong, nonatomic)NSArray *theFriendsArray;
@property (strong, nonatomic)NSMutableArray *friendsArray, * dataSource;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic)NSMutableDictionary * objDict;
@end

