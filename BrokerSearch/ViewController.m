//
//  ViewController.m
//  BrokerSearch
//
//  Created by Mark Houghton on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

//BACKGROUND QUEUE FROM GCD
#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//URL FOR DATA
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]

//needs to be mutable
//#define searchBrokerAsJSONURL [NSURL URLWithString: @"http://appd041a:8080/OppTracker/brokerMain/searchBrokerAsJSON"]



@interface ViewController ()

@end


@implementation ViewController


@synthesize searchBar = _searchBar;
@synthesize searchDisplayController;
@synthesize allItems;
@synthesize searchResults;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
    
    //TODO  REPLACE WITH JSON LOOKUP
//    NSArray *items = [[NSArray alloc] initWithObjects:
//                      @"Alexander Forbes",
//                      @"Aon Hewitt'",
//                      @"Atlas consulting",
//                      @"AWD Chase",
//                      @"Barclays",
//                      @"Bartlett Group",
//                      nil];
    
    
    // start the data download ona background thread queue managed by GCD
  //  dispatch_async(kBgQueue, ^{
        //NSData* data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
        
        // when finished execute the fetched data on the main thread
       // [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    //});
    
    //[self fetchedData:data];
    
    //self.allItems = items;
    
    //[self.tableView reloadData];
    
    [self filterContentForSearchTextFromOppTracker : @""];
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else{
        rows = [self.allItems count];
    }
    
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // this bit adds the > at the end of each table row
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    return cell;
}


#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // recall the JSON service rather than filter the array list
    
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
   
    // recall the JSON service
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

#pragma FILTER THE SEARCH RESULTS
- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.allItems filteredArrayUsingPredicate:resultPredicate];
}






- (void) fetchedData: (NSData *) responseData 
{
    
    
    // PARSE THE RESPONSE DATA
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* latestLoans = [json objectForKey:@"loans"];
//    NSLog(@"loans: %@",latestLoans);
    
    
    
    
    // iterate over each NSDictionary type
    NSMutableArray* activities = [NSMutableArray new];
    for (id loan in latestLoans) {
        [activities addObject:[loan objectForKey:@"activity"]];        
    }
    
    allItems = activities;
    
    
    
    
//    NSDictionary* loan = [latestLoans objectAtIndex:0];
//    
//    NSNumber* fundedAmount = [loan objectForKey:@"funded_amount"];
//    NSNumber* loanAmount = [loan objectForKey:@"loan_amount"];
//    
//    float outstandingAmount = [loanAmount floatValue] - [fundedAmount floatValue];
//    
//    humanReadable.text = [NSString stringWithFormat:@"Latest loan: %@ from %@ needs another $%.2f to pursue their entreprenueal dream", 
//                          [loan objectForKey:@"name"],
//                          [(NSDictionary*)[loan objectForKey:@"location"] 
//                           objectForKey:@"country"],
//                          outstandingAmount];
//    
//    
//    
//    //build an info object and convert to json
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
//                          [loan objectForKey:@"name"], @"who",
//                          [(NSDictionary*)[loan objectForKey:@"location"] 
//                           objectForKey:@"country"], @"where",
//                          [NSNumber numberWithFloat: outstandingAmount], @"what",nil];
//    
//    
//    // CREATE A JSON RESPONSE  ,
//    
//    //convert object to data
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info 
//                                                       options:NSJSONWritingPrettyPrinted error:&error];
//    
//    //print out the data contents
//    jsonSummary.text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


#pragma FILTER THE SEARCH RESULTS FROM OPPTRACKER
- (void)filterContentForSearchTextFromOppTracker:(NSString*)searchText 
                          
{
 
    // append the query string to the url
    NSMutableString* url =[NSMutableString stringWithCapacity: 1000];
                           
    [url appendString: @"http://appd041a:8080/OppTracker/brokerMain/searchBrokerAsJSON?query="] ;
    
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: url]];
    
    [self fetchedData:data]; // this could be async

    
    
}


@end
