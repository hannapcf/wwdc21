//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code

import PlaygroundSupport
import SpriteKit
import UIKit
import BookCore

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 1366, height: 1024))
let scene = Cutscene(size: CGSize(width: 1366, height: 1024))
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
    sceneView.ignoresSiblingOrder = true
    


PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true
