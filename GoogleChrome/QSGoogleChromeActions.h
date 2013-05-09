//
//  QSGoogleChromeActions.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSGoogleChromeDefinitions.h"

@interface QSGoogleChromeActions : NSObject

- (NSString *)getBundle;

- (void)performJavaScript:(NSString *)jScript;
- (QSObject *)revealTab:(QSObject *)directObj;
- (QSObject *)reloadTab:(QSObject *)directObj;

@end

@interface QSGoogleChromeCanaryActions : QSGoogleChromeActions

@end
