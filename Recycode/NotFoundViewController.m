//
//  NotFoundViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/11/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "NotFoundViewController.h"

@interface NotFoundViewController ()

- (IBAction)ok_btn:(id)sender;
- (IBAction)cancel_btn:(id)sender;
@end

@implementation NotFoundViewController

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    CGPoint pos = self.view.layer.position;
    pos.y = 284;
    self.view.layer.position = pos;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    CGPoint pos = self.view.layer.position;
    pos.y = 174;
    self.view.layer.position = pos;
    
}


- (IBAction)ok_btn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UINavigationController * p = self.presentingViewController;
    [p popViewControllerAnimated:YES];
}

- (IBAction)cancel_btn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UINavigationController * p = self.presentingViewController;
    [p popViewControllerAnimated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
