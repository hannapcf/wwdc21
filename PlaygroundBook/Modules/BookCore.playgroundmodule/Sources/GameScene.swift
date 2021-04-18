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
    
    // MARK: PROPERTIES
    public var starpath: Answer = .yes
    public var myEvolution: Answer = .yes
    public var myChanges: Answer = .yes
    
    let voiceSound = SKAction.playSoundFileNamed("theMagicHunt", waitForCompletion: false)
    private var label:SKLabelNode!
    private var emitterNode = SKNode() //Criando um nó
    private let background = SKSpriteNode(imageNamed: "background") //Criando background
    private let background1 = SKSpriteNode(imageNamed: "background1")
    private var emitters =  [SKEmitterNode]()
    private var nextStar: SKSpriteNode?
    private var stars = [SKSpriteNode]()
    private var lastStarTap: Double?
    private var nextStarMinTime: Double?
    private var currentStarIndex = 0
    private var aurora = Aurora(randomHues: false, auroraMaxUpgrade: 1)
    private var followingStars:Bool = false
    var music: AVAudioPlayer!
    
    // MARK: LIFECYCLE
    // Essa parte do código é executada logo que a cena começa
    public override func didMove(to view: SKView) {
        
        
        run(voiceSound)
        
        //Adicionando background
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background)
        background1.zPosition = 80
        background1.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background1)


        
        view.showsFPS = true
        
        

        
    }
    
    
    public func startGame(){
        
        if starpath == .yes{
            createStarPath(starCount: 7)
        }
        else{
            createStarPath(starCount: 1)
        }
    }
    
    // MARK: METHODS
    
    //CRIA,ATUALIZA, ETC
    //ESTRELAS, ETC
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
    
    fileprivate func getNextStar() {
        

        //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
        lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
        
        nextStar?.alpha = 0
        
        
        if currentStarIndex < stars.count-1{
            currentStarIndex += 1
            nextStar = stars[currentStarIndex]
            nextStar?.alpha = 1
            aurora.upgrade()
            // MARK: CHANGE COLORS HERE
            if myChanges == .yes{
                for emitter in emitters{
                    updateEmitter(emitter: emitter, aurora: aurora)
                }
            }

        }
        else if currentStarIndex == stars.count-1{
            followingStars = false
            currentStarIndex += 1
            aurora.upgrade()
            // MARK: CHANGE COLORS HERE
            if myChanges == .yes{
                for emitter in emitters{
                    updateEmitter(emitter: emitter, aurora: aurora)
                }
            }
            destroyAurora(time: 6, progressive: true)
            
        }
    }
    
    
    
    fileprivate func destroyAurora(time: TimeInterval, progressive: Bool) {
        let timeMax = time
        let timeMin = time/2
        
        for (index, emitter) in emitters.enumerated(){
            if progressive == false{
                removeEmitter(emitter, time: time)
            }
            else{
                let EmitterTime = timeMin + (timeMax - timeMin) * (Double(index)/Double(emitters.count))
                removeEmitter(emitter, time: EmitterTime)
            }
            
        }
        if starpath == .yes{
            for star in stars{
                star.removeFromParent()
            }
            stars = []
            nextStar = nil
            lastStarTap = nil
        }

        emitters = []

        
    }
    
    //Remove Particles
    func removeEmitter(_ emitter: SKNode, time: TimeInterval){
        let fadeOutAction = SKAction.fadeOut(withDuration: time)
        let wait = SKAction.wait(forDuration: 1)
        
        emitter.run(.sequence([wait, fadeOutAction])){
            emitter.removeFromParent()
        }
    }
    
    
    //Spawna particles
    func spawnEmitter(pos: CGPoint, aurora:Aurora){
        // Verificar a distancia do ultimo toque
        //Detectar que a pessoa clicou
        let emitter = createEmitter(aurora:aurora)
        emitter.position = pos
        emitter.zPosition = 20
        addChild(emitter)
        let moveUp = SKAction.moveTo(y: pos.y+CGFloat.random(in: 2...5), duration: 1.7)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveTo(y: pos.y+CGFloat.random(in: (-5)...(-2)), duration: 1.7)
        moveDown.timingMode = .easeInEaseOut
        let sequence = SKAction.sequence([moveUp,moveDown])
        emitter.run(.repeatForever(sequence))
        
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
            let randomPosition = CGPoint(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -200...200))
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
    
    
    // MARK: TOUCHES
    func touchDown(atPoint pos : CGPoint) {
        //verificar se a pessoa tocou na primeira estrela
        if myEvolution == .yes{
            aurora = Aurora(randomHues: true, auroraMaxUpgrade: stars.count)
        }
        else{
            aurora = Aurora(randomHues: false, auroraMaxUpgrade: stars.count)
        }
        
        if starpath == .no {
            emitters = [] //lista vazia
            spawnEmitter(pos: pos, aurora: aurora)
        }
        else if starpath == .yes && nextStar?.contains(pos) ?? false  {

            followingStars = true
            
            //salva uma variavel o momento de agora para comparar com o toque da proxima estrela
            lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
            emitters = [] //lista vazia
            spawnEmitter(pos: pos, aurora: aurora)
            nextStar?.alpha = 0
            currentStarIndex += 1
            nextStar = stars[currentStarIndex]
            nextStar?.alpha = 1
        }

    }
    

    
    func touchMoved(toPoint pos : CGPoint) {
        //verifica se a pessoa está se aproximando da próxima estrela
        if starpath == .no{
            spawnEmitter(pos: pos, aurora: aurora)
            
        }
        
        else if followingStars == true && starpath == .yes{
            
    
            //se sim: colocar emitter na posição e verfiica se chegou na próxima estrela (tempo maior do que minimo: se menor: desmonta a aurora atual)
            spawnEmitter(pos: pos, aurora: aurora)
            if nextStar?.contains(pos) ?? false {

                getNextStar()
            }
        }

    }
    
    
    
    func touchUp(atPoint pos : CGPoint) {
        if starpath == .no{
            destroyAurora(time: 6, progressive: true)
        }
        else{
            
            //verifica se a pessoa passou em todas as estrelas
            followingStars = false
            if currentStarIndex < stars.count{
                
                destroyAurora(time: 1, progressive: false)
            }
            createStarPath(starCount: Int.random(in: 5...9))
        }

        
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

