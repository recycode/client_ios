//
//  ProductViewController.m
//  Recycode
//
//  Created by Angel Genov on 10/28/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "ProductViewController.h"

@import AVFoundation;

typedef NS_ENUM(NSUInteger, ViewState) {
    ViewStateLookUp,
    ViewStateYes,
    ViewStateNO,
};

@interface ProductViewController () {
    ViewState _state;
    NSTimer * _timer;
    BOOL      _talk;
}

@property(strong) IBOutlet UILabel * label;
@property(strong) IBOutlet UIImageView * img;
@property(strong) IBOutlet UILabel * line1;
@property(strong) IBOutlet UILabel * line2;
@property(strong) IBOutlet UILabel * line3;
@property(strong) IBOutlet UIButton * tipsBtn;

@property(strong) IBOutlet UIImageView * backBtn;
@property(strong) IBOutlet UIImageView * settBtn;


- (IBAction)back_btn:(id)sender;
- (IBAction)sett_btn:(id)sender;
- (IBAction)tips_btn:(id)sender;

@end

@implementation ProductViewController

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

    _state = ViewStateLookUp;
    self.label.text = _barCode;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:NO];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setViewState];
}

- (void)fireTimer:(NSTimer*)timer
{
    _talk = YES;
    if ([_barCode isEqualToString:@"0769981114204"]) {
        _state = ViewStateYes;
    }
    else if ([_barCode isEqualToString:@"0078693417962"]) {
        [self performSegueWithIdentifier:@"showNotFound" sender:self];
    }
    else {
        _state = ViewStateNO;
    }
    
    [self setViewState];
}


- (void)setViewState;
{
    UIView * view = self.view;
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance;
    
    switch (_state) {
        case ViewStateLookUp:
            view.backgroundColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
            _img.image = [UIImage imageNamed:@"check.png"];
            _line1.text = @"Hold on.";
            _line1.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            [_line1 setNeedsDisplay];
            _line2.text = @"We are searching for your product.";
            _line2.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            [_line2 setNeedsDisplay];
            _line3.text = @"It won't take long. Believe me.";
            _line3.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            [_line3 setNeedsDisplay];
            _tipsBtn.hidden = YES;
            _backBtn.hidden = YES;
            _settBtn.hidden = YES;
            break;

        case ViewStateYes:
            view.backgroundColor = [UIColor colorWithRed:0.0 green:152.0 / 255.0 blue:46.0 / 255.0 alpha:1.0];
            _img.image = [UIImage imageNamed:@"yes.png"];
            _line1.text = @"Yes!";
            _line1.textColor = [UIColor colorWithRed:0.0 green:254.0 / 255.0 blue:82.0 / 255.0 alpha:1.0];
            [_line1 setNeedsDisplay];
            _line2.text = @"This material is recyclable!";
            _line2.textColor = [UIColor colorWithRed:0.0 green:254.0 / 255.0 blue:82.0 / 255.0 alpha:1.0];
            [_line2 setNeedsDisplay];
            _line3.text = @"Go ahead and put it in the recycle bin.";
            _line3.textColor = [UIColor colorWithRed:0.0 green:254.0 / 255.0 blue:82.0 / 255.0 alpha:1.0];
            [_line3 setNeedsDisplay];
            _tipsBtn.hidden = YES;
            _backBtn.image = [UIImage imageNamed:@"back_g.png"];
            _backBtn.hidden = NO;
            _settBtn.image = [UIImage imageNamed:@"sett_g.png"];
            _settBtn.hidden = NO;
            if (_talk) {
                utterance = [AVSpeechUtterance speechUtteranceWithString:@"Yes! This material is recyclable! Go ahead and put it in the recycle bin."];
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 1.9;
                [synthesizer speakUtterance:utterance];
                _talk = NO;
            }
            break;

        case ViewStateNO:
            view.backgroundColor = [UIColor colorWithRed:1.0 green:46.0 / 255.0 blue:57.0 / 255.0 alpha:1.0];
            _img.image = [UIImage imageNamed:@"no.png"];
            _line1.text = @"Oh No!";
            _line1.textColor = [UIColor colorWithRed:1.0 green:204.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
            [_line1 setNeedsDisplay];
            _line2.text = @"This material isn't recyclable!";
            _line2.textColor = [UIColor colorWithRed:1.0 green:204.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
            [_line2 setNeedsDisplay];
            _line3.text = @"That one will go to the trash can.";
            _line3.textColor = [UIColor colorWithRed:1.0 green:204.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
            [_line3 setNeedsDisplay];
            _tipsBtn.hidden = NO;
            _backBtn.image = [UIImage imageNamed:@"back_r.png"];
            _backBtn.hidden = NO;
            _settBtn.image = [UIImage imageNamed:@"sett_r.png"];
            _settBtn.hidden = NO;
            if (_talk) {
                utterance = [AVSpeechUtterance speechUtteranceWithString:@"Oh No! This material isn't recyclable! That one will go to the trash can."];
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 1.9;
                [synthesizer speakUtterance:utterance];
                _talk = NO;
            }
            break;
            
        default:
            break;
    }

}

- (IBAction)back_btn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sett_btn:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (IBAction)tips_btn:(id)sender
{
    [self performSegueWithIdentifier:@"showTips" sender:self];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
