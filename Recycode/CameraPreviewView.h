//
//  CameraPreviewView.h
//  picsnap
//
//  Created by Angel Genov on 1/6/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
