//
//  APIClient.h
//  Events
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject

+(APIClient*)shareClient;

-(void)fetchCategoriesOnsuccess:(void (^)(NSArray *categories))success
                     Onfailure:(void (^)(void))failure;

-(void)fetchEventsForCategoryName:(NSString*)name withPageNumber:(NSUInteger)pageNumber andPageSize:(NSUInteger)pageSize andCity:(NSString*) city onSuccess:(void (^)(NSArray *events,NSUInteger totalEventsCount))success
                      onFailure:(void (^)(void))failure;


@end