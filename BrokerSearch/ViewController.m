//
//  ViewController.m
//  BrokerSearch
//
//  Created by Mark Houghton on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// see http://www.raywenderlich.com/5492/working-with-json-in-ios-5 for JSON stuff and a touch of GCD
// see http://ygamretuta.me/2011/08/10/ios-implementing-a-basic-search-uisearchdisplaycontroller-and-interface-builder/ for UISearchControllerStuff
//
//
// Connected to LT020671 running customised version of OppTracker:-
// - add hosts entry;
// - disable session expired filter in OppTracker
// - removed security from searchBrokerAsJSON method (otherwise we'd need to be logged in)
//
//  To disable DEBUG, search for 'macros' in the project build settings and delete the DEBUG macro definition
//
// Improvements
// - implement scope filtering (OppTracker change required)
// - implement bookmarks
// - use broker objects rather than strings
// - use GCD to move data retrieval from main thread
// - unit tests
// - use a bespoke Opptracker service: OppTracker-iOS
// 
//

#import "ViewController.h"

//MAYBE USE GCD BACKGROUND QUEUE FROM
//#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface ViewController ()

@end


@implementation ViewController


@synthesize searchBar = _searchBar;
@synthesize searchDisplayController;
@synthesize allItems;
@synthesize searchResults;

NSString* oppTrackerUrl;

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
    
//     populate the base list with the top 10: could change to last used maybe 
    [self filterContentForSearchTextFromOppTracker : @""];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//         this bit adds the > at the end of each table row
//         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = 
        [self.searchResults objectAtIndex:indexPath.row];
        
    }
    else{
        cell.textLabel.text = 
        [self.allItems objectAtIndex:indexPath.row];
        
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
    NSUInteger row = indexPath.row;
    NSString *rowValue;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rowValue = [searchResults objectAtIndex:row];
    } else {
        rowValue = [allItems objectAtIndex:row];
    }
    NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Broker Selected!" message:message delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
