//
//  PreferencesViewController.h
//  Events
//
//  Created by Daawar Khan on 7/31/16.
//

#import <UIKit/UIKit.h>

@interface PreferencesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *switchCurrentCity;

@property (weak, nonatomic) IBOutlet UISwitch *switchProvideCity;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;


@end
