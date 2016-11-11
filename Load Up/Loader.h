//
//  Loader.h
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loader : NSObject

@property (nonatomic) BOOL isDone;

@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* dateOfStart;

@property (nonatomic) NSUInteger expectedSize;
@property (nonatomic) NSUInteger currentSize;


+ (NSMutableArray*)loadFilesFromCodeDate;
+ (NSUInteger)getFreeSpace;
- (id)initWithLink:(NSString*)link andName:(NSString*)name;
- (id) initWithName:(NSString*)name andSize:(NSUInteger)size andDate:(NSDate*)date andPath:(NSString*)path;
- (void)canceAndRemove;

- (void) pause;
- (void) resume;

@end
