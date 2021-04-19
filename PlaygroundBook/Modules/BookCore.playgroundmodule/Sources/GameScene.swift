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
        
        
        
        //Adicionando background
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background)
        background1.zPosition = 80
        background1.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background1)
        
        view.showsFPS = true
        
        GSAudio.sharedInstance.playSound(soundFileName: "theMagicHunt")
        
    }
    
    
    public func startGame(){
        
        if starpath == .yes{
            createStarPath(starCount: 5)
        }
        else{
            createStarPath(starCount: 10)
        }
    }
    
    // MARK: SOUNDS
    class GSAudio: NSObject, AVAudioPlayerDelegate {

        static let sharedInstance = GSAudio()

        private override init() {}

        var players = [NSURL:AVAudioPlayer]()
        var duplicatePlayers = [AVAudioPlayer]()

        func playSound (soundFileName: String){

            let soundFileNameURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: soundFileName, ofType: "mp3")!)

            if let player = players[soundFileNameURL] { //player for sound has been found

                if player.isPlaying == false { //player is not in use, so use that one
                    player.prepareToPlay()
                    player.play()

                } else { // player is in use, create a new, duplicate, player and use that instead

                    let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                    //use 'try!' because we know the URL worked before.

                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing

                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()

                }
            } else { //player has not been found, create a new player with the URL if possible
                do{
                    let player = try AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                    players[soundFileNameURL] = player
                    player.prepareToPlay()
                    player.volume = 0.1
                    player.play()
                } catch {
                    print("Could not play sound file!")
                }
            }
        }

        func stopAll() {
          players.forEach { $0.1.stop() }
          duplicatePlayers.forEach { $0.stop() }
          players.removeAll()
          duplicatePlayers.removeAll()
        }
    }
    
    
    //MARK: LABELS
    
    func setLabel(text: String, alpha: CGFloat, wait: TimeInterval){
        var label:SKLabelNode!
        label = SKLabelNode(text: text)
        label.fontColor = .white
        label.zPosition = 2000
        label.fontSize = 20
        label.alpha = alpha
        label.position = CGPoint(x: 0, y: 200)
        let labelFadeIn = SKAction.fadeIn(withDuration: 1)
        let labelFadeOut = SKAction.fadeOut(withDuration: 2)
        let labelWait = SKAction.wait(forDuration: wait)
        label.run(.sequence([labelFadeIn, labelWait, labelFadeOut]))
        label.name = "tip"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        for tip in children where tip.name == "tip"{
            tip.removeAllActions()
            tip.removeFromParent()
        }
        self.addChild(label)
    }
    
    // MARK: METHODS

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
            let previousStar = nextStar
            nextStar = stars[currentStarIndex]
            let starDistance = distance(p1: previousStar!.position, p2: nextStar!.position)
            let timeFor100 = Double(1)
            nextStarMinTime = (Double(starDistance)/100 * timeFor100)
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
        followingStars = false
        
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
            star.setScale(0.05)
            star.alpha = 0
            let starFadeIn = SKAction.scale(to: 0.04, duration: 2)
            let starFadeOut = SKAction.scale(to: 0.06, duration: 2)
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
            //lastStarTap = Date().timeIntervalSince1970 //salvando no ultimo tap o momento de agora
            emitters = [] //lista vazia
            spawnEmitter(pos: pos, aurora: aurora)
            getNextStar()
//            nextStar?.alpha = 0
//            currentStarIndex += 1
//            nextStar = stars[currentStarIndex]
//            nextStar?.alpha = 1
        }

    }
    
    func distance(p1: CGPoint, p2: CGPoint) -> CGFloat{
        sqrt(pow((p2.x - p1.x), 2)+(pow((p2.y-p1.y), 2)))
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
                let currentTime = Date().timeIntervalSince1970
                let dif = currentTime - (lastStarTap!)
                if dif < nextStarMinTime!{
                    destroyAurora(time: 1, progressive: false)
                    //MARK: ERRO AQUI
                    setLabel(text: "be patient...\nchasing the northern lights takes time", alpha: 0, wait: 2)
                    createStarPath(starCount: Int.random(in: 3...6))
                }
                else{
                    getNextStar()
                }
                
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
                setLabel(text: "chase the stars!\ndrag your finger over them", alpha: 0, wait: 2)
                destroyAurora(time: 1, progressive: false)
            }
            createStarPath(starCount: Int.random(in: 3...6))
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

