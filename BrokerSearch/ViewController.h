//
//  ViewController.h
//  BrokerSearch
//
//  Created by Mark Houghton on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController {
    // ALL THESE ADDED MANUALLY
//    UISearchDisplayController *searchDisplayController;
//    UISearchBar *searchBar;
//    NSArray *allItems;
//    NSArray *searchResults;
}


// CLICK DRAGGED VIA ASSISTANT EDITOR FROM GUI TO .H
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

// CLICK DRAGGED VIA ASSISTANT EDITOR FROM GUI TO .H
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;


@end
