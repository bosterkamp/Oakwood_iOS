//
//  DevotionSelectionParser.h
//  Oakwood
//
//  Created by The Osterkamps on 8/25/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevotionSelectionParser : NSObject <NSXMLParserDelegate>
{
    
    NSXMLParser *devotionSelectionParser;
    
}

- (NSMutableArray *)parseXMLFile:(NSString *)url;

@end
