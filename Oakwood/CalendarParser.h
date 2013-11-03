//
//  CalendarParser.h
//  Oakwood
//
//  Created by The Osterkamps on 1/3/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarParser : NSObject  <NSXMLParserDelegate>
{
    
    NSXMLParser *calendarParser;
    
}

- (NSArray *)parseXMLFile:(NSString *)url;

@end
