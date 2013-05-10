//
//  QSGoogleChromeActions.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeActions.h"

@implementation QSGoogleChromeActions


- (NSString *)getBundle { return kQSGoogleChromeBundle; }


/*
 Runs javascript in the current tab, required by the interface for web browser mediators
 */
- (void)performJavaScript:(NSString *)jScript {
    GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:[self getBundle]];
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
        NSString *bundle = [tabInfo objectForKey:@"bundle"];
        
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:bundle];
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


/*
 Opens a Chrome URL in the source browser
 */
- (QSObject *)openURLInSourceBrowser:(QSObject *)urlObj {
    NSString *bundle = [urlObj objectForType:kQSGoogleChromeURL];

    NSWorkspace *ws = [NSWorkspace sharedWorkspace];

    for (NSString *urlString in [urlObj arrayForType:QSURLType]) {
        NSURL *url = [[NSURL URLWithString:[urlString URLEncoding]] URLByInjectingPasswordFromKeychain];
        NSString *ident = [[NSBundle bundleWithIdentifier:bundle] bundleIdentifier];

        [ws openURLs:[NSArray arrayWithObject:url] withAppBundleIdentifier:ident options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil];
    }

    return nil;
}


@end

@implementation QSGoogleChromeCanaryActions

- (NSString *)getBundle { return kQSGoogleChromeCanaryBundle; }

@end
