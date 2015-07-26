//
//  BibleVerseParser.m
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVerseParser.h"
#import "BibleVerseDetails.h"
#import "HTMLNumberDecoder.h"

@implementation BibleVerseParser

NSString *searchForMe = @"Monday:";
NSString *scriptureText =@"GREAT SCRIPTURE TO MEMORIZE";
NSString *bibleVerseContent;
BOOL firstTimeMonday = true;
BOOL firstTimeMemoryScripture = true;
BOOL encodedContent = false;
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
    if ([elementName isEqualToString:@"content:encoded"])
    {
        encodedContent = true;
        //NSLog(@"Found encoded content!");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if (encodedContent)
    {
        encodedContent = false;
    }
    
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to retrieve bible verses.  Please try again later."];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)unparsedString{
	//NSLog(@"found characters: %@", unparsedString);
    if (encodedContent)
    {
    
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
                
                //NSLog(@"Parsed Data: %@", parsedParagraphElement);
                
                //We need to find Monday again, since we're searching within multiple fields parsed out with <p> tags.
                NSRange mondayFinder = [parsedParagraphElement rangeOfString : searchForMe];
                
                if (mondayFinder.location != NSNotFound)
                {
                    //Parse out by <br /> after finding the days
                    NSArray *days = [parsedParagraphElement componentsSeparatedByString:@"<br />"];
                    //NSLog(@"days: %@", days);
                    
                    for (NSString *parsedDayElement in days)
                    {
                    
                        @try
                        {
                            //Create BibleVerseDetails
                            BibleVerseDetails *bvd = [[BibleVerseDetails alloc] init];
                            
                            //Split into 3 fields (day, link, verse)
                            
                            //First part of the days breakdown is the actual day of the week
                            
                            //Remove any line breaks...
                            NSString *removedLineBreak = [[[parsedDayElement componentsSeparatedByString:@":"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
                            NSString *dayOfWeek = [removedLineBreak stringByReplacingOccurrencesOfString:@" " withString:@""];
                            //NSString *dayOfWeek = [[[parsedDayElement componentsSeparatedByString:@":"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
                            //NSLog(@"dayOfWeek: %@", dayOfWeek);
                            NSString *scriptureUrl = [[[parsedDayElement componentsSeparatedByString:@"\""] objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
                            //NSLog(@"scriptureUrl: %@", scriptureUrl);
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
                        }
                        @catch (NSException *exception)
                        {
                            NSLog(@"dayOfWeek: %s", "Caught Exception parsing days");
                            NSLog( @"Name: %@", exception.name);
                            NSLog( @"Reason: %@", exception.reason );
                        }

                        firstTimeMonday = false;
                    }
                }
                else
                {
                    NSRange memoryVerseFinder = [parsedParagraphElement rangeOfString : scriptureText];
                    
                    if (memoryVerseFinder.location != NSNotFound)
                    {
                        NSArray *scriptureOnly = [parsedParagraphElement componentsSeparatedByString:@"<br />"];
                        NSString *scriptureOnlyString = [scriptureOnly objectAtIndex:0];
                         scriptureOnlyString = [HTMLNumberDecoder decodeString:scriptureOnlyString];
                        
                        //testing
                        NSRange r;
                        while ((r = [scriptureOnlyString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                            scriptureOnlyString = [scriptureOnlyString stringByReplacingCharactersInRange:r withString:@""];
                        
                        
                        
                        //NSLog(@"Memory Verse: %@", scriptureOnlyString);
                        
                        //Trying something
                        BibleVerseDetails *bvd = [[BibleVerseDetails alloc] init];
                        //Populate Bible Verse Details
                        [bvd setDayOfWeek:@""];
                        [bvd setScriptureReference:scriptureOnlyString];
                        [bvd setScriptureUrl:@""];
                        [verses addObject:bvd];

                    }
                   
                }
            }
            
        }
    }


}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
}

@end








