//
//  BibleVerseParser.h
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BibleVerseParser : NSObject <NSXMLParserDelegate>
{
    
   NSXMLParser *bibleVerseParser;

}

- (NSMutableArray *)parseXMLFile:(NSString *)pathToFile;

@end

