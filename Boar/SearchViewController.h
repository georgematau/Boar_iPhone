//
//  SearchViewController.h
//  Boar
//
//  Created by George Matau on 16/10/2015.
//  Copyright (c) 2015 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedListCell.h"
#import "FeedLandListCell.h"
#import "ArticleViewController.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic) int lastPage;
@property (nonatomic) UIInterfaceOrientation currentOrientation;
@property (nonatomic) UIStatusBarStyle previousStatusbarStyle;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* myTag;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewLoader;
@property (weak, nonatomic) IBOutlet UIImageView *ivLoaderBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcSearchBarHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoArticles;

- (IBAction)doBack:(id)sender;

@end
