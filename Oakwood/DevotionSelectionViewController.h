//
//  DevotionSelectionViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 8/24/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevotionSelectionViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    NSArray *tableData;
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
