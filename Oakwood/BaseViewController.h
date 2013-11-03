//
//  BaseViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 5/12/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@interface BaseViewController : UIViewController
{
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

@end
