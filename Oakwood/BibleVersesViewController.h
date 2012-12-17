//
//  BibleVersesViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 12/2/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleVerseConnection.h"

@interface BibleVersesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    BibleVerseConnection *myConn;
    UITextView *display;
    NSMutableString *displayString;
    NSArray *tableData;
    BibleVerseParser *myParser;
}

//Added
@property (nonatomic, retain) IBOutlet UITextView *display;
@property (nonatomic, retain) NSString *displayString;


@end
