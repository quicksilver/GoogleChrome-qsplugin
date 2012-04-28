//
//  QSGoogleChromeDatabaseManager.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-28.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeDatabaseManager.h"

@implementation QSGoogleChromeDatabaseManager


+(FMDatabase *)openDatabase:(NSString *)name {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *tempFile = [NSTemporaryDirectory() stringByAppendingString:[name lastPathComponent]];
    NSError *err;
    
    [manager removeItemAtPath:tempFile error:&err];
    
    if (![manager copyItemAtPath:name toPath:tempFile error:&err]) {
        NSLog(@"Error while copying %@ to %@: %@", name, tempFile, err);
        return nil;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:tempFile];
    if (![db open]) {
        NSLog(@"Could not open database %@", tempFile);
        return nil;
    }

    return db;
}


@end
