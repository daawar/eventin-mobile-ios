//
//  CategoriesViewController.m
//  Events
//  Modified by Daawar Khan on 27/7/16.
//

#import "CategoriesViewController.h"
#import "APIClient.h"
#import "EventCategory.h"
#import "EventsViewController.h"
#import "DBManager.h"
#import "SharedData.h"

@interface CategoriesViewController (){
    BOOL hasSearchResults;
}

@property(nonatomic,strong) IBOutlet NSMutableArray *categoriesThatMatchSearch;
@property(nonatomic,strong) IBOutlet NSMutableArray *categoriesArray;
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end

static NSString *CategoryCellIdentifier = @"CategoryCellID";

@implementation CategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![SharedData getInstance].tblCleared){
    [[DBManager getSharedInstance] clearTable];
        [SharedData getInstance].tblCleared = YES;
    }
    
    [self loadCategories];
}

-(void) viewDidAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated{
    _searchBar.text = @"";
    hasSearchResults = NO;
    [_tableView reloadData];
}

-(void)loadCategories{
    
    [[APIClient shareClient] fetchCategoriesOnsuccess:^(NSArray *categories) {
        
        if(!_categoriesArray)
            _categoriesArray = [NSMutableArray arrayWithCapacity:categories.count];
        [_categoriesArray addObjectsFromArray:categories];
        [_tableView reloadData];
        
    } Onfailure:^(void) {
        
    }];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  hasSearchResults ? [_categoriesThatMatchSearch count]:[_categoriesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    EventCategory *category  = (hasSearchResults ?
                                [_categoriesThatMatchSearch objectAtIndex:indexPath.row]:
                                [_categoriesArray objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = category.name;
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"events"]){
        [_searchBar resignFirstResponder];
        EventsViewController *events = (EventsViewController *)[segue destinationViewController];
        UITableViewCell *selectedCell = (UITableViewCell*)sender;
        events.categoryName = selectedCell.textLabel.text;
    }
}

#pragma mark - UIScrollView Methods
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollview{
    [_searchBar resignFirstResponder];
}


#pragma mark - UISearchBar Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    hasSearchResults = NO;
    if(searchText.length != 0){
        _categoriesThatMatchSearch = [NSMutableArray array];
        for(EventCategory *c in _categoriesArray)
            if([c.name rangeOfString:searchText options:NSCaseInsensitiveSearch|
                NSDiacriticInsensitiveSearch|NSAnchoredSearch].location != NSNotFound)
                [_categoriesThatMatchSearch addObject:c];
        
        hasSearchResults = YES;
    }
    
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar
{
    [activeSearchBar resignFirstResponder];
}


@end