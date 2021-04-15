//
//  Cutscene.swift
//  BookCore
//
//  Created by HANNA P C FERREIRA on 15/04/21.
//

import Foundation
import SpriteKit


public class Cutscene: SKScene{
    
    var background = SKSpriteNode(imageNamed: "cutsceneBackground")
    var poem = SKSpriteNode(imageNamed: "poem1")
    var page: Int = 1
    var nextButtonEnable = true
    var beforeButtonEnable = false
    var nextButton = SKSpriteNode(imageNamed: "next")
    var beforeButton = SKSpriteNode(imageNamed: "before")
    var pageControl = SKSpriteNode(imageNamed: "pageControl1")
    var pageControl0 = SKSpriteNode(imageNamed: "pageControl0")
    
    func setUpButton(){
        
        nextButton.position = CGPoint(x: self.size.width*0.9, y: self.frame.midY)
        nextButton.setScale(0.1)
        nextButton.zPosition = 1000
        nextButton.alpha = 1
        addChild(nextButton)
        
        beforeButton.position = CGPoint(x: self.size.width*0.1, y: self.frame.midY)
        beforeButton.setScale(0.1)
        beforeButton.zPosition = 1000
        beforeButton.alpha = 0
        addChild(beforeButton)
    }
    
    public override func didMove(to view: SKView) {
        
        
        
        //Adicionando background
        background.zPosition = 0
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background) //Adicionando background
        //Adicionando poema
        poem.zPosition = 1
        poem.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(poem) //Adicionando background
        //Page Control
        pageControl.zPosition = 2
        pageControl.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(pageControl) //Adicionando background
        //Page Control
        pageControl0.zPosition = 1.5
        pageControl0.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(pageControl0) //Adicionando background
        
        setUpButton()
    }
    
    func changePoem(){
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let changePoem = SKAction.setTexture(SKTexture(imageNamed: "poem\(page)"))
        let pageControle = SKAction.setTexture(SKTexture(imageNamed: "pageControl\(page)"))
        
        poem.run(SKAction.sequence([fadeOut, changePoem, fadeIn]))
        pageControl.run(SKAction.sequence([fadeOut, pageControle, fadeIn]))
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if nextButton.contains(pos) && nextButtonEnable == true{
            page += 1
            if page > 2 {
                
                nextButtonEnable = false
                nextButton.alpha = 0
                
            }
            beforeButtonEnable = true
            beforeButton.alpha = 1
            changePoem()
        }
        if beforeButton.contains(pos) && beforeButtonEnable == true{
            page -= 1
            if page < 2 {
                beforeButtonEnable = false
                beforeButton.alpha = 0
            }
            
            nextButtonEnable = true
            nextButton.alpha = 1
            changePoem()
        }
        
        

    }

    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
}


