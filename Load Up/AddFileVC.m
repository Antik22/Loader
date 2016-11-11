//
//  AddFileVC.m
//  Load Up
//
//  Created by Anton Hrabovskyi on 11/4/16.
//  Copyright © 2016 Anton Hrabovskyi. All rights reserved.
//

#import "AddFileVC.h"
#import "TableOfFilesVC.h"

@interface AddFileVC () <UITextFieldDelegate>

// UI elements
@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation AddFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set backButton color
    UIColor* backButtonColor = [UIColor colorWithRed:(27.0f/255.0f) green:(88.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f];
    self.navigationController.navigationBar.tintColor = backButtonColor;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set active on the link field
    [self.linkField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)requestToAddLoaderInTableOfFiles {
    
    NSString* link = self.linkField.text;
    NSString* name = self.nameField.text;
    
    if ([link isEqualToString:@""] || [name isEqualToString:@""])
        return FALSE;

    TableOfFilesVC* tableOfFilesVC = (TableOfFilesVC*)[self.navigationController.viewControllers objectAtIndex:0];
    [tableOfFilesVC addFileFromLink:link andName:name];
    return TRUE;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.linkField]) {
        [self.nameField becomeFirstResponder];
        
    } else {
        
        if ([self requestToAddLoaderInTableOfFiles]) {
            
            // return back to tableViewController
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    return NO;
}




@end
