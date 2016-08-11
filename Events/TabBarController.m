//
//  TabBarController.m
//  Events
//
//  Created by Daawar Khan on 7/31/16.
//  Copyright © 2016 Thiago Lioy. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showActions{
//Show Action sheet for user to select from 2 options
//1. Location preferences
//2. Logout

UIAlertController * view=   [UIAlertController
                             alertControllerWithTitle:@"My Title"
                             message:@"Select you Choice"
                             preferredStyle:UIAlertControllerStyleActionSheet];

UIAlertAction* ok = [UIAlertAction
                     actionWithTitle:@"OK"
                     style:UIAlertActionStyleDefault
                     handler:^(UIAlertAction * action)
                     {
                         //Do some thing here
                         [view dismissViewControllerAnimated:YES completion:nil];
                         
                     }];
UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];


[view addAction:ok];
[view addAction:cancel];
[self presentViewController:view animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
