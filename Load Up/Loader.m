//
//  Loader.m
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import "Loader.h"
#import "TableOfFilesVC.h"
@interface Loader () <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *ourTask;
@property (strong, nonatomic) NSMutableData *ourData;

@end


@implementation Loader

+ (NSMutableArray*)loadFilesFromCodeDate {
    
    NSMutableArray* loaderArray = [NSMutableArray array];
    
    // read data and create Loader objects and return them
    // but now just read all files in Document directory

    NSURL* documentsDirectoryUrl = [Loader documentsDirectoryUrl];
    NSError* error;
    NSArray  *yourFolderContents = [[NSFileManager defaultManager]
                                    contentsOfDirectoryAtPath:documentsDirectoryUrl.path error:&error];

    
    for (NSString* name in yourFolderContents) {
        
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [Loader documentsDirectoryUrl].path, name];
        NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSUInteger fileSize = [attrs fileSize];
        NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];
        Loader *loader = [[Loader alloc] initWithName:name andSize:fileSize andDate:date andPath:filePath];
        [loaderArray addObject:loader];
    }

    
    return loaderArray;
}

+ (NSURL *)documentsDirectoryUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


+ (NSUInteger)getFreeSpace {
    NSUInteger fileSystemFreeSizeInBytes;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject]
                                                                                    error: &error];
    
    if (dictionary) {
        fileSystemFreeSizeInBytes = [[dictionary objectForKey: NSFileSystemFreeSize] unsignedIntegerValue];
    }
    
    return fileSystemFreeSizeInBytes;
}

// initialize file which is downloaded and saved in Documents
- (id)initWithName:(NSString*)name andSize:(NSUInteger)size andDate:(NSDate*)date andPath:(NSString*)path {
    
    self = [super init];
    if (self) {
        
        _name = name;
        _link = path;
        _currentSize = _expectedSize = size;
        _dateOfStart = date;
        _isDone = TRUE;
    }
    return self;
}

// initialize file which should will download
- (id)initWithLink:(NSString*)link andName:(NSString*)name {
    
    self = [super init];
    if (self) {
        
        _link = link;
        _name = name;
        _currentSize = 0;
        _expectedSize = 0;
        _dateOfStart = [NSDate date];
        _isDone = FALSE;
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        self.ourTask = [defaultSession dataTaskWithURL:[NSURL URLWithString:link]];
        [self.ourTask resume];
        
    }
    return self;
}

- (void)pause {
    [self.ourTask suspend];
}

- (void)resume {
    [self.ourTask resume];
}

- (void)dealloc {
    
    NSLog(@"dealloc called");
    // we need stop downloading or/and delete file from Documents
    [self removeAll];
}

- (void)removeAll {

    [self.ourTask cancel];
    
    // delete file from file system
    if (self.isDone) {
        NSString* path = [NSString stringWithFormat:@"%@/%@", [Loader documentsDirectoryUrl].path, self.name];
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    
    
}

#pragma mark - NSURLSession

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    
    if (task == self.ourTask) {
    
        // file saving
        NSLog(@"Finished downloading file");
        __block NSString* filePath = [NSString stringWithFormat:@"%@/%@", [Loader documentsDirectoryUrl].path, self.name];
        dispatch_async(dispatch_queue_create("loadingQueue", 0), ^{
            [self.ourData writeToFile:filePath atomically:TRUE];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isDone = TRUE;
                [TableOfFilesVC updateMemoryBar];
            });
        });
    } else {
        NSLog(@"DOWNLOADED NOT OUR FILE");
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    completionHandler(NSURLSessionResponseAllow);

    // not required
    if (dataTask == self.ourTask) {

        self.expectedSize = [response expectedContentLength];
        self.ourData = [NSMutableData data];
        NSLog(@"Get response, expected length %li", self.expectedSize);
        
    } else {
        NSLog(@"NOT OUR TASK!!!!!");
    }
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    // not required
    if (dataTask == self.ourTask) {
        
        [self.ourData appendData:data];
        self.currentSize = self.ourData.length;
        NSLog(@"Received data %li of %li", self.currentSize, self.expectedSize);

    } else {
        NSLog(@"NOT OUR DATA RECEIVED");
    }
}




@end
