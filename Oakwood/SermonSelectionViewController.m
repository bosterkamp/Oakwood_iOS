//
//  SermonSelectionViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 11/21/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "SermonSelectionViewController.h"

@interface SermonSelectionViewController ()

@end

@implementation SermonSelectionViewController

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
	// Do any additional setup after loading the view.
    NSLog(@"inside SermonSelectionViewController");
        self.navigationItem.title = @"Sermons";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
