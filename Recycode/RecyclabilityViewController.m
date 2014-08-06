//
//  RecyclabilityViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/26/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "RecyclabilityViewController.h"

@interface RecyclabilityViewController () {
    UIColor * _backBarTintColor;
    UIColor * _backTintColor;
}

@end

@implementation RecyclabilityViewController

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _backBarTintColor = self.navigationController.navigationBar.barTintColor;
    _backTintColor = self.navigationController.navigationBar.tintColor;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:46.0 / 255.0 blue:57.0 / 255.0 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:204.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = _backBarTintColor;
    self.navigationController.navigationBar.tintColor = _backTintColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
