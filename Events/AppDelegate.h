//
//  AppDelegate.h
//  Events
//

#import <UIKit/UIKit.h>
#import "ESSBeaconScanner.h"
#import <Foundation/Foundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, ESSBeaconScannerDelegate>
{
    ESSBeaconScanner *_scanner;
}
@property (strong, nonatomic) UIWindow *window;

@end
