//
//  EventDetailsViewController.h
//  Events
//
//  Created by Daawar Khan on 7/24/16.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TwilioClient.h"

@interface EventDetailsViewController : UIViewController
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
@property(nonatomic) NSString *eventUrl;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;

@property (weak, nonatomic) IBOutlet UILabel *lblStopTime;

@property (weak, nonatomic) IBOutlet UILabel *lblPlace;

@property (retain, nonatomic) IBOutlet MKMapView *mkMapView;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@end
