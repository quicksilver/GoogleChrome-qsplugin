//
//  QSGoogleChromeProxies.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-03.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeProxies.h"

@implementation QSGoogleChromeProxies


/*
 Provides proxy objects for the current front page in Chrome, both as an url
 and as a search alternative.
 */
- (id)resolveProxyObject:(id)proxy {
    
    if (QSAppIsRunning(kQSGoogleChromeBundle)) {
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
        GoogleChromeTab *currentTab = [[[chrome windows] objectAtIndex:0] activeTab];
        
        NSString *identifier = [proxy identifier];
        
        if ([identifier isEqualToString:kQSGoogleChromeFrontPageProxy] && currentTab.URL) {
            return [QSObject URLObjectWithURL:currentTab.URL title:currentTab.title];
        } else if ([identifier isEqualToString:kQSGoogleChromeSearchCurrentSiteProxy] && currentTab.URL) {
            NSURL *currentURL = [NSURL URLWithString:currentTab.URL];
            NSString *searchShortcut = [NSString stringWithFormat:@"http://www.google.com/search?q=*** site:%@", 
                                        [currentURL host]];
            return [QSObject URLObjectWithURL:searchShortcut title:nil];
        }
    } else {
        NSBeep();
    }
    
    return nil;
}


/*
 Sets the details for the current front page proxies
 */
- (NSString *)detailsOfObject:(QSObject *)object {
    
    NSString *identifier = [object identifier];
    
    if ([identifier isEqualToString:kQSGoogleChromeFrontPageProxy]) {
        return @"The URL of the page open in Chrome";
    } else if ([identifier isEqualToString:kQSGoogleChromeSearchCurrentSiteProxy]) {
        return @"Search the site open in Chrome";
    }
    
    return nil;
}


@end
