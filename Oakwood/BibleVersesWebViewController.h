//
//  BibleVersesWebViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 4/19/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BibleVersesWebViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    
}

- (id)initWithUrl:(NSString *)launchUrl;


@end
