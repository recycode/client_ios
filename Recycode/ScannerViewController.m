//
//  ScannerViewController.m
//  Recycode
//
//  Created by Angel Genov on 10/28/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "ScannerViewController.h"
#import "SearchViewController.h"

@import AVFoundation;

@interface ScannerViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    NSTimer * _timer;
}

@property (strong) NSString * lastBarCode;
@property (strong) AVCaptureSession * captureSession;
@property (strong) AVCaptureMetadataOutput *metadataOutput;
@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong) IBOutlet UIView * cameraView;

- (IBAction)sett_btn:(id)sender;

@end

@implementation ScannerViewController

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
 
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    if(videoInput)
        [self.captureSession addInput:videoInput];
    else
        NSLog(@"Error: %@", error);
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:metadataOutput];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code]];
    //[metadataOutput setMetadataObjectTypes:metadataOutput.availableMetadataObjectTypes];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = _cameraView.layer.bounds;
    [_cameraView.layer addSublayer:previewLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
/*
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    if(videoInput)
        [self.captureSession addInput:videoInput];
    else
        NSLog(@"Error: %@", error);
    
    //[metadataOutput setMetadataObjectTypes:metadataOutput.availableMetadataObjectTypes];
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession addOutput:self.metadataOutput];
    [self.metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code]];
    
    //self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = _cameraView.layer.bounds;
    [_cameraView.layer addSublayer:self.previewLayer];
*/
    
    [self.captureSession startRunning];
    _lastBarCode = nil;
    //_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	[self.captureSession stopRunning];
    //self.previewLayer = nil;
    //self.metadataOutput = nil;
    //self.captureSession = nil;
    [_timer invalidate];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code])
        {
            [_timer invalidate];
            NSLog(@"EAN 13 = %@", readableObject.stringValue);
            if (!_lastBarCode) {
                self.lastBarCode = readableObject.stringValue;
                [self performSegueWithIdentifier:@"checkCode" sender:self];
            }
            [self.captureSession stopRunning];
            return; // BAD BAD BAD !!!!
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    if ([segue.identifier isEqualToString:@"checkCode"]) {
        SearchViewController * svc = segue.destinationViewController;
        svc.barCode = self.lastBarCode;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (IBAction)sett_btn:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)fireTimer:(NSTimer*)timer
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance;
    
    utterance = [AVSpeechUtterance speechUtteranceWithString:@"Hey! Show me a bar code, please."];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 1.9;
    [synthesizer speakUtterance:utterance];
}

@end
