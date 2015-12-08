//
//  AboutViewController.m
//  Boar
//
//  Created by George Matau on 19/10/2015.
//  Copyright (c) 2015 Visible Tech. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

#pragma mark - lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setuo status bar
    self.previousStatusbarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated{
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusbarStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - class methods
- (void) handleEmail:(NSString*)eAddress {
    // Mail
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setMailComposeDelegate:self];
        
        // Set recipients
        [picker setToRecipients:[NSArray arrayWithObject:eAddress]];
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No email account" message:@"You do not have an active email account!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - IBAction methods
- (IBAction)doEmail:(id)sender {
    [self handleEmail:EMAIL_CONTACT];
}

- (IBAction)doFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/warwickboar"]];
}

- (IBAction)doTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/warwickboar"]];
}

- (IBAction)doFeedback:(id)sender {
    [self handleEmail:EMAIL_APP];
}

- (IBAction)doAbout:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theboar.org/about"]];
}

- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
