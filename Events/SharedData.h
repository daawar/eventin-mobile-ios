//
//  SharedData.h
//  Events
//
//  Created by Daawar Khan on 7/31/16.
//

#import <Foundation/Foundation.h>
#import "BeaconInfo.h"
#import "EventInfo.h"

@interface SharedData : NSObject

@property(nonatomic,retain) BeaconInfo *beaconInfo;
@property(nonatomic,retain) EventInfo *eventInfo;
@property(nonatomic,assign) BOOL tblCleared;

+(SharedData*) getInstance;

@end