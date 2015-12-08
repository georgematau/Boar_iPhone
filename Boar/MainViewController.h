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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArticleViewController.h"
#import "SearchViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

- (IBAction)showMenu:(id)sender;
- (IBAction)refreshFeed:(id)sender;
- (IBAction)closeMenu:(id)sender;
- (IBAction)doMore:(id)sender;
- (IBAction)doSearch:(id)sender;
- (IBAction)doFavorites:(id)sender;
- (IBAction)doShowCategory:(id)sender;
- (IBAction)doCloseMorePopup:(id)sender;
- (IBAction)doAbout:(id)sender;
- (IBAction)doSettings:(id)sender;
- (IBAction)doVisitBrowser:(id)sender;
- (IBAction)doSendFeedback:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btnBlackOverlay;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
@property (weak, nonatomic) IBOutlet UIScrollView *svMenu;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopOverlay;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIView *viewMenuSvHolder;
@property (weak, nonatomic) IBOutlet UIImageView *ivMoney;
@property (weak, nonatomic) IBOutlet UIImageView *ivArts;
@property (weak, nonatomic) IBOutlet UIImageView *ivComment;
@property (weak, nonatomic) IBOutlet UIImageView *ivFeatures;
@property (weak, nonatomic) IBOutlet UIImageView *ivSport;
@property (weak, nonatomic) IBOutlet UIImageView *ivGames;
@property (weak, nonatomic) IBOutlet UIImageView *ivScience;
@property (weak, nonatomic) IBOutlet UIImageView *ivBooks;
@property (weak, nonatomic) IBOutlet UIImageView *ivTravel;
@property (weak, nonatomic) IBOutlet UIImageView *ivTV;
@property (weak, nonatomic) IBOutlet UIImageView *ivLifestyle;
@property (weak, nonatomic) IBOutlet UIImageView *ivMusic;
@property (weak, nonatomic) IBOutlet UIImageView *ivNews;
@property (weak, nonatomic) IBOutlet UIImageView *ivFilm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcMenuOffset;
@property (weak, nonatomic) IBOutlet UIView *viewMorePopup;
@property (weak, nonatomic) IBOutlet UIView *viewHomePopup;
@property (weak, nonatomic) IBOutlet UIView *viewLoader;
@property (weak, nonatomic) IBOutlet UIImageView *ivLoaderBg;
@property (weak, nonatomic) IBOutlet UILabel *lblNoFavorites;


@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic) int lastPage;
@property (nonatomic) UIInterfaceOrientation currentOrientation;

@end
