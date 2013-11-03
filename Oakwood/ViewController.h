//
//  ViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 11/16/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *findUsBtn;
@property (weak, nonatomic) IBOutlet UIButton *sermonsBtn;
@property (weak, nonatomic) IBOutlet UIButton *eRayBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *baseView;


- (IBAction)informationRequest:(id)sender;
- (IBAction)loadDevotionals:(id)sender;

@end
