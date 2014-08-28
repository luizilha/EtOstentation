//
//  ANIMyScene.m
//  EtOstentation
//
//  Created by Luiz Ilha Moschem on 8/21/14.
//  Copyright (c) 2014 ani. All rights reserved.
//

#import "ANIMyScene.h"
#import "ANIGameOver.h"

@implementation ANIMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        /* Setup your scene here */
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        self.planeta = [SKSpriteNode spriteNodeWithImageNamed:@"lua2"];
        [self.planeta setScale:1.5]; // diminuir a escala do planeta
        self.planeta.position = CGPointMake(self.size.width/2, self.size.height);
        [self addChild:self.planeta];
        
        int score = [defaults integerForKey:@"score"];
        NSLog(@"score passado %d ",score);
        
        self.et = [SKSpriteNode spriteNodeWithImageNamed:@"et1"];
        [self.et setScale:0.15]; // diminuir a escala do et
        self.et.zRotation = M_PI; // girar o et de cabeca pra baixo
        self.et.position = CGPointMake(self.size.width/2, self.size.height - self.size.height/4);
        [self addChild:_et];
        _somDiamante = [SKAction playSoundFileNamed:@"diamantada.mp3" waitForCompletion:NO];
        _somPedrada = [SKAction playSoundFileNamed:@"pedrada.mp3" waitForCompletion:NO];
        _somGameOver = [SKAction playSoundFileNamed:@"gameOver.mp3" waitForCompletion:NO];
        [self criarCoracao];
        [self initScroe];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveEt:touchLocation.x];
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    //NSLog(@"tocou %@",NSStringFromCGPoint(touchLocation));
    [self moveEt:touchLocation.x];
    
}

-(void)moveEt:(CGFloat)location{
    SKAction *move = [SKAction moveToX:location duration:0.5];
    [_et runAction:move];
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
}

-(void) checarColisao
{
    NSMutableArray * lista = [[NSMutableArray alloc]init];
    // Checando colisao com a pedra
    [self enumerateChildNodesWithName:@"pedra" usingBlock:^(SKNode * node,BOOL * stop){
        
        SKSpriteNode * pedra = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(pedra.frame, _et.frame)) {
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
    coracao1.position = CGPointMake(50, 550);
    coracao2.position = CGPointMake(77, 550);
    coracao3.position = CGPointMake(104, 550);
    
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
    _scoreLabel.position = CGPointMake(220 , 540);
    
    // LABEL MELHOR SCORE
    
    [self addChild:_scoreLabel];
}

- (void)somaScore{
    [self enumerateChildNodesWithName:@"diamante" usingBlock:^(SKNode * node,BOOL * stop){
        
        SKSpriteNode * diamante = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(diamante.frame, self.et.frame)) {
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    int melhorScore = 0;
    
    melhorScore = [defaults integerForKey:@"score"];
    
    
    if (self.score > melhorScore) {
        _scoreLabel.fontColor = [SKColor blueColor];
    }
    _scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    
}
@end
