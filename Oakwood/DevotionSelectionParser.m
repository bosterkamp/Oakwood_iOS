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
BOOL insideDevotionalPubDate = false;
BOOL insideDevotionalDesc;
NSString *devotionalTitle;
NSDate *devotionalPubDate;
NSMutableString *fullDesc;
NSMutableArray *devotions;
DevotionalDetails *dd;

- (NSMutableArray *)parseXMLFile:(NSString *)url
{
    
    BOOL success;
    
    //Used for production...
    NSURL *xmlURL = [NSURL URLWithString: url];
    devotionSelectionParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    //Used for testing...
    //NSData *xmlURL = [NSData dataWithContentsOfFile:url];
    //devotionSelectionParser = [[NSXMLParser alloc] initWithData:xmlURL];
    
    devotions = [[NSMutableArray alloc] init];
    
    //
    [devotionSelectionParser setDelegate:self];
    [devotionSelectionParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [devotionSelectionParser setShouldReportNamespacePrefixes:NO]; //
    [devotionSelectionParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [devotionSelectionParser parse];
    
    //NSLog(@"Devotions in parsed xml %i", [devotions count]);
    
    //pubDate
    //Now we need to sort them properly (probably need to do this based on publish date...)
    //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"devotionalName" ascending:YES];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"devotionalPublishDate" ascending:NO];
    [devotions sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    //
    //Next we sort the contents of the array by event date
    
    // The results are likely to be shown to a user
    // Note the use of the localizedCaseInsensitiveCompare: selector
    /*NSSortDescriptor *lastDescriptor =
    [[NSSortDescriptor alloc] initWithKey:eventDate
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    */
     /*
     NSSortDescriptor *firstDescriptor =
     [[NSSortDescriptor alloc] initWithKey:first
     ascending:YES
     selector:@selector(localizedCaseInsensitiveCompare:)];
     */
    /*
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor,nil];
    sortedArray = [array sortedArrayUsingDescriptors:descriptors];
    */
    //
    
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
    } else if  ([elementName isEqualToString:@"pubDate"] && insideDevotionalItem)
    {
        insideDevotionalPubDate = true;
    }
    else if  ([elementName isEqualToString:@"link"] && insideDevotionalItem)
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
	//NSLog(@"found file and started parsing");
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
        //NSLog(@"found characters inside item: %@", unparsedString);
        
        
        insideDevotionalItem = true;
        
        
        if (insideDevotionalTitle)
        {
            //NSLog(@"found characters inside title: %@", unparsedString);
                  
            devotionalTitle= unparsedString;
  
            insideDevotionalTitle = false;
            
        }
        
        if (insideDevotionalPubDate)
        {
            //map it
            //NSLog(@"found characters inside pubDate: %@", unparsedString);
            
            //devotionalPubDate= unparsedString;
            
            //Parse into a date
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
            //Fri, 02 Mar 2012 15:20:59 -0500
            devotionalPubDate = [df dateFromString:unparsedString];
            //NSLog(@"%@", devotionalPubDate);
            
            //we are finished, so set it back to false
            insideDevotionalPubDate = false;
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
            [dd setDevotionalPublishDate:devotionalPubDate];
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
    
    
	//NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}


@end
