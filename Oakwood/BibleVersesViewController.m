//
//  BibleVersesViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVersesViewController.h"
#import "BibleVerseDetails.h"
#import "ColorConverter.h"
#import "BibleVersesWebViewController.h"


@interface BibleVersesViewController ()

@end

@implementation BibleVersesViewController

@synthesize display, displayString;

UIWebView *webUIView;
UIActivityIndicatorView *spinner;

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
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"inside BibleVersesViewController");
    self.navigationItem.title = @"Bible Verses";
    [self.tableView setBackgroundColor: [ColorConverter colorFromHexString:@"#FFFFFF"]];
    [self.tableView setOpaque: NO];
    

    
    myParser = [[BibleVerseParser alloc] init];

    //Set the returned NSMutableArray into the Controller NSArray
    tableData = [myParser parseXMLFile:@"http://oakwoodnb.com/category/sermons/feed"];
    
    //NSLog(@"bibleVerses in controller: %@", bibleVerses);
    
    self.display.text = self.displayString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Trying some things...
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retVal = 1;
    if (0 == section)
    {
        retVal = [tableData count] - 1;
    }
    if (1 == section)
    {
        retVal = 1;
    }
    
    return retVal;
    
}
//

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.section == 0)
    {

        BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
        NSMutableString *bvdDisplay = [[NSMutableString alloc] initWithString:[bvd dayOfWeek]];
        [bvdDisplay appendString: @": "];
        [bvdDisplay appendString: [bvd scriptureReference]];
        
        
        cell.textLabel.text = bvdDisplay;
    }
    
    if (indexPath.section == 1)
    {
        NSInteger lastOne = [tableData count] - 1;
        BibleVerseDetails *memVerse =[tableData objectAtIndex:lastOne];
        NSMutableString *scriptureDisplay = [[NSMutableString alloc] initWithString:[memVerse scriptureReference] ];
        
        //[disclaimerDisplay appendString:[memVerse scriptureReference]];
        [scriptureDisplay appendString:@"\nNote: Tapping on a bible verse will redirect you to mobile.biblegateway.com."];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.numberOfLines = 0;
        cell.userInteractionEnabled = false;
        cell.textLabel.text = scriptureDisplay;
    }
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
    
    if (indexPath.section == 1)
    {
        height = 150;
    }

    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        //Create new thread to show activity indicator
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
        
        NSString *scriptureUrlMobile = [[bvd scriptureUrl] stringByReplacingOccurrencesOfString:@"www" withString:@"mobile"];
        
        //Adding new view
        BibleVersesWebViewController* bibleVersesWebVC = [[BibleVersesWebViewController alloc] initWithUrl:scriptureUrlMobile];
        [self.navigationController pushViewController:bibleVersesWebVC animated:YES];
        //end
        [spinner stopAnimating];
    }
    
    
}

//Need to do this to ensure the full screen is covered upon orientation change.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //NSLog(@"Landscape");
        [webUIView  setFrame: self.view.bounds];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //NSLog(@"Portrait");
        [webUIView setFrame: self.view.bounds];
    }
    
    
}

- (void)webViewDidFinishLoading:(UIWebView *)wv
{
    //NSLog(@"finished loading");
}

-(void) threadStartAnimating: (id) data
{
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner startAnimating];
}
/*
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    //TextField
    UITextView *findUsText = [[UITextView alloc] initWithFrame:self.view.bounds];
    findUsText.textColor = [UIColor blackColor];
    findUsText.font = [UIFont systemFontOfSize:14.0];
    findUsText.text = @"Note: Tapping on a bible verse will redirect you to mobile.biblegateway.com.";
    findUsText.backgroundColor = [UIColor clearColor];
    findUsText.editable = FALSE;
    
    return findUsText;
}


-(CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section
{
        return 65.0f;
}
*/
@end
