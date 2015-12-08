//
//  SettingsViewController.h
//  Boar
//
//  Created by George Matau on 26/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BModel.h"

@interface SettingsViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic) UIInterfaceOrientation currentOrientation;
@property (nonatomic) UIStatusBarStyle previousStatusbarStyle;
@property (strong, nonatomic) NSArray *pickerData;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcScrollViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *lblDefaultCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnHighQuality;
@property (weak, nonatomic) IBOutlet UIButton *btnFullscreen;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnClosePicker;
@property (weak, nonatomic) IBOutlet UISlider *sliderCache;
@property (weak, nonatomic) IBOutlet UILabel *lblSliderValue;
@property (weak, nonatomic) IBOutlet UIView *viewSlider;
@property (weak, nonatomic) IBOutlet UIView *viewSliderPopup;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

- (IBAction)doBack:(id)sender;
- (IBAction)doDefaultCategory:(id)sender;
- (IBAction)doFullscreen:(id)sender;
- (IBAction)doHighQuality:(id)sender;
- (IBAction)doCacheSize:(id)sender;
- (IBAction)doClearCache:(id)sender;
- (IBAction)doRateApp:(id)sender;
- (IBAction)doBuildVersion:(id)sender;
- (IBAction)doCredits:(id)sender;
- (IBAction)doSelectPicker:(id)sender;
- (IBAction)doClosePicker:(id)sender;
- (IBAction)doCancelSlider:(id)sender;
- (IBAction)doSetSlider:(id)sender;
- (IBAction)doSliderValueChanged:(id)sender;

@end
