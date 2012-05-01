//
//  QSGoogleChromeActions.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeActions.h"

@implementation QSGoogleChromeActions


/*
 Runs javascript in the current tab, required by the interface for web browser mediators
 */
- (void)performJavaScript:(NSString *)jScript {
    GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
    GoogleChromeTab *currentTab = [[[chrome windows] objectAtIndex:0] activeTab];
    [currentTab executeJavascript:jScript];
}


/*
 Activates the tab of a currently open web page in Chrome
 */
- (QSObject *)revealTab:(QSObject *)directObj {
    NSDictionary *tabInfo = [directObj objectForType:kQSGoogleChromeTab];
    
    if (tabInfo) {
        GoogleChromeWindow *window = [tabInfo objectForKey:@"window"];
        NSNumber *tabIndex = [tabInfo objectForKey:@"tabIndex"];
        
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
        [chrome activate];
        [window setActiveTabIndex:[tabIndex intValue]];
        [window setIndex:1];
    }
    
    return nil;
}


/*
 Reloads the tab of a currently open web page in Chrome
 */
- (QSObject *)reloadTab:(QSObject *)directObj {
    NSDictionary *tabInfo = [directObj objectForType:kQSGoogleChromeTab];
    
    if (tabInfo) {
        GoogleChromeTab *tab = [tabInfo objectForKey:@"tab"];
        [tab reload];
    }
    
    return nil;
}


@end
