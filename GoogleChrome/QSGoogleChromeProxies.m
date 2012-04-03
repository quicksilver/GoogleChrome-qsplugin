//
//  QSGoogleChromeProxies.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-03.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeProxies.h"

@implementation QSGoogleChromeProxies


- (id)resolveProxyObject:(id)proxy {
    if ([[proxy identifier] isEqualToString:kQSGoogleChromeFrontPageProxy]) {
        if (QSAppIsRunning(kQSGoogleChromeBundle)) {
            
            GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
            GoogleChromeTab *currentTab = [[[chrome windows] objectAtIndex:0] activeTab];
            
            if (currentTab.URL) {
                return [QSObject URLObjectWithURL:currentTab.URL title:currentTab.title];
            }
        }
        
    }
    
    return nil;
}


- (NSString *)detailsOfObject:(QSObject *)object {
    if ([[object identifier] isEqualToString:kQSGoogleChromeFrontPageProxy]) {
        return @"The URL of the page open in Chrome";
    }
    return nil;
}


@end
