//
//  WorkListDetailViewController.m
//  BrokerSearch
//
//  Created by Mark Houghton on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkListDetailViewController.h"

@interface WorkListDetailViewController ()

@end

NSArray *outcomes;

@implementation WorkListDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    outcomes = [NSArray arrayWithObjects: @"Undecided" , @"Won" , @"Closed Off" , @"Declined", @"Pending on Risk", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"outcome"];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //    [self.view addSubview:myPickerView];
    //    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    //	myPickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	
	// check if our date picker is already on screen
    //	if (myPickerView.superview == nil)
    //	{
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    //         UIPickerView *myPickerView = [UIPickerView alloc];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    //        [self.view addSubview:myPickerView];
    
    [self.view.window addSubview: myPickerView];
    self.view.window.autoresizesSubviews = NO;
    self.view.autoresizesSubviews = NO;
    myPickerView.backgroundColor = [UIColor redColor];
    
    //		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
    //		//
    //		// compute the start frame
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(200,
                                  screenRect.origin.y + screenRect.size.height,
                                  pickerSize.width, pickerSize.height);
    myPickerView.frame = startRect;
    myPickerView.opaque = YES;

    //		// compute the end frame
    CGRect pickerRect = CGRectMake(200,
                                   screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    //		// start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    
    myPickerView.frame = pickerRect;
    
    
    // shrink the table vertical size to make room for the date picker
    CGRect newFrame = self.tableView.frame;
    newFrame.size.height -= myPickerView.frame.size.height;
    self.tableView.frame = newFrame;
    [UIView commitAnimations];
    //		
    //		// add the "Done" button to the nav bar
    ////		self.navigationItem.rightBarButtonItem = self.doneButton;
    
    //    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    //    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"outcome"];
    
    NSIndexPath *a = [NSIndexPath indexPathForRow:0 inSection:0]; // I wanted to update this cell specifically
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:a];
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
#ifdef DEBUG
    NSLog(@"BEFORE cell text label= %@",  cell.textLabel.text);
#endif
    cellLabel.text = [outcomes objectAtIndex:row];
#ifdef DEBUG
    NSLog(@"AFTER cell text label= %@",  cell.textLabel.text);
#endif
    
    
    // slide down the date picker
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
    pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.tableView.frame;
	newFrame.size.height += pickerView.frame.size.height;
	self.tableView.frame = newFrame;
	
	// remove the "Done" button in the nav bar
    //	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    [self.tableView setNeedsLayout];
    
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 5;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [outcomes objectAtIndex:row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
    //	[self.pickerView removeFromSuperview];
}


@end
