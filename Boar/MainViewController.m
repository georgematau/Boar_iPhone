//
//  ViewController.m
//  Boar
//
//  Created by George Matau on 17/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import "MainViewController.h"

#define MENU_ITEM_HEIGHT 40
#define MENU_ITEM_NO 16

@interface MainViewController ()

@end

@implementation MainViewController

- (NSString*)changeSpecialCharacters: (NSString*) foo {
    foo = [foo stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8211;" withString:@":"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8216;" withString:@"'"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8218;" withString:@","];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8220;" withString:@"\""];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8221;" withString:@"\""];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8222;" withString:@",,"];
    return foo;
}

- (void)showArticle:(NSDictionary*)article {
    // Set content
    [self.viewArticle setHidden:NO];
    self.ivArticlePhoto.image = [self.imagesCache objectForKey:[article valueForKey:@"id"]];
    [self.wvArticleContent loadHTMLString:[article valueForKey:@"content"] baseURL:nil];
    // Set dimensions
    [self setArticleDimensions];
}

- (void)setArticleDimensions {
    CGRect rect = CGRectMake(0, 0, self.svArticleContent.frame.size.width, self.svArticleContent.frame.size.width/2);
    self.ivArticlePhoto.frame = rect;
    rect = CGRectMake(0, self.ivArticlePhoto.frame.size.height, self.ivArticlePhoto.frame.size.width, self.svArticleContent.frame.size.height);
    self.wvArticleContent.frame = rect;
    [self.svArticleContent setContentSize:CGSizeMake(self.ivArticlePhoto.frame.size.width, self.ivArticlePhoto.frame.size.height + self.wvArticleContent.frame.size.height)];
}

- (void)loadDataForSection:(NSString *)aSection {
    // Get the URL from the singleton
    NSURL *linkUrl = [[BModel sharedBModel] getURLForSection:aSection];
    
    // Load from online
    // Check if online outside of this method
    NSString *htmlString = [NSString stringWithContentsOfURL:linkUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fullJson = [NSJSONSerialization JSONObjectWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    self.data = [fullJson objectForKey:@"posts"];

//    // Used to test odd number of headlines
//    NSMutableArray* mutda = [self.data mutableCopy];
//    [mutda removeLastObject];
//    self.data = mutda;

    
    // Save loaded data to local storage
    [[BModel sharedBModel].fullData setValue:self.data forKey:aSection];
    [[BModel sharedBModel] saveDataToStorage];
    
//    NSLog([self.data description]);
}

# pragma mark lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.section = @"Home";
//    self.imagesCache =  [[NSUserDefaults standardUserDefaults] objectForKey:@"boarPhotos"];
//    if(self.imagesCache == nil){
//        self.imagesCache = [NSMutableDictionary new];
//    }
    self.imagesCache = [NSMutableDictionary new];
    
    // Load content
    if([BModel sharedBModel].fullData == nil) {
        // first run
        [BModel sharedBModel].fullData = [NSMutableDictionary new];
        if([[BModel sharedBModel] isOnline]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self loadDataForSection:@"Home"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.table reloadData];
                });
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NO_FEEDS delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        // data already in local storage
        self.data = [[BModel sharedBModel].fullData objectForKey:@"Home"];
        if([[BModel sharedBModel] isOnline]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self loadDataForSection:@"Home"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.table reloadData];
                });
            });
        }
    }
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePressNotification:) name:@"ItemPressed" object:nil];
    
    // Set-up Menu
    self.categories = [NSArray arrayWithObjects:@"Home", @"News", @"Comment", @"Features", @"Lifestyle", @"Money", @"Art", @"Books", @"Film", @"Games", @"Music", @"Science & Tech", @"Travel", @"TV", @"Sport", @"Photography", nil];
    for(int i=0; i<16; i++) {
        // Text buttons
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:[self.categories objectAtIndex:i] forState:UIControlStateNormal];
        [but setFrame:CGRectMake(20, MENU_ITEM_HEIGHT * (i+1), 150, 20)];
        but.titleLabel.textColor = [UIColor whiteColor];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        but.tag = i;
        [but addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.svMenu addSubview:but];
        
        // Color buttons
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setFrame:CGRectMake(5, MENU_ITEM_HEIGHT * (i+1), 5, 20)];
        but.backgroundColor = [[BModel sharedBModel] getColorForSection:[self.categories objectAtIndex:i]];
        but.tag = i;
        [but addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.svMenu addSubview:but];
        
        // Separator lines
        UIImageView *ivLine = [UIImageView new];
        [ivLine setFrame:CGRectMake(5, MENU_ITEM_HEIGHT * (i+2) - 10, 190, 1)];
        [ivLine setBackgroundColor:[UIColor darkGrayColor]];
        [self.svMenu addSubview:ivLine];
    }
    self.svMenu.contentSize = CGSizeMake(self.viewMenu.frame.size.width, 20*2 + MENU_ITEM_HEIGHT*MENU_ITEM_NO);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Orientation configuration
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(orientationChanged:)
                                          name:UIDeviceOrientationDidChangeNotification
                                          object:nil];
}

