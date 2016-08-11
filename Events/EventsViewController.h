//
//  EventsViewController.h
//  Events
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface EventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate>
{
    CLLocation * currentLocation;
    CLLocationManager * locationManager;
}
@property(nonatomic,strong) NSString *categoryName;
@property(nonatomic,strong) NSString *city;

@end
