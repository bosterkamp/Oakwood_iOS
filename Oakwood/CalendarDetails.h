//
//  CalendarDetails.h
//  Oakwood
//
//  Created by The Osterkamps on 4/12/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecurringEventDetails.h"

@interface CalendarDetails : NSObject
{
    
}

+ (Boolean *)isValid:(CalendarDetails *)objForValidation;


@property (copy) NSString *eventStartDate;
@property (copy) NSString *eventEndDate;
@property (copy) NSString *eventSummary;
@property (copy) NSString *eventUrl;
@property (copy) NSString *eventDescription;
@property (retain) RecurringEventDetails *recurringEventInfo;


@end
