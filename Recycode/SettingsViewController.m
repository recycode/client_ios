//
//  SettingsViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/10/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

- (IBAction)close:(id)sender;

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
