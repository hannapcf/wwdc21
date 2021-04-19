//#-hidden-code

import PlaygroundSupport
import SpriteKit
import UIKit
import BookCore

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 768))
let scene = GameScene(fileNamed: "GameScene")!
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
    sceneView.ignoresSiblingOrder = true
    


PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
/*:
 
 # The Magic Hunt
  
  * Note: For a complete experience, use this playground in split landscape and the volume...
  
 You have just read a poem based on a Finnish folktale about the origin of the northern lights. Now, I invite you to participate in a visual experience created from generative art. Have you ever ventured to look for the northern lights?
  
  ### Tips:
  * Just like the child from the poem, **follow the stars** that appear in the sky.
   
  * **Be patient!** You should take it easy to truly experience this phenomena.
  
  * **Don't give up halfway!** It takes resilience to achieve our goals.


  # Do you want to create your personal aurora?
  If you wish, you can create your own experience by answering the quiz:
  
  * callout (answer):
  
     `.yes` \
     `.no`

  */

 //Do you feel like you're in control of your own life?
 var myMode: Answer = /*#-editable-code*/.yes/*#-end-editable-code*/

 // Do you enjoy being out of your comfort zone?
 var myEvolution: Answer = /*#-editable-code*/.yes/*#-end-editable-code*/

 // With every new experience, do you feel like a different person?
 var myChanges: Answer = /*#-editable-code*/.no/*#-end-editable-code*/

 // # - hidden code

scene.starpath = myMode == .yes ? .no : .yes
scene.myEvolution = myEvolution
scene.myChanges = myChanges
scene.startGame ()

 // # - end-hidden-code

/*:
Answer the quiz and then click **Run My Code**!
*/
