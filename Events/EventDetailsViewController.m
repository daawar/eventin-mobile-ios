//
//  EventDetailsViewController.m
//  Events
//
//  Created by Daawar Khan on 7/24/16.
//

#import "EventDetailsViewController.h"
#import "ESSBeaconScanner.h"
#import "FriendsViewController.h"
#import "BeaconInfo.h"
#import "SharedData.h"
#import "EventInfo.h"

@interface EventDetailsViewController ()
@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.eventDescr rangeOfString:@"beacon:{" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        NSLog(@"Descripton does not contain beacon information.");
    } else {
        NSInteger beaconStartIndex = [self.eventDescr rangeOfString:@"beacon:{" options:NSCaseInsensitiveSearch].location;
        NSString *urlSearchString = [self.eventDescr substringFromIndex:(beaconStartIndex+8)];
        
        NSInteger beaconEndIndex = [urlSearchString rangeOfString:@"}"].location;
        if(beaconEndIndex!=NSNotFound){
            NSString *beaconnUrl = [urlSearchString substringWithRange:NSMakeRange(0, beaconEndIndex)];
            self.eventBeaconUrl = beaconnUrl;
            NSLog(beaconnUrl);
        }
    }

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.eventLatitude;
    coordinate.longitude = self.eventLongitude;
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = coordinate;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = coordinate;
    [_mkMapView setRegion:region animated:YES];
    
    [_mkMapView addAnnotation:myAnnotation];
    
    _lblTitle.text = self.eventTitle;
    _lblStartTime.text = self.eventStartTime;
    _lblStopTime.text = self.eventStopTime;
    
    _lblPlace.text = self.eventAddr;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [self.eventDescr dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    _txtDescription.attributedText = attributedString;
    
    
    EventInfo *event = [[EventInfo alloc] init];
    event.eventTitle = self.eventTitle;
    event.eventAddress = self.eventAddr;

    event.eventStart = self.eventStartTime;
    
    event.eventUrl = self.eventUrl;
    
    [SharedData getInstance].eventInfo = event;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (IBAction)btnSendClick:(UIButton *)sender {
       if(self.eventBeaconUrl){
        
        NSLog(@"%@", self.eventBeaconUrl);
        
        //add this beacon url to the shared data class
        BeaconInfo *info = [[BeaconInfo alloc] init];
        info.url = self.eventBeaconUrl;
        info.found = NO;
        [SharedData getInstance].beaconInfo = info;
        
    }
    else{
        NSLog(@"No beacon url found for this event.");
    }

    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        //        [self performSegueWithIdentifier:@"friendsSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    FriendsViewController *friendsController = (FriendsViewController*)[segue destinationViewController];
//
//    friendsController.eventTitle = self.eventTitle;
//    friendsController.eventStartTime = self.eventStartTime;
//    friendsController.eventAddr = self.eventAddr;
//    friendsController.eventLatitude = self.eventLatitude;
//    friendsController.eventLongitude = self.eventLongitude;
//    friendsController.eventDescr = self.eventDescr;
//    friendsController.eventStopTime = self.eventStopTime;
//
//    if(self.eventBeaconUrl){
//        friendsController.eventBeaconUrl = self.eventBeaconUrl;
//    }
//}

@end