//
//  ANIMyScene.m
//  EtOstentation
//
//  Created by Luiz Ilha Moschem on 8/21/14.
//  Copyright (c) 2014 ani. All rights reserved.
//

#import "ANIMyScene.h"
#import "ANIGameOver.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation ANIMyScene
{
    // Sprites
    SKSpriteNode *_et;
    SKSpriteNode *_planeta;
    SKSpriteNode *_pernaEsq;
    SKSpriteNode *_pernaDir;
    // Sons
    SKAction *_somDiamante;
    SKAction *_somPedrada;
    SKAction *_somGameOver;
    // rotacao
    int _qtdPedra;
    BOOL _planetaMovendoDir;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _planetaMovendoDir = NO;
        _somDiamante = [SKAction playSoundFileNamed:@"diamantada.mp3" waitForCompletion:NO];
        _somPedrada = [SKAction playSoundFileNamed:@"pedrada.mp3" waitForCompletion:NO];
        _somGameOver = [SKAction playSoundFileNamed:@"gameOver.mp3" waitForCompletion:NO];
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        /* Setup your scene here */
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        _planeta = [SKSpriteNode spriteNodeWithImageNamed:@"lua"];
        [_planeta setScale:1.4]; // diminuir a escala do planeta
        _planeta.position = CGPointMake(self.size.width/2, self.size.height/2 + self.size.height);
//        _planeta.position = CGPointMake(0, self.size.height/2 + self.size.height - self.size.height * -0.1);
        [self addChild:_planeta];
        
//        int score = (int) [defaults integerForKey:@"score"];

        _et = [SKSpriteNode spriteNodeWithImageNamed:@"et1"];
        [_et setScale:0.15]; // diminuir a escala do et
        _et.zRotation = M_PI; // girar o et de cabeca pra baixo
        _et.position = CGPointMake(self.size.width/2, self.size.height - self.size.height/4);
        [self addChild:_et];
        
        _pernaEsq = [SKSpriteNode spriteNodeWithImageNamed:@"et_perna"];
        _pernaEsq.position = CGPointMake(_et.size.width - 128, _et.size.height - 300);
        [_et addChild:_pernaEsq];
        
        _pernaDir = [SKSpriteNode spriteNodeWithImageNamed:@"et_perna2"];
        _pernaDir.position = CGPointMake(110, _et.size.height - 300);
        [_et addChild:_pernaDir];

        
        [self criarCoracao];
        [self initScroe];
        //[self vibrate];
    }
    return self;
}


- (void)vibrate {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveEt:touchLocation.x];
    
}

/*
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    //NSLog(@"tocou %@",NSStringFromCGPoint(touchLocation));
    [self moveEt:touchLocation.x];
    
}
*/

-(void)moveEt:(CGFloat)location{
    _pernaEsq.zRotation = M_PI /7;
    _pernaDir.zRotation = -M_PI/8;
    SKAction *move = [SKAction moveToX:location duration:0.5];
    [_et runAction:move completion:^{
        _pernaEsq.zRotation = 0;
        _pernaDir.zRotation = 0;
    }];
}

-(void) addPedra{
    self.pedraTime++;
    self.timeScorePedra++;
    SKSpriteNode *pedra = [SKSpriteNode spriteNodeWithImageNamed:@"meteoro"];
    [pedra setScale:0.2];
    pedra.name = @"pedra";
    float speed = (arc4random() % 4) + 1;
    int randX = (arc4random() % 320);
    
    pedra.position = CGPointMake(randX,0);
    [self addChild:pedra];
    [pedra runAction:[SKAction sequence:@[[SKAction moveToY:self.size.height duration:speed],
                                          [SKAction removeFromParent]]]];
    //metodo de adicionar os diamantes a cada 10 pedras.
    if (self.pedraTime == 5) {
        SKSpriteNode *diamante = [SKSpriteNode spriteNodeWithImageNamed:@"diamante"];
        diamante.name = @"diamante";
        [diamante setScale:0.15];
        float speed = (arc4random() % 3) + 2;
        int randX = (arc4random() % 320);
        
        diamante.position = CGPointMake(randX,0);
        [self addChild:diamante];
        [diamante runAction:[SKAction sequence:@[[SKAction moveToY:self.size.height duration:speed],
                                                 [SKAction removeFromParent]]]];
        self.pedraTime = 0;
    }
//    _qtdPedra++;
//    if (_qtdPedra>5) {
//        if(arc4random() % 2 == 0) {
//            _planetaMovendoDir = YES;
//            [self rotacaoPlaneta:M_PI velocidade:3 duracao:4];
//        }else
//            [self rotacaoPlaneta:-M_PI velocidade:3 duracao:4];
//         _qtdPedra = 0;
//    }
}

