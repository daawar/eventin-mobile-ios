//
//  Event.h
//  Events
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *descr;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *ID;

//newly added properties
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *stopTime;
@property(nonatomic,strong) NSString *eventUrl;

//For location information
@property(nonatomic) float latitude;
@property(nonatomic) float longitude;

//For beacon related information
@property(nonatomic) NSString *beaconUrl;


+(Event*)eventWithDict:(NSDictionary*)dict;
+(NSArray*)eventsWithArray:(NSArray*)array;

-(NSString*)address;
@end
