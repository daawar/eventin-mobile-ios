//
//  ContactCell.h
//  Events
//
//  Created by Daawar Khan on 7/27/16.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UISwitch *switchSelect;

@end
