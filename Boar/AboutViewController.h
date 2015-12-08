//
//  AboutViewController.h
//  Boar
//
//  Created by George Matau on 19/10/2015.
//  Copyright (c) 2015 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic) UIStatusBarStyle previousStatusbarStyle;

- (IBAction)doEmail:(id)sender;
- (IBAction)doFacebook:(id)sender;
- (IBAction)doTwitter:(id)sender;
- (IBAction)doFeedback:(id)sender;
- (IBAction)doAbout:(id)sender;
- (IBAction)doBack:(id)sender;

@end
