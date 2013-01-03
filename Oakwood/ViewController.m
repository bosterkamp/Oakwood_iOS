//
//  ViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 11/16/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "ViewController.h"
#import "FindUsViewController.h"
#import "CalendarViewController.h"
#import "SermonSelectionViewController.h"
#import "BibleVersesViewController.h"
#import "ERayViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *navItems;
    NSArray *imgItems;
}

UIActivityIndicatorView *spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    navItems = [NSArray arrayWithObjects:@"How to find us", @"Calendar", @"Sermons", @"Bible Verses", @"eRay", nil];
    imgItems = [NSArray arrayWithObjects:@"address.png", @"calendar.png", @"sermon.png", @"scripture.png", @"eray.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [navItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NavItemsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
 
    }
    
    cell.textLabel.text = [navItems objectAtIndex:indexPath.row];
    
    NSString *image = [imgItems objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:image];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //This isn't displaying properly...
    
    //Try to add activity indicator...

    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    //[spinner setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // I do this because I'm in landscape mode

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    
    if ([@"How to find us" isEqualToString:([navItems objectAtIndex:indexPath.row])])
        {
            //Call Map View
            FindUsViewController *mapView = [[FindUsViewController alloc] init];
            [[self navigationController] pushViewController:mapView animated:YES];
        }
        else if ([@"Calendar" isEqualToString:([navItems objectAtIndex:indexPath.row])])
        {
            //Call Calendar View
            CalendarViewController *calView = [[CalendarViewController alloc] init];
            [[self navigationController] pushViewController:calView animated:YES];
        }
        else if ([@"Sermons" isEqualToString:([navItems objectAtIndex:indexPath.row])])
        {
            //Call SermonSelection View
            SermonSelectionViewController *sermonView = [[SermonSelectionViewController alloc] init];
            [[self navigationController] pushViewController:sermonView animated:YES];
        }
        else if ([@"Bible Verses" isEqualToString:([navItems objectAtIndex:indexPath.row])])
        {
            //Call BibleVerse View
            BibleVersesViewController *bvView = [[BibleVersesViewController alloc] init];
            [[self navigationController] pushViewController:bvView animated:YES];
        }
        else if ([@"eRay" isEqualToString:([navItems objectAtIndex:indexPath.row])])
        {
            //Call ERay View
            ERayViewController *erayView = [[ERayViewController alloc] init];
            [[self navigationController] pushViewController:erayView animated:YES];
        }
        else
        {
            NSLog(@"invalid selection: %@", [navItems objectAtIndex:indexPath.row]);
        }
    
    [spinner stopAnimating];
    
    
        //Do I need to release the controllers?
}

-(void) threadStartAnimating: (id) data
{
    NSLog(@"threadStartAnimating begin");
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner]; // spinner is not visible until started
        [spinner startAnimating];
    NSLog(@"threadStartAnimating end");
}



@end
