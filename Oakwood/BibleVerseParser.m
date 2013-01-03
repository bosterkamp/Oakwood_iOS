//
//  BibleVerseParser.m
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVerseParser.h"
#import "BibleVerseDetails.h"

@implementation BibleVerseParser

NSString *searchForMe = @"Monday:";
NSString *bibleVerseContent;
BOOL firstTimeMonday = true;
NSMutableArray *verses;

- (NSMutableArray *)parseXMLFile:(NSString *)pathToFile {
    
     //NSLog(@"Inside parseXMLFile");
    
    BOOL success;

    
    
    //Initialize the delegate.
    //XmlParser *bibleVerseParser = [[XmlParser alloc] initXMLParser];
    
    NSURL *xmlURL = [NSURL URLWithString: pathToFile];
    
    //NSLog(@"xmlURL is: %@", xmlURL);
    
    //if (bibleVerseParser) // bibleVerseParser is an NSXMLParser instance variable
        bibleVerseParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    verses = [[NSMutableArray alloc] init];
    
   // NSLog(@"bibleVerseParser is %@", bibleVerseParser);
    
    //
    [bibleVerseParser setDelegate:self];
    [bibleVerseParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [bibleVerseParser setShouldReportNamespacePrefixes:NO]; //
    [bibleVerseParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
    //
    
    success = [bibleVerseParser parse];
    
    //NSLog(@"Finishing parseXMLFile, success?: %d", success);
    //NSLog(@"Bible Verse content: %@", verses);
    firstTimeMonday = true;
    return verses;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
       //NSLog(@"Did Start Parsing long");
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	//NSLog(@"found characters: %@", string);
    
    NSRange range = [unparsedString rangeOfString : searchForMe];
    
    //Once the first one is found, parse it and return.
    if (range.location != NSNotFound && firstTimeMonday)
    {
        //NSLog(@"I found Monday!");
        
      
        //Separate out the <p> to work with only the days of the week
        NSArray *parsedParagraphs = [unparsedString componentsSeparatedByString:@"<p>"];
      
        //Iterate over all the elements in the fields (parsed out by <p>)
        for (NSString *parsedParagraphElement in parsedParagraphs)
        {
            //We need to find Monday again, since we're searching within multiple fields parsed out with <p> tags.
            NSRange mondayFinder = [parsedParagraphElement rangeOfString : searchForMe];
            
            if (mondayFinder.location != NSNotFound)
            {
                //Parse out by <br /> after finding the days
                NSArray *days = [parsedParagraphElement componentsSeparatedByString:@"<br />"];
                //NSLog(@"days: %@", days);
                
                for (NSString *parsedDayElement in days)
                {
                
                    //Create BibleVerseDetails
                    BibleVerseDetails *bvd = [[BibleVerseDetails alloc] init];
                    
                    //Split into 3 fields (day, link, verse)
                
                    //First part of the days breakdown is the actual day of the week
                    NSString *dayOfWeek = [[[parsedDayElement componentsSeparatedByString:@":"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
                    NSString *scriptureUrl = [[[parsedDayElement componentsSeparatedByString:@"\""] objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
                    NSString *scriptureUrlReference = [[[[parsedDayElement componentsSeparatedByString:@">"] objectAtIndex:1] componentsSeparatedByString:@"</"] objectAtIndex:0];
                    
                    //Remove whitespace
                    //NSLog(@"DAY OF WEEK: %@", dayOfWeek);
                    //NSLog(@"Url: %@", scriptureUrl);
                    //NSLog(@"Reference: %@", scriptureUrlReference);
                    
                    //Populate Bible Verse Details
                    [bvd setDayOfWeek:dayOfWeek];
                    [bvd setScriptureReference:scriptureUrlReference];
                    [bvd setScriptureUrl:scriptureUrl];
                     
                    //Add to verses
                    [verses addObject:bvd];
                
                    //Add elements
                    //NSMutableArray *stringArray = [[NSMutableArray alloc] init];
                    //for(int i=0; i< days.count; i++){
                        //[stringArray addObject:element];
                    //}
                
                
                    // NSLog(@"ELEMENT: %@", element);
                    //bibleVerseContent = dayOfWeek;
                    //NSLog(@"verses - first time through: %@", verses);
                    //NSLog(@"verses - bvd: %@", bvd);
                    firstTimeMonday = false;
                }
            }
        }
        
        //NSLog(@"verses - each time: %@", verses);
        
    }


}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
	NSLog(@"all done!");
}


@end








