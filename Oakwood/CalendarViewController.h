//
//  CalendarViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 11/20/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarParser.h"

@interface CalendarViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITextView *display;
    NSMutableString *displayString;
    NSArray *tableData;
    CalendarParser *myParser;
}

//Added
//@property (nonatomic, retain) IBOutlet UITextView *display;
//@property (nonatomic, retain) NSString *displayString;

@end
