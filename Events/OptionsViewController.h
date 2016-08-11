//
//  OptionsViewController.h
//  Events
//
//  Created by Daawar Khan on 7/31/16.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController<UIActionSheetDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITableView *tblOptions;


@end
