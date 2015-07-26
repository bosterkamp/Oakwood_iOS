//
//  DevotionSelectionViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 8/24/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "DevotionSelectionViewController.h"
#import "DevotionSelectionParser.h"
#import "ColorConverter.h"
#import "DevotionalDetails.h"
#import "BibleVersesWebViewController.h"
#import "SermonAudioViewController.h"

@interface DevotionSelectionViewController ()

@end

@implementation DevotionSelectionViewController


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
    
    //NSLog(@"inside DevotionSelectionViewController");
    self.navigationItem.title = @"Devotions";
    [self.tableView setBackgroundColor: [ColorConverter colorFromHexString:@"#FFFFFF"]];
    [self.tableView setOpaque: NO];
    
    DevotionSelectionParser *myParser = [[DevotionSelectionParser alloc] init];
    
    //Production...
    tableData = [myParser parseXMLFile:@"http://vimeo.com/channels/299087/videos/rss"];
    
    //For testing only
    //tableData = [myParser parseXMLFile:@"/Users/bosterkamp/Desktop/devotions_dates.txt"];
    //End for testing only
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    DevotionalDetails *dd = [tableData objectAtIndex:indexPath.row];
    NSMutableString *ddDisplay = [[NSMutableString alloc] initWithString:[dd devotionalName]];
    NSMutableString *ddUrl = [[NSMutableString alloc] initWithString:[dd devotionalUrl ]];
    cell.textLabel.text = ddDisplay;
    
    //NSLog(@"Devotional %i: Name: %@ - Url: %@", indexPath.row, ddDisplay, ddUrl);
    
    
    cell.textLabel.numberOfLines = 0;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"shouldHighlightRowAtIndexPath");
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DevotionalDetails *dd = [tableData objectAtIndex:indexPath.row];
    
    //Adding new view
    /*
    BibleVersesWebViewController* bibleVersesWebVC = [[BibleVersesWebViewController alloc] initWithUrl:[dd devotionalUrl]];
    [self.navigationController pushViewController:bibleVersesWebVC animated:YES];
*/
    SermonAudioViewController* sermonAudioVC = [[SermonAudioViewController alloc] init];
    sermonAudioVC.launchUrl = [dd devotionalUrl];
    [self.navigationController pushViewController:sermonAudioVC animated:YES];

}

//This looks pretty good for when two rows are needed.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

@end
