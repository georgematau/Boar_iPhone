//
//  SettingsViewController.m
//  Boar
//
//  Created by George Matau on 26/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import "SettingsViewController.h"

#define SLIDER_INCREMENT 10

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init
    self.previousStatusbarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.lcScrollViewWidth.constant = self.view.frame.size.width;
    [self.lblDefaultCategory setText:[NSString stringWithFormat:@"Default Category: %@", [[BModel sharedBModel] getDefaultCategoryFromStorage]]];
    [self.btnFullscreen setSelected:[[BModel sharedBModel] getFullscreenFromStorage]];
    [self.btnHighQuality setSelected:[[BModel sharedBModel] getSaveImagesFromStorage]];
    [self.lblVersion setText:[NSString stringWithFormat:@"Version: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]]];
    
    // Picker
    self.pickerData = [NSArray arrayWithObjects:@"Home", @"Money", @"Arts", @"Comment", @"Features", @"Sport", @"Games", @"Science & Tech", @"Books", @"Travel", @"TV", @"Lifestyle", @"Music", @"News", @"Film", nil];
    self.btnSelectPicker.layer.cornerRadius = 3;
    self.btnSelectPicker.clipsToBounds = YES;
    
    // Slider
    self.sliderCache.value = [[BModel sharedBModel] getCacheMaxSize] / 1000000;
    self.lblSliderValue.text = [NSString stringWithFormat:@"%d MB", (int)self.sliderCache.value];
    self.viewSliderPopup.clipsToBounds = YES;
    self.viewSliderPopup.layer.cornerRadius = 15;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods
-(void) animatePickerIn {
    [self.viewPicker setHidden:NO];
    [self.btnClosePicker setHidden:NO];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.btnClosePicker setHidden:NO];
//                         [self.btnClosePicker setBackgroundColor:[UIColor blackColor]];
                         [self.btnClosePicker setAlpha:0.35];
                         // Picker
                         [self.viewPicker setFrame:CGRectMake(0, self.view.frame.size.height - self.viewPicker.frame.size.height, self.viewPicker.frame.size.width, self.viewPicker.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) animatePickerOut {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
//                         [self.btnClosePicker setBackgroundColor:[UIColor clearColor]];
                         [self.btnClosePicker setAlpha:0];
                         // Picker
                         [self.viewPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.viewPicker.frame.size.width, self.viewPicker.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         [self.btnClosePicker setHidden:YES];
                         [self.viewPicker setHidden:YES];
                     }];
}

-(void) animateSliderIn {
    [self.viewSlider setHidden:NO];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.viewSlider setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) animateSliderOut {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.viewSlider setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [self.viewSlider setHidden:YES];
                     }];
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation newOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(newOrientation != self.currentOrientation) {
        // Setup 
        self.lcScrollViewWidth.constant = self.view.frame.size.width;
        
        // Set new orientation
        self.currentOrientation = newOrientation;
    }
}

#pragma mark - IBAction
- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doDefaultCategory:(id)sender {
    [self animatePickerIn];
}

- (IBAction)doFullscreen:(id)sender {
    if([self.btnFullscreen isSelected]) {
        // Unselect
        [self.btnFullscreen setSelected:NO];
        [[BModel sharedBModel] saveFullscreenToStorage:@"false"];
    } else {
        // Select
        [self.btnFullscreen setSelected:YES];
        [[BModel sharedBModel] saveFullscreenToStorage:@"true"];
    }
}

- (IBAction)doHighQuality:(id)sender {
    if([self.btnHighQuality isSelected]) {
        // Unselect
        [self.btnHighQuality setSelected:NO];
        [[BModel sharedBModel] saveSaveImagesToStorage:@"false"];
    } else {
        // Select
        [self.btnHighQuality setSelected:YES];
        [[BModel sharedBModel] saveSaveImagesToStorage:@"true"];
    }
}

- (IBAction)doCacheSize:(id)sender {
    [self animateSliderIn];
}

- (IBAction)doClearCache:(id)sender {
    BOOL toClear = [[BModel sharedBModel]clearAllAssets];
    if(!toClear) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear cache" message:@"There are no images stored in the cache!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    NSLog(@"cleared cache");
}

- (IBAction)doRateApp:(id)sender {
    NSString* url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@", @"1062445766"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (IBAction)doBuildVersion:(id)sender {
}

- (IBAction)doCredits:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"Developer:\nGeorge Matau" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Check website", nil];
    [alert show];
}

- (IBAction)doSelectPicker:(id)sender {
    NSString* category = [self.pickerData objectAtIndex:[self.picker selectedRowInComponent:0]];
    [self.lblDefaultCategory setText:[NSString stringWithFormat:@"Default Category: %@", category]];
    [self animatePickerOut];
    [[BModel sharedBModel]saveDefaultCategoryToStorage:category];
}

- (IBAction)doClosePicker:(id)sender {
    [self animatePickerOut];
}

- (IBAction)doCancelSlider:(id)sender {
    [self animateSliderOut];
}

- (IBAction)doSetSlider:(id)sender {
    int cacheSize = (int)self.sliderCache.value * 1000000;
    [[BModel sharedBModel] saveCacheMaxSize:cacheSize];
    [self animateSliderOut];
    NSLog(@"Cache size set at %d: ", cacheSize);
}

- (IBAction)doSliderValueChanged:(id)sender {
    [self.sliderCache setValue:((int)((self.sliderCache.value + SLIDER_INCREMENT / 2) / SLIDER_INCREMENT) * SLIDER_INCREMENT) animated:NO];
    [self.lblSliderValue setText:[NSString stringWithFormat:@"%d MB", (int)self.sliderCache.value]];
}

#pragma mark pickerView methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerData count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:@"Credits"]) {
        if(buttonIndex == 1) {
            NSString* url = [NSString stringWithFormat:@"http://www.visibletech.co.uk"];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
}


@end
