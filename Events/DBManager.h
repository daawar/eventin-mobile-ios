//
//  DBManager.h
//  Events
//
//  Created by Daawar Khan on 7/28/16.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*) getSharedInstance;
-(BOOL)createDB;
-(BOOL)saveContact:(NSString*)name phone:(NSString*) phone
      selected:(NSString*) selected;
-(NSMutableArray*) getContacts;
-(BOOL) clearTable;

@end
