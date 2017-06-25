//
//  QSGoogleChromeDatabaseManager.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-28.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeDatabaseManager.h"
#import <sqlite3.h>

@implementation QSGoogleChromeDatabaseManager


+ (FMDatabase *)openDatabase:(NSString *)name {
	NSString *tempFile = name;
	
	FMDatabase *db = [FMDatabase databaseWithPath:tempFile];
	NSString *vfsFile = @"unix-none";
	if (![db openWithFlags:SQLITE_OPEN_READONLY vfs:vfsFile]) {
		NSLog(@"Could not open database %@: %@", tempFile, [db lastError]);
		return nil;
	}
	return db;
}

@end
