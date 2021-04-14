//
//  Aurora.swift
//  BookCore
//
//  Created by HANNA P C FERREIRA on 13/04/21.
//

import SpriteKit

public class Aurora{

    //Particles
    var particleBirthRateMin: CGFloat
    var particleBirthRateMax: CGFloat
    var particleBirthRate: CGFloat {
        CGFloat.random(in: particleBirthRateMin...particleBirthRateMax)
    }
    let particleTexture: SKTexture
    var particleLifeTime: CGFloat //aurora inteira
    
    //Position Range
    var particlePositionRange: CGVector
    let particleZPosition: CGFloat
    let emissionAngle: CGFloat
    let emissionAngleRange: CGFloat
    var particleSpeedMin: CGFloat
    var particleSpeedMax: CGFloat
    var particleSpeed: CGFloat {
        CGFloat.random(in: particleSpeedMin...particleSpeedMax)
    }
    let xAcceleration: CGFloat
    var yAcceleration: CGFloat
    
    //alpha
    let particleAlpha: CGFloat
    let particleAlphaRange: CGFloat
    let particleAlphaSpeed: CGFloat
    
    //scale
    var particleScaleSequence: SKKeyframeSequence //aurora inteira

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
    let particleColorSequence: SKKeyframeSequence

    
    public init() {
        
        //Particles
        particleBirthRateMin = CGFloat.random(in: 1...5)
        particleBirthRateMax = CGFloat.random(in: 6...15)
        particleTexture = SKTexture(imageNamed: "bola")
        particleLifeTime = CGFloat.random(in: 1.5...4)
        
        //Position Range
        particlePositionRange = CGVector(dx: 0, dy: 1)
        particleZPosition = 0
        emissionAngle = 90
        emissionAngleRange = 0.40
        particleSpeedMin = CGFloat.random(in: 10...15)
        particleSpeedMax = CGFloat.random(in: 20...30)
        xAcceleration = 0
        yAcceleration = CGFloat.random(in: 1...2)
        
        //alpha
        particleAlpha = 0.8
        particleAlphaRange = 1
        particleAlphaSpeed = 50
        
        //scale
        particleScaleSequence = SKKeyframeSequence() //aurora inteira
        particleScaleSequence.addKeyframeValue(0.07, time: 0)
        particleScaleSequence.addKeyframeValue(0.05, time: 1)
        particleScaleSequence.addKeyframeValue(0.04, time: 2)

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
        
        //color sequence
        particleColorSequence = SKKeyframeSequence()
        
        particleColorSequence.addKeyframeValue(UIColor(hue: CGFloat.random(in: 0...1), saturation: 20/100, brightness: 100/100, alpha: 0.3), time: 0)
        
        particleColorSequence.addKeyframeValue(UIColor(hue: CGFloat.random(in: 0...1), saturation: 80/100, brightness: 100/100, alpha: 0.5), time: CGFloat.random(in: 0.5...1))
        
        particleColorSequence.addKeyframeValue(UIColor(hue: CGFloat.random(in: 0...1), saturation: 100/100, brightness: 100/100, alpha: 0.04), time: CGFloat.random(in: 1...2.5))
        
        particleColorSequence.addKeyframeValue(UIColor(hue: CGFloat.random(in: 0...1), saturation: 70/100, brightness: 100/100, alpha: 0.15), time: CGFloat.random(in: 2.5...4))
        
    }
    
    //getters e setters
    
    
    //métodos
    


}
