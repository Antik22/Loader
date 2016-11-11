//
//  FileCell.h
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Loader;

@interface FileCell : UITableViewCell

@property (weak, nonatomic) Loader* loader;

+ (NSString*)normalSizeFromLength:(NSUInteger)size;
- (void)removeObserverFromLoader;

@end
