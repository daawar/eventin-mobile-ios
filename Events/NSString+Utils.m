//
//  NSString+Utils.m
//  Events
//

#import "NSString+Utils.h"

@implementation NSString (Utils)


-(NSString*)encodeEmptySpaces{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}
-(NSString*)changeAndSymbol{
    return [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"and"];
}
-(NSString*)encodeAndToSymbol{
    return [self stringByReplacingOccurrencesOfString:@"and" withString:@"&amp;"];
}

@end
