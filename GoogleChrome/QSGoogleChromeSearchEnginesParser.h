//
//  QSGoogleChromeSearchesParser.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-05-01.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegexKitLite.h"
#import "QSGoogleChromeDefinitions.h"
#import "QSGoogleChromeDatabaseManager.h"

@interface QSGoogleChromeSearchEnginesParser : QSParser

- (NSArray *)allSearchesFromDB:(NSString *)path;

@end
