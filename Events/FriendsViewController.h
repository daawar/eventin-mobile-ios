//
//  FriendsViewController.h
//  Events
//
//  Created by Daawar Khan on 7/27/16.
//

#import <UIKit/UIKit.h>
#import "TwilioClient.h"

@interface FriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    
    TCDevice* _phone;
    TCConnection* _connection;
    
}
@property(nonatomic) NSString *eventTitle;
@property(nonatomic) NSString *eventAddr;
@property(nonatomic) NSString *eventDescr;
@property(nonatomic) NSString *eventStartTime;
@property(nonatomic) NSString *eventStopTime;
@property(nonatomic) float eventLatitude;
@property(nonatomic) float eventLongitude;
@property(nonatomic) NSString *eventBeaconUrl;
@property(nonatomic,strong) NSMutableArray *contacts;

@end