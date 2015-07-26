//
//  SermonFormatter.m
//  Oakwood
//
//  Created by The Osterkamps on 12/10/14.
//  Copyright (c) 2014 Oakwood Baptist Church. All rights reserved.
//

#import "SermonFormatter.h"
#import "SermonDetails.h"
#import "DevotionalDetails.h"
#import "SermonSelectionDetails.h"
#import "SermonSelectionDetails.m"


@implementation SermonFormatter
+(NSDictionary *)formatSermons:(NSArray *)videoSermons audioSermon:(NSArray *)audioSermons
{
    //Create dictionary to hold audio and video sermons to return
    NSMutableDictionary *mergedSermons = [[NSMutableDictionary alloc]init];
    
    //Loop through the audio events
    for (SermonDetails *selectedEvent in audioSermons)
    {
        SermonSelectionDetails *sermonSelection = [[SermonSelectionDetails alloc] init];
        //sermonSelection = [[SermonSelectionDetails alloc] init];
        [sermonSelection setSermon:selectedEvent];
        
        //Set the higher level publish date so we can use it in the comparator easier.
        [sermonSelection setSermonPublishDate:[selectedEvent sermonPublishDate]];
        
        [mergedSermons setObject:sermonSelection forKey:[selectedEvent sermonName]];
    }
    
    //Loop through the video events
    for (DevotionalDetails *ddEvent in videoSermons)
    {
            //NSLog(@"Video Sermon Name: %@", [ddEvent devotionalName] );
            //NSLog(@"Video Published Date: %@", [ddEvent devotionalPublishDate]);

        
        for (id key in [mergedSermons allKeys])
        {
            //NSLog(@"%@ - %@",key,[mergedSermons objectForKey:key]);
            SermonSelectionDetails *ssd = [mergedSermons objectForKey:key];
            if (ssd != nil)
            {
                SermonDetails *sd = [ssd sermon];
                if (sd != nil)
                {
                    //NSLog(@"Audio: %@", [sd sermonName]);
                    if ([[sd sermonName] caseInsensitiveCompare:[ddEvent devotionalName]] == NSOrderedSame)
                        //([[sd sermonName] isEqualToString:[ddEvent devotionalName]])
                        //if ([myString1 caseInsensitiveCompare:myString2] == NSOrderedSame)
                         {
                             //We want to set the video, not the dictionary
                             [ssd setDevotional:ddEvent];
                             //NSLog(@"Match!");
                             //[mergedSermons setObject:ddEvent forKey:[sd sermonName]];
                         }
                         else
                        {
                            //NSLog(@"No Match :(");
                        }
                    
                }
            }

        }
     }
    

    //Print out the dictionary to see what we have (temp)
    
    /*
    for (id key in [mergedSermons allKeys])
        {
            NSLog(@"____________Starting To Print Objects____________");
            //NSLog(@"%@ - %@",key,[mergedSermons objectForKey:key]);
            SermonSelectionDetails *ssd = [mergedSermons objectForKey:key];
            if (ssd != nil)
            {
                SermonDetails *sd = [ssd sermon];
                if (sd != nil)
                {
                    NSLog(@"Audio: %@", [sd sermonName]);

                }
                else
                {
                    NSLog(@"No Audio");
                }
                
                DevotionalDetails *dd = [ssd devotional];
                if (dd != nil)
                {
                    NSLog(@"Video: %@", [dd devotionalName]);
                }
                else
                {
                    NSLog(@"No Video");
                }
                
                
            }
            

    }
    */
 
    return mergedSermons;
}

@end
