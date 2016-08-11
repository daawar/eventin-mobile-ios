//
//  FriendsViewController.m
//  Events
//
//  Created by Daawar Khan on 7/27/16.
//

#import "FriendsViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "DBManager.h"
#import "SharedData.h"
#import "EventInfo.h"
@import AddressBook;

@interface FriendsViewController ()
{
    BOOL hasSearchResults;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong) NSMutableArray *contactsThatMatchSearch;
@property(nonatomic,strong) NSMutableArray *contactsSelectedForNotification;
@end



@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    
    _contacts = [[NSMutableArray alloc] init];
    
    [self loadContacts];
}


-(void) loadContacts{
    
    NSMutableArray *dbContacts = [[DBManager getSharedInstance] getContacts];
    
    //If there are contacts in database then get them in contacts array else get them from address book
    if([dbContacts count] > 0){
        for (NSInteger i = 0; i < [dbContacts count]; i++) {
            
            NSString *cName = [[dbContacts objectAtIndex:i] name];
            NSString *cPhone = [[dbContacts objectAtIndex:i] phone];
            NSString *cSelected = [[dbContacts objectAtIndex:i] selected];
            
            NSLog(@"%@, %@, %@",cName, cPhone, cSelected);
            
            Contact *c = [[Contact alloc] init];
            c.name = cName;
            c.phone = cPhone;
            c.selected = cSelected;
            
            [_contacts addObject:c];
        }
    }
    
    else{
    
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    // First time access has been granted, add the contact
                    [self addContactsToList];
                } else {
                    // User denied access
                    // Display an alert telling user the contact could not be added
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            [self addContactsToList];
        }
        else {
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
        }
        
    }//else
}

-(void) addContactsToList{
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *contactPhone;
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            
            if(phoneNumber){
                contactPhone = phoneNumber;
                NSLog(@"phone:%@", phoneNumber);
                break;
            }
        }
        
        Contact *c = [[Contact alloc] init];
        
        c.name = firstName;
        
        if(lastName){
            c.name = [[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];
        }
        
        c.phone = contactPhone;
        
        //make it unselected by default
        c.selected = @"NO";
        
        [_contacts addObject:c];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    _searchBar.text = @"";
    hasSearchResults = NO;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  hasSearchResults ? [_contactsThatMatchSearch count]:[_contacts count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *contactIdentifier = @"ContactInfoCell";
    
    ContactCell *cell = (ContactCell*)[_tableView dequeueReusableCellWithIdentifier:contactIdentifier];
    
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactIdentifier];
    }
    
    Contact *contact  = (hasSearchResults ?
                         [_contactsThatMatchSearch objectAtIndex:indexPath.row]:
                         [_contacts objectAtIndex:indexPath.row]);
    
    cell.lblName.text = contact.name;
    cell.lblPhone.text = contact.phone;
    
    if([contact.selected isEqualToString:@"YES"]){
        [cell.switchSelect setOn:YES animated:YES];
    }
    
    else{
        [cell.switchSelect setOn:NO];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UISearchBar Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    hasSearchResults = NO;
    if(searchText.length != 0){
        _contactsThatMatchSearch = [NSMutableArray array];
        for(Contact *c in _contacts)
            if([c.name rangeOfString:searchText options:NSCaseInsensitiveSearch|
                NSDiacriticInsensitiveSearch|NSAnchoredSearch].location != NSNotFound)
                [_contactsThatMatchSearch addObject:c];
        
        hasSearchResults = YES;
    }
    
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar
{
    [activeSearchBar resignFirstResponder];
}


- (IBAction)doneClick:(UIButton *)sender {
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    _contactsSelectedForNotification = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [_tableView numberOfRowsInSection:0]; ++i)
    {
        UITableViewCell *cellObj = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(cellObj){
            [cells addObject:cellObj];
        }
        
    }
    
    //Clear the table contact_details to avoid saving the same contacts repeatedly
    [[DBManager getSharedInstance] clearTable];
    
    for (ContactCell *cell in cells)
    {
        NSString* cName = cell.lblName.text;
        NSString* cPhone = cell.lblPhone.text;
        
        UISwitch* selectSwitch = cell.switchSelect;
        
        NSString* selected = @"NO";
        if([selectSwitch isOn]){
            selected = @"YES";
        }
        
        //Write to DB
        BOOL saveStatus = [[DBManager getSharedInstance] saveContact:cName phone:cPhone selected:selected];
        
        if(saveStatus){
            NSLog(@"Contact saved to database");
        }
        else{
            NSLog(@"Contact can't be saved");
        }
        
        if([selectSwitch isOn]){
            Contact *c = [[Contact alloc] init];
            c.name = cName;
            c.phone = cPhone;
            [_contactsSelectedForNotification addObject:c];
        }
    }
    
    NSMutableArray *dbContacts = [[DBManager getSharedInstance] getContacts];
    
    NSLog(@"Printing the contacts fetched from array");
    
    for (NSInteger i = 0; i < [dbContacts count]; i++) {
        NSLog(@"%@",[dbContacts objectAtIndex:i]);
    }
    
    [self prepareSMS];    
}

-(void) prepareSMS{
    NSLog(@"Sending SMS");
    
    for(int i = 0; i < [_contactsSelectedForNotification count];i++){
        Contact *contact = [_contactsSelectedForNotification objectAtIndex:i];
        NSString *name = contact.name;
        NSString *phone = contact.phone;
        
        EventInfo *info = [[SharedData getInstance] eventInfo];
        NSString *sEventTitle = info.eventTitle;
        NSString *sEventAddr = info.eventAddress;
        NSString *sEventStart = info.eventStart;
        
        NSString *message = @"Hi ";
        message = [NSString stringWithFormat:@"Hello %@, I am going for %@ at %@, %@.", name, sEventTitle, sEventAddr, sEventStart];
        
        [self sendSMS:phone withMessage:message];
    }
}

-(void) sendSMS : (NSString *)phoneNumber withMessage: (NSString *) message{
    
    //Replacing + in the phone String to %2B since HTTP request url creating parsing issues
    NSString *toNumber = phoneNumber;
    toNumber = [toNumber stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *twilioSID = @"AC20f75d87bb9c8ac7435d538857379384";
    NSString *twilioSecret = @"1d1be736876a3e933a38b1f0964ab6de";
    NSString *fromNumber = @"%2B14129688020";
    NSString *messageBody = message;
    
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", twilioSID, twilioSecret, twilioSID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", fromNumber, toNumber, messageBody];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handle the received data
    if (error) {
        NSLog(@"Error: %@", error);
        [self showToastMessage : @"Error Sending SMS"];
    } else {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
        [self showToastMessage : @"SMS Sent"];
    }
}

//This method is used to mimic notification functionality similar to Android's toast library
-(void) showToastMessage:(NSString *) message{
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
