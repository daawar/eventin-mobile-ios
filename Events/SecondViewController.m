//
//  SecondViewController.m
//  EventIn
//
//  Created by Yuvaraj on 19/07/16.
//  Copyright © 2016 Yuvaraj. All rights reserved.
//
#import <Social/Social.h>


#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKAccessToken *access_token = [FBSDKAccessToken currentAccessToken];
    if (access_token != nil) {
        // User is signed in.
        NSLog ( @"Hello!!" );
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
        
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    else
    {
    _loginButton = [[FBSDKLoginButton alloc] init];
    _loginButton.center = self.view.center;
    [self.view addSubview:_loginButton];
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
        NSString * storyboardName = @"mainStoryboard" ;
        UIStoryboard *storyboard = [ UIStoryboard storyboardWithName :storyboardName bundle : nil ];
        
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier : @"TabBarController" ];
        self . navigationController . navigationBarHidden = YES ;
        [ self presentViewController :obj animated : YES completion : nil ];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
