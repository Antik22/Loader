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

@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation AddFileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.linkField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)requestToControllerForAddLoader {
    
    NSString* link = self.linkField.text;
    NSString* name = self.nameField.text;
    
    if ([link isEqualToString:@""] || [name isEqualToString:@""])
        return FALSE;

    [self.prevController addFileFromLink:link andName:name];
    return TRUE;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.linkField]) {
        [self.nameField becomeFirstResponder];
        
    } else {
        
        if ([self requestToControllerForAddLoader]) {
            
            // return back to tableViewController
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    return NO;
}




@end
