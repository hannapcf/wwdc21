//
//  Aurora.swift
//  BookCore
//
//  Created by HANNA P C FERREIRA on 13/04/21.
//

import SpriteKit

public class Aurora{
    
    //atributos
    var auroraMaxUpgrade: Int
    var auroraCurrentLevel: Int = 0
    
    //Particles
    var particleBirthRateMin: CGFloat = -1 //ignorado pois construtor seta
    var particleBirthRateMax: CGFloat = -1 //ignorado pois construtor seta
    var particleBirthRate: CGFloat {
        CGFloat.random(in: particleBirthRateMin...particleBirthRateMax)
    }
    let particleTexture: SKTexture
    var particleLifeTime: CGFloat = -1 //ignorado pois construtor seta
    
    //Position Range
    var particlePositionRange: CGVector = .zero //ignorado pois construtor seta
    let particleZPosition: CGFloat
    let emissionAngle: CGFloat
    let emissionAngleRange: CGFloat
    var particleSpeedMin: CGFloat = -1 //ignorado pois construtor seta
    var particleSpeedMax: CGFloat = -1 //ignorado pois construtor seta
    var particleSpeed: CGFloat {
        CGFloat.random(in: particleSpeedMin...particleSpeedMax)
    }
    let xAcceleration: CGFloat
    var yAcceleration: CGFloat = -1 //ignorado pois construtor seta
    
    //alpha
    let particleAlpha: CGFloat
    let particleAlphaRange: CGFloat
    let particleAlphaSpeed: CGFloat
    
    //scale
    var particleScaleSequence: SKKeyframeSequence = SKKeyframeSequence()

    //rotation
    let particleRotation: CGFloat
    let particleRotationRange: CGFloat
    let particleRotationSpeed: CGFloat
    
    //color blend
    let particleColorBlendFactor: CGFloat
    let particleColorBlendFactorRange: CGFloat
    let particleColorBlendFactorSpeed: CGFloat
    
    //blend mode
    let particleBlendMode: SKBlendMode
    
    //color sequence
    var particleColorSequence: SKKeyframeSequence = SKKeyframeSequence()
    let originalColorsHues: [CGFloat]
    
    public init(auroraMaxUpgrade: Int) {
        
        self.auroraMaxUpgrade = auroraMaxUpgrade
        
        //particles
        particleTexture = SKTexture(imageNamed: "meuspark")
        
        
        //position Range
        particleZPosition = 0
        emissionAngle = 90
        emissionAngleRange = 0.40
        xAcceleration = 0
 
        
        //alpha
        particleAlpha = 0.8
        particleAlphaRange = 1
        particleAlphaSpeed = 50
        

        //rotation
        particleRotation = 0
        particleRotationRange = 0
        particleRotationSpeed = 0
        
        //color blend
        particleColorBlendFactor = 1
        particleColorBlendFactorRange = 0
        particleColorBlendFactorSpeed = 0
        
        //blend mode
        particleBlendMode = .alpha
        
        originalColorsHues = [CGFloat.random(in: 0...1),
                              CGFloat.random(in: 0...1),
                              CGFloat.random(in: 0...1),
                              CGFloat.random(in: 0...1)]
        
        upgrade()
        
        
    }
    
    //getters e setters
    
    
    //upgrade aurora
    func upgrade(){
        
        auroraCurrentLevel += 1
        
        let proportion = CGFloat(auroraCurrentLevel)/CGFloat(auroraMaxUpgrade)
        
        //particle
        particleBirthRateMin = CGFloat.random(in: 1...5) * proportion
        particleBirthRateMax = CGFloat.random(in: 6...15) * proportion
        particleLifeTime = CGFloat.random(in: 1.5...4) * proportion
        
        //position range
        particlePositionRange = CGVector(dx: 0, dy: 1)
        particleSpeedMin = CGFloat.random(in: 10...15) * proportion
        particleSpeedMax = CGFloat.random(in: 20...30) * proportion
        yAcceleration = CGFloat.random(in: 1...2) * proportion
        
        //scale
        particleScaleSequence = SKKeyframeSequence() //aurora inteira
        particleScaleSequence.addKeyframeValue(0.07, time: 0)
        particleScaleSequence.addKeyframeValue(0.05, time: 1)
        particleScaleSequence.addKeyframeValue(0.04, time: 2)
        
        //color sequence
        particleColorSequence = SKKeyframeSequence()
        
        particleColorSequence.addKeyframeValue(UIColor(hue: originalColorsHues[0], saturation: 20/100 * proportion, brightness: 100/100, alpha: 0.3), time: 0)
        
        particleColorSequence.addKeyframeValue(UIColor(hue: originalColorsHues[1], saturation: 80/100 * proportion, brightness: 100/100, alpha: 0.5), time: CGFloat.random(in: 0.5...1))
        
        particleColorSequence.addKeyframeValue(UIColor(hue: originalColorsHues[2], saturation: 100/100 * proportion, brightness: 100/100, alpha: 0.04), time: CGFloat.random(in: 1...2.5))
        
        particleColorSequence.addKeyframeValue(UIColor(hue: originalColorsHues[3], saturation: 70/100 * proportion, brightness: 100/100, alpha: 0.15), time: CGFloat.random(in: 2.5...4))
    }


}
