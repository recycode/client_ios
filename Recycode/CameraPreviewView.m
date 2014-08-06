//
//  CameraPreviewView.m
//  picsnap
//
//  Created by Angel Genov on 1/6/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import "CameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraPreviewView

+ (Class)layerClass
{
	return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
	return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
	[(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
