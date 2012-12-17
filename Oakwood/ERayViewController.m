//
//  ERayViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "ERayViewController.h"
#import "ERayParser.h"

@interface ERayViewController ()

@end

@implementation ERayViewController

@synthesize webUIView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"inside ERayViewController");
    self.navigationItem.title = @"eRay";
    
    ERayParser *myParser = [[ERayParser alloc] init];
    NSString *eRay = [myParser parseXMLFile:@"http://oakwoodnb.com/eray/feed"];
    
    //NSLog(@"inside ERayViewController: %@", eRay);
    
    [self.webUIView loadHTMLString: eRay baseURL:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
