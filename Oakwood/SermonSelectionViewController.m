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
#import "DevotionalDetails.h"
#import "SermonSelectionDetails.h"
#import "DevotionSelectionParser.h"
#import "BibleVersesWebViewController.h"
#import "SermonAudioViewController.h"
#import "ColorConverter.h"
#import "SermonFormatter.h"

@interface SermonSelectionViewController ()

@end

@implementation SermonSelectionViewController

UIActivityIndicatorView *spinner;
UILabel *rightHeaderLabel;
UIView *sectionHeaderView;


//This holds the sermons we got back...
NSDictionary *sermons;
NSArray *sortedValues;
NSMutableString *ddDisplay;


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
    //NSLog(@"inside SermonSelectionViewController");
    self.navigationItem.title = @"Sermons";
    [self.tableView setBackgroundColor: [ColorConverter colorFromHexString:@"#FFFFFF"]];
    [self.tableView setOpaque: NO];
    
    //Audio
    SermonSelectionParser *myParser = [[SermonSelectionParser alloc] init];
    
    //Production
    tableData = [myParser parseXMLFile:@"http://oakwoodnb.com/sermons/feed"];
    
    //For testing only
    //tableData = [myParser parseXMLFile:@"/Users/bosterkamp/Desktop/punc_sermons.txt"];
    //End for testing only
    
    //Video
    DevotionSelectionParser *myVideoParser = [[DevotionSelectionParser alloc] init];
    
    //Production...
    tableVideoData = [myVideoParser parseXMLFile:@"http://vimeo.com/channels/577936/videos/rss"];
    
    //Starting to integrate SermonSelectionParser
    sermons = [SermonFormatter formatSermons:tableVideoData audioSermon:tableData];
    
    //*sortedKeys = [sermons keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare)];
    NSArray* values = [sermons allValues];
    
    //Sort
    
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sermonPublishDate" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    sortedValues = [values sortedArrayUsingDescriptors:sortDescriptors];
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NO];
    
    @try {
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //Create the images for video and audio
 
        
        
    //Put this inside the nil check to make sure we don't duplicate the images
    UIButton *audioImage = [[UIButton alloc] initWithFrame:
                               CGRectMake(cell.frame.size.width - 110, 15, 40.0, 40.0)];
    
    UIButton *videoImage = [[UIButton alloc] initWithFrame:
                               CGRectMake(cell.frame.size.width - 55, 15, 40.0, 40.0)];
    
        UILabel *sermonSpace = [[UILabel alloc] initWithFrame:
                                CGRectMake(10, 0, cell.frame.size.width - 120, 80)];
    
    //Now we need to grab SSD and drive down to the SD
    SermonSelectionDetails *ssd = [sortedValues objectAtIndex:indexPath.row];
    SermonDetails *sd = [ssd sermon];
    NSMutableString *sdDisplay = [[NSMutableString alloc] initWithString:[sd sermonName]];
      
    //Pull the DD if it is there.
    DevotionalDetails *dd = [ssd devotional];
    
    //This is after iOS 6...
    #ifdef __IPHONE_6_0
    [sermonSpace setLineBreakMode:NSLineBreakByWordWrapping];
    #else
    [sermonSpace setLineBreakMode:UILineBreakModeWordWrap];
    #endif
        
    [sermonSpace setLineBreakMode:NSLineBreakByWordWrapping];
        
    sermonSpace.numberOfLines = 0;
        
        NSString *sermonUrl = [sd sermonUrl];
        //NSLog(@"URL: %@", sermonUrl);
        
            NSArray *slashSplit = [sermonUrl componentsSeparatedByString:@"/"];
            NSString *fileString = [slashSplit objectAtIndex:(slashSplit.count - 1)];
            NSArray *fileSplit = [fileString componentsSeparatedByString:@"."];
            NSString *dateString = [fileSplit objectAtIndex:0];
        //NSLog(@"Parsed Date: %@", dateString);
        
        //Gotta convert the date to a different format
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSDate *date = [formatter dateFromString:dateString];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            NSString *newDate = [formatter stringFromDate:date];
            [sdDisplay appendString:@"\n"];
            [sdDisplay appendString:newDate];

        
        //Using Attributed Text
        if ([sermonSpace respondsToSelector:@selector(setAttributedText:)]) {
            const CGFloat titleFontSize = 16;
            const CGFloat dateFontSize = 13;
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: sermonSpace.textColor,
                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:titleFontSize]
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:sdDisplay
                                                   attributes:attribs];
            // Date attributes
            NSRange dateTextRange = NSMakeRange(sdDisplay.length-10, 10);
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:dateFontSize]}
                                    range:dateTextRange];
            
            sermonSpace.attributedText = attributedText;
        }
        // If attributed text is NOT supported (iOS5-)
        else {
            sermonSpace.text = sdDisplay;
        }
        //End Using Attributed Text
    
    sermonSpace.numberOfLines = 0;
        //[sdDisplay appendString:@"\n1/12/2015"];
        
    //sermonSpace.text = sdDisplay;
 
    [cell.contentView addSubview:sermonSpace];
    
    audioImage.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin);
    //audioImage.image = [UIImage imageNamed:@"audio_icon.png"];
        [audioImage setBackgroundImage:[UIImage imageNamed:@"audio_icon.png"] forState:UIControlStateNormal];
        //NSLog(@"Audio Title: %@", sdDisplay);
    [cell.contentView addSubview:audioImage];
        
        audioImage.tag=indexPath.row;
        [audioImage addTarget:self action:@selector(PlayAudio:) forControlEvents:UIControlEventTouchUpInside];

    if (dd != nil)
    {
        videoImage.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin);
        [videoImage setBackgroundImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
        //NSLog(@"Video Title: %@", ddDisplay);
        [cell.contentView addSubview:videoImage];
        
        videoImage.tag=indexPath.row;
        [videoImage addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    }
        

    }
    @catch (NSException *exception) {
        //Swallow any exception
    }
    @finally {
        
    }
    return cell;
}

