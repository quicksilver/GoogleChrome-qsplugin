//
//  QSGoogleChromeObjectSource.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <QSCore/QSCore.h>
#import "QSGoogleChromeDefinitions.h"

@interface QSGoogleChromeObjectSource : QSObjectSource

- (BOOL) loadChildrenForObject:(QSObject *)object;

@end
