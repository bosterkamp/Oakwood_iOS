//
//  BibleVerseConnection.h
//  Oakwood
//
//  Created by The Osterkamps on 12/1/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BibleVerseParser.h"

@interface BibleVerseConnection : NSObject {

        BibleVerseParser *myParser;
}

    -(NSMutableArray *) connectWithURL;

@end
