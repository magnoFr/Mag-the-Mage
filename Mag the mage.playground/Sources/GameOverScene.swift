import Foundation
import SpriteKit

open class GameOverScene: SKScene {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let previousLocation = touch!.previousLocation(in: self)
        
        guard let gameScene = SKScene(fileNamed: "GameScene") else {return}
        gameScene.scaleMode = .aspectFit
        let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
        view?.presentScene(gameScene, transition: reveal)
        
        
    }
}
