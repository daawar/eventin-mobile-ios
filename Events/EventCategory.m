//
//  EventCategory.m
//  Events
//

#import "EventCategory.h"
#import "NSObject+emptyNullValue.h"
#import "NSString+Utils.h"

@implementation EventCategory


-(id) initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _name = [[self emptyNullValue:[dict objectForKey:@"name"]] changeAndSymbol];
        _ID = [self emptyNullValue:[dict objectForKey:@"id"]];
    }
    return self;
}

+(EventCategory*)eventCategoryWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+(NSArray*)eventCategoriesWithArray:(NSArray*)array{
    NSMutableArray *categories = [NSMutableArray array];
    for(NSDictionary *dc in array){
        EventCategory *category = [EventCategory eventCategoryWithDict:dc];
        [categories addObject:category];
    }
    return [NSArray arrayWithArray:categories];
}
@end
