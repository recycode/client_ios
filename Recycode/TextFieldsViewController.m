//
//  TextFieldsViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "TextFieldsViewController.h"
#import "UnknownViewController.h"

@interface TextFieldsViewController ()

@end

@implementation TextFieldsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)takePicture:(id)sender
{
    UnknownViewController *p = (UnknownViewController*) self.parentViewController;
    [p takePicture];
}

@end
