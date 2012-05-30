//
//  WorkListViewController.m  copied from ViewController
// 
//


#import "WorkListViewController.h"

//MAYBE USE GCD BACKGROUND QUEUE FROM
//#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface WorkListViewController ()
@property (nonatomic, copy) NSArray *allItems;
@property (nonatomic, copy) NSArray *searchResults;
@end


@implementation WorkListViewController


@synthesize searchBar = _searchBar;
@synthesize searchDisplayController;
@synthesize allItems;
@synthesize searchResults;

NSString* oppTrackerUrl;
int alt = 1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    read the url from the plist
    NSBundle* mainBundle;
    mainBundle = [NSBundle mainBundle];
    oppTrackerUrl = [mainBundle objectForInfoDictionaryKey:@"OppTrackerUrl"];    
#ifdef DEBUG
    NSLog(@"url from plit is= %@",  oppTrackerUrl);
#endif
    
    self.tableView.scrollEnabled = YES;
    
    self.allItems = [NSArray arrayWithObjects:
                     @"Boots",
                     @"WH Smith",
                     @"Jaguar",
                     @"Hornet Plc",
                     nil];
    
    
    
    //     populate the base list with the top 10: could change to last used maybe 
    //    [self filterContentForSearchTextFromOppTracker : @""];
    
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


// remember this controller is handling two views: the base view and the search results
// return the number of rows from the appropriate list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else {
        rows = [self.allItems count];
    }
    
    return rows;
}


// remember this controller is handling two views: the base view and the search results
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"workCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //         this bit adds the > at the end of each table row
        //         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    }
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = 
        [self.searchResults objectAtIndex:indexPath.row];
        
    }
    else{
        UILabel *cellLabel = (UILabel *)[cell viewWithTag:102];
        cellLabel.text = [self.allItems objectAtIndex:indexPath.row];
        
        UILabel *cellLabel2 = (UILabel *)[cell viewWithTag:103];
        cellLabel2.text = @"More detail about this quote like rate and stuff. Maybe some star rating for prospect rating";
        
        
        
        //        cell.textLabel.text = [self.allItems objectAtIndex:indexPath.row];
        
               UIImageView * imageView = (UIImageView *) [cell viewWithTag:101];
        if (alt == 1) {
            imageView.image = [UIImage imageNamed:@"aquila30x33.png"];
            alt =0;
        } else {
            imageView.image = [UIImage imageNamed:@"wizhat30x33.jpg"];
            alt =1;
        }
        
    }
#ifdef DEBUG
    NSLog(@"cell text label= %@",  cell.textLabel.text);
#endif
    return cell;
}


#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //     recall the JSON service
    [self filterContentForSearchTextFromOppTracker : searchString];
    
    //     technically there is only one broker list...but lets retain the base list / search list metaphore
    self.searchResults = allItems; 
    return YES;
}



#pragma mark - 
// scope is the scope of the search e.g all brokers or just my brokers
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // recall the JSON service
    return NO;
}

#pragma mark FILTER THE SEARCH RESULTS FROM OPPTRACKER
- (void)filterContentForSearchTextFromOppTracker:(NSString*)searchText 

{
    
    // needed to add hosts entry, disable session expired filter and remove security from JSON method to get this working
    NSMutableString* urlStr =  [NSMutableString new] ;
    [urlStr setString :  oppTrackerUrl];
    
    NSString* escapedSearchText =[searchText stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"escaped search string is:%@",escapedSearchText);
#endif
    [urlStr appendString:escapedSearchText];
#ifdef DEBUG
    NSLog(@"url is:%@",urlStr);
#endif
    NSURL* url = [NSURL URLWithString:urlStr];
    NSError* error = nil;   
    NSData* data = [NSData dataWithContentsOfURL: url  options: NSDataReadingUncached error: &error];
    
#ifdef DEBUG
    NSLog(@"error is:%@",error);
    NSLog(@"data is:%@",data);
#endif
    
    if (data != nil) {
        [self fetchedDataForOppTracker:data]; // this could be async
    }
    
    
}


#pragma mark TODO use real broker objects!

-(void) fetchedDataForOppTracker: (NSData*) responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* result = [json objectForKey:@"result"];
#ifdef DEBUG
    NSLog(@"result is %@",result);
#endif 
    NSMutableArray* brokers = [NSMutableArray new];
    for(id entry in result) {
        NSNumber* brokerId = [entry objectForKey:@"id"];
        NSString* brokerName = [entry objectForKey:@"name"];
#ifdef DEBUG
        NSLog(@"id is %@",brokerId);
        NSLog(@"name is %@",brokerName);
#endif        
        [brokers addObject: brokerName];        
    }
    allItems = brokers;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSUInteger row = indexPath.row;
    //    NSString *rowValue;
    //    
    //    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
    //        rowValue = [searchResults objectAtIndex:row];
    //    } else {
    //        rowValue = [allItems objectAtIndex:row];
    //    }
    //    NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Broker Selected!" message:message delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    [self performSegueWithIdentifier:@"workSelected" sender:self];
}




@end
