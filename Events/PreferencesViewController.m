//
//  PreferencesViewController.m
//  Events
//
//  Created by Daawar Khan on 7/31/16
//

#import "PreferencesViewController.h"

@interface PreferencesViewController (){
    NSMutableDictionary *pDict;
}

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get user preferences from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pref = [defaults objectForKey:@"LocationPreference"];
    
    if([pref isEqualToString:@"current"]){
        [self.switchCurrentCity setOn:YES];
        [self.switchProvideCity setOn:NO];
        [self.txtCity setEnabled:NO];
    }
    
    else{
        [self.switchCurrentCity setOn:NO];
        [self.switchProvideCity setOn:YES];
        [self.txtCity setEnabled:YES];
        [self.txtCity setText:pref];
    }
    
    
    [self.switchCurrentCity addTarget:self action:@selector(selectCurrentCity) forControlEvents:UIControlEventValueChanged];
    
    [self.switchProvideCity addTarget:self action:@selector(selectProvidedCity) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.hidesBackButton=YES;
}

-(void) selectCurrentCity{
    NSLog(@"Select Current City");
    
    if([_switchCurrentCity isOn]){
        [_switchProvideCity setOn:NO animated:YES];
        [_txtCity setEnabled:NO];
    }
    
    else{
        [_switchProvideCity setOn:YES animated:YES];
        [_txtCity setEnabled:YES];
    }
}

-(void) selectProvidedCity{
    NSLog(@"Select Provided City");
    if([_switchProvideCity isOn]){
        [_switchCurrentCity setOn:NO animated:YES];
        [_txtCity setEnabled:YES];
    }
    
    else{
        [_switchCurrentCity setOn:YES animated:YES];
        [_txtCity setEnabled:NO];
    }
}

- (IBAction)saveSettings:(UIButton *)sender {
    NSLog(@"Settings saved button clicked");
    
    NSString *pref;
    
    if([_switchCurrentCity isOn]){
        pref = @"current";
    }
    
    else{
        //trim the text box value and set the city name as the pref value
        pref = [_txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pref forKey:@"LocationPreference"];
    [defaults synchronize];
 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
