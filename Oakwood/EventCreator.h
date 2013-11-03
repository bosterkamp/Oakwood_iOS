//
//  EventCreator.h
//  Oakwood
//
//  Created by The Osterkamps on 7/14/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDetails.h"

@interface EventCreator : NSObject

+ (NSArray *)createEvents:(CalendarDetails *)calendarDetails;

@end
