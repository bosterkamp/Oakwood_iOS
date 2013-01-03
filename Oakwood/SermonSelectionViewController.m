//
//  SermonSelectionViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 12/17/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "SermonSelectionViewController.h"
#import "SermonSelectionParser.h"
#import "SermonDetails.h"
#import "SermonAudioViewController.h"

@interface SermonSelectionViewController ()

@end

@implementation SermonSelectionViewController

UIActivityIndicatorView *spinner;

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
    NSLog(@"inside SermonSelectionViewController");
    self.navigationItem.title = @"Sermons";
    
    SermonSelectionParser *myParser = [[SermonSelectionParser alloc] init];
    tableData = [myParser parseXMLFile:@"http://oakwoodnb.com/sermons/feed"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    SermonDetails *sd = [tableData objectAtIndex:indexPath.row];
    NSMutableString *sdDisplay = [[NSMutableString alloc] initWithString:[sd sermonName]];
    //NSMutableString *sdUrl = [[NSMutableString alloc] initWithString:[sd sermonUrl]];
    cell.textLabel.text = sdDisplay;
    
    //NSLog(@"Sermon %i: Name: %@ - Url: %@", indexPath.row, sdDisplay, sdUrl);
    
    
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create new thread to show activity indicator
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SermonDetails *sd = [tableData objectAtIndex:indexPath.row];
    
    //Trying to add new view
    
    SermonAudioViewController* sermonAudioVC = [[SermonAudioViewController alloc] initWithNibName:@"SermonAudioViewController" bundle:nil];
    sermonAudioVC.launchUrl = [sd sermonUrl];
    [self.navigationController pushViewController:sermonAudioVC animated:YES];
    [spinner stopAnimating];
    
}

//This looks pretty good for when two rows are needed.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

-(void) threadStartAnimating: (id) data
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner]; // spinner is not visible until started
    [spinner startAnimating];
}


@end
