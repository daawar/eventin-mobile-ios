//
//  ViewController.m
//  Events
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
    // Do any additional setup after loading the view.
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShareEventViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
