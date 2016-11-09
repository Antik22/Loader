//
//  TableOfFilesVC.h
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableOfFilesVC : UIViewController

+ (void)updateMemoryBar;
- (void)addFileFromLink:(NSString*)link andName:(NSString*)name;


@end
