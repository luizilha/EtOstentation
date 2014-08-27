//
//  ANIMyScene.h
//  EtOstentation
//

//  Copyright (c) 2014 ani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ANIMyScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdadeTimeInterval;

@end
