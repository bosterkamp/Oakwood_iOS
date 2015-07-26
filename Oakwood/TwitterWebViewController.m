//
//  TwitterWebViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 9/17/14.
//  Copyright (c) 2014 Oakwood Baptist Church. All rights reserved.
//

#import "TwitterWebViewController.h"

@interface TwitterWebViewController ()

@end

@implementation TwitterWebViewController

UIActivityIndicatorView *spinner;
bool alreadySpinningTwitter = false;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    [spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)wv
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [spinner stopAnimating];
}

-(void) threadStartAnimating: (id) data
{
    if (!alreadySpinningTwitter)
    {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor blackColor];
        spinner.frame = self.view.bounds;
        [spinner startAnimating];
        [self.view addSubview:spinner];
        alreadySpinningTwitter = true;
    }
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://mobile.twitter.com/PastorRayStill"]]];
    self.view = webView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
