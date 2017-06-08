//
//  ARViewController.m
//  AmazingAPP
//
//  Created by 唐绍成 on 2017/6/7.
//  Copyright © 2017年 唐绍成. All rights reserved.
//

#import "ARViewController.h"
#import <ARKit/ARKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ARViewController ()
<ARSKViewDelegate,
ARSessionDelegate>

@end

@implementation ARViewController
{
    ARSKView *sceneView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        SKScene *scene = [SKScene sceneWithSize:self.view.bounds.size];
        scene.camera = [SKCameraNode node];
        sceneView = [[ARSKView alloc] initWithFrame:self.view.bounds];
        sceneView.session.delegate = self;
        [self.view addSubview:sceneView];
        sceneView.delegate = self;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        ARWorldTrackingSessionConfiguration *config = [ARWorldTrackingSessionConfiguration new];
        config.planeDetection = ARPlaneDetectionHorizontal;
        config.worldAlignment = ARWorldAlignmentCamera;
        [sceneView.session runWithConfiguration:config];
        SKScene *scene = [SKScene sceneWithSize:self.view.bounds.size];
        scene.camera = [SKCameraNode node];
        [sceneView presentScene:scene];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            simd_float4x4 transilation = matrix_identity_float4x4;
            transilation.columns[3].z = -0.2;
            simd_float4x4 transform = simd_mul(sceneView.session.currentFrame.camera.transform, transilation);
            ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
            [sceneView.session addAnchor:anchor];
        });
    } else {
        // Fallback on earlier versions
    }
}

- (nullable SKNode *)view:(ARSKView *)view nodeForAnchor:(ARAnchor *)anchor{
    SKLabelNode *node = [SKLabelNode labelNodeWithText:@"Hello World"];
    return node;
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
    
}

- (void)view:(ARSKView *)view didAddNode:(SKNode *)node forAnchor:(ARAnchor *)anchor{
    
}

@end
