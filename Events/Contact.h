//
//  Contact.h
//  Events
//
//  Created by Daawar Khan on 7/27/16.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject{
    BOOL isSelected;
}

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *selected;

@end
