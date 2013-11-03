//
//  BaseViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 5/12/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

bool reachableStatusAlreadyShown;

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
    
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //We already check that our host is up in our parser and display proper error messages....
	//hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
	//[hostReach startNotifier];
	//[self updateInterfaceWithReachability: hostReach];
	
    //Just check for any type of internet connection.
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    
    //This is covered with the internet reach, no changes if it is wifi.
    //wifiReach = [Reachability reachabilityForLocalWiFi];
	//[wifiReach startNotifier];
	//[self updateInterfaceWithReachability: wifiReach];
     
     }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self configureAlert: curReach];
        //NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
        
        //summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabel=  @"";
        if(connectionRequired)
        {
            baseLabel=  @"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.";
        }
        else
        {
            baseLabel=  @"Cellular data network is active.\n  Internet traffic will be routed through it.";
        }
    }
	if(curReach == internetReach)
	{
		[self configureAlert: curReach];
	}
	if(curReach == wifiReach)
	{
		[self configureAlert: curReach];
	}
	
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void) configureAlert: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            if (!reachableStatusAlreadyShown && connectionRequired)
            {
                statusString = @"This app requires an internet connection and one is not available.";
                //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
                connectionRequired= NO;
                //We want to show an alert if the Network is lost...
                UIAlertView * statusAlert = [[UIAlertView alloc] initWithTitle:@"Connection Required" message:statusString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [statusAlert show];
                reachableStatusAlreadyShown = true;
                break;
            }
            

        }
        
       //Don't show anything if we are reachable.
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            reachableStatusAlreadyShown = false;
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            reachableStatusAlreadyShown = false;
            break;
        }
    }
    

}


@end
