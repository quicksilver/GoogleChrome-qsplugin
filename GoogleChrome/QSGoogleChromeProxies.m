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
    
    NSDictionary *settings = (NSDictionary *)[proxy objectForType:QSProxyType];
    NSString *bundle = [settings objectForKey:@"bundle"];
    NSString *type = [settings objectForKey:@"proxyType"];
    
    if (QSAppIsRunning(bundle)) {
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:bundle];
        GoogleChromeWindow *currentWindow = [[chrome windows] objectAtIndex:0];
        GoogleChromeTab *currentTab = [currentWindow activeTab];
        
        if ([type isEqualToString:@"page"] && currentTab.URL) {
            QSObject *frontPage = [QSObject URLObjectWithURL:currentTab.URL title:currentTab.title];
            
            [frontPage setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  currentTab, @"tab",
                                  currentWindow, @"window",
                                  [NSNumber numberWithInt:[currentWindow activeTabIndex]], @"tabIndex",
                                  nil ]
                         forType:kQSGoogleChromeTab];
            
            return frontPage;
        } else if ([type isEqualToString:@"site"] && currentTab.URL) {
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
    NSDictionary *settings = (NSDictionary *)[object objectForType:QSProxyType];
    return [settings objectForKey:@"details"];
}


@end
