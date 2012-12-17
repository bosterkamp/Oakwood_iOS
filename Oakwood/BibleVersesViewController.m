//
//  BibleVersesViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVersesViewController.h"
#import "BibleVerseDetails.h"

@interface BibleVersesViewController ()

@end

@implementation BibleVersesViewController

@synthesize display, displayString;

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
    NSLog(@"inside BibleVersesViewController");
    self.navigationItem.title = @"Bible Verses";
    
    myConn = [[BibleVerseConnection alloc] init];
    
    
    //Set the returned NSMutableArray into the Controller NSArray
    tableData = [myConn connectWithURL];
    
    //NSLog(@"bibleVerses in controller: %@", bibleVerses);
    
    self.display.text = self.displayString;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
    NSMutableString *bvdDisplay = [[NSMutableString alloc] initWithString:[bvd dayOfWeek]];
    [bvdDisplay appendString: @": "];
    [bvdDisplay appendString: [bvd scriptureReference]];
     
    
    cell.textLabel.text = bvdDisplay;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
    
    //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    UIWebView *webUIView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    NSString *scriptureUrlMobile = [[bvd scriptureUrl] stringByReplacingOccurrencesOfString:@"www" withString:@"mobile"];
    
    [webUIView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: scriptureUrlMobile]]];
    [self.view addSubview:webUIView];
    
    
    
    //Do I need to release the controllers?
}


@end
