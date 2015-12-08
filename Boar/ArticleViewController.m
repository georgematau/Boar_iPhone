//
//  ArticleViewController.m
//  Boar
//
//  Created by George Matau on 23/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import "ArticleViewController.h"

#define kArticlePhotoHeight 200
#define kTopOffset 60
#define kCommentsDefaultHeight 30

@interface ArticleViewController ()

@end

@implementation ArticleViewController

#pragma mark - lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get category and setup navbar
    self.category = [[BModel sharedBModel] changeSpecialCharacters:[[BModel sharedBModel] getCategoryFromList:[self.dicArticle objectForKey:@"categories"]]];
    [self.ivHeaderBg setBackgroundColor:[[BModel sharedBModel] getColorForSection:self.category]];
    self.previousStatusbarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.isHeaderVisible = YES;
    
    // Setup article
    [self setupArticleDetails];
    
    // Setup scrollview sizes
    [self setScrollViewSizes];
    
    // Check if favorite
    NSMutableArray* arFavorites = [[BModel sharedBModel] getFavoritesFromStorage];
    if([arFavorites containsObject:self.dicArticle]) {
        [self.btnFavorites setSelected:YES];
    }
    
    // Save image if set to save and online
    if([[BModel sharedBModel] shouldSaveImage] && [[BModel sharedBModel].imagesCache objectForKey:[self.dicArticle objectForKey:@"id"]] != nil) {
        NSMutableDictionary* dicAssets = [[BModel sharedBModel] getStoredImageAssets];
        if([dicAssets objectForKey:[self.dicArticle objectForKey:@"id"]] == nil) {
            // Save image if not already saved
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[BModel sharedBModel]saveImage:[[BModel sharedBModel].imagesCache objectForKey:[self.dicArticle objectForKey:@"id"]] withDetails:self.dicArticle];
            });
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Orientation configuration
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusbarStyle];
}

