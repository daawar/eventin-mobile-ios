//
//  EventsViewController.m
//  Events
//  Modified by Daawar Khan on 07/25/16.
//

#import "EventsViewController.h"
#import "APIClient.h"
#import "Event.h"
#import "EventCell.h"
#import <SVPullToRefresh/UIScrollView+SVPullToRefresh.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "EventDetailsViewController.h"
#import "EventInfo.h"
#import "SharedData.h"


@interface EventsViewController (){
    NSUInteger pageNumber;
    NSUInteger pageSize;
}


@property(nonatomic,strong) IBOutlet NSMutableArray *eventsArray;
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UILabel *headerSectionLabel;

@end


static NSString *EventCellIdentifier = @"EventCellID";

@implementation EventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getLocationPreference];
    
    if([_city isEqualToString:@"current"]){
        if(locationManager==nil){
            locationManager = [[CLLocationManager alloc] init];
        }
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    
    if(_city==nil || [_city isEqualToString:@"current"]){
        _city = @"Pittsburgh";
    }
    
    [self configureFetchEventsParams];
    
    [self loadEvents];
    
    [self configureInfiniteScroll];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    currentLocation = (CLLocation *)[locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *pCity = [[NSString alloc]initWithString:placemark.locality];
             NSString *pCountry = [[NSString alloc]initWithString:placemark.country];
             
             NSLog(@"City: %@, Country: %@", pCity, pCountry);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }
     }];
}

-(void)configureFetchEventsParams{
    pageNumber = 1;
    pageSize = 20;
}

-(void)configureInfiniteScroll{
    __weak EventsViewController *weakSelf = self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreEvents];
    }];
}

-(void)updateHeaderSectionWithNumberOfEvents:(NSUInteger)eventsNumber andTotalEventsNumber:(NSUInteger)total{
    _headerSectionLabel.text = [NSString stringWithFormat:@"%d event(s) of %d",eventsNumber,total];
}

-(void)loadMoreEvents{
    pageNumber++;
    [[APIClient shareClient] fetchEventsForCategoryName:_categoryName withPageNumber:pageNumber andPageSize:pageSize andCity:_city
                                              onSuccess:^(NSArray *events,NSUInteger totalEventsCount) {
                                                  
                                                  [self updateDatasource:events];
                                                  [self updateHeaderSectionWithNumberOfEvents:_eventsArray.count andTotalEventsNumber:totalEventsCount];
                                                  
                                                  
                                                  [_tableView.infiniteScrollingView stopAnimating];
                                                  if(_eventsArray.count == totalEventsCount)
                                                      _tableView.showsInfiniteScrolling = NO;
                                                  
                                              } onFailure:^{
                                                  
                                              }];
}

-(void)updateDatasource:(NSArray*)events{
    if(!_eventsArray)
        _eventsArray = [NSMutableArray arrayWithCapacity:events.count];
    [_eventsArray addObjectsFromArray:events];
    [_tableView reloadData];
}

-(void)loadEvents{
    
    //replace space by %20 otherwise I am getting bad url error
    _city = [_city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[APIClient shareClient] fetchEventsForCategoryName:_categoryName withPageNumber:pageNumber andPageSize:pageSize andCity:_city  onSuccess:^(NSArray *events,NSUInteger totalEventsCount) {
        
        [self updateDatasource:events];
        [self updateHeaderSectionWithNumberOfEvents:_eventsArray.count andTotalEventsNumber:totalEventsCount];
        
    } onFailure:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_eventsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCell *cell = (EventCell*)[_tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
    Event *event = [_eventsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = event.title;
    cell.addressLabel.text = event.address;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showEventDetailsSegue"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger cellRow = indexPath.row;
        
        Event *event = [_eventsArray objectAtIndex:cellRow];
        
        EventDetailsViewController *eventDetailsController = (EventDetailsViewController *)[segue destinationViewController];
        
        eventDetailsController.eventTitle = event.title;
        eventDetailsController.eventStartTime = event.startTime;
        eventDetailsController.eventAddr = event.address;
        eventDetailsController.eventLatitude = event.latitude;
        eventDetailsController.eventLongitude = event.longitude;
        eventDetailsController.eventDescr = event.descr;
        eventDetailsController.eventStopTime = event.stopTime;
        eventDetailsController.eventUrl = event.eventUrl;
    
        
        if(event.beaconUrl){
            eventDetailsController.eventBeaconUrl = event.beaconUrl;
        }
    }
}

-(void) getLocationPreference{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pref = [defaults objectForKey:@"LocationPreference"];
    
    //[pDict valueForKey:@"LocationPreference"];
    NSLog(@"Location preference fetched from plist: %@", pref);
    
    if([pref isEqualToString:@"current"]){
        _city = @"pittsburgh";
    }
    
    else{
        _city = pref;
    }
}

@end