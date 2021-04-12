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
    
    // Essa parte do código é executada logo que a cena começa
    public override func didMove(to view: SKView) {
        
        //Adicionando background
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background) //Adicionando background
        
        //Posições do emitterNode
        let points = [CGPoint(x: -50, y: 50),
                      CGPoint(x: -40, y: 50),
                      CGPoint(x: -30, y: 40),
                      CGPoint(x: -20, y: 40),
                      CGPoint(x: -10, y: 20),
                      CGPoint(x: 0, y: 0),
                      CGPoint(x: 10, y: -20),
                      CGPoint(x: 20, y: -40),
                      CGPoint(x: 30, y: -40),
                      CGPoint(x: 40, y: -50),
                      CGPoint(x: 50, y: -50)]
        for point in points{
            //create particle
            let emitterNode = createEmitter() // Criação da aurora
            emitterNode.targetNode = self // Onde vai emitir as particulas
            //addChild(emitterNode)
            emitterNode.position = point
        }
        
        view.showsFPS = true
        createStarPath(starCount: 4)
                
        
    }
    
    //create emitter
    func createEmitter() -> SKEmitterNode{
        let emitter = SKEmitterNode()
        //Particles
        emitter.particleBirthRate = 10
        emitter.particleTexture = SKTexture(imageNamed: "meuspark")
        emitter.particleLifetime = 6
        //Position Range
        emitter.particlePositionRange = CGVector(dx: 15, dy: 20)
        emitter.particleZPosition = 0
        emitter.emissionAngle = 89.381
        emitter.emissionAngleRange = 0.39
        emitter.particleSpeed = 10
        emitter.xAcceleration = 0
        emitter.yAcceleration = 1.1 //se colocar negativo vai pra baixo
        //alpha
        emitter.particleAlpha = 0.8
        emitter.particleAlphaRange = 1
        emitter.particleAlphaSpeed = 50
        //scale
        let particleScaleSequence = SKKeyframeSequence()
        particleScaleSequence.addKeyframeValue(0.05, time: 0)
        particleScaleSequence.addKeyframeValue(0.07, time: 3)
        particleScaleSequence.addKeyframeValue(0.04, time: 6)
        emitter.particleScaleSequence = particleScaleSequence
        
        //emitter.particleScale = 0.05
        //emitter.particleScaleRange = 0
        //emitter.particleScaleSpeed = 0
        
        //rotation
        emitter.particleRotation = 0
        emitter.particleRotationRange = 0
        emitter.particleRotationSpeed = 0
        //color blend
        emitter.particleColorBlendFactor = 11
        emitter.particleColorBlendFactorRange = 0
        emitter.particleColorBlendFactorSpeed = 0
        //blend mode
        emitter.particleBlendMode = .alpha
        
        //colors
        let colorSequence = SKKeyframeSequence()
        colorSequence.addKeyframeValue(UIColor(hue: 179/360, saturation: 0/100, brightness: 100/100, alpha: 0.3), time: 0)
        
        colorSequence.addKeyframeValue(UIColor(hue: 130/360, saturation: 80/100, brightness: 100/100, alpha: 0.5), time: 0.1)
        
        colorSequence.addKeyframeValue(UIColor(hue: 300/360, saturation: 100/100, brightness: 100/100, alpha: 0.04), time: 1)
        
        colorSequence.addKeyframeValue(UIColor(hue: 300/360, saturation: 70/100, brightness: 100/100, alpha: 0.15), time: 3)
        
        emitter.particleColorSequence = colorSequence
        

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
            //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
            lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
            emitters = [] //lista vazia
            spawnEmiter(pos: pos)
            nextStar?.alpha = 0
            currentStarIndex += 1
            nextStar = stars[currentStarIndex]
            nextStar?.alpha = 1
            
        }


    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //verifica se a pessoa está se aproximando da próxima estrela
        //fazer depois
            //se sim: colocar emittetr na posição e verfiica se chegou na próxima estrela (tempo maior do que minimo: se menor: desmonta a aurora atual)
            if nextStar?.contains(pos) ?? false {

                //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
                lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
                spawnEmiter(pos: pos)
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
        
        spawnEmiter(pos: pos)
        
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
    func spawnEmiter(pos: CGPoint){
        // Verificar a distancia do ultimo toque
        //Detectar que a pessoa clicou
        let emitter = createEmitter()
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
            star.zPosition = 5
            star.setScale(0.2)
            star.alpha = 0
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


