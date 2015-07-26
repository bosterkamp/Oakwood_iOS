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
    //NSLog(@"End Date: %@", [calendarDetails eventEndDate]);
    
    
    NSDate *updatedDate;
    NSDate *endDate;
    NSDate *now = [NSDate date];
    
    NSString *today;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    // Convert string to date object
    NSDateFormatter *dateFormatRecur = [[NSDateFormatter alloc] init];
    
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
        [dateFormat setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
        
        //No "correction" needed for timezone dates, so just set corrected date directly.
        updatedDate = [dateFormat dateFromString:iterationDateStr];
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
    //NSLog(@"End Date String: %@", cdEndDate);
    //NSLog(@"End Date: %@", [dateFormat stringFromDate:endDate]);

    
    //For Recurring Events
    if ([calendarDetails recurringEventInfo])
    {
        
        //If the recurring event has an end date
        if (![[[calendarDetails recurringEventInfo] untilDay] isEqualToString:@""])
        {
            
            NSString *cdUntilDate = [[calendarDetails recurringEventInfo] untilDay];
            
            //NSCalendar *gregorianRecur = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            //Formatting
            cdUntilDate = [EventFormatter formatEvent:cdUntilDate];
            
            //Create events for each day...
            if ([cdUntilDate rangeOfString:@":"].location == NSNotFound)
            {
                [dateFormatRecur setDateFormat:@"EEEE MMMM d, yyyy"];
                endDate = [dateFormatRecur dateFromString:cdUntilDate];
            }
            else
            {
                //If String contains 'Z', then format this way
                [dateFormatRecur setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
                
                //No "correction" needed for timezone dates, so just set corrected date directly.
                endDate = [dateFormatRecur dateFromString:cdUntilDate];
            }
        }
 
        //END If the recurring event has an end date logic
        
        //NSLog(@"Inside recurring event");
        
        //Add a day
        int daysToAdd = 1;
        
        //Add 7 days if recurrence is weekly
        if ([@"WEEKLY" isEqualToString:[[calendarDetails recurringEventInfo] eventFrequency]])
        {
            daysToAdd = 7;
        }
        
        
        
        // set up date components
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:daysToAdd];
        
        
        if ([[[calendarDetails recurringEventInfo] untilDay] isEqualToString:@""])
        {
            // set up end date components and add 30 days.
            NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
            [endDateComponents setDay:90];
            
            //Add 3 months to today's date
            endDate = [gregorian dateByAddingComponents:endDateComponents toDate:endDate options:0];
        }
        //NSLog(@"About to start reccur - while");
        
        // Starting recurrence code
        while ([updatedDate compare: endDate] == NSOrderedAscending)
        {
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
                    
                    //only create it if it is before the end date
                    
                    [ed setEventDate: [dateFormat stringFromDate:updatedDate]];
                    [ed setEventSummary: [calendarDetails eventSummary]];
                    [ed setEventDescription:[calendarDetails eventDescription]];
                    
                    //NSLog(@"Event Date: %@", [ed eventDate]);
                    //NSLog(@"End Date: %@", [dateFormat stringFromDate:endDate]);
                    //NSLog(@"Now Date: %@", [dateFormat stringFromDate:now]);
                    [createdEvents addObject:ed];
                    
                    break;
            }
            /*
            //Add a day
            int daysToAdd = 1;
            
            // set up date components
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:daysToAdd];
            */
            updatedDate = [gregorian dateByAddingComponents:components toDate:updatedDate options:0];
            
            
        }
        // End recurrence code
        
        //Log that this has recurring event details
        //NSLog(@"Recurring Event Summary: %@", [calendarDetails eventSummary]);
        //NSLog(@"Recurring Event Frequency: %@", [[calendarDetails recurringEventInfo] eventFrequency]);
        

    }
    //For Non-Recurring Events
    else
    {
 
        while ([updatedDate compare: endDate] == NSOrderedAscending)
        {
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
                    
                    //only create it if it is before the end date
                    
                    [ed setEventDate: [dateFormat stringFromDate:updatedDate]];
                    [ed setEventSummary: [calendarDetails eventSummary]];
                    [ed setEventDescription:[calendarDetails eventDescription]];
                    
                    //NSLog(@"Event Date: %@", [ed eventDate]);
                    //NSLog(@"End Date: %@", [dateFormat stringFromDate:endDate]);
                    //NSLog(@"Now Date: %@", [dateFormat stringFromDate:now]);
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
    }
    
    return createdEvents;
}

@end
