//
//  AppDelegate.m
//  Events
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "BeaconInfo.h"
#import "SharedData.h"
#import "FriendsViewController.h"
#import "ShareViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    
    UIViewController *mainViewController = [storyboard instantiateInitialViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    _scanner = [[ESSBeaconScanner alloc] init];
    _scanner.delegate = self;
    [_scanner startScanning];
    
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"pList" ofType:@"plist"];
    NSMutableDictionary *locPref = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:locPref] forKey:@"plist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

-(void) alertUser{
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Beacon Alert" message:@"Alert Body" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *actionNotify = [UIAlertAction actionWithTitle:@"Notify Friends" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FriendsViewController *friendsController = [[FriendsViewController alloc] init];
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController; [nav pushViewController:friendsController animated:YES];
        
    }];
    
    [alertvc addAction:actionOk];
    [alertvc addAction:actionNotify];
    
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    [topController presentViewController:alertvc animated:YES completion:nil];
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindURL:(NSURL *)url {
    NSLog(@"Beacon URL found!: %@", url);
    
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Location Alert" message:@"You have reached the venue of your event." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionNotify = [UIAlertAction actionWithTitle:@"Notify Friends" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    
    [alertvc addAction:actionOk];
    [alertvc addAction:actionNotify];
    
    BeaconInfo *beaconInfo = [[SharedData getInstance] beaconInfo];
    
    if(beaconInfo!=nil){
        NSString *beaconUrl = beaconInfo.url;
        BOOL beaconFound = beaconInfo.found;
        
        if(!beaconFound){
            if([url.absoluteString isEqualToString: beaconUrl]){
                
                UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (topController.presentedViewController) {
                    topController = topController.presentedViewController;
                }
                
                //Clear the beaconInfo value in the shared data class so that the alert does not show multiple times
                [SharedData getInstance].beaconInfo = nil;
                
                [topController presentViewController:alertvc animated:YES completion:nil];
            }
        }
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"If you close this app, beacon data cant be scanned"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:@"YES", nil];
//    [toast show];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
