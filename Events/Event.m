//
//  Event.m
//  Events
//  Edited by Daawar Khan on 24/7/16
//

#import "Event.h"
#import "NSObject+emptyNullValue.h"

@implementation Event


-(id)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _ID = [self emptyNullValue:[dict objectForKey:@"id"]];
        _country = [self emptyNullValue:[dict objectForKey:@"country_name"]];
        _city = [self emptyNullValue:[dict objectForKey:@"city_name"]];
        _descr = [self emptyNullValue:[dict objectForKey:@"description"]];
        _title = [self emptyNullValue:[dict objectForKey:@"title"]];
        _eventUrl = [self emptyNullValue:[dict objectForKey:@"url"]];
        
        _address = [self emptyNullValue:[dict objectForKey:@"venue_address"]];
        _state = [self emptyNullValue:[dict objectForKey:@"region_name"]];
        _startTime = [self emptyNullValue:[dict objectForKey:@"start_time"]];
        _stopTime = [self emptyNullValue:[dict objectForKey:@"stop_time"]];
        
        _latitude = [[self emptyNullValue:[dict objectForKey:@"latitude"]] floatValue];
        _longitude = [[self emptyNullValue:[dict objectForKey:@"longitude"]] floatValue];
        
        if([_descr isEqualToString:@""])
            _descr = @"This event has not description yet.";
        
        //else try to get beacon url from the description if it exists
        else{
            if ([_descr rangeOfString:@"beacon:{" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSLog(@"Descripton does not contain beacon information.");
            } else {
                NSInteger beaconStartIndex = [_descr rangeOfString:@"beacon:{" options:NSCaseInsensitiveSearch].location;
                NSString *urlSearchString = [_descr substringFromIndex:(beaconStartIndex+8)];
                
                NSInteger beaconEndIndex = [urlSearchString rangeOfString:@"}"].location;
                if(beaconEndIndex!=NSNotFound){
                    NSString *beaconUrl = [urlSearchString substringWithRange:NSMakeRange(0, beaconEndIndex)];
                    _beaconUrl = beaconUrl;
                    NSLog(beaconUrl);
                }
            }
        }
        
        
    }
    return self;
}

+(Event*)eventWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(NSString *)address{
    return [NSString stringWithFormat:@"%@, %@",_city,_country];
}

+(NSArray*)eventsWithArray:(NSArray*)array{
    NSMutableArray *events = [NSMutableArray array];
    for(NSDictionary *dc in array){
        Event *event = [Event eventWithDict:dc];
        [events addObject:event];
    }
    return [NSArray arrayWithArray:events];
}

@end