//Added to listen for events
-(IBAction)PlayAudio:(UIButton *)sender
{
    //NSLog(@"%d",sender.tag);
    //Create new thread to show activity indicator
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    SermonSelectionDetails *ssd1 = [sortedValues objectAtIndex:sender.tag];
    SermonDetails *sd = [ssd1 sermon];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    //SermonDetails *sd = [tableData objectAtIndex:sender.tag];
    
    //This is the Audio Selection
    //NSLog(@"Audio URL %@", [sd sermonUrl]);
    SermonAudioViewController* sermonAudioVC = [[SermonAudioViewController alloc] init];
    sermonAudioVC.launchUrl = [sd sermonUrl];
    [self.navigationController pushViewController:sermonAudioVC animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    
}

-(IBAction)PlayVideo:(UIButton *)sender
{
    
    //Create new thread to show activity indicator
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    SermonSelectionDetails *ssd1 = [sortedValues objectAtIndex:sender.tag];
    DevotionalDetails *dd  = [ssd1 devotional];

    //This will be the Video Selection
    //DevotionalDetails *dd = [tableVideoData objectAtIndex:sender.tag];
    
    //Adding new view
    //BibleVersesWebViewController* bibleVersesWebVC = [[BibleVersesWebViewController alloc] initWithUrl:[dd devotionalUrl]];
    //[self.navigationController pushViewController:bibleVersesWebVC animated:YES];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    //NSLog(@"Devotional URL %@", [dd devotionalUrl]);
    SermonAudioViewController* sermonAudioVC = [[SermonAudioViewController alloc] init];
    sermonAudioVC.launchUrl = [dd devotionalUrl];
    [self.navigationController pushViewController:sermonAudioVC animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /*
    //Create new thread to show activity indicator
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    //This will be the Video Selection
    DevotionalDetails *dd = [tableVideoData objectAtIndex:indexPath.row];
    
    //Adding new view
    //BibleVersesWebViewController* bibleVersesWebVC = [[BibleVersesWebViewController alloc] initWithUrl:[dd devotionalUrl]];
    //[self.navigationController pushViewController:bibleVersesWebVC animated:YES];
    
    SermonAudioViewController* sermonAudioVC = [[SermonAudioViewController alloc] init];
    sermonAudioVC.launchUrl = [dd devotionalUrl];
    [self.navigationController pushViewController:sermonAudioVC animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    */
}

//This looks pretty good for when two rows are needed.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(void) threadStartAnimating: (id) data
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped=TRUE;
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner]; // spinner is not visible until started
    [spinner startAnimating];
}

-(void) threadStopAnimating: (id) data
{
    [spinner stopAnimating];
}

- (void) viewWillAppear:(BOOL)animated
{
    //Make sure the activity indicator stops animating if we go back.
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 25.0)];
    sectionHeaderView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *leftHeaderLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(0, 0, sectionHeaderView.frame.size.width - 150, 25.0)];

    
    rightHeaderLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(tableView.frame.size.width - 110, 0, sectionHeaderView.frame.size.width, 25.0)];
    
    UILabel *evenerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(0, 0, sectionHeaderView.frame.size.width, 25.0)];
    
    evenerLabel.backgroundColor = [UIColor lightGrayColor];
    evenerLabel.textAlignment = NSTextAlignmentLeft;
    [evenerLabel setFont:[UIFont fontWithName:@"Verdana" size:10.0]];
    [sectionHeaderView addSubview:evenerLabel];
    evenerLabel.text = @"";
    
    rightHeaderLabel.backgroundColor = [UIColor lightGrayColor];
    //rightHeaderLabel.textAlignment = NSTextAlignmentRight;
    rightHeaderLabel.textAlignment = NSTextAlignmentLeft;
    [rightHeaderLabel setFont:[UIFont fontWithName:@"Verdana" size:10.0]];
    [sectionHeaderView addSubview:rightHeaderLabel];
    rightHeaderLabel.text = @"AUDIO   |   VIDEO";
    
    
    leftHeaderLabel.backgroundColor = [UIColor lightGrayColor];
    leftHeaderLabel.textAlignment = NSTextAlignmentLeft;
    [leftHeaderLabel setFont:[UIFont fontWithName:@"Verdana" size:10.0]];
    [sectionHeaderView addSubview:leftHeaderLabel];
    leftHeaderLabel.text = @"  SERMON TITLE";

    
    
    return sectionHeaderView;
}

//Need to do this to ensure the full screen is covered upon orientation change.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    [self.parentViewController.view setNeedsLayout];
    
    /*
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Landscape");
        [self.view setNeedsDisplay];
        //rightHeaderLabel.text = @"landscape!";
        //[self.tableView reloadData];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Portrait");
        [self.view setNeedsDisplay];
        //rightHeaderLabel.text = @"portrait!";
        //[self.tableView reloadData];
    }
 */
    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    

if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
{
    //NSLog(@"Landscape");
    [self.view setNeedsDisplay];
    //rightHeaderLabel.text = @"landscape!";
    [self.tableView reloadData];
}

if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
{
    //NSLog(@"Portrait");
    [self.view setNeedsDisplay];
    //rightHeaderLabel.text = @"portrait!";
    [self.tableView reloadData];
}

 
}


/*
- (BOOL) clearsSelectionOnViewWillAppear
{
    NSLog(@"clearsSelectionOnViewWillAppear");
    return NO;
}
*/

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    //NSLog(@"viewWillTransitionToSize");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });


    

}

@end
