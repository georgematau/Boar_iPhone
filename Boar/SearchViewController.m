//
//  SearchViewController.m
//  Boar
//
//  Created by George Matau on 16/10/2015.
//  Copyright (c) 2015 Visible Tech. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

#pragma mark - lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePressNotification:) name:@"ItemPressed" object:nil];
    
    // Setup loader
    [self.ivLoaderBg setBackgroundColor:[UIColor grayColor]];
    
    // Setup status bar
    self.previousStatusbarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Setup for tag search
    if([self.type isEqualToString:KEY_TAG]) {
        // Update UI for tag view
        self.lcSearchBarHeight.constant = 0;
        [self.lblTitle setText:self.myTag];
        // Load data
        [self.viewLoader setHidden:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadDataForTag:self.myTag andPage:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.viewLoader setHidden:YES];
            });
        });
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
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusbarStyle];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - class methods
- (void)loadDataForSearchTerm:(NSString *)aSearchTerm andPage:(int)aPage{
    // Get the URL for the search
    self.lastPage = aPage;
    NSURL *linkUrl = [[BModel sharedBModel] getURLForSearchTerm:aSearchTerm andPage:aPage];
    
    // Load from online
    NSString *htmlString = [NSString stringWithContentsOfURL:linkUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fullJson = [NSJSONSerialization JSONObjectWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    if(aPage == 0) {
        // New search
        self.data = [fullJson objectForKey:@"posts"];
    } else {
        // Merge this content with contect from previous pages
        NSMutableArray* mergedData = [NSMutableArray arrayWithArray:self.data];
        [mergedData addObjectsFromArray:[fullJson objectForKey:@"posts"]];
        self.data = mergedData;
    }
    
    // Show empty table message
    if([self.data count] == 0) {
        [self.lblNoArticles setHidden:NO];
        [self.tableView setHidden:YES];
    } else {
        [self.lblNoArticles setHidden:YES];
        [self.tableView setHidden:NO];
    }
}

- (void)loadDataForTag:(NSString *)aTag andPage:(int)aPage{
    // Get the URL for the search
    self.lastPage = aPage;
    NSURL *linkUrl = [[BModel sharedBModel] getURLForTag:aTag andPage:aPage];
    
    // Load from online
    NSString *htmlString = [NSString stringWithContentsOfURL:linkUrl encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fullJson = [NSJSONSerialization JSONObjectWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    if(aPage == 0) {
        // New search
        self.data = [fullJson objectForKey:@"posts"];
    } else {
        // Merge this content with contect from previous pages
        NSMutableArray* mergedData = [NSMutableArray arrayWithArray:self.data];
        [mergedData addObjectsFromArray:[fullJson objectForKey:@"posts"]];
        self.data = mergedData;
    }
    
    // Show table because there is at least one item for each tag
    [self.lblNoArticles setHidden:YES];
    [self.tableView setHidden:NO];
}

#pragma mark - rotation methods
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation newOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(newOrientation != self.currentOrientation) {
        [self.tableView reloadData];
        
        // Set new orientation
        self.currentOrientation = newOrientation;
    }
}

#pragma mark - IBAction methods
- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if(row == [aTableView numberOfRowsInSection:[indexPath section]] - 1) {
        if([[BModel sharedBModel] isOnline]){
            // Setup loader
            [self.viewLoader setHidden:NO];
            // Get data
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if([self.type isEqualToString:KEY_SEARCH]) {
                    [self loadDataForSearchTerm:self.searchBar.text andPage:(self.lastPage + 1)];
                } else {
                    [self loadDataForTag:self.myTag andPage:(self.lastPage + 1)];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.viewLoader setHidden:YES];
                });
            });
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

#pragma mark - SearchBar methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Hide keyboard
    [self.searchBar endEditing:YES];
    // Empty table
    [self.viewLoader setHidden:NO];
    self.data = [NSArray new];
    [self.tableView reloadData];
    // Load data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadDataForSearchTerm:self.searchBar.text andPage:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.viewLoader setHidden:YES];
        });
    });
    NSLog(@"Search: %@", self.searchBar.text);
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showArticle"]) {
        ArticleViewController* avc = (ArticleViewController*)[segue destinationViewController];
        avc.dicArticle = sender;
    }
}

@end
