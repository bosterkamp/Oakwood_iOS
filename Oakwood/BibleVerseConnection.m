//
//  BibleVerseConnection.m
//  Oakwood
//
//  Created by The Osterkamps on 12/1/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "BibleVerseConnection.h"


@implementation BibleVerseConnection

-(NSMutableArray *)connectWithURL
{
    //Call to parse the Bible Verses out of the XML

     myParser = [[BibleVerseParser alloc] init];
    NSMutableArray *bibleVerses = [myParser parseXMLFile:@"http://oakwoodnb.com/category/sermons/feed"];

    
    return bibleVerses;
}


@end