- (void)viewDidUnload {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - class methods
- (void)setScrollViewSizes {
    self.lcParalaxWidth.constant = self.view.frame.size.width;
    self.lcSvContentWidth.constant = self.view.frame.size.width;
}

- (void)setupArticleDetails {
    // Header
    [self setupArticleHeader];
    
    // Categories & Comments
    [self setupCategoriesComments];
    
    // Tags
    [self setupTags];
    
    // Webview
    [self.wvContent setHidden:YES];
    self.htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>body { font: 11pt 'Arial'; color: #555555; }</style></head><body>%@</body></html>", [self.dicArticle valueForKey:@"content"]];
    [self.wvContent loadHTMLString:self.htmlString baseURL:nil];
    
    NSLog(@"Showing article: %@", self.dicArticle);
}

- (void)setupArticleHeader {
    // Article photo
    [self.ivArticleImage setImage:[[BModel sharedBModel].imagesCache objectForKey:[self.dicArticle objectForKey:@"id"]]];
    
    // Article header
    [self.ivArticleHeaderBg setBackgroundColor:[[BModel sharedBModel] getColorForSection:self.category]];
    [self.lblArticleTitle setText:[[BModel sharedBModel] changeSpecialCharacters:[self.dicArticle objectForKey:@"title"]]];
    [self.lblArticleAutor setText:[NSString stringWithFormat:@"by %@", [[self.dicArticle objectForKey:@"author"] objectForKey:@"name"]]];
    
    // Article date
    NSString *str = [self.dicArticle valueForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    [formatter setDateFormat:@"EEE, dd MMM yyyy"];
    [self.lblArticleDate setText:[formatter stringFromDate:date]];
}

- (void) setupCategoriesComments {
    // Categories
    NSMutableString* strCategories = [[[[self.dicArticle objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"title"] mutableCopy];
    for(NSDictionary* dicCategory in [self.dicArticle objectForKey:@"categories"]) {
        NSString* strCategory = [dicCategory objectForKey:@"title"];
        if(![strCategory isEqualToString:[[[self.dicArticle objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"title"]]) {
            [strCategories appendString:[NSString stringWithFormat:@", %@", strCategory]];
        }
    }
    [self.lblCategory setText:strCategories];
    
    // Comments
    NSUInteger noComments = [[self.dicArticle objectForKey:@"comments"] count];
    [self.lblComments setText:[NSString stringWithFormat:@"%lu Comments", (unsigned long)noComments]];
    if(noComments == 0) {
        // No comment
        [self.lblNoComments setHidden:NO];
        self.lcViewCommentsListHeight.constant = 50;
    } else {
        // Display array of comments
        int yLastComment = 0;
        [self.lblNoComments setHidden:YES];
        NSArray* arComments = [self.dicArticle objectForKey:@"comments"];
        for(NSDictionary* dicComment in arComments) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil];
            CommentView* cv = [nib objectAtIndex:0];
            int height = [cv setupComment:dicComment];
            [cv setFrame:CGRectMake(0, yLastComment, self.view.frame.size.width, height)];
            [self.viewCommentsList addSubview:cv];
            yLastComment += height;
        }
        self.lcViewCommentsListHeight.constant = yLastComment + 20;
    }
}

- (void) setupTags {
    NSArray* arTags = [self.dicArticle objectForKey:@"tags"];
    int xLastTag = 0;
    for(NSDictionary* dicTag in arTags) {
        // Create button for each tag
        NSString* strTag = [dicTag objectForKey:@"slug"];
        UIButton* btnTag = [[UIButton alloc]initWithFrame:CGRectMake(xLastTag, 0, 10, 20)];
        btnTag.titleLabel.font = [UIFont systemFontOfSize: 12];
        [btnTag setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        [btnTag setTitle:strTag forState:UIControlStateNormal];
        [btnTag setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnTag setFrame:CGRectMake(xLastTag, 0, [btnTag intrinsicContentSize].width + 5, 20)];
        [btnTag setBackgroundColor:[[BModel sharedBModel] colorFromHexString:COLOR_LIGHT_GREY_BG]];
        [btnTag addTarget:self action:@selector(doTagPress:) forControlEvents:UIControlEventTouchUpInside];
        // Add tag and increase sv width
        [self.viewSvTagsContent addSubview:btnTag];
        xLastTag += btnTag.frame.size.width + 5;
    }
    self.lcViewSvTagsContentWidth.constant = xLastTag;
}

- (void)setupArticleConstraints {
    self.lcSvContentHeight.constant = self.wvContent.frame.origin.y + self.lcWebViewHeight.constant + self.lcViewCommentsHeight.constant + self.viewTags.frame.size.height;
}

- (void)doTagPress:(UIButton*) aButton {
    NSString* strTag = [[aButton titleLabel]text];
    [self performSegueWithIdentifier:@"showTag" sender:strTag];
}

- (void)animatePopupIn {
    [self.viewMorePopup setHidden:NO];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.viewMorePopup setAlpha:1];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)animatePopupOut {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.viewMorePopup setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [self.viewMorePopup setHidden:YES];
                     }];
}

- (void)animateHeaderIn {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.viewHeader setFrame:CGRectMake(self.viewHeader.frame.origin.x, 0, self.viewHeader.frame.size.width, self.viewHeader.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         self.isHeaderVisible = YES;
                     }];
}

- (void)animateHeaderOut {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.viewHeader setFrame:CGRectMake(self.viewHeader.frame.origin.x, -60, self.viewHeader.frame.size.width, self.viewHeader.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         self.isHeaderVisible = NO;
                     }];
}

- (void) handleEmail:(NSString*)eAddress {
    // Mail
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setMailComposeDelegate:self];
        
        // Set title
        [picker setSubject:@"App Feedback - iOS"];
        
        // Set recipients
        [picker setToRecipients:[NSArray arrayWithObject:eAddress]];
        
        // Set body
        NSString *emailBody = [NSString stringWithFormat:@"Bug(s) I found:\n\n\nThings I like/dislike:\n\n\nOther Comments:\n\n\n- - - - - Device Info - - - - -\nDevice: %@\niOS Version: %@", [[BModel sharedBModel] getModel], [[BModel sharedBModel] getIOSVersion]];
        [picker setMessageBody:emailBody isHTML:NO];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No email account" message:@"You do not have an active email account!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - rotation methods
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation newOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(newOrientation != self.currentOrientation) {
        // Resize constraints
        [self setScrollViewSizes];
        
        // Reload webview to fit new size
        self.lcWebViewHeight.constant = 100; // not sure why but this has to be set really small to allow webview to get correct content size
        [self.wvContent loadHTMLString:self.htmlString baseURL:nil];
        
        // Set new orientation
        self.currentOrientation = newOrientation;
    }
}

#pragma mark - IBAction methods
- (IBAction)doMore:(id)sender {
    if(self.viewMorePopup.hidden == YES) {
        [self animatePopupIn];
    } else {
        [self animatePopupOut];
    }
}

- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doShowComments:(id)sender {
    if([self.viewCommentsList isHidden]) {
        // Show
        [self.viewCommentsList setHidden:NO];
        self.lcViewCommentsHeight.constant = kCommentsDefaultHeight + self.lcViewCommentsListHeight.constant;
    } else {
        // Hide
        [self.viewCommentsList setHidden:YES];
        self.lcViewCommentsHeight.constant = kCommentsDefaultHeight;
    }
    
    [self setupArticleConstraints];
}

- (IBAction)doCloseMorePopup:(id)sender {
    [self animatePopupOut];
}

- (IBAction)doShare:(id)sender {
    NSArray* sharingItems = [NSArray arrayWithObjects:[self.dicArticle objectForKey:@"url"], nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)doAbout:(id)sender {
    [self performSegueWithIdentifier:@"showAbout" sender:nil];
}

- (IBAction)doSettings:(id)sender {
    [self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (IBAction)doVisitBrowser:(id)sender {
    NSURL* urlWebsite = [NSURL URLWithString:[self.dicArticle objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:urlWebsite];
}

- (IBAction)doSendFeedback:(id)sender {
    [self handleEmail:EMAIL_APP];
}

- (IBAction)doRefreshArticle:(id)sender {
    // Setup article
    [self setupArticleDetails];
    
    // Setup scrollview sizes
    [self setScrollViewSizes];
}

- (IBAction)doFavorites:(id)sender {
    if([self.btnFavorites isSelected]) {
        // Mark not favorite
        [self.btnFavorites setSelected:NO];
        NSMutableArray* arFavorites = [[BModel sharedBModel] getFavoritesFromStorage];
        [arFavorites removeObject:self.dicArticle];
        [[BModel sharedBModel]saveFavoritesToStorage:arFavorites];
    } else {
        // Mark favorite
        [self.btnFavorites setSelected:YES];
        NSMutableArray* arFavorites = [[BModel sharedBModel] getFavoritesFromStorage];
        [arFavorites addObject:self.dicArticle];
        [[BModel sharedBModel]saveFavoritesToStorage:arFavorites];
    }
}

#pragma mark - ScrollView methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get percentage moved for content scrollview
    CGFloat detailMaxOffset = self.svContent.contentSize.height - (kArticlePhotoHeight + kTopOffset);
    CGFloat percentage = self.svContent.contentOffset.y / detailMaxOffset;
    
    // Set offset of paralax view
    if(percentage >= 0) {
        // Scroll paralax view
//        [self.svParalax setContentOffset:CGPointMake(0, percentage * (kArticlePhotoHeight + kTopOffset))];
        [self.svParalax setContentOffset:CGPointMake(0, self.svContent.contentOffset.y / 2)]; // stronger paralax
        [self.ivArticleImage setFrame:CGRectMake(0, kTopOffset, self.view.frame.size.width, kArticlePhotoHeight)];
    } else {
        // Enlarge top image
        [self.svParalax setContentOffset:CGPointMake(0, 0)];
        CGFloat contentOffset = self.svContent.contentOffset.y;
        CGRect zoomRect = CGRectMake(contentOffset, kTopOffset, self.view.frame.size.width - 2 * contentOffset, kArticlePhotoHeight - 2 * contentOffset);
        [self.ivArticleImage setFrame:zoomRect];
    }
    
    // Decide if to hide/show header
    if([[BModel sharedBModel] getFullscreenFromStorage]) {
        if(self.svContent.contentOffset.y > 260) {
            // Should hide header
            if(self.isHeaderVisible == YES) {
                [self animateHeaderOut];
            }
        } else {
            // Should show header
            if(self.isHeaderVisible == NO) {
                [self animateHeaderIn];
            }
        }
    }
    
//    NSLog(@"ScrollView moved at offset: %f of total: %f and percentage: %f", self.svContent.contentOffset.y, self.svContent.contentSize.height, percentage);
    
}

#pragma mark - WebView methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Resize webview
    CGSize contentSize = webView.scrollView.contentSize;
    self.lcWebViewHeight.constant = contentSize.height;
    [self setupArticleConstraints];
    [self.wvContent setHidden:NO];
    
    NSLog(@"Webview content size: %f x %f", contentSize.width, contentSize.height);
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showTag"]) {
        SearchViewController* svc = (SearchViewController*)[segue destinationViewController];
        svc.type = KEY_TAG;
        svc.myTag = sender;
    }
}

@end
