//
//  ERayParser.m
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "ERayParser.h"

@implementation ERayParser

BOOL needToParse = false;
BOOL firstTime = true;
NSString *returnString;

- (NSString *)parseXMLFile:(NSString *)url
{
    
       BOOL success;
    
    NSLog(@"inside ERayParser parseXMLFile: %@", url);
    
    NSURL *xmlURL = [NSURL URLWithString: url];
    
    NSLog(@"xmlURL is: %@", xmlURL);

    //if (eRayParser) // eRayParser is an NSXMLParser instance variable
    eRayParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    //verses = [[NSMutableArray alloc] init];
    
    NSLog(@"eRayParser is %@", eRayParser);
    
    //
    [eRayParser setDelegate:self];
    [eRayParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [eRayParser setShouldReportNamespacePrefixes:NO]; //
    [eRayParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [eRayParser parse];
    
    NSLog(@"Finishing parseXMLFile, success?: %d", success);
    //NSLog(@"Bible Verse content: %@", verses);
    
    return returnString;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"Did Start Parsing: %@", elementName);
    
    if ([elementName isEqualToString:@"content:encoded"])
    {
        
        needToParse = true;
        
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
	
    if(needToParse && firstTime)
    {
        NSLog(@"found characters: %@", unparsedString);
        firstTime = FALSE;
        returnString = unparsedString;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	NSLog(@"all done!");
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    needToParse = false;
}



@end
