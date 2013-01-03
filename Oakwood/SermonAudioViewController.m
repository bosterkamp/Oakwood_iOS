//
//  SermonAudioViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/24/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "SermonAudioViewController.h"


@interface SermonAudioViewController ()

@end

@implementation SermonAudioViewController

@synthesize launchUrl;

MPMoviePlayerController *moviePlayerController;

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
    
    //Show alert just to show we know the URL
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sermon URL"
                                                    message:launchUrl
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    */
     
      /*WIP
    NSURL *sermonURL = [NSURL URLWithString: launchUrl];
    
    //
  
    //NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/audiofile.mp3", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sermonURL error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog([error description]);
	else
		[audioPlayer play];
    */
    
    //More WIP - Trying with movie player
    
    /*MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:launchUrl]];
    player.movieSourceType = MPMovieSourceTypeStreaming;
    player.view.hidden = YES;
    [self.view addSubview:player.view];
    [player play];
    */
    
    
    //End More WIP
    /*
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:launchUrl]];
       player.controlStyle = MPMovieControlStyleEmbedded;
    [player prepareToPlay];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: player.view];
    //player.shouldAutoplay = YES;
    // ...
 
    [player play];
    */
    
    //This actually works!

    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:launchUrl]];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(moviePlaybackComplete:)
                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                           object:moviePlayerController]; */
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:themovie.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    
    //[moviePlayerController.view setFrame:CGRectMake(38,100,250,163)];
    
    [moviePlayerController.view setFrame: self.view.bounds];
    [self.view addSubview:moviePlayerController.view];
    
    /*
    //TODO: Add a label with title
    CGRect  viewRect = CGRectMake(10, 10, 100, 100);
    //UIView* myView = [[UIView alloc] initWithFrame:viewRect];
    
    UILabel *label = [[UILabel alloc] initWithFrame:viewRect];
    [label setText:];
    //[label setBackgroundColor: [UIColor blackColor]];
    [label setTextColor:[UIColor whiteColor]];
    [self.view addSubview:label];
    */
    [moviePlayerController play];
    [self setController:moviePlayerController];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [moviePlayerController stop];
}

@end
