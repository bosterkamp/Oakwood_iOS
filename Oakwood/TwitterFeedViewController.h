//
//  TwitterFeedViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 10/7/13. - Adapted from Blake Watters RKTwitterViewController (RestKit).
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface TwitterFeedViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *twitterFeed;
    NSArray *_statuses;
}


@end
