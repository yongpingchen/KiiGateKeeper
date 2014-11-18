//
//  LoginViewController.m
//  KiiGateKeeper
//
//  Created by Yongping on 11/18/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <TSMessages/TSMessage.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)tapLoginButton:(id)sender;
- (IBAction)tapSignUpButton:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else {
        [_passwordTextField resignFirstResponder];
    }
    return false;
}

// User clicked the Login button
- (IBAction)tapLoginButton:(id)sender {
    // Get the user identifier/password from the UI
    NSString *userIdentifier = [_userNameTextField text];
    NSString *password = [_passwordTextField text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loging...";
    [KiiUser authenticate:userIdentifier withPassword:password andBlock: ^(KiiUser *user, NSError *error) {
        if (error) {
            hud.hidden = true;
            
            // get the error message
            NSString *errorMessage = [self errorMessage:error];
            
            [TSMessage showNotificationInViewController:self title:@"Login failed" subtitle:errorMessage type:TSMessageNotificationTypeError duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];
        }
        else {
            hud.hidden = true;
            
            [[NSUserDefaults standardUserDefaults] setObject:user.accessToken forKey:@"accessToken"];
            [self dismissViewControllerAnimated:YES completion:^{
                [TSMessage showNotificationInViewController:self.parentViewController title:@"Login success" subtitle:@"" type:TSMessageNotificationTypeSuccess duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];
            }];

        }
    }];
}

// User clicked the Sign Up button
- (IBAction)tapSignUpButton:(id)sender {
    // Get the user identifier/password from the UI
    NSString *userIdentifier = [_userNameTextField text];
    NSString *password = [_passwordTextField text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Regiestering user...";
    
    KiiUser *user = [KiiUser userWithUsername:userIdentifier andPassword:password];
    
    [user performRegistrationWithBlock: ^(KiiUser *user, NSError *error) {
        if (error) {
            hud.hidden = true;
            
            // get the error message
            NSString *errorMessage = [self errorMessage:error];
            
            [TSMessage showNotificationInViewController:self title:@"Sign up failed" subtitle:errorMessage type:TSMessageNotificationTypeError duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];
        }
        else {
            hud.hidden = true;
            [[NSUserDefaults standardUserDefaults] setObject:user.accessToken forKey:@"accessToken"];
            [self dismissViewControllerAnimated:YES completion:^{
                [TSMessage showNotificationInViewController:self.parentViewController title:@"Sign up success" subtitle:@"" type:TSMessageNotificationTypeSuccess duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser:YES];
            }];

            
        }
    }];
}

#pragma mark common methods
- (NSString *)errorMessage:(NSError *)error {
    NSLog(@"error: %@", error.description);
    NSString *errorMessage = @"";
    
    // if there is error message from server
    if (error.userInfo[@"server_message"]) {
        errorMessage = error.userInfo[@"server_message"];
    }
    else { // if there is not error message from server, it means error happend locally
        errorMessage = error.userInfo[@"description"];
    }
    return errorMessage;
}


@end
