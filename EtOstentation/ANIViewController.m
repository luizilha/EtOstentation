//
//  ANIViewController.m
//  EtOstentation
//
//  Created by Luiz Ilha Moschem on 8/21/14.
//  Copyright (c) 2014 ani. All rights reserved.
//

#import "ANIViewController.h"
#import "ANIStart.h"

@implementation ANIViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSError *erro;
    NSURL *bgUrlAudio = [[NSBundle mainBundle] URLForResource:@"bg-music" withExtension:@"caf"];
    self.bgAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:bgUrlAudio error:&erro];
    self.bgAudio.numberOfLoops = -1;
    [self.bgAudio prepareToPlay];
    [self.bgAudio play];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    skView.showsPhysics = YES; // aparecer a fisica dos corpos
    // Create and configure the scene.
    //SKScene * scene = [ANIMyScene sceneWithSize:skView.bounds.size];
    SKScene * scene = [ANIStart sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden{
    return  YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
