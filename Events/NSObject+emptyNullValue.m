//
//  NSObject+emptyNullValue.m
//  Events
//

#import "NSObject+emptyNullValue.h"

@implementation NSObject (emptyNullValue)


-(NSString*)emptyNullValue:(NSString*)value{
    return  ((NSNull *) value != [NSNull null]) ? value: @"";
}
@end
