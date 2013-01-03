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
NSMutableArray *sermons;
SermonDetails *sd;

- (NSMutableArray *)parseXMLFile:(NSString *)url
{
    
    BOOL success;
    
    NSLog(@"inside SermonSelectionParser parseXMLFile: %@", url);
    
    NSURL *xmlURL = [NSURL URLWithString: url];
    
    NSLog(@"xmlURL is: %@", xmlURL);
    
    sermonSelectionParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    sermons = [[NSMutableArray alloc] init];
    
    NSLog(@"sermonSelectionParser is %@", sermonSelectionParser);
    
    //
    [sermonSelectionParser setDelegate:self];
    [sermonSelectionParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [sermonSelectionParser setShouldReportNamespacePrefixes:NO]; //
    [sermonSelectionParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [sermonSelectionParser parse];
    
    NSLog(@"Finishing parseXMLFile, success?: %d", success);
    //NSLog(@"Bible Verse content: %@", verses);
    
    return sermons;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Did Start Parsing: %@", elementName);
    
    if ([elementName isEqualToString:@"item"])
    {
        
        insideItem = true;
        
    } else if ([elementName isEqualToString:@"title"] && insideItem)
    {
        insideTitle = true;
    }
    
    //check for URL
    
    if ( [elementName isEqualToString:@"enclosure"])
    {
        
        NSString *sermonUrl = [attributeDict objectForKey:@"url"];
        NSLog(@"sermonUrl: %@", sermonUrl);
        [sd setSermonUrl:sermonUrl];
        [sermons addObject:sd];
    }
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	
    if(insideItem)
    {
        NSLog(@"found characters inside item: %@", unparsedString);
        
        
        //insideItem = true;
  
        if (insideTitle)
        {
            NSLog(@"found characters inside title: %@", unparsedString);
            
            
            //
            
            //Create BibleVerseDetails
            sd = [[SermonDetails alloc] init];
            
            //First part of the days breakdown is the actual day of the week
            NSString *sermonName = unparsedString;

            
            //Populate Sermon Details
            [sd setSermonName:sermonName];

            //[sermons addObject:sd];
            //
            
            insideItem = false;
            insideTitle = false;
            
        }
        
        

    }
   // NSLog(@"found characters: %@", unparsedString);
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    insideItem = false;
}

@end
