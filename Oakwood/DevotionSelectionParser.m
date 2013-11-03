//
//  DevotionSelectionParser.m
//  Oakwood
//
//  Created by The Osterkamps on 8/25/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "DevotionSelectionParser.h"
#import "DevotionalDetails.h"

@implementation DevotionSelectionParser


BOOL insideDevotionalItem = false;
BOOL insideDevotionalTitle = false;
BOOL insideDevotionalLink = false;
BOOL insideDevotionalDesc;
NSString *devotionalTitle;
NSMutableString *fullDesc;
NSMutableArray *devotions;
DevotionalDetails *dd;

- (NSMutableArray *)parseXMLFile:(NSString *)url
{
    
    BOOL success;
    
    NSURL *xmlURL = [NSURL URLWithString: url];

    
    devotionSelectionParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    devotions = [[NSMutableArray alloc] init];
    
    NSLog(@"devotionSelectionParser is %@", devotionSelectionParser);
    
    //
    [devotionSelectionParser setDelegate:self];
    [devotionSelectionParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [devotionSelectionParser setShouldReportNamespacePrefixes:NO]; //
    [devotionSelectionParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [devotionSelectionParser parse];
    
    NSLog(@"Devotions in parsed xml %i", [devotions count]);
    return devotions;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Did Start Parsing: %@", elementName);
    
    if ([elementName isEqualToString:@"item"])
    {
        
        insideDevotionalItem = true;
        
    } else if ([elementName isEqualToString:@"title"] && insideDevotionalItem)
    {
        insideDevotionalTitle = true;
    } else if  ([elementName isEqualToString:@"link"] && insideDevotionalItem)
    {
        insideDevotionalLink = true;
    }
    
    //check for URL
    
    /*
    if ( [elementName isEqualToString:@"enclosure"])
    {
        
        NSString *devotionalUrl = [attributeDict objectForKey:@"url"];
        NSLog(@"devotionalUrl: %@", devotionalUrl);
        [dd setDevotionalUrl:devotionalUrl];
        [devotions addObject:dd];
    }
     */
    
    /*
    if ( [elementName isEqualToString:@"description"])
    {
        
        //NSString *devotionalUrl = [attributeDict objectForKey:@"url"];
        //NSLog(@"devotionalUrl: %@", devotionalUrl);
        //[dd setDevotionalUrl:devotionalUrl];
        //[devotions addObject:dd];
        insideDevotionalDesc = TRUE;
        fullDesc = [[NSMutableString alloc] init];

        
    }
     */
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to retrieve sermons.  Please try again later."];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	
    
    if(insideDevotionalItem)
    {
        NSLog(@"found characters inside item: %@", unparsedString);
        
        
        insideDevotionalItem = true;
        
        
        if (insideDevotionalTitle)
        {
            NSLog(@"found characters inside title: %@", unparsedString);
                  
            devotionalTitle= unparsedString;
  
            insideDevotionalTitle = false;
            
        }
        
        if (insideDevotionalLink)
        {
            
            //Create DevotionalDetails
            dd = [[DevotionalDetails alloc] init];
            
            
            //Convert the link to the vimeo player link
            //http://vimeo.com/channels/299087/34629015 would be http://player.vimeo.com/video/34629015
            //NSMutableString *tweetDisplay = [[NSMutableString alloc] initWithString:status.user.screenName];
            NSMutableString *fullUrl = [[NSMutableString alloc] initWithString:@"http://player.vimeo.com/video/"];
            
            //Separate out the "/" to get the last element
            NSArray *parsedParagraphs = [unparsedString componentsSeparatedByString:@"/"];
           
            NSMutableString *videoId = [parsedParagraphs lastObject];
            
            //NSLog(@"Last object: %@", videoId);
            
            [fullUrl appendString: videoId];
            
            //Iterate over all the elements in the fields (parsed out by <p>)
            /*
            for (NSString *parsedParagraphElement in parsedParagraphs)
            {
                
            }
            
            [[parsedDayElement componentsSeparatedByString:@"\""] objectAtIndex:1]
            */
            //NSLog(@"Full URL: %@", fullUrl);
            
            //Populate Devotional Details
            [dd setDevotionalName:devotionalTitle];
            [dd setDevotionalUrl:fullUrl];
            [devotions addObject:dd];
            //

            
            insideDevotionalLink = false;
            insideDevotionalItem = false;
        }
         
        
        
        
    }
    
    /*
    if (insideDevotionalDesc == TRUE)
    {
      //NSLog(@"found characters: %@", unparsedString);
      [fullDesc appendString: unparsedString];

    }
     */
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}


@end
