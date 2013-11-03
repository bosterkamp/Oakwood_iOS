//
//  EventSorter.h
//  Oakwood
//
//  Created by The Osterkamps on 8/4/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDetails.h"

@interface EventSorter : NSObject

+ (NSMutableArray *)sortEvents:(NSArray *)eventDetails;

@end
