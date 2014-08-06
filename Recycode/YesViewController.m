//
//  YesViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "YesViewController.h"
#import "ProductImageViewController.h"
#import "ProductsCache.h"
#import "UIImage-JTImageCrop.h"

@import AVFoundation;

@interface YesViewController () {
    UIColor * _backBarTintColor;
    UIColor * _backTintColor;
    NSString * _desc;
    NSString * _brand;
    NSString * _code;
    NSString * _imgfn;
    UIImage * _productImage;
}
@property(weak,nonatomic) IBOutlet UIImageView * imgView;
@property(weak,nonatomic) IBOutlet UILabel * descriptionField;
@property(weak,nonatomic) IBOutlet UILabel * brandField;

@end

@implementation YesViewController

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
    NSArray * p = [_info componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    _desc = [p objectAtIndex:0];
    _brand = [p objectAtIndex:1];
    _code = [p objectAtIndex:2];
    _imgfn = [p objectAtIndex:3];
    
    if ([_imgfn length]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * picfn = [NSString stringWithFormat:@"img%@.jpg",self.barCode];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:picfn];
        NSData *myData = [NSData dataWithContentsOfFile:savedImagePath];
        _productImage = [UIImage imageWithData:myData];
/*
        UIImage *crop = [UIImage imageWithImage:_productImage cropInRelativeRect:CGRectMake(0, 0.4, 1, 0.118)];
*/
        UIImage *crop = [UIImage imageWithImage:_productImage cropMiddleSegmentPercentage:11.97];
        _imgView.image = crop;
    }
    else {
        _imgView.hidden = YES;
    }
    _descriptionField.text = _desc;
    _brandField.text = _brand;
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance;
    
    utterance = [AVSpeechUtterance speechUtteranceWithString:@"Yes! This material is recyclable! Go ahead and put it in the recycle bin."];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 1.9;
    [synthesizer speakUtterance:utterance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _backBarTintColor = self.navigationController.navigationBar.barTintColor;
    _backTintColor = self.navigationController.navigationBar.tintColor;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:152.0 / 255.0 blue:45.0 / 255.0 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:254.0 / 255.0 blue:82.0 / 255.0 alpha:1.0];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.barTintColor = _backBarTintColor;
     self.navigationController.navigationBar.tintColor = _backTintColor;
     self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (IBAction)showImage:(id)sender
{
    [self performSegueWithIdentifier:@"showImage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImage"]) {
        ProductImageViewController * c = segue.destinationViewController;
        c.imageData = _productImage;
        c.productName = _desc;
        c.productMaker = _brand;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
