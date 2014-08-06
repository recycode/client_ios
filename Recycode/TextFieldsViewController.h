//
//  TextFieldsViewController.h
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldsViewController : UITableViewController
@property(weak,nonatomic) IBOutlet UITextField *desc;
@property(weak,nonatomic) IBOutlet UITextField *brand;
@property(weak,nonatomic) IBOutlet UITextField *code;

@end
