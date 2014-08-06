//
//  CameraViewController.m
//  picsnap
//
//  Created by Angel Genov on 1/6/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import "CameraViewController2.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraPreviewView.h"
#import "UnknownViewController.h"

@interface CameraViewController2 () <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureSession * _session;
    AVCaptureDeviceInput * _videoDeviceInput;
    AVCaptureStillImageOutput * _stillImageOutput;
    BOOL _deviceAuthorized;
    id _runtimeErrorHandlingObserver;
}

@property (nonatomic, weak) IBOutlet CameraPreviewView *previewView;

- (IBAction)snapImage:(id)sender;

@end

@implementation CameraViewController2

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

    // Create the AVCaptureSession
	_session = [[AVCaptureSession alloc] init];
	//_session.sessionPreset = AVCaptureSessionPreset640x480;
    
	// Setup the preview view
	[[self previewView] setSession:_session];
	
	// Check for device authorization
	[self checkDeviceAuthorizationStatus];
	
    NSError *error = nil;
/*
    AVCaptureDevice *videoDevice = [CameraViewController2 deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];

 
    if (error)
    {
        NSLog(@"%@", error);
    }
 
*/
    
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];

    if(videoInput)
        [_session addInput:videoInput];
    else
        NSLog(@"Error: %@", error);
    
    if ([_session canAddInput:_videoDeviceInput])
    {
        [_session addInput:_videoDeviceInput];
    }
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([_session canAddOutput:_stillImageOutput])
    {
        [_stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [_session addOutput:_stillImageOutput];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //	dispatch_async(_sessionQueue, ^{
    //		__weak CameraViewController *weakSelf = self;
    /*		_runtimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:_session queue:nil usingBlock:^(NSNotification *note) {
     CameraViewController *strongSelf = weakSelf;
     dispatch_async([strongSelf _sessionQueue], ^{
     // Manually restarting the session since it must have been stopped due to an error.
     [[strongSelf session] startRunning];
     [[strongSelf recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
     });
     }];*/
    [_session startRunning];
    //	});
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //	dispatch_async(_sessionQueue, ^{
        [_session stopRunning];
    //	});
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)checkDeviceAuthorizationStatus
{
	NSString *mediaType = AVMediaTypeVideo;
	
	[AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
		if (granted)
		{
            _deviceAuthorized = YES;
        }
		else
		{
            
            [[[UIAlertView alloc] initWithTitle:@"Recycode!"
                                        message:@"Recycode doesn't have permission to use Camera, please change privacy settings"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            _deviceAuthorized = NO;
        }
	}];
}


+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
	AVCaptureDevice *captureDevice = [devices firstObject];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == position)
		{
			captureDevice = device;
			break;
		}
	}
	
	return captureDevice;
}


- (IBAction)snapImage:(id)sender
{

		// Update the orientation on the still image output video connection before capturing.
		[[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
		
		// Flash set to Auto for Still Capture
        if ([_videoDeviceInput.device hasFlash] && [_videoDeviceInput.device isFlashModeSupported:AVCaptureFlashModeAuto])
        {
            NSError *error = nil;
            if ([_videoDeviceInput.device lockForConfiguration:&error])
            {
                [_videoDeviceInput.device setFlashMode:AVCaptureFlashModeAuto];
                [_videoDeviceInput.device unlockForConfiguration];
            }
            else
            {
                NSLog(@"%@", error);
            }
        }
		
        //effect
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self previewView] layer] setOpacity:0.0];
            [UIView animateWithDuration:.25 animations:^{
                [[[self previewView] layer] setOpacity:1.0];
            }];
        });
        
		// Capture a still image.
        __weak CameraViewController2 *weakSelf = self;
		[_stillImageOutput captureStillImageAsynchronouslyFromConnection:[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
			
			if (imageDataSampleBuffer)
			{
				NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
				//UIImage *image = [[UIImage alloc] initWithData:imageData];
                /*
                 [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
                 
                 */
                /*
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"img"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:savedImagePath error:nil];
                    NSLog(@"file removed from path");
                }
                NSLog(@"Saved Image Path : %@",savedImagePath);
                [imageData writeToFile:savedImagePath atomically:YES];
                 */

                self.parent.pictureData = imageData;
                self.parent.picture = YES;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
		}];
}



@end
