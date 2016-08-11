//
//  FirstViewController.m
//  EventIn
//
//  Created by Yuvaraj on 19/07/16.
//  Copyright © 2016 Yuvaraj. All rights reserved.
//
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FirstViewController.h"
#import "FBSDKCoreKit/FBSDKAccessToken.h"

@interface FirstViewController ()
@end

@implementation FirstViewController

- ( void )viewDidAppear:(BOOL)animated {
    [ super viewDidAppear:YES ];
   
    _loginButton = [[ FBSDKLoginButton alloc ] init ];
    _loginButton.hidden = false ;
    
    /*
     
     Here the code uses firebase database to authenticate the user, can we just authenticate here with sqlite database
     */
    
        
        if ([FBSDKAccessToken currentAccessToken] != nil) {
            // User is signed in.
            NSLog ( @"Hello!!" );
            
            NSString * storyboardName = @"mainStoryboard" ;
            UIStoryboard *storyboard = [ UIStoryboard storyboardWithName :storyboardName bundle : nil ];
            
            UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier : @"TabBarController" ];
            self . navigationController . navigationBarHidden = YES ;
            [ self presentViewController :obj animated : YES completion : nil ];
        }
        
        else
        {
            // No user is signed in.
            _loginButton . center = self . view . center ;
            _loginButton . readPermissions =
            @[ @"public_profile" , @"email" , @"user_friends" ] ;
            _loginButton . delegate = self ;
            [ self . view addSubview : _loginButton ];
            _loginButton . hidden = false ;
        }
}

- ( void )loginButton:( FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:( NSError *)error {   
    NSLog ( @"User Logged in" );
    self . loginButton . hidden = true ;
    
    
    
    if (error != nil )
    {
        self . loginButton . hidden = false ;
        NSLog(@"something wrong");
    }
    
    else if (result. isCancelled )
    {
        self . loginButton . hidden = false ;
        
    }
    
    else
    {   
             NSLog ( @"User logged in to Firebase app.." );
        _loginButton . hidden = true ;
         NSString * storyboardName = @"mainStoryboard" ;
        UIStoryboard *storyboard = [ UIStoryboard storyboardWithName :storyboardName bundle : nil ];
        
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier : @"TabBarController" ];
        self . navigationController . navigationBarHidden = YES ;
        [ self presentViewController :obj animated : YES completion : nil ];
        
    }
    
    
}

- ( void ) loginButtonDidLogOut:( FBSDKLoginButton *)loginButton {
    NSLog ( @"User logged out" );
}

- ( void )didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

@end

