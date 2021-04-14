//
//  GameScene.swift
//  The Magic Hunt
//
//  Created by HANNA P C FERREIRA on 06/04/21.
//

import SpriteKit
import GameplayKit
import AVFoundation

public class GameScene: SKScene {
    
    private var label:SKLabelNode!
    private var emitterNode = SKNode() //Criando um nó
    private let background = SKSpriteNode(imageNamed: "background") //Criando background
    private var emitters =  [SKEmitterNode]()
    private var nextStar: SKSpriteNode?
    private var stars = [SKSpriteNode]()
    private var lastStarTap: Double?
    private var nextStarMinTime: Double?
    private var currentStarIndex = 0
    private var aurora = Aurora()
    
    // Essa parte do código é executada logo que a cena começa
    public override func didMove(to view: SKView) {
        
        //Adicionando background
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background) //Adicionando background
        
        
        view.showsFPS = true
        createStarPath(starCount: 4)
                
        
    }
    
    //update emitter
    func updateEmitter(emitter:SKEmitterNode , aurora:Aurora){
        
        //Particles
        emitter.particleBirthRate = aurora.particleBirthRate
        emitter.particleTexture = aurora.particleTexture
        emitter.particleLifetime = aurora.particleLifeTime
        
        //Position Range
        emitter.particlePositionRange = aurora.particlePositionRange
        emitter.particleZPosition = aurora.particleZPosition
        emitter.emissionAngle = aurora.emissionAngle
        emitter.emissionAngleRange = aurora.emissionAngleRange
        emitter.particleSpeed = aurora.particleSpeed
        emitter.xAcceleration = aurora.xAcceleration
        emitter.yAcceleration = aurora.yAcceleration
        
        //alpha
        emitter.particleAlpha = aurora.particleAlpha
        emitter.particleAlphaRange = aurora.particleAlphaRange
        emitter.particleAlphaSpeed = aurora.particleAlphaSpeed
        
        //scale
        let particleScaleSequence = aurora.particleScaleSequence
        particleScaleSequence.addKeyframeValue(0.07, time: 0)
        particleScaleSequence.addKeyframeValue(0.05, time: 1)
        particleScaleSequence.addKeyframeValue(0.04, time: 2)
        emitter.particleScaleSequence = aurora.particleScaleSequence
        
        //rotation
        emitter.particleRotation = aurora.particleRotation
        emitter.particleRotationRange = aurora.particleRotationRange
        emitter.particleRotationSpeed = aurora.particleRotationSpeed
        
        //color blend
        emitter.particleColorBlendFactor = aurora.particleColorBlendFactor
        emitter.particleColorBlendFactorRange = aurora.particleColorBlendFactorRange
        emitter.particleColorBlendFactorSpeed = aurora.particleColorBlendFactorSpeed
        
        //blend mode
        emitter.particleBlendMode = aurora.particleBlendMode
        
        //color sequence
        emitter.particleColorSequence = aurora.particleColorSequence
    }
    
    //create emitter
    func createEmitter(aurora:Aurora) -> SKEmitterNode{
        let emitter = SKEmitterNode()
        updateEmitter(emitter: emitter, aurora: aurora)
        return emitter
    }
    
    //create aurora node
//    func createAuroraNode()->SKEmitterNode{
//        let emitter = createEmitter()
//        //aplicar ações
//        return emitter
//    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //verificar se a pessoa tocou na primeira estrela
        if nextStar?.contains(pos) ?? false {
            //se sim:código
            aurora = Aurora()
            //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
            lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
            emitters = [] //lista vazia
            spawnEmiter(pos: pos, aurora: aurora)
            nextStar?.alpha = 0
            currentStarIndex += 1
            nextStar = stars[currentStarIndex]
            nextStar?.alpha = 1
            
        }

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //verifica se a pessoa está se aproximando da próxima estrela
        //fazer depois
        spawnEmiter(pos: pos, aurora: aurora)
            //se sim: colocar emittetr na posição e verfiica se chegou na próxima estrela (tempo maior do que minimo: se menor: desmonta a aurora atual)
            if nextStar?.contains(pos) ?? false {

                //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
                lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora

                nextStar?.alpha = 0
                if currentStarIndex < stars.count-1{
                    currentStarIndex += 1
                    nextStar = stars[currentStarIndex]
                    nextStar?.alpha = 1
                }
                else{
                    //verifica se a pessoa passou em todas as estrelas
                        //se sim: prepara a remoção das particulas e faz coisas bonitas
                }

            }

            //se nao: verifica se a pessoa esta se afastando da próxima estrela
                //se sim: desmonta a aurora atual

        
    }
    
    fileprivate func destroyAurora() {
        for emitter in emitters{
            removeEmitter(emitter)
        }
        for star in stars{
            star.removeFromParent()
        }
        emitters = []
        stars = []
        nextStar = nil
        lastStarTap = nil
        createStarPath(starCount: Int.random(in: 3...5))
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //verifica se a pessoa passou em todas as estrelas
        if currentStarIndex < stars.count{
            destroyAurora()
        }

    }
    
    //Remove Particles
    func removeEmitter(_ emitter: SKNode){
        let fadeOutAction = SKAction.fadeOut(withDuration: 5)

        emitter.run(fadeOutAction) {
            emitter.removeFromParent()
        }
    }
    
    //Spawna particles
    func spawnEmiter(pos: CGPoint, aurora:Aurora){
        // Verificar a distancia do ultimo toque
        //Detectar que a pessoa clicou
        let emitter = createEmitter(aurora:aurora)
        emitter.position = pos
        emitter.zPosition = 10
        addChild(emitter)
        

        
        //Criar lista vazia temporária de toques
        emitters.append(emitter) //criando nova lista só com emitter
        // Verificar a distancia da proxima estrela
            // Colocar a próxima partícula na cena e na lista
    }
    
    //createStarPath
    func createStarPath(starCount: Int){
        
        //criar lista de posições aleatórias para ser o caminho de estrelas
        var randomPositions: [CGPoint] = []
        for _ in 0..<starCount {
            let randomPosition = CGPoint(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -150...150))
            randomPositions.append(randomPosition)
        }
        
        //colocar assets da estrelas com alpha 0
        for randomPosition in randomPositions{
            let star = SKSpriteNode(imageNamed: "spark")
            stars.append(star)
            star.position = randomPosition
            star.zPosition = 100
            star.setScale(0.2)
            star.alpha = 0
            let starFadeIn = SKAction.scale(to: 0.3, duration: 1)
            let starFadeOut = SKAction.scale(to: 0.1, duration: 1)
            let starRepeatForever = SKAction.repeatForever(SKAction.sequence([starFadeIn, starFadeOut]))
            star.run(starRepeatForever)
            addChild(star)
        }
        
        //constrói linhas entre as estrelas
        //mostra as duas primeiras estrelas e a linha
        stars[0].alpha = 1
        nextStar = stars.first
        currentStarIndex = 0
        
    }
    
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}



func loadParticle(named: String) -> SKEmitterNode? {
    guard let path = Bundle.main.path(forResource: named, ofType: "sks") else { return nil }
    
    return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SKEmitterNode
}


