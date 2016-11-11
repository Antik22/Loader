//
//  FileCell.m
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/3/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import "FileCell.h"
#import "Loader.h"

@interface FileCell()

@property (strong, nonatomic) NSString* fullSize;
@property (strong, nonatomic) NSString* currentSize;
@property (nonatomic) BOOL isRunning;

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *downloadDate;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *controllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* nameHeightConstraint;

@property(strong, nonatomic) UIView* backCellView;

@end

@implementation FileCell


- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"cell init");
    if (!self.backCellView) {
        self.backCellView = [[UIView alloc] init];
        UIColor *selectedCellColor = [UIColor colorWithRed:(153.0f/255.0f)
                                                    green:(216.0f/255.0f)
                                                    blue:(221.0f/255.0f)
                                                    alpha:1.0f];
        
        self.backCellView.backgroundColor = selectedCellColor;
    }
    [self setSelectedBackgroundView:self.backCellView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setLoader:(Loader *)loader {
    
    _loader = loader;
    self.fullSize = [FileCell normalSizeFromLength:self.loader.expectedSize];
    
    self.name.text = loader.name;
    NSString *createdDate = [NSDateFormatter localizedStringFromDate:self.loader.dateOfStart
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterShortStyle];
    self.downloadDate.text = createdDate;
    
    if (self.loader.isDone) {
        _isRunning = FALSE;
        self.nameHeightConstraint.constant = 58;
        self.controllButton.hidden = TRUE;
        
        self.state.text = [FileCell normalSizeFromLength:self.loader.currentSize];
        self.progressBar.progress = 1.f;
        
    } else {
        
        _isRunning = TRUE;
        self.nameHeightConstraint.constant = 28;
        self.controllButton.hidden = FALSE;
        self.state.text = @"No Answer";
        self.progressBar.progress = 0.f;
        
        [self.loader addObserver:self forKeyPath:@"expectedSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.loader addObserver:self forKeyPath:@"currentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.loader addObserver:self forKeyPath:@"isDone" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    // not required
    if ([object isEqual:self.loader]) {
        
        if ([keyPath isEqualToString:@"currentSize"]) {
        
            self.currentSize = [FileCell normalSizeFromLength:self.loader.currentSize];
            self.progressBar.progress = (float)self.loader.currentSize/(float)self.loader.expectedSize;
            self.state.text = [NSString stringWithFormat:@"%@ of %@", self.currentSize, self.fullSize];
        
        } else if ([keyPath isEqualToString:@"expectedSize"]) {
        
            self.fullSize = [FileCell normalSizeFromLength:self.loader.expectedSize];
            self.progressBar.progress = (float)self.loader.currentSize/(float)self.loader.expectedSize;
            self.state.text = [NSString stringWithFormat:@"%@ of %@", self.currentSize, self.fullSize];
    
        } else if ([keyPath isEqualToString:@"isDone"] && self.loader.isDone) {
        
            _isRunning = FALSE;
            
            self.controllButton.hidden = TRUE;
            self.nameHeightConstraint.constant = 58;
            [UIView animateWithDuration:0.5 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {}];
            
            self.state.text = [FileCell normalSizeFromLength:self.loader.currentSize];
            self.progressBar.progress = 1.f;
            
            [self.loader removeObserver:self forKeyPath:@"currentSize"];
            [self.loader removeObserver:self forKeyPath:@"expectedSize"];
            [self.loader removeObserver:self forKeyPath:@"isDone"];

        }
    }
}

+ (NSString*)normalSizeFromLength:(NSUInteger)size {
    
    NSString* normalView;
    
    // GB
    if (size >= 1000000000) {
        float sizeGB = (float)size/1000000000.f;
        normalView = [NSString stringWithFormat:@"%.2f GB", sizeGB];
    } // MB
    else if (size >= 1000000) {
        float sizeMB = (float)size/1000000.f;
        normalView = [NSString stringWithFormat:@"%.2f MB", sizeMB];
        
    } // KB
    else if (size >= 1000) {
        float sizeKB = (float)size/1000.f;
        normalView = [NSString stringWithFormat:@"%.2f KB", sizeKB];
    } // Bytes
    else {
        normalView = [NSString stringWithFormat:@"%.0f B", (float)size];
    }
    return normalView;
}

- (void)prepareForReuse {
    NSLog(@"cell reuse");
    
    [self removeObserverFromLoader];
    
}

- (void)removeObserverFromLoader {
    
    if (!self.loader.isDone) {
        NSLog(@"remove Observer from active Loader");
        
        [self.loader removeObserver:self forKeyPath:@"currentSize"];
        [self.loader removeObserver:self forKeyPath:@"expectedSize"];
        [self.loader removeObserver:self forKeyPath:@"isDone"];
    }
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)controll:(id)sender {

    if (self.isRunning) {
        self.isRunning = FALSE;
        [self.controllButton setTitle:@"> resume" forState:UIControlStateNormal];
        [self.loader pause];
    } else {
        self.isRunning = TRUE;
        [self.controllButton setTitle:@"II pause" forState:UIControlStateNormal];
        [self.loader resume];
    }
    
}
@end
