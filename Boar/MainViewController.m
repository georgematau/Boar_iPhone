//
//  ViewController.m
//  Boar
//
//  Created by George Matau on 17/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

# pragma mark - lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init
    self.section = [[BModel sharedBModel] getDefaultCategoryFromStorage];
    
    // Load content
    [self loadInitialContent];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePressNotification:) name:@"ItemPressed" object:nil];
    
    // Set-up Menu
    [self setupMenu];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Orientation configuration
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(orientationChanged:)
                                          name:UIDeviceOrientationDidChangeNotification
                                          object:nil];
    
    // Refresh if favorites
    if([self.section isEqualToString:@"Favorites"]) {
        self.data = [[BModel sharedBModel] getFavoritesFromStorage];
        [self.table reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

#pragma mark - class methods
- (void) loadInitialContent {
    if([BModel sharedBModel].fullData == nil) {
        // First run
        [BModel sharedBModel].fullData = [NSMutableDictionary new];
        if(![[BModel sharedBModel] isOnline]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KEY_NO_INTERNET message:MSG_NO_FEEDS delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        // Data already in local storage
        self.data = [[BModel sharedBModel].fullData objectForKey:self.section];
        [self.table reloadData];
    }
    
    // Get updated feed if online
    if([[BModel sharedBModel] isOnline]) {
        // Setup loader
        [self.ivLoaderBg setBackgroundColor:[[BModel sharedBModel] getColorForSection:self.section]];
        [self.viewLoader setHidden:NO];
        // Get data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadDataForSection:self.section];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
                [self.viewLoader setHidden:YES];
            });
        });
    }
}

- (void) setupMenu {
    self.categories = [NSArray arrayWithObjects:@"Home", @"Money", @"Arts", @"Comment", @"Features", @"Sport", @"Games", @"Science & Tech", @"Books", @"Travel", @"TV", @"Lifestyle", @"Music", @"News", @"Film", nil];
    self.ivMoney.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:1]];
    self.ivArts.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:2]];
    self.ivComment.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:3]];
    self.ivFeatures.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:4]];
    self.ivSport.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:5]];
    self.ivGames.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:6]];
    self.ivScience.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:7]];
    self.ivBooks.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:8]];
    self.ivTravel.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:9]];
    self.ivTV.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:10]];
    self.ivLifestyle.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:11]];
    self.ivMusic.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:12]];
    self.ivNews.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:13]];
    self.ivFilm.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:14]];
}

//- (void)showArticle:(NSDictionary*)article {
//    // Set content
//    [self.viewArticle setHidden:NO];
////    self.ivArticlePhoto.image = [self.imagesCache objectForKey:[article valueForKey:@"id"]];
//    [self.wvArticleContent loadHTMLString:[article valueForKey:@"content"] baseURL:nil];
//    // Set dimensions
//    [self setArticleDimensions];
//}
//
//- (void)setArticleDimensions {
//    CGRect rect = CGRectMake(0, 0, self.svArticleContent.frame.size.width, self.svArticleContent.frame.size.width/2);
//    self.ivArticlePhoto.frame = rect;
//    rect = CGRectMake(0, self.ivArticlePhoto.frame.size.height, self.ivArticlePhoto.frame.size.width, self.svArticleContent.frame.size.height);
//    self.wvArticleContent.frame = rect;
//    [self.svArticleContent setContentSize:CGSizeMake(self.ivArticlePhoto.frame.size.width, self.ivArticlePhoto.frame.size.height + self.wvArticleContent.frame.size.height)];
//}

