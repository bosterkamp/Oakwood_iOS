//
//  CalendarParser.m
//  Oakwood
//
//  Created by The Osterkamps on 1/3/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "CalendarParser.h"
#import "CalendarDetails.h"
#import "EventFormatter.h"
#import "EventCreator.h"
#import "EventSorter.h"
#import "HTMLNumberDecoder.h"
#import "RecurringEventDetails.h"

@implementation CalendarParser


//TODO: Include recurrence (both start/end date and RRULE), do not include dates that have already passed, make sure end date matches calendar, only show events for 2 months out.

- (NSArray *)parseXMLFile:(NSString *)url
{
    BOOL firstTime = true;
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSMutableArray *potentialEvents = [[NSMutableArray alloc] init];
      
    NSURL *xmlURL = [NSURL URLWithString: url];
    
    //Used when the application is in prod
    NSData *data = [NSData dataWithContentsOfURL:xmlURL];
    
    //Used for testing...
    //NSData *data = [NSData dataWithContentsOfFile:url];
    
    
    NSString *myString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
    
    NSString *caldata = myString;
    
    //NSLog(@"URL contents: %@", caldata);
    
    //Break up the file into "events" and set elements for each event.
    
    
    //Separate out the BEGIN:VEVENT to work with each event independently
    NSArray *parsedParagraphs = [caldata componentsSeparatedByString:@"BEGIN:VEVENT"];
    
    
    //Iterate over all the elements in the fields (parsed out by BEGIN:VEVENT)
    for (NSString *parsedParagraphElement in parsedParagraphs)
    {
        BOOL *duplicate = false;
        
        if (!firstTime)
        {
            //The first element is not an event, it is just header info
            //NSLog(@"**********Parsed Data: %@", parsedParagraphElement);
            
            //Setup the variables
            NSString *startDate = [[NSString alloc] init];
            NSString *endDate = [[NSString alloc] init];
            NSString *summaryString = [[NSString alloc] init];
            NSString *descString = [[NSString alloc] init];
            
            //Recurring Details
            NSString *frequency = [[NSString alloc] init];
            NSString *interval = [[NSString alloc] init];
            NSString *day = [[NSString alloc] init];
            NSString *untilDay = [[NSString alloc] init];
            
            RecurringEventDetails *recurringEventInfo = [[RecurringEventDetails alloc] init];
            
            Boolean *skipEvent = false;
            descString = @"";
            
            NSArray *parsedLines = [parsedParagraphElement componentsSeparatedByString:@"\n"];
            
            CalendarDetails *cd = [[CalendarDetails alloc] init];
            
 
            
            for (NSString *parsedLineElement in parsedLines)
            {
                //NSLog(@"**********Parsed Line: %@", parsedLineElement);
                
                
                
                //DTStart
               // NSString *startDate = [[NSString alloc] init];
                NSString *start = @"DTSTART";
                if ([parsedLineElement rangeOfString:start].location != NSNotFound)
                {
                
                    startDate = [[parsedLineElement componentsSeparatedByString:@":"] objectAtIndex:1];
                    
                    NSString *dateStr = startDate;
                    
                    //Formatting
                    startDate = [EventFormatter formatEvent:dateStr];

                    //NSLog(@"DTSTART is %@", startDate);
                    continue;
                }
                
                //DTEnd
                //NSString *endDate = [[NSString alloc] init];
                NSString *end = @"DTEND";
                if ([parsedLineElement rangeOfString:end].location != NSNotFound)
                {
                    
                    endDate = [[parsedLineElement componentsSeparatedByString:@":"] objectAtIndex:1];
                    
                    NSString *dateEnd = endDate;
                    
                    //NSLog(@"dateEnd is %@", dateEnd);
                    
                    //Formatting
                    endDate = [EventFormatter formatEvent:dateEnd];
                    
                    //NSLog(@"DTEND is %@", endDate);
                    continue;
                }
                
                //RRULE - For now we want to skip over it, until we understand the rules better.
                NSString *rrule = @"RRULE";
                if ([parsedLineElement rangeOfString:rrule].location != NSNotFound)
                {
                    
                    
                    
                    
                    NSString *rruleString =[[parsedLineElement componentsSeparatedByString:@"RRULE:"] objectAtIndex:1];
                    NSArray *semicolonSplit = [rruleString componentsSeparatedByString:@";"];
        
                    @try {
                        
                        
                        //TODO loop through all the delimiters
                        
                        //TODO check for the actual value and not just delimiters...
                        //Check to see if there is an end date
                        if (semicolonSplit.count == 3)
                        {
                            //NSLog(@"semicolonSplit %i", semicolonSplit.count);
                            
                            frequency = [[semicolonSplit[0] componentsSeparatedByString:@"FREQ="] objectAtIndex:1];
                            interval = [[semicolonSplit[1] componentsSeparatedByString:@"INTERVAL="] objectAtIndex:1];
                            day = [[semicolonSplit[2] componentsSeparatedByString:@"BYDAY="] objectAtIndex:1];
                        }
                        else if (semicolonSplit.count == 4)
                        {
                            frequency = [[semicolonSplit[0] componentsSeparatedByString:@"FREQ="] objectAtIndex:1];
                            untilDay = [[semicolonSplit[1] componentsSeparatedByString:@"UNTIL="] objectAtIndex:1];
                            interval = [[semicolonSplit[2] componentsSeparatedByString:@"INTERVAL="] objectAtIndex:1];
                            day = [[semicolonSplit[3] componentsSeparatedByString:@"BYDAY="] objectAtIndex:1];
                        }
                        
                        //skipEvent = true;
                        
                        //recurringEventInfo = [[RecurringEventDetails alloc] init];
                        [recurringEventInfo setEventFrequency:frequency];
                        [recurringEventInfo setEventInterval:interval];
                        [recurringEventInfo setEventDay:day];
                        [recurringEventInfo setUntilDay:untilDay];
                        
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Exception Thrown");
                        NSLog( @"Name: %@", exception.name);
                        NSLog( @"Reason: %@", exception.reason );
                        //Just swallow it, so the app doesn't blow up.
                    }
                    @finally {
                       
                    }



                    
                    continue;
                    
                }
                
                
                
                //Summary
                //NSString *summaryString = [[NSString alloc] init];
                NSString *summary = @"SUMMARY";
                if ([parsedLineElement rangeOfString:summary].location != NSNotFound)
                {
                    
                    summaryString = [[parsedLineElement componentsSeparatedByString:@"SUMMARY:"] objectAtIndex:1];
                    summaryString = [HTMLNumberDecoder decodeString:summaryString];
                    
                    //NSLog(@"Summary is %@", summaryString);
                    continue;
                }
                
                //Description
                //NSString *descString = [[NSString alloc] init];
                NSString *desc = @"DESCRIPTION";
                if ([parsedLineElement rangeOfString:desc].location != NSNotFound)
                {
                    descString = [[parsedLineElement componentsSeparatedByString:@"DESCRIPTION:"] objectAtIndex:1];
                    continue;
                   // NSLog(@"DESCRIPTION is %@", descString);
                }
                
                //End of Event
                NSString *endEvent = @"END:VEVENT";
                if ([parsedLineElement rangeOfString:endEvent].location != NSNotFound)
                {
                
                    //We should only do this when the object is fully built...
     
                    [cd setEventStartDate:startDate];
                    [cd setEventSummary:summaryString];
                    [cd setEventEndDate:endDate];
                    [cd setEventDescription:descString];

                    //Only set if this is a recurring event
                    if ([recurringEventInfo eventFrequency])
                    {
                        [cd setRecurringEventInfo:recurringEventInfo];
                        
                        //NSLog(@"Recurring Freq= %@", [[cd recurringEventInfo] eventFrequency]);

                    }
                    else
                    {
                        //NSLog(@"NO FREQ SET");
                    }
                    
                    //Don't create events if the summary is blank or it is an event we need to skip
                    if (![[cd eventSummary] isEqualToString:@""] || skipEvent)
                    {
                        [potentialEvents addObjectsFromArray:[EventCreator createEvents:cd]];
                        //NSLog(@"Events Number: %lu", (unsigned long)[potentialEvents count]);

                        //Break out because we have completed this event
                        break;
                    }
                }
                
                
            }
            
            //Iterate over existing events to check for duplicate summary
            for (CalendarDetails *selectedEvents in events)
            {
                if ([summaryString rangeOfString:selectedEvents.eventSummary].location != NSNotFound)
                {
                    duplicate = TRUE;
                   // NSLog(@"We found a duplicate!, %@", summaryString);
                }
            }
            
            //Check for duplicate
            //Removed duplicate check until I can add more logic to check string AND date to determine duplicates.
            
            //if (!duplicate)
            //{
                //NSLog(@"Adding objects");
                [events addObjectsFromArray:potentialEvents];
            //}
            
            potentialEvents = [[NSMutableArray alloc] init];
            
        }
        else
        {
            //Set it to false, so we can start parsing!
            firstTime = FALSE;
        }

    }
        
    
    //End
    
    //NSLog(@"Finishing parseXMLFile, success?: %d", success);
    //NSLog(@"Events Number: %lu", (unsigned long)[events count]);
    
    //Now sort the events before we return them...
    events = [EventSorter sortEvents:events];
    
    return events;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Did Start Parsing: %@", elementName);
    
    //Need to determine what is needed for calendar.
    
    if ([elementName isEqualToString:@"content:encoded"])
    {
        
        //needToParse = true;
        
    }
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to retrieve calendar events.  Please try again later"];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	
    //if(needToParse && firstTime)
    //{
        NSLog(@"found characters: %@", unparsedString);
     //   firstTime = FALSE;
        //returnString = unparsedString;
    //}
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //needToParse = false;
}


@end
