//
//  SermonAudioViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/24/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "SermonAudioViewController.h"
#import "ColorConverter.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SermonAudioViewController ()

@end

@implementation SermonAudioViewController

@synthesize launchUrl;

bool launchedSermon = false;

//MPMoviePlayerController *moviePlayerController;

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
    launchedSermon = false;
    
    //Setting up audio mode
    
    // Registers this class as the delegate of the audio session.
	[[AVAudioSession sharedInstance] setDelegate: self];
	
	
	// Use this code instead to allow the app sound to continue to play when the screen is locked.
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
	
	NSError *myErr;
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&myErr];

    /*
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) {  handle the error condition  }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {  handle the error condition  }
    */

    //End
    
    // Do any additional setup after loading the view from its nib.
    
    //This actually works!
    
    //moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"]];

    /*
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"player.vimeo.com/video/37340275"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    
    //[moviePlayerController.view setFrame:CGRectMake(38,100,250,163)];
    
    
    //CWORKING
    
    [moviePlayerController.view setFrame: self.view.bounds];
    moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [moviePlayerController.view setBackgroundColor:[ColorConverter colorFromHexString:@"#FFFFFF"]];
    [self.view addSubview:moviePlayerController.view];
    
     //WORKING
    
    [moviePlayerController setFullscreen:YES animated:NO];
    moviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
    [moviePlayerController play];

     
     

    NSLog(@"Launched Sermon: %d", launchedSermon);
    */
    webView = [[UIWebView alloc] /*initWithFrame:CGRectMake(0.0,0.0,1.0,1.0)];*/initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    
    //This is why it is loading the player...
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: launchUrl]]];
    [self.view addSubview:webView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Landscape");
        [moviePlayerController.view setFrame: self.view.bounds];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Portrait");
        [moviePlayerController.view setFrame: self.view.bounds];
    }
    
    
}
 */

//Listener for completion of the audio.

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    NSLog(@"inside playbackdidfinish");
    
    MPMoviePlayerController *theMovie = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie stop];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[moviePlayerController stop];
    NSLog(@"viewDidDisappear");
    launchedSermon = true;
}

- (void) viewWillAppear:(BOOL)animated
{

}

- (void) viewDidAppear:(BOOL)animated
{
    //Make sure the activity indicator stops animating if we go back.
    NSLog(@"viewDidAppear");
    NSLog(@"Launched Sermon: %d", launchedSermon);
    
    if (launchedSermon)
    {
        //[self.parentViewController dismissModalViewControllerAnimated:YES];
        NSLog(@"going back!");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    // Do whatever you want here
     NSLog(@"webViewDidStartLoad!");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Do whatever you want here
    NSLog(@"webViewDidFinishLoad!");
}

@end
