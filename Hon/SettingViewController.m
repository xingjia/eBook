//
//  SettingViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 21/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"夜間モード";
        case 1:
            return @"画面の明る";
        case 2:
            return @"文字サイズ";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if( aCell == nil )
        aCell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] ;
    switch(indexPath.section){
        case 0:{
            aCell.textLabel.text = @"夜間モードの設定";
            aCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            aCell.accessoryView = switchView;
            [switchView setOn: [[self.defaults objectForKey:@"nightMode"] boolValue] animated:NO];
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            break;}
        case 1:{
            //aCell.textLabel.text = @"Screen Brightness";
            aCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISlider *brightnessSlider = [[UISlider alloc] init];
            brightnessSlider.bounds = CGRectMake(aCell.contentView.bounds.origin.x+10,aCell.contentView.bounds.origin.y, aCell.contentView.bounds.size.width-20, aCell.contentView.bounds.size.height);
            brightnessSlider.center = CGPointMake(CGRectGetMidX(aCell.contentView.bounds), CGRectGetMidY(aCell.contentView.bounds));
            brightnessSlider.minimumValue = 2;
            brightnessSlider.maximumValue = 10;
            brightnessSlider.continuous = YES;
            [brightnessSlider setValue:0 animated:YES];
            [brightnessSlider addTarget:self action:@selector(sliderChanged:)
                       forControlEvents:UIControlEventValueChanged];
            [aCell addSubview:brightnessSlider];
            break;
        }
        case 2:{
            NSArray *fontArray = [NSArray arrayWithObjects: @"小", @"中", @"大", nil];
            UISegmentedControl *fontControl = [[UISegmentedControl alloc] initWithItems:fontArray];
            fontControl.frame = CGRectMake(aCell.frame.origin.x+10, aCell.frame.origin.y+5, aCell.frame.size.width-20, aCell.frame.size.height-10);
            fontControl.selectedSegmentIndex = (int)self.delegate.textFontSize == 15 ? 0 : ((int)self.delegate.textFontSize == 17 ? 1 : 2);
            [fontControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
            [aCell addSubview:fontControl];
        }
    }
    return aCell;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [self.defaults setObject:[NSNumber numberWithBool:switchControl.on ] forKey:@"nightMode"];
    self.delegate.nightMode = [self.defaults boolForKey:@"nightMode"];
}

- (void) sliderChanged: (id)sender{
    UISlider *sliderControl = sender;
    CGFloat brightness = sliderControl.value/10;
    NSLog(@"Current Value: %f", brightness);
    //this can not be tested on a simulator
    [[UIScreen mainScreen] setBrightness:brightness];
}

-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.delegate.textFontSize = 15.0f;
            break;}
        case 1:{
            self.delegate.textFontSize = 17.0f;
            break;}
        case 2:{
            self.delegate.textFontSize = 19.0f;
            break;}
    }
}


@end
