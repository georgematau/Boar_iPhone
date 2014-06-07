//
//  ViewController.h
//  Boar
//
//  Created by George Matau on 17/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BModel.h"
#import "FeedListCell.h"
#import "FeedLandListCell.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)showMenu:(id)sender;
- (IBAction)refreshFeed:(id)sender;
- (IBAction)closeMenu:(id)sender;
- (IBAction)closeArticle:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btnBlackOverlay;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
@property (weak, nonatomic) IBOutlet UIScrollView *svMenu;
@property (weak, nonatomic) IBOutlet UIView *viewArticle;
@property (weak, nonatomic) IBOutlet UIImageView *ivArticlePhoto;
@property (weak, nonatomic) IBOutlet UIWebView *wvArticleContent;
@property (weak, nonatomic) IBOutlet UIScrollView *svArticleContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopOverlay;


@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSMutableDictionary *imagesCache;
@property (nonatomic, strong) NSArray *categories;

@end
