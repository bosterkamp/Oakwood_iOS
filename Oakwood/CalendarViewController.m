//
//  CalendarViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 11/20/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "CalendarViewController.h"
//#import "CalendarDetails.h"
#import "EventDetails.h"
#import "ColorConverter.h"


@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"inside CalendarViewController");
    self.navigationItem.title = @"Calendar";
    
    [self.tableView setBackgroundColor: [ColorConverter colorFromHexString:@"#FFFFFF"]];
    [self.tableView setOpaque: NO];
    
    //Commented out until I get the calendar parsing working...
    myParser = [[CalendarParser alloc] init];
    /*NSMutableArray *calendar*/  tableData = [myParser parseXMLFile:@"http://oakwoodnb.com/calendars/all/feed/ical/"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    EventDetails *ed = [tableData objectAtIndex:indexPath.row];
    
    //NSLog(@"Event %@", [cd eventSummary]);
    if ([ed eventDate] == NULL)
    {
        [ed setEventDate:@""];
    }
    
    
    NSMutableString *cdDisplay = [[NSMutableString alloc] initWithString:[ed eventDate]];
    [cdDisplay appendString: @"\n"];
    [cdDisplay appendString: [ed eventSummary]];
    

    cell.textLabel.text = cdDisplay;
    
    cell.textLabel.numberOfLines = 0;
    //[cell.textLabel sizeToFit];
    //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create new thread to show activity indicator
    //[NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    /*
    BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
    
    NSString *scriptureUrlMobile = [[bvd scriptureUrl] stringByReplacingOccurrencesOfString:@"www" withString:@"mobile"];
    
    //Adding new view
    BibleVersesWebViewController* bibleVersesWebVC = [[BibleVersesWebViewController alloc] initWithUrl:scriptureUrlMobile];
    [self.navigationController pushViewController:bibleVersesWebVC animated:YES];
    //end
    [spinner stopAnimating];
    */
}

//Need to do this to ensure the full screen is covered upon orientation change.
/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Landscape");
        [webUIView  setFrame: self.view.bounds];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Portrait");
        [webUIView setFrame: self.view.bounds];
    }
    
    
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


@end
