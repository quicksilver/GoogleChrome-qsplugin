//
//  QSGoogleChromeActions.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSGoogleChromeDefinitions.h"
#import "Google Chrome.h"

@interface QSGoogleChromeActions : NSObject
- (void)performJavaScript:(NSString *)jScript;
@end
