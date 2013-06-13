//
//  NewNoteViewController.m
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "NewNoteViewController.h"
#import "DataManager.h"

@interface NewNoteViewController () <QBActionStatusDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *noteTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextField;

- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;

@end

@implementation NewNoteViewController

- (void)viewDidUnload
{
    [self setNoteTextField:nil];
    [self setCommentTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    
    if (self.noteTextField.text.length && self.commentTextField.text.length) {
        [self createNote];
    } else {
        UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                         message:@"Please fill both Note & Comment fields"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [allert show];
    }
}


- (void)createNote {
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = customClassName;
    object.fields[@"note"] = self.noteTextField.text;
    object.fields[@"comment"] = self.commentTextField.text;
    object.fields[@"status"] = @"New";
    
    [QBCustomObjects createObject:object delegate:self];
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    
    return YES;
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result {
    
    // Create custom object result
    if ([result isKindOfClass:QBCOCustomObjectResult.class]) {

        // Success result
        if (result.success) {
            QBCOCustomObjectResult *res = (QBCOCustomObjectResult *)result;
            
            // add note to storage
            [[[DataManager shared] notes] addObject:res.object];
            
            // hide screen
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

@end