- (void)loadDataForSection:(NSString *)aSection {
    // Get the URL from the section
    self.lastPage = 1;
    NSURL *linkUrl = [[BModel sharedBModel] getURLForSection:aSection andPage:self.lastPage];
    
    // Load from online
    // Check if online outside of this method
    NSString *htmlString = [NSString stringWithContentsOfURL:linkUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fullJson = [NSJSONSerialization JSONObjectWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    self.data = [fullJson objectForKey:@"posts"];
    
    // Remove miss patina
    if([self.section isEqualToString:@"Home"] && [[[self.data objectAtIndex:0] valueForKey:@"title"] isEqualToString:@"Miss Patina: Fashion fades, style is eternal"]) {
        NSMutableArray* arData = [self.data mutableCopy];
        [arData removeObjectAtIndex:0];
        self.data = arData;
    }
    
    
    // Save loaded data to local storage
    [[BModel sharedBModel].fullData setValue:self.data forKey:aSection];
    [[BModel sharedBModel] saveDataToStorage];
    
//    NSLog(@"Loaded and saved data: %@", self.data);
}

- (void)loadDataForSection:(NSString *)aSection andPage:(int)aPage{
    // Get the URL from the section
    self.lastPage = aPage;
    NSURL *linkUrl = [[BModel sharedBModel] getURLForSection:aSection andPage:aPage];
    
    // Load from online
    NSString *htmlString = [NSString stringWithContentsOfURL:linkUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fullJson = [NSJSONSerialization JSONObjectWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // Merge this content with contect from previous pages
    NSMutableArray* mergedData = [NSMutableArray arrayWithArray:self.data];
    [mergedData addObjectsFromArray:[fullJson objectForKey:@"posts"]];
    self.data = mergedData;
    
    // Remove miss patina
    if([self.section isEqualToString:@"Home"] && [[[self.data objectAtIndex:0] valueForKey:@"title"] isEqualToString:@"Miss Patina: Fashion fades, style is eternal"]) {
        NSMutableArray* arData = [self.data mutableCopy];
        [arData removeObjectAtIndex:0];
        self.data = arData;
    }
    
    // Save loaded data to local storage
    [[BModel sharedBModel].fullData setValue:self.data forKey:aSection];
    [[BModel sharedBModel] saveDataToStorage];
    
    NSLog(@"Loaded and saved data: %@", self.data);
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
        [self.table reloadData];
        
        // Set new orientation
        self.currentOrientation = newOrientation;
    }
}

#pragma mark - IBAction mothods
- (IBAction)showMenu:(id)sender {
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Black overlay
                         [self.btnBlackOverlay setHidden:FALSE];
                         [self.btnBlackOverlay setBackgroundColor:[UIColor blackColor]];
                         [self.btnBlackOverlay setAlpha:0.3];
                         // Menu
                         [self.viewMenu setHidden:FALSE];
                         [self.viewMenu setFrame:CGRectMake(0, 0, self.viewMenu.frame.size.width, self.viewMenu.frame.size.height)];
                         self.lcMenuOffset.constant = 0;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)closeMenu:(id)sender {
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Black overlay
                         [self.btnBlackOverlay setBackgroundColor:[UIColor blackColor]];
                         [self.btnBlackOverlay setAlpha:0];
                         // Menu
                         [self.viewMenu setFrame:CGRectMake(-self.viewMenu.frame.size.width, 0, self.viewMenu.frame.size.width, self.viewMenu.frame.size.height)];
                         self.lcMenuOffset.constant = -self.viewMenu.frame.size.width;
                     }
                     completion:^(BOOL finished){
                         [self.btnBlackOverlay setHidden:TRUE];
                     }];
}

- (IBAction)refreshFeed:(id)sender {
    if([[BModel sharedBModel] isOnline]) {
        [self.viewLoader setHidden:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadDataForSection:self.section];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
                [self.table setContentOffset:CGPointZero];
                [self.viewLoader setHidden:YES];
                [self animatePopupOut];
            });
        });
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KEY_NO_INTERNET message:MSG_NO_REFRESH delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)doMore:(id)sender {
    if(self.viewMorePopup.hidden == YES) {
        [self animatePopupIn];
    } else {
        [self animatePopupOut];
    }
}

- (IBAction)doSearch:(id)sender {
    [self performSegueWithIdentifier:@"showSearch" sender:nil];
}

- (IBAction)doFavorites:(id)sender {
    // Close menu
    [self closeMenu:sender];
    // Setup header
    self.ivTopOverlay.backgroundColor = [UIColor whiteColor];
    [self.lblTitle setImage:[UIImage imageNamed:@"the_boar_logo.png"]];
    [self.btnMenu setImage:[UIImage imageNamed:@"menu_black.png"] forState:UIControlStateNormal];
    [self.btnMore setImage:[UIImage imageNamed:@"more_black.png"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // Open favorites
    self.data = [[BModel sharedBModel] getFavoritesFromStorage];
    [self.table reloadData];
    self.section = @"Favorites";
    // Show message if no favorites
    if([self.data count] == 0) {
        [self.lblNoFavorites setText:MSG_NO_FAVORITES];
        [self.lblNoFavorites setHidden:NO];
    } else {
        [self.lblNoFavorites setHidden:YES];
    }
}

- (IBAction)doShowCategory:(id)sender {
    // Close menu
    [self closeMenu:sender];
    
    // Open category
    int tag = (int)[sender tag];
    if(![[self.categories objectAtIndex:tag] isEqualToString:self.section]) {
        // Setup header
        self.section = [self.categories objectAtIndex:tag];
        if([self.section isEqualToString:@"Home"]) {
            // White background, dark logo
            self.ivTopOverlay.backgroundColor = [UIColor whiteColor];
            [self.lblTitle setImage:[UIImage imageNamed:@"the_boar_logo.png"]];
            [self.btnMenu setImage:[UIImage imageNamed:@"menu_black.png"] forState:UIControlStateNormal];
            [self.btnMore setImage:[UIImage imageNamed:@"more_black.png"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            // Color background, white logo
            self.ivTopOverlay.backgroundColor = [[BModel sharedBModel]getColorForSection:self.section];
            [self.lblTitle setImage:[UIImage imageNamed:@"the_boar_logo_white.png"]];
            [self.btnMenu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
            [self.btnMore setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        
        // Load offline data
        self.data = [[BModel sharedBModel].fullData objectForKey:self.section];
        [self.table reloadData];
        [self.table setContentOffset:CGPointZero];
        
        // Load new data
        if([[BModel sharedBModel] isOnline]) {
            // Setup loader
            [self.ivLoaderBg setBackgroundColor:[[BModel sharedBModel] getColorForSection:self.section]];
            [self.viewLoader setHidden:NO];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self loadDataForSection:self.section];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.table reloadData];
                    [self.viewLoader setHidden:YES];
                    // Display alert if list is empty
                    if(self.data == nil) {
                        if([[BModel sharedBModel] isOnline]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KEY_NO_ARTICLES message:MSG_NO_ARTICLES_IN_SECTION delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        } else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KEY_NO_INTERNET message:MSG_NO_FEEDS delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        }
                        [self.lblNoFavorites setText:MSG_NO_ARTICLES_IN_SECTION];
                        [self.lblNoFavorites setHidden:NO];
                    } else {
                        [self.lblNoFavorites setHidden:YES];
                    }
                });
            });
        }
    }
}

