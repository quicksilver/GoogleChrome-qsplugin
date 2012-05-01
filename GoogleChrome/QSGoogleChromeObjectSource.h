//
//  QSGoogleChromeObjectSource.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <QSCore/QSCore.h>
#import "QSGoogleChromeDefinitions.h"
#import "QSGoogleChromeBookmarksParser.h"
#import "QSGoogleChromeHistoryParser.h"
#import "QSGoogleChromeSearchEnginesParser.h"

@interface QSGoogleChromeObjectSource : QSObjectSource

- (NSArray *)objectsForEntry:(NSDictionary *)theEntry;
- (BOOL)loadChildrenForObject:(QSObject *)object;
- (void)setQuickIconForObject:(QSObject *)object;
- (BOOL)objectHasChildren:(QSObject *)object;
- (NSString *)detailsOfObject:(QSObject *)object;

@end
