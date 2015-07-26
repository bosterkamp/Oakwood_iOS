//
//  EventSorter.m
//  Oakwood
//
//  Created by The Osterkamps on 8/4/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "EventSorter.h"
#import "EventDetails.h"

@implementation EventSorter

+ (NSMutableArray *)sortEvents:(NSArray *)events {
    
    //Sort the events
    //First create the array of dictionaries
    NSString *eventDate = @"eventDate";
    NSString *eventSummary = @"eventSummary";
    //NSString *eventUrl = @"eventUrl";
    NSString *eventDescription = @"eventDescription";
    EventDetails *ed;
    
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *sortedArray;
    NSMutableArray *reconstructedArray = [NSMutableArray array];
    
    NSDictionary *dict;

    int *serialNumber = 0;
    

    
    
    for (EventDetails *selectedEvent in events)
    {
        serialNumber++;
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *updatedDate;
        NSString *formattedDate;
        
        //Need to format the strings into dates before putting in...
        //Create events for each day...
        if ([[selectedEvent eventDate] rangeOfString:@":"].location == NSNotFound)
        {  
            [dateFormat setDateFormat:@"EEEE MMMM d, yyyy"];
            updatedDate = [dateFormat dateFromString:[selectedEvent eventDate]];
            [dateFormat setDateFormat:@"yyyyMMdd"];
            
        }
        else
        {
            [dateFormat setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
            updatedDate = [dateFormat dateFromString:[selectedEvent eventDate]];
            [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
        }
        
        //Convert all into the same format?
        formattedDate = [dateFormat stringFromDate:updatedDate];
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                //@"serialNumber", serialNumber, //Blowing up here... 
                 formattedDate,eventDate,
                 [selectedEvent eventSummary],eventSummary,
                 [selectedEvent eventDescription],eventDescription,
                nil];
        [array addObject:dict];
    }
    
    //Make a loop to set these up...
 /*
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Jo", first, @"Smith", last, nil];
    [array addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Joe", first, @"Smith", last, nil];
    [array addObject:dict];
   */ 
    
    //Next we sort the contents of the array by event date
    
    // The results are likely to be shown to a user
    // Note the use of the localizedCaseInsensitiveCompare: selector
    NSSortDescriptor *lastDescriptor =
    [[NSSortDescriptor alloc] initWithKey:eventDate
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    /*
    NSSortDescriptor *firstDescriptor =
    [[NSSortDescriptor alloc] initWithKey:first
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    */
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, /*firstDescriptor,*/ nil];
    sortedArray = [array sortedArrayUsingDescriptors:descriptors];
    
    
    //NSLog (@"Sorted array size: %lu", (unsigned long)[sortedArray count]);
    
    //Recreate the array with proper strings and EventDetails...
    for (NSDictionary *selectedEvent in sortedArray)
    {
        NSDate *tempDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //tempDate = [dateFormat dateFromString:[dict objectForKey:eventDate]];
        
        //Need another formatting...
        if ([[selectedEvent objectForKey:eventDate] rangeOfString:@"Z"].location == NSNotFound)
        {
            [dateFormat setDateFormat:@"yyyyMMdd"];
            //NSLog(@"Before Conversion: %@", [selectedEvent objectForKey:eventDate]);
            tempDate = [dateFormat dateFromString:[selectedEvent objectForKey:eventDate]];
            //correctedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/Chicago"]];
            [dateFormat setDateFormat:@"EEEE MMMM d, yyyy"];
        }
        else
        {
            //If String contains 'Z', then format this way
            [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
            
            //No "correction" needed for timezone dates, so just set corrected date directly.
            tempDate = [dateFormat dateFromString:[selectedEvent objectForKey:eventDate]];
            //date = [dateFormat dateFromString:dateStr];
            //correctedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/Chicago"]];
            [dateFormat setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
            
        }
        
        
        //NSLog(@"Event: %@", [selectedEvent objectForKey:eventDate]);
        
        ed = [[EventDetails alloc] init];
        
        [ed setEventDate: [dateFormat stringFromDate:tempDate]];
        //NSLog(@"After Conversion: %@", [ed eventDate]);
        [ed setEventSummary: [selectedEvent objectForKey:eventSummary]];
        [ed setEventDescription:[selectedEvent objectForKey:eventDescription]];
        
        
        [reconstructedArray addObject:ed];
    }
    
    //END
    
    
    return reconstructedArray;
    
}
@end