- (IBAction)doCloseMorePopup:(id)sender {
    [self animatePopupOut];
}

- (IBAction)doAbout:(id)sender {
    [self performSegueWithIdentifier:@"showAbout" sender:nil];
}

- (IBAction)doSettings:(id)sender {
    [self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (IBAction)doVisitBrowser:(id)sender {
    if([self.section isEqualToString:@"Favorites"]) {
        
    } else {
        NSURL* urlWebsite = [[BModel sharedBModel] getWebsiteForSection:self.section];
        [[UIApplication sharedApplication] openURL:urlWebsite];
    }
}

- (IBAction)doSendFeedback:(id)sender {
    [self handleEmail:EMAIL_APP];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        int no = [self.data count];
        return (no/2) + (no%2);
    } else {
        return [self.data count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get row
    int row = [indexPath row];
    
    // Load next page if last row
    if(![self.section isEqualToString:@"Favorites"]) {
        if(row == [aTableView numberOfRowsInSection:[indexPath section]] - 1) {
            if([[BModel sharedBModel] isOnline]){
                // Setup loader
                [self.viewLoader setHidden:NO];
                // Get data
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self loadDataForSection:self.section andPage:(self.lastPage + 1)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.table reloadData];
                        [self.viewLoader setHidden:YES];
                    });
                });
            }
        }
    }
    
    // Get cell based on orientation
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        // Landscape
        // Create a cell if one is not already available
        FeedLandListCell *cell = (FeedLandListCell *)[aTableView dequeueReusableCellWithIdentifier:@"FeedLandListCell"];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedLandListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Set data
        NSDictionary *item1 = [self.data objectAtIndex:(row * 2)];
        NSDictionary *item2 = nil;
        if((row * 2 + 1) >= [self.data count]) {
        } else {
            item2 = [self.data objectAtIndex:(row * 2 + 1)];
        }
        [cell displayItem1:item1 andItem2:item2 onRow:row];
        
        return cell;
    } else {
        // Portrait
        // Create a cell if one is not already available
        FeedListCell *cell = (FeedListCell *)[aTableView dequeueReusableCellWithIdentifier:@"FeedListCell"];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Set data
        NSDictionary *item = [self.data objectAtIndex:row];
        [cell displayItem:item];

        return cell;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        // Landscape - do nothing
    } else {
        // Portrait
        [self performSelector:@selector(deselect:) withObject:aTableView afterDelay:0.2];
        // Get selected item
        int row = (int)[indexPath row];
        NSDictionary *item = [self.data objectAtIndex:row];
        
        // Open Article screen
        [self performSegueWithIdentifier:@"showArticle" sender:item];
    }
}

- (void)deselect:(UITableView *)aTableView {
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 300;
    } else {
        return 400;
    }
}

- (void)receivePressNotification: (NSNotification *) notification {
    // Get item pressed
    NSDictionary *userInfo = [notification userInfo];
    int index = [[userInfo valueForKey:@"index"] intValue];
    NSDictionary *item = [self.data objectAtIndex:index];
    
    // Open Article screen
    [self performSegueWithIdentifier:@"showArticle" sender:item];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showArticle"]) {
        ArticleViewController* avc = (ArticleViewController*)[segue destinationViewController];
        avc.dicArticle = sender;
    } else if([[segue identifier] isEqualToString:@"showSearch"]) {
        SearchViewController* svc = (SearchViewController*)[segue destinationViewController];
        svc.type = KEY_SEARCH;
    }
}

@end
