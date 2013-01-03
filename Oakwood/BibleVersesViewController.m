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
    NSLog(@"inside BibleVersesViewController");
    self.navigationItem.title = @"Bible Verses";
    
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
    //Create new thread to show activity indicator
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BibleVerseDetails *bvd = [tableData objectAtIndex:indexPath.row];
    
    //TODO May want to load this in a new controller, to be able to manage it separately...
    
    //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    webUIView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    //UIWebView *webUIView = [[UIWebView alloc] init];
    
    NSString *scriptureUrlMobile = [[bvd scriptureUrl] stringByReplacingOccurrencesOfString:@"www" withString:@"mobile"];
    
    [webUIView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: scriptureUrlMobile]]];
    
    //Trying to setup notification for spinner
    //[[NSNotificationCenter defaultCenter] addObserver:webUIView selector:@selector() name:WebUIViewRequestLoaded object:webUIView];
    //
    
    [self.view addSubview:webUIView];
    [spinner stopAnimating];
    
}

//Need to do this to ensure the full screen is covered upon orientation change.
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

- (void)webViewDidFinishLoading:(UIWebView *)wv
{
    NSLog(@"finished loading");
}

-(void) threadStartAnimating: (id) data
{
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner startAnimating];
}



@end
