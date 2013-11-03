//
//  EventFormatter.m
//  Oakwood
//
//  Created by The Osterkamps on 7/14/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "EventFormatter.h"

@implementation EventFormatter

//This is a helper method to format strings into CST NSDates
+ (NSString *)formatEvent:(NSString *)unformattedDateString {
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *date;
    
    //Setup addition of day, since it is off a day
    NSDate *correctedDate;
    
    int daysToAdd = 1;
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //End Setup
    
    
    
    if ([unformattedDateString rangeOfString:@"Z"].location == NSNotFound)
    {
        //TODO: Need to indicate there is no timezone on this...
        [dateFormat setDateFormat:@"yyyyMMdd"];
        date = [dateFormat dateFromString:unformattedDateString];
        correctedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/Chicago"]];
        [dateFormat setDateFormat:@"EEEE MMMM d, yyyy"];
    }
    else
    {
        //If String contains 'Z', then format this way
        [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
        
        //No "correction" needed for timezone dates, so just set corrected date directly.
        correctedDate = [dateFormat dateFromString:unformattedDateString];
        //date = [dateFormat dateFromString:dateStr];
        //correctedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/Chicago"]];
        [dateFormat setDateFormat:@"EEEE MMMM d, yyyy - h:mm a"];
        
    }
    
    NSString *correctedDateStr = [dateFormat stringFromDate:correctedDate];
    
    return correctedDateStr;
    
    
}

@end
