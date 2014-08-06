//
//  ProductImageViewController.m
//  Recycode
//
//  Created by Angel Genov on 12/10/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "ProductImageViewController.h"

@interface ProductImageViewController ()

@property(strong) IBOutlet UIImageView* img;
@property(strong) IBOutlet UILabel * productLabel;
@property(strong) IBOutlet UILabel * makerLabel;
@end

@implementation ProductImageViewController

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
    _img.image = _imageData;
    _productLabel.text = _productName;
    _makerLabel.text = _productMaker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
