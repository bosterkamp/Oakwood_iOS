//
//  SermonSelectionViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SermonSelectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    NSArray *tableData;
    NSArray *tableVideoData;
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
