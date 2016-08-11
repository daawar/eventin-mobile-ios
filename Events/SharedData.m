//
//  SharedData.m
//  Events
//
//  Created by Daawar Khan on 7/31/16.
//

#import "SharedData.h"

@implementation SharedData
@synthesize beaconInfo;

static SharedData *instance = nil;

+(SharedData *) getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [SharedData new];
        }
    }
    return instance;
}

@end
