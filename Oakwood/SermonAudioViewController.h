//
//  SermonAudioViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 12/24/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SermonAudioViewController : UIViewController
{

}

//Need to retain the MPMoviePlayerController, so setting the controller to strong.
@property (nonatomic, strong) MPMoviePlayerController *controller;

@property         NSString *launchUrl;

@end
