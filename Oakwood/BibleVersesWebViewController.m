//
//  BibleVersesWebViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 4/19/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVersesWebViewController.h"

@interface BibleVersesWebViewController ()

@end

@implementation BibleVersesWebViewController

UIActivityIndicatorView *spinner;
bool alreadySpinning = false;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUrl:(NSString *)launchUrl
{
    self = [super init];
    // ...
    // NSLog(@"initWithUrl");
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    
    //Just make it generic.
    //self.title = @"Bible Verse";
    
    //NSLog(@"Launch Url init: %@", launchUrl);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: launchUrl]]];
    // ...
    [self.view addSubview:webView];
    return self;
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    //[spinner startAnimating];
    //NSLog(@"shouldStartLoadWithRequest");
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    //[activityIndicator stopAnimating];
    //NSLog(@"webViewDidFinishLoad of webview");
    [spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)wv
{
    //[spinner startAnimating];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    //[webView addSubview:_activityIndicator];
    //[webView bringSubviewToFront:_activityIndicator];
    //NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [spinner stopAnimating];
    //NSLog(@"didFailLoadWithError");
}

-(void) threadStartAnimating: (id) data
{
    //[_activityIndicator startAnimating];
    
    if (!alreadySpinning)
    {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor blackColor];
        spinner.frame = self.view.bounds;
        [spinner startAnimating];
        [self.view addSubview:spinner];
        alreadySpinning = true;
    }

    
}

@end
