//
//  TableOfFilesVC.m
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import "TableOfFilesVC.h"
#import "AddFileVC.h"
#import "FileCell.h"
#import "Loader.h"

@interface TableOfFilesVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* loaderArray;

// UI elements
@property (weak, nonatomic) IBOutlet UIBarButtonItem *usedMemoryBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *allMemoryBar;
@property (weak, nonatomic) IBOutlet UIProgressView *memoryProgressBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

static TableOfFilesVC* singleton;

@implementation TableOfFilesVC

// test link: http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-CD-1.iso

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleton = self;
    
    // read Documents files and create array with them
    self.loaderArray = [Loader loadFilesFromCodeDate];
    
    [TableOfFilesVC updateMemoryBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// call when file was change and we need to update memory bar
+ (void)updateMemoryBar {
    
    NSUInteger usedMemory = 0;
    
    for (Loader* loader in singleton.loaderArray) {
        
        usedMemory += loader.currentSize;
    }
    
    // should will know how much bytes busy our "documents"
    NSUInteger fullSpace = [Loader getFreeSpace];
    singleton.usedMemoryBar.title = [FileCell normalSizeFromLength:usedMemory];
    singleton.allMemoryBar.title = [FileCell normalSizeFromLength:fullSpace];
    fullSpace += usedMemory;
    double round = (double)usedMemory/(double)fullSpace;
    singleton.memoryProgressBar.progress = round;
    
}

// call from other addFileViewController, where we input link and name of file
- (void)addFileFromLink:(NSString*)link andName:(NSString*)name {
    
    // create Loader from link and name and add its to array
    Loader* loader = [[Loader alloc] initWithLink:link andName:name];
    [self.loaderArray addObject:loader];
    
    // UI tableView update
    [self.tableView beginUpdates];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.loaderArray count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];

}


- (IBAction)edit:(id)sender {
    
    BOOL isEditing = !(self.tableView.editing);
    [self.tableView setEditing:isEditing animated:TRUE];
    self.editButton.title = isEditing ? @"Done" : @"Edit";
}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Loader* loader = [self.loaderArray objectAtIndex:indexPath.row];
        [loader removeAll];
        [_loaderArray removeObjectAtIndex:indexPath.row];
        [TableOfFilesVC updateMemoryBar];
        
        // UI update
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.loaderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Loader* loader = [self.loaderArray objectAtIndex:indexPath.row];
    
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    cell.loader = loader;

    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addFileIdentifier"]) {
        
        AddFileVC* addFileController = (AddFileVC*)[segue destinationViewController];
        addFileController.prevController = self;
    }

}



@end