#pragma mark rotation methods
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        // To landscape
        if(IS_IPHONE5) {
            // Title
            CGRect newPos = CGRectMake(90 + LAND_IPHONE5_DIF/2,  self.lblTitle.frame.origin.y,  self.lblTitle.frame.size.width,  self.lblTitle.frame.size.height);
            self.lblTitle.frame = newPos;
            // List
            newPos = CGRectMake(5 + LAND_DIF_5_4S/2, 42, 470, self.table.frame.size.height);
            self.table.frame = newPos;
        } else {
            // Title
            CGRect newPos = CGRectMake(90 + LAND_IPHONE_DIF/2,  self.lblTitle.frame.origin.y,  self.lblTitle.frame.size.width,  self.lblTitle.frame.size.height);
            self.lblTitle.frame = newPos;
            // List
            newPos = CGRectMake(5, 42, 470, self.table.frame.size.height);
            self.table.frame = newPos;
        }
    }
    else {
        // To portrait
        if(IS_IPHONE5) {
            // Title
            CGRect newPos = CGRectMake(90,  self.lblTitle.frame.origin.y,  self.lblTitle.frame.size.width,  self.lblTitle.frame.size.height);
            self.lblTitle.frame = newPos;
            // List
            newPos = CGRectMake(10, 42, 300, self.table.frame.size.height);
            self.table.frame = newPos;
        } else {
            // Title
            CGRect newPos = CGRectMake(90,  self.lblTitle.frame.origin.y,  self.lblTitle.frame.size.width,  self.lblTitle.frame.size.height);
            self.lblTitle.frame = newPos;
            // List
            newPos = CGRectMake(10, 42, 300, self.table.frame.size.height);
            self.table.frame = newPos;
        }
    }
    [self setArticleDimensions];
    [self.table reloadData];
}

#pragma mark IBAction mothods
- (void) selectedCategory:(id) sender {
    int tag = [(UIButton*)sender tag];
    [self closeMenu:sender];
    // Refresh data
    if(![[self.categories objectAtIndex:tag] isEqualToString:self.section]) {
        // Emplty table and show indicator
        self.data = nil;
        [self.table reloadData];
        self.section = [self.categories objectAtIndex:tag];
        self.activityIndicator.frame = CGRectMake(self.viewArticle.frame.size.width/2-10, self.viewArticle.frame.size.height/2-10, 20, 20);
        [self.activityIndicator setHidden:NO];
        // Load new data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.data = [[BModel sharedBModel].fullData objectForKey:self.section];
            if([[BModel sharedBModel] isOnline]) {
                [self loadDataForSection:self.section];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
                [self.activityIndicator setHidden:YES];
                // Display alert if list is empty
                if(self.data == nil) {
                    if([[BModel sharedBModel] isOnline]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NO_ARTICLES_IN_SECTION delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NO_FEEDS delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
            });
        });
        if([self.section isEqualToString:@"Home"] || [self.section isEqualToString:@"Art"] || [self.section isEqualToString:@"Photography"]) {
            self.ivTopOverlay.backgroundColor = [UIColor clearColor];
        } else {
            self.ivTopOverlay.backgroundColor = [[BModel sharedBModel]getColorForSection:self.section];
        }
    }
}

