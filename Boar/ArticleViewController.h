//
//  ArticleViewController.h
//  Boar
//
//  Created by George Matau on 23/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BModel.h"
#import "CommentView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SearchViewController.h"

@interface ArticleViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSDictionary* dicArticle;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* htmlString;
@property (nonatomic) UIStatusBarStyle previousStatusbarStyle;
@property (nonatomic) UIInterfaceOrientation currentOrientation;
@property (nonatomic) BOOL isHeaderVisible;

@property (weak, nonatomic) IBOutlet UIImageView *ivHeaderBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcParalaxWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcParalaxHeight;
@property (weak, nonatomic) IBOutlet UIImageView *ivArticleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcSvContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcSvContentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *svParalax;
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UIView *viewSvParalax;
@property (weak, nonatomic) IBOutlet UIView *viewSvContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivArticleHeaderBg;
@property (weak, nonatomic) IBOutlet UILabel *lblArticleTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblArticleAutor;
@property (weak, nonatomic) IBOutlet UILabel *lblArticleDate;
@property (weak, nonatomic) IBOutlet UIWebView *wvContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcWebViewHeight;
@property (weak, nonatomic) IBOutlet UIView *viewComments;
@property (weak, nonatomic) IBOutlet UIView *viewCommentsList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcViewCommentsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcViewCommentsListHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblNoComments;
@property (weak, nonatomic) IBOutlet UIScrollView *svTags;
@property (weak, nonatomic) IBOutlet UIView *viewSvTagsContent;
@property (weak, nonatomic) IBOutlet UIView *viewTags;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcViewSvTagsContentWidth;
@property (weak, nonatomic) IBOutlet UILabel *lblTags;
@property (weak, nonatomic) IBOutlet UIView *viewMorePopup;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorites;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;

- (IBAction)doMore:(id)sender;
- (IBAction)doBack:(id)sender;
- (IBAction)doShowComments:(id)sender;
- (IBAction)doCloseMorePopup:(id)sender;
- (IBAction)doShare:(id)sender;
- (IBAction)doAbout:(id)sender;
- (IBAction)doSettings:(id)sender;
- (IBAction)doVisitBrowser:(id)sender;
- (IBAction)doSendFeedback:(id)sender;
- (IBAction)doRefreshArticle:(id)sender;
- (IBAction)doFavorites:(id)sender;

@end
