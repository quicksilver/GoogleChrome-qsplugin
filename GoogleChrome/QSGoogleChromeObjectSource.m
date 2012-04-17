//
//  QSGoogleChromeObjectSource.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeObjectSource.h"

@implementation QSGoogleChromeObjectSource


- (BOOL) loadChildrenForObject:(QSObject *)object {
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    if ([[object primaryType] isEqualToString:NSFilenamesPboardType]) {
        id chromeIcon = [QSResourceManager imageNamed:kQSGoogleChromeBundle];
        
        QSObject *child;
        
        child = [QSObject objectWithName:@"Open Web Pages (Chrome)"];
        
        [child setDetails:@"URLs from all open windows and tabs"];
        [child setPrimaryType:kQSGoogleChromeOpenWebPages];
        [child setObject:@"Open Web Pages (Chrome)" forType:kQSGoogleChromeOpenWebPages];
        [child setIcon:chromeIcon];
        
        [children addObject:child];
        
        [object setChildren:children];
        return YES;
        
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeOpenWebPages]) {
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
        
        for (GoogleChromeWindow *window in [chrome windows]) {
            for (GoogleChromeTab *tab in [window tabs]) {
                [children addObject:[QSObject URLObjectWithURL:tab.URL title:tab.title]];
            }
        }
        
        [object setChildren:children];
        return YES;
    }
    
    return NO;
}


@end