- (IBAction)showMenu:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Black overlay
                         [self.btnBlackOverlay setHidden:FALSE];
                         [self.btnBlackOverlay setBackgroundColor:[UIColor blackColor]];
                         [self.btnBlackOverlay setAlpha:0.7];
                         // Menu
                         [self.viewMenu setHidden:FALSE];
                         [self.viewMenu setFrame:CGRectMake(0, 0, self.viewMenu.frame.size.width, self.viewMenu.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)refreshFeed:(id)sender {
    if([[BModel sharedBModel] isOnline]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadDataForSection:self.section];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
        });
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NO_REFRESH delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)closeMenu:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.btnBlackOverlay setBackgroundColor:[UIColor clearColor]];
                         [self.btnBlackOverlay setAlpha:1];
                         // Menu
                         [self.viewMenu setFrame:CGRectMake(-200, 0, self.viewMenu.frame.size.width, self.viewMenu.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         [self.btnBlackOverlay setHidden:TRUE];
                     }];
}

- (IBAction)closeArticle:(id)sender {
    [self.viewArticle setHidden:YES];
}

#pragma mark UITableViewDelegate & UITableViewDataSource methods
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
            [cell.view2 setHidden:YES];
        } else {
            item2 = [self.data objectAtIndex:(row * 2 + 1)];
            [cell.view2 setHidden:NO];
        }
        cell.view1.tag = row * 2;
        cell.lblTitle1.text = [self changeSpecialCharacters:[item1 valueForKey:@"title"]];
        cell.lblAuthor1.text = [NSString stringWithFormat:@"by %@", [[item1 objectForKey:@"author"] valueForKey:@"name"]];
        cell.lblCategory1.text = [[[item1 objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"];
        cell.view2.tag = row * 2 + 1;
        cell.lblTitle2.text = [self changeSpecialCharacters:[item2 valueForKey:@"title"]];
        cell.lblAuthor2.text = [NSString stringWithFormat:@"by %@", [[item2 objectForKey:@"author"] valueForKey:@"name"]];
        cell.lblCategory2.text = [[[item2 objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"];
        // Date
        NSString *str1 = [item1 valueForKey:@"date"];
        NSString *str2 = [item2 valueForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date1 = [formatter dateFromString:str1];
        NSDate *date2 = [formatter dateFromString:str2];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        cell.lblDate1.text = [formatter stringFromDate:date1];
        cell.lblDate2.text = [formatter stringFromDate:date2];
        // Images
        for(int i=0; i<2; i++) {
            UIImageView* ivPhoto;
            NSDictionary* item;
            if(i==0) {
                ivPhoto = cell.ivPhoto1;
                item = item1;
            } else {
                ivPhoto = cell.ivPhoto2;
                item = item2;
            }
            if(item != nil) {
                UIImage *photo = [self.imagesCache objectForKey:[item valueForKey:@"id"]];
                if(photo == nil) {
                    // Not in cache so download and scale
                    [ivPhoto setImage:nil];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // Get and resize image
                        int pWidth = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"width"]intValue];
                        int pHeight = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"height"]intValue];
                        if(pHeight <= 0) {
                            pHeight = pWidth/2;
                        }
                        float pRatio = pWidth/pHeight;
                        float pScale = 1;
                        if(pRatio > (ivPhoto.frame.size.width/ivPhoto.frame.size.height)) {
                            // Scale by height
                            if(ivPhoto.frame.size.height < pHeight) {
                                pScale = pHeight/ivPhoto.frame.size.height;
                            }
                        } else {
                            // Scale by width
                            if(ivPhoto.frame.size.width < pWidth) {
                                pScale = pWidth/ivPhoto.frame.size.width;
                            }
                        }
                        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"url"]]]scale:pScale];
                        [self.imagesCache setValue:img forKey:[item valueForKey:@"id"]];
                        //            [[NSUserDefaults standardUserDefaults]setValue:self.imagesCache forKey:@"boarPhotos"];
                        // Display image
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ivPhoto setImage:img];
                        });
                    });
                } else {
                    // Take from cache
                    [ivPhoto setImage:photo];
                }
            }
        }
        cell.ivCategory1.backgroundColor = [[BModel sharedBModel] getColorForSection:[[[item1 objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"]];
        cell.ivCategory2.backgroundColor = [[BModel sharedBModel] getColorForSection:[[[item2 objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"]];
        
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
        cell.lblTitle.text = [self changeSpecialCharacters:[item valueForKey:@"title"]];
        cell.lblAuthor.text = [NSString stringWithFormat:@"by %@", [[item objectForKey:@"author"] valueForKey:@"name"]];
        cell.lblCategory.text = [self changeSpecialCharacters:[[[item objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"]];
        if([cell.lblCategory.text isEqualToString:@"Science & Tech"]) cell.lblCategory.text = @"Science";
        // Date
        NSString *str = [item valueForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:str];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        cell.lblDate.text = [formatter stringFromDate:date];
        // Images
        UIImage *photo = [self.imagesCache objectForKey:[item valueForKey:@"id"]];
        if(photo == nil) {
            // Not in cache so download and scale
            [cell.ivPhoto setImage:nil];
            if([[item objectForKey:@"thumbnail_images"] isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // Get and resize image
                    int pWidth = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"width"]intValue];
                    int pHeight = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"height"]intValue];
                    if(pHeight <= 0) {
                        pHeight = pWidth/2;
                        if(pHeight <= 0) pHeight = 1;
                    }
                    float pRatio = pWidth/pHeight;
                    float pScale = 1;
                    if(pRatio > (cell.ivPhoto.frame.size.width/cell.ivPhoto.frame.size.height)) {
                        // Scale by height
                        if(cell.ivPhoto.frame.size.height < pHeight) {
                            pScale = pHeight/cell.ivPhoto.frame.size.height;
                        }
                    } else {
                        // Scale by width
                        if(cell.ivPhoto.frame.size.width < pWidth) {
                            pScale = pWidth/cell.ivPhoto.frame.size.width;
                        }
                    }
                    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[item objectForKey:@"thumbnail_images"] objectForKey:@"full"] valueForKey:@"url"]]]scale:pScale];
                    [self.imagesCache setValue:img forKey:[item valueForKey:@"id"]];
                    //            [[NSUserDefaults standardUserDefaults]setValue:self.imagesCache forKey:@"boarPhotos"];
                    // Display image
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.ivPhoto setImage:img];
                    });
                });
            }
        } else {
            // Take from cache
            [cell.ivPhoto setImage:photo];
        }
        cell.ivCategory.backgroundColor = [[BModel sharedBModel] getColorForSection:[[[item objectForKey:@"categories"] objectAtIndex:0]valueForKey:@"title"]];
        
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
        int row = [indexPath row];
        NSDictionary *item = [self.data objectAtIndex:row];
        [self showArticle:item];
        
        NSLog([item description]);
    }
}

- (void)deselect:(UITableView *)aTableView {
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 215;
    } else {
        return 250;
    }
}

- (void)receivePressNotification: (NSNotification *) notification {
    NSDictionary *userInfo = [notification userInfo];
    int index = [[userInfo valueForKey:@"index"] intValue];
    NSDictionary *item = [self.data objectAtIndex:index];
    [self showArticle:item];
    
//    NSLog([item description]);
}
@end
