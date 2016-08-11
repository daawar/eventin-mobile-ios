//
//  EventCategory.h
//  Events
//

#import <Foundation/Foundation.h>

@interface EventCategory : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *ID;


+(EventCategory*)eventCategoryWithDict:(NSDictionary*)dict;
+(NSArray*)eventCategoriesWithArray:(NSArray*)array;

@end
