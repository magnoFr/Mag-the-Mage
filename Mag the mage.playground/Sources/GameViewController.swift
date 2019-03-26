import UIKit
import SpriteKit
import GameplayKit

open class GameViewController: UIViewController {
    
    var sceneView: SKView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
        
        sceneView = SKView(frame: CGRect(x:0 , y:0, width: self.view.frame.width, height: self.view.frame.height))
        if let scene = GameScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            let gameScene = scene
            gameScene.scaleMode = .aspectFill
            sceneView.presentScene(gameScene)
            // Present the scene
            self.view.addSubview(sceneView)
        }
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
