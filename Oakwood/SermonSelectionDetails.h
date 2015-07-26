//
//  SermonSelectionDetails.h
//  Oakwood
//
//  Created by The Osterkamps on 12/20/14.
//  Copyright (c) 2014 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SermonDetails.h"
#import "DevotionalDetails.h"

//This is the container for the video and audio sermon details
@interface SermonSelectionDetails : NSObject
{
    
    
}

@property (retain) SermonDetails *sermon;
@property (retain) DevotionalDetails *devotional;
@property (copy) NSDate *sermonPublishDate;

@end
