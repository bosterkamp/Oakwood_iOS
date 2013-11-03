//
//  BibleVersesViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleVerseParser.h"

@interface BibleVersesViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    UITextView *display;
    NSMutableString *displayString;
    NSArray *tableData;
    BibleVerseParser *myParser;
}

//Added
@property (nonatomic, retain) IBOutlet UITextView *display;
@property (nonatomic, retain) NSString *displayString;


@end
