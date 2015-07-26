//
//  ViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 11/16/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "ViewController.h"
#import "FindUsViewController.h"
#import "CalendarViewController.h"
#import "SermonSelectionViewController.h"
#import "BibleVersesViewController.h"
#import "ERayViewController.h"
#import "TwitterWebViewController.h"

@interface ViewController ()

@end

int MenuSize = 500;

@implementation ViewController
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //automaticallyAdjustsScrollViewInsets
    
    //This is supposed to fix the menu, but it doesn't.
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //NSLog(@"ViewController loaded");
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator stopAnimating];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    //NSLog(@"deviceOrientation: %d", deviceOrientation);
    
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        //NSLog(@"Landscape View");
        [_scrollView setScrollEnabled:YES];
        //[self setLandscapeTextDimensions];
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) || deviceOrientation == 0)
    {
        //NSLog(@"Portrait View");
        [_scrollView setScrollEnabled:YES];
        //[self setPortraitTextDimensions];
    }
    

}

- (void) viewDidAppear:(BOOL)animated
{
    [_scrollView setScrollEnabled:YES];
    //_baseView.frame.size.width;
    [_scrollView setContentSize: CGSizeMake(_baseView.frame.size.width, MenuSize)];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)awakeFromNib
{
    //NSLog(@"stop animation");
    [_activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    //Make sure the activity indicator stops animating if we go back.
    [_activityIndicator stopAnimating];
    
    
    //Does this work when we go back??
    [_scrollView setScrollEnabled:YES];
    //_baseView.frame.size.width;
    //[_scrollView setContentSize: CGSizeMake(_baseView.frame.size.width, MenuSize)];
    //[_scrollView setContentOffset:CGPointZero animated:YES];
    //
    
    //Ensure we scroll back to the top, or we get odd behavior (unable to scroll to top) when in landscape mode and selecting one of the lower buttons.
    //[_scrollView setContentOffset:CGPointZero animated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ///NSLog(@"prepareForSegue");
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    //[_activityIndicator startAnimating];
}

-(void) threadStartAnimating: (id) data
{
    [_activityIndicator startAnimating];
    //NSLog(@"_activityIndicator startAnimating");

}

- (IBAction)informationRequest:(id)sender;
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Oakwood Mobile App"
                                                   message:@"Bryan Osterkamp - 2013, 2014"
                                                  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [view show];
}

- (IBAction)launchWebsite:(id)sender;
{
    //[NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.oakwoodnb.com"]];
}

- (IBAction)loadDevotionals:(id)sender;
{
    NSLog(@"Inside Loading");
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vimeo.com/m/channels/299087"]]];
    [self.view addSubview:webView];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        //[self setLandscapeTextDimensions];
        [_scrollView setScrollEnabled:YES];
        [_scrollView setContentSize: CGSizeMake(_baseView.frame.size.width, MenuSize)];
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        //[self setPortraitTextDimensions];
        [_scrollView setScrollEnabled:YES];
        [_scrollView setContentSize: CGSizeMake(_baseView.frame.size.width, MenuSize)];
    }
}


@end
