//
//  QSGoogleChromeDatabaseManager.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-28.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeDefinitions.h"

@class FMDatabase;


/*
 Chrome keeps an exclusive lock on its databases while running,
 so in order to access the information stored in the databases,
 we need to make a duplicate of the database from which to read.
 
 This class provides the functionality of copying the database and
 supplying a connection to the database.
 */
@interface QSGoogleChromeDatabaseManager : NSObject

+(FMDatabase *)openDatabase:(NSString *)name;

@end
