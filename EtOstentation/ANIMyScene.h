//
//  ANIMyScene.h
//  EtOstentation
//

//  Copyright (c) 2014 ani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ANIMyScene : SKScene 
@property (nonatomic,assign) int pedraTime;
@property (nonatomic,assign) int timeScorePedra;
@property (nonatomic,assign) int score;
@property (nonatomic) SKSpriteNode *et;
@property (nonatomic) SKSpriteNode *planeta;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdadeTimeInterval;
@end
