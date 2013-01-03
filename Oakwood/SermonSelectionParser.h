//
//  SermonSelectionParser.h
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SermonSelectionParser : NSObject <NSXMLParserDelegate>
{
    
    NSXMLParser *sermonSelectionParser;
    
}

- (NSMutableArray *)parseXMLFile:(NSString *)url;

@end