-(void) updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast{
    self.lastSpawnTimeInterval += timeSinceLast;
    if(self.lastSpawnTimeInterval > 1){
        self.lastSpawnTimeInterval = 0;
        [self addPedra];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Tempo de atendimento delta
    // se cair abaixo de 60fps, ainda queremos tudo para mover a mesma distância
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdadeTimeInterval;
    self.lastUpdadeTimeInterval = currentTime;
    if(timeSinceLast > 1){ // mais de um segundo desde a última atualização
        timeSinceLast = 1.0/60.0;
        self.lastUpdadeTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [self checarColisao];
    [self somaScore];
    
    if (_planetaMovendoDir) {
        
        _et.physicsBody.velocity = CGVectorMake(0, -50);
//        SKAction *move = [SKAction moveToX:0.5 duration:1];
//        [_et runAction:move completion:^{
//            _pernaEsq.zRotation = 0;
//            _pernaDir.zRotation = 0;
//        }];
    }
    
    //NSLog(@"score *** %d ***",_score/10);
}

-(void) checarColisao
{
    NSMutableArray * lista = [[NSMutableArray alloc]init];
    // Checando colisao com a pedra
    [self enumerateChildNodesWithName:@"pedra" usingBlock:^(SKNode * node,BOOL * stop){
        
        SKSpriteNode * pedra = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(pedra.frame, _et.frame)) {
            [self vibrate];
            // Aqui vamos tirar uma vida
            [pedra removeFromParent];
            [self removerUmCoracao:lista];
            [self runAction:_somPedrada];
        }
    }];
    if (lista.count == 1) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[ANIGameOver alloc]initWithSize:self.size score:self.score];
        [self runAction:_somGameOver];
        [self.view presentScene:gameOverScene transition: reveal];
        
    }
}

-(void)criarCoracao{
    SKSpriteNode *coracao1 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao1.name = @"coracao";
    SKSpriteNode *coracao2 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao2.name = @"coracao";
    SKSpriteNode *coracao3 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao3.name = @"coracao";
    
    [coracao1 setScale:0.2];
    [coracao2 setScale:0.2];
    [coracao3 setScale:0.2];
    
    //coracao1.position = CGPointMake(50, 30);
    //coracao2.position = CGPointMake(77, 30);
    //coracao3.position = CGPointMake(104, 30);
    coracao1.position = CGPointMake(50, self.size.height-15);
    coracao2.position = CGPointMake(77, self.size.height-15);
    coracao3.position = CGPointMake(104, self.size.height-15);
    
    [self addChild: coracao3];
    [self addChild:coracao2];
    [self addChild:coracao1];
}

-(void)removerUmCoracao:(NSMutableArray *)lista{
    
    [self enumerateChildNodesWithName:@"coracao" usingBlock:^(SKNode * node,BOOL * stop){
        SKSpriteNode * coracao = (SKSpriteNode *)node;
        [lista addObject:coracao];
    }];
    
    SKSpriteNode * ultimoCoracao = (SKSpriteNode *)[lista lastObject];
    [ultimoCoracao removeFromParent];
}

- (void)initScroe{
    
    //_scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    //_scoreLabel.text = @"00";
    _scoreLabel.fontColor = [SKColor whiteColor];
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    //_scoreLabel.position = CGPointMake(250 , 20);
    _scoreLabel.position = CGPointMake(220 , self.size.height-30);
    
    // LABEL MELHOR SCORE
    
    [self addChild:_scoreLabel];
}

- (void)somaScore{
    [self enumerateChildNodesWithName:@"diamante" usingBlock:^(SKNode * node,BOOL * stop){
        
        SKSpriteNode * diamante = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(diamante.frame, _et.frame)) {
            [diamante removeFromParent];
            self.score += 100;
            [self runAction: _somDiamante];
            //NSLog(@"%d",self.score);
        }
    }];
    if (self.timeScorePedra == 1) {
        self.score += 10;
        self.timeScorePedra = 0;
    }
    if (self.score > 1000) {
        self.scoreLabel.fontColor = [SKColor yellowColor];
    }
    if (self.score > 2000) {
        self.scoreLabel.fontColor = [SKColor redColor];
    }
    _scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    
}
-(void)rotacaoPlaneta:(CGFloat)direcao velocidade:(NSTimeInterval)velocidade duracao:(CGFloat)duracao{
    SKAction *girar = [SKAction rotateByAngle:direcao duration:velocidade];
    [_planeta runAction:[SKAction repeatAction:girar count:duracao]];
    // [sprite runAction:[SKAction repeatActionForever:action]]
}
@end
