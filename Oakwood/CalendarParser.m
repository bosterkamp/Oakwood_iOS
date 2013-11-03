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

@implementation CalendarParser


//TODO: Include recurrence (both start/end date and RRULE), do not include dates that have already passed, make sure end date matches calendar, only show events for 2 months out.

- (NSArray *)parseXMLFile:(NSString *)url
{
    BOOL firstTime = true;
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSMutableArray *potentialEvents = [[NSMutableArray alloc] init];
    
    //NSLog(@"inside Calendar parseXMLFile: %@", url);
      
    NSURL *xmlURL = [NSURL URLWithString: url];
    
    //NSLog(@"xmlURL is: %@", xmlURL);
    

    //calendarParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    
    
    //NSLog(@"calendarParser is %@", calendarParser);
    
    /*
    [calendarParser setDelegate:self];
    [calendarParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [calendarParser setShouldReportNamespacePrefixes:NO]; //
    [calendarParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    */
    
    //success = [calendarParser parse];
    
    
    NSData *data = [NSData dataWithContentsOfURL:xmlURL];
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
                }
                
                //DTEnd
                //NSString *endDate = [[NSString alloc] init];
                NSString *end = @"DTEND";
                if ([parsedLineElement rangeOfString:end].location != NSNotFound)
                {
                    
                    endDate = [[parsedLineElement componentsSeparatedByString:@":"] objectAtIndex:1];
                    
                    NSString *dateEnd = endDate;
                    
                    //Formatting
                    endDate = [EventFormatter formatEvent:dateEnd];
                    
                    //NSLog(@"DTEND is %@", endDate);
                }
                
                //RRULE - For now we want to skip over it, until we understand the rules better.
                NSString *rrule = @"RRULE";
                if ([parsedLineElement rangeOfString:rrule].location != NSNotFound)
                {
                    
                    //summaryString = [[parsedLineElement componentsSeparatedByString:@"SUMMARY:"] objectAtIndex:1];
                    skipEvent = true;
                    //NSLog(@"RRULE line");// is %@", summaryString);
                }
                
                //Summary
                //NSString *summaryString = [[NSString alloc] init];
                NSString *summary = @"SUMMARY";
                if ([parsedLineElement rangeOfString:summary].location != NSNotFound)
                {
                    
                    summaryString = [[parsedLineElement componentsSeparatedByString:@"SUMMARY:"] objectAtIndex:1];
                    summaryString = [HTMLNumberDecoder decodeString:summaryString];
                    
                    //NSLog(@"Summary is %@", summaryString);
                }
                
                //Description
                //NSString *descString = [[NSString alloc] init];
                NSString *desc = @"DESCRIPTION";
                if ([parsedLineElement rangeOfString:desc].location != NSNotFound)
                {
                    descString = [[parsedLineElement componentsSeparatedByString:@"DESCRIPTION:"] objectAtIndex:1];
                    
                   // NSLog(@"DESCRIPTION is %@", descString);
                }


                [cd setEventStartDate:startDate];
                [cd setEventSummary:summaryString];
                [cd setEventEndDate:endDate];
                [cd setEventDescription:descString];
                
                //Don't create events if the description is blank or it is an event we need to skip
                if (![[cd eventDescription] isEqualToString:@""] || skipEvent)
                {
                    [potentialEvents addObjectsFromArray:[EventCreator createEvents:cd]];
                    //NSLog(@"Events Number: %lu", (unsigned long)[potentialEvents count]);

                    //Break out because we have completed this event
                    break;
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
            if (!duplicate)
            {
                //NSLog(@"Adding objects");
                [events addObjectsFromArray:potentialEvents];
            }
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
