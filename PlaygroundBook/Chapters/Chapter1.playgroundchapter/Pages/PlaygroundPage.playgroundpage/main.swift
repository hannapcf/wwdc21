//#-hidden-code

import PlaygroundSupport
import SpriteKit
import UIKit
import BookCore

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 768))
if let scene = GameScene(fileNamed: "GameScene") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
    sceneView.ignoresSiblingOrder = true
    
}

PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
/*:
 
 # The Magic Hunt
 
 * Note: Para uma experiência completa, utilize este playground em tela cheia e no modo livro, não esqueça de usar seu headset.
 
Você acabou de ler um poema de uma lenda finlandesa sobre a origem das auroras boreais.  Agora te convido a participar de uma experiência visual criada a partir de arte generativa. Você já se aventurou a procurar a aurora boreal?
 
 ### Dicas:
 * Assim como a criança, **siga as estrelas** que vão surgindo no céu.
  
 * **Seja paciente!** É necessário ir com calma para experenciar esses fenomênos.
 
 * **Não desista no meio do caminho!** É preciso resiliência para alcançar nossos objetivos.
 
 
 * Note: **Você notou que a cada estrela a aurora muda e sempre que encontra sua aurora boreal completa, um novo caminho de estrelas se forma?**
 \
Isso acontece pois evoluimos a cada nova experiência em nossas vidas, e, quando fechamos um ciclo, é preciso abrir novos caminhos para que a gente se mantenha sempre evoluindo!
 
 Mesmo se tentar, nunca conseguirá reproduzir a mesma aurora, nós não temos controle total sobre a vida, ela depende de fatores externos, e isso é ótimo! A zona de conforto não contribui para a evolução.
 

 # Quer ter novas experiências?
 
 Responda o quiz com true or false:
 
 * callout(Answer):
 
    `.yes`\
    `.no`

 */

//Você prefere que outras pessoas escolham o rumo da sua vida?
//starpath on(true) or off(false)
var myMode : Answer = /*#-editable-code*/.yes/*#-end-editable-code*/

// Você evolui a cada experiência?
//aurora não muda a cor (false) ou aurora muda a cor (true)
var myEvolution : Answer = /*#-editable-code*/.yes/*#-end-editable-code*/

//A cada experiência você é uma nova pessoa?
//Starpath: A aurora toda muda a cada estrela(true) ou as partes da aurora mudam(false)
//funMode: Cada aurora é de uma cor(true) ou A aurora tem várias cores(false)
var myChanges : Answer = /*#-editable-code*/.yes/*#-end-editable-code*/

//#-hidden-code

scene?.starpath = myMode
scene?.myEvolution = myEvolution
scene?.myChanges = myChanges
scene?.startGame()

//#-end-hidden-code

