//
//  EventCell.h
//  Events
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *addressLabel;
@property(nonatomic,strong)IBOutlet UITextView *descriptionTextView;

@end
