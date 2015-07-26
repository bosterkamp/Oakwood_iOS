//
//  SermonSelectionParser.m
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "SermonSelectionParser.h"
#import "SermonDetails.h"

@implementation SermonSelectionParser

BOOL insideItem = false;
BOOL insideTitle = false;
BOOL insideSermonPubDate = false;
NSDate *sermonPubDate;
NSMutableArray *sermons;
SermonDetails *sd;

- (NSMutableArray *)parseXMLFile:(NSString *)url
{
    
    BOOL success;
    
    //NSLog(@"inside SermonSelectionParser parseXMLFile: %@", url);
    
    
    
    //NSLog(@"xmlURL is: %@", xmlURL);
    
    //Used for production
    NSURL *xmlURL = [NSURL URLWithString: url];
    NSData *xmlURLdata = [NSData dataWithContentsOfURL:xmlURL];
    //sermonSelectionParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    //Used for testing...
    //NSData *xmlURLdata = [NSData dataWithContentsOfFile:url];
    
    
    
    NSString* responseString = [[NSString alloc] initWithData:xmlURLdata encoding:NSUTF8StringEncoding];
    //NSLog(@"full xml, %@", responseString);
    
    //Replace the apostrophe - this is what you call a hack... ugly isn't it?!
    responseString = [responseString stringByReplacingOccurrencesOfString:@"’" withString:@"\'"];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    
    //NSLog(@"full xml, %@", responseString);
    
    sermonSelectionParser = [[NSXMLParser alloc] initWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
    
    sermons = [[NSMutableArray alloc] init];
    
    //NSLog(@"sermonSelectionParser is %@", sermonSelectionParser);
    
    //
    [sermonSelectionParser setDelegate:self];
    [sermonSelectionParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [sermonSelectionParser setShouldReportNamespacePrefixes:NO]; //
    [sermonSelectionParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [sermonSelectionParser parse];
    
    //NSLog(@"Finishing parseXMLFile, success?: %d", success);
    //NSLog(@"Bible Verse content: %@", verses);
    
    return sermons;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Did Start Parsing: %@", elementName);
    
    if ([elementName isEqualToString:@"item"])
    {
        
        insideItem = true;
        //NSLog(@"insideItem");
        
    } else if ([elementName isEqualToString:@"title"] && insideItem)
    {
        insideTitle = true;
        //NSLog(@"insideTitle");

    } else if  ([elementName isEqualToString:@"pubDate"] && insideItem)
    {
        insideSermonPubDate = true;
         //NSLog(@"insideSermonPubDate");
    }
    
    //check for URL
    
    if ( [elementName isEqualToString:@"enclosure"])
    {
        
        NSString *sermonUrl = [attributeDict objectForKey:@"url"];
        
        @try {

            
            
        //let's generate random errors --- for testing only!
        /*
            int x = arc4random() % 100;
            
            NSLog(@"Random Number: %i", x);
            
            if (x > 75)
            {
                
                NSException* myException = [NSException
                                            exceptionWithName:@"Concocted exception"
                                            reason:@"Random number"
                                            userInfo:nil];
                @throw myException;
            }
        */
        //NSLog(@"sermonUrl: %@", sermonUrl);
        [sd setSermonUrl:sermonUrl];
        
        
        //Don't add it unless the URL has a proper date
        
        //NSLog(@"URL: %@", sermonUrl);
        
        NSArray *slashSplit = [sermonUrl componentsSeparatedByString:@"/"];
        NSString *fileString = [slashSplit objectAtIndex:(slashSplit.count - 1)];
        NSArray *fileSplit = [fileString componentsSeparatedByString:@"."];
        NSString *dateString = [fileSplit objectAtIndex:0];
        //NSLog(@"Parsed Date: %@", dateString);
        
        //Gotta convert the date to a different format
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:dateString];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *newDate = [formatter stringFromDate:date];
        
        //End "don't add"
        
        [sermons addObject:sd];
            
            
        }
        @catch (NSException *exception) {
            //Just swallow the error.
            //NSLog(@"sermonUrl: %@", sermonUrl);

        }
        @finally {
            
        }
    }
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to retrieve sermons.  Please try again later."];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	
    if(insideItem)
    {
        //NSLog(@"found characters inside item: %@", unparsedString);
        
        
        //insideItem = true;
  
        if (insideTitle)
        {
            //NSLog(@"found characters inside title: %@", unparsedString);
            
            
            //
            
            //Create BibleVerseDetails
            sd = [[SermonDetails alloc] init];
            
            //First part of the days breakdown is the actual day of the week
            NSString *sermonName = unparsedString;

            
            //Populate Sermon Details
            [sd setSermonName:sermonName];

            //[sermons addObject:sd];
            //
            
            //insideItem = false;
            insideTitle = false;
            
        }
        
        if (insideSermonPubDate)
        {
            //map it
            //NSLog(@"found characters inside pubDate: %@", unparsedString);
            
            //devotionalPubDate= unparsedString;
            
            //Parse into a date
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
            //Fri, 02 Mar 2012 15:20:59 -0500
            sermonPubDate = [df dateFromString:unparsedString];
            [sd setSermonPublishDate:sermonPubDate];
            //NSLog(@"Sermon Published Date: %@", sermonPubDate);
            
            //we are finished, so set it back to false
            insideSermonPubDate = false;
            insideItem = false;
        }
        
        

    }
   // NSLog(@"found characters: %@", unparsedString);
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	//NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //insideItem = false;
}

@end
