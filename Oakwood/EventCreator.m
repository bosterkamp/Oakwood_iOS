//
//  EventCreator.m
//  Oakwood
//
//  Created by The Osterkamps on 7/14/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "EventCreator.h"
#import "EventFormatter.h"
#import "EventDetails.h"

@implementation EventCreator

//This is a helper method to format strings into CST NSDates
+ (NSArray *)createEvents:(CalendarDetails *)calendarDetails {
    
    NSMutableArray *createdEvents = [[NSMutableArray alloc] init];
    
    //Pull in the start date as the date we will iterate over
    NSString *iterationDateStr = [calendarDetails eventStartDate];
    NSString *cdEndDate = [calendarDetails eventEndDate];
   // NSLog(@"Event Start Date: %@", iterationDateStr);
   // NSLog(@"End Date: %@", cdEndDate);
    
    
    NSDate *updatedDate;
    NSDate *endDate;
    NSDate *now = [NSDate date];
    
    NSString *today;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    //Create events for each day...
    if ([iterationDateStr rangeOfString:@":"].location == NSNotFound)
    {
        //NSLog(@"**Updated Date: %@", iterationDateStr);

        [dateFormat setDateFormat:@"EEEE MMMM d, yyyy"];
        updatedDate = [dateFormat dateFromString:iterationDateStr];
        
        //NSLog(@"!!Updated Date: %@", [dateFormat stringFromDate: updatedDate]);
        
    }
    else
    {
        //NSLog(@"###Updated Date Z: %@", iterationDateStr);
        
        //If String contains 'Z', then format this way
        //[dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
        [dateFormat setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
        
        //No "correction" needed for timezone dates, so just set corrected date directly.
        updatedDate = [dateFormat dateFromString:iterationDateStr];
        //date = [dateFormat dateFromString:dateStr];
        //correctedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
        //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/Chicago"]];
        //[dateFormat setDateFormat:@"EEEE MMMM d, YYYY - h:mm a"];
        
    }
    
    //NSLog(@"Updated Date: %@", [dateFormat stringFromDate: updatedDate]);
    //NSLog(@"End Date: %@", [calendarDetails eventEndDate]);
    
    //Create events for each day
    
    endDate = [dateFormat dateFromString:cdEndDate];
    today = [dateFormat stringFromDate:now];
    
    EventDetails *ed = [[EventDetails alloc] init];
    
    int daysToRemove = 0;
    NSDateComponents *removeComp = [[NSDateComponents alloc] init];
    [removeComp setDay:daysToRemove];
    //NSDate *yesterday = [gregorian dateByAddingComponents:removeComp toDate:now options:0];
    
    //Logging
    //NSLog(@"Updated Date: %@", [dateFormat stringFromDate:updatedDate]);
    //NSLog(@"End Date: %@", [dateFormat stringFromDate:endDate]);

    
    while ([updatedDate compare: endDate] == NSOrderedAscending) {
        
        //Filter out dates before today
        /*
        if (![updatedDate compare: now] == NSOrderedAscending)
        {
            ed = [[EventDetails alloc] init];
            
            [ed setEventDate: [dateFormat stringFromDate:updatedDate]];
            [ed setEventSummary: [calendarDetails eventSummary]];
            [ed setEventDescription:[calendarDetails eventDescription]];
            
            //NSLog(@"Event Date: %@", [ed eventDate]);
            [createdEvents addObject:ed];
            //NSLog(@"Then here...");

        }
        
        //Add a day
        int daysToAdd = 1;
        
        // set up date components
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:daysToAdd];
        
        updatedDate = [gregorian dateByAddingComponents:components toDate:updatedDate options:0];
        */

        
        //NSLog(@"yesterday is: %@", [dateFormat stringFromDate:yesterday]);
        
    switch ([updatedDate compare:now])
    {
        case NSOrderedAscending:
            //NSLog(@"NSOrderedAscending");
            break;
            
        case NSOrderedSame:
            //NSLog(@"NSOrderedSame");
            break;
            
        case NSOrderedDescending:
            //NSLog(@"NSOrderedDescending");
            ed = [[EventDetails alloc] init];
            
            [ed setEventDate: [dateFormat stringFromDate:updatedDate]];
            [ed setEventSummary: [calendarDetails eventSummary]];
            [ed setEventDescription:[calendarDetails eventDescription]];
            
            //NSLog(@"Event Date: %@", [ed eventDate]);
            [createdEvents addObject:ed];
            
            break;  
    }
        //Add a day
        int daysToAdd = 1;
        
        // set up date components
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:daysToAdd];
        
        updatedDate = [gregorian dateByAddingComponents:components toDate:updatedDate options:0];

        
    }
     
    //While not last day
    
    //Create new day CalendarDetail
    
    //Setup recurrence of events
    
    // and up to 3 months out
    //NSLog(@"Created Events Number: %lu", (unsigned long)[createdEvents count]);
    
    //for (ed in createdEvents) {
     //   NSLog(@"Date: %@", [ed eventDate]);
    //}
    
    return createdEvents;
}

@end
