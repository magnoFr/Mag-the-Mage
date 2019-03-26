//
//  GameScene.swift
//  Mag the mage
//
//  Created by Magno on 19/03/19.
//  Copyright © 2019 academysenac. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit

let playerC: UInt32 = 0x1 << 1
let groundC: UInt32 = 0x1 << 2
let shootC: UInt32 = 0x1 << 7
let enemyC: UInt32 = 0x1 << 8
let princessC: UInt32 = 0x1 << 3
let racketC: UInt32 = 0x1 << 4
let racket2C: UInt32 = 0x1 << 5
let manaC: UInt32 = 0x1 << 6


class GameScene: SKScene {
    var player: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var shootButton: SKSpriteNode!
    var racket: SKSpriteNode!
    var ground: SKSpriteNode!
    var racket2: SKSpriteNode!
    var shoot: SKSpriteNode!
    var stick: SKSpriteNode!
    var mana: SKSpriteNode!
    
    var i = 15
    var y = 20
    var life: SKLabelNode!
    //var lifePoint = "X\(i)"
    var manaLife: SKLabelNode!
    //var lifeManaPoint = "X\(y)"
    
    var AudioPlayer = AVAudioPlayer()
    var Aplayer: AVAudioPlayer?
    var spellCast: AVAudioPlayer?
    var dispell: AVAudioPlayer?
    
    var isShooting = false
    var isMovingLeft = false
    var isMovingRight = false
    var isMoving = false
    
    
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
        
        playSound()
        
        life = childNode(withName: "life") as! SKLabelNode
        life.text = "X\(i)"
        manaLife = childNode(withName: "lifeMana") as! SKLabelNode
        manaLife.text = "X\(y)"
        
        //Creating ground
        ground = childNode(withName: "ground") as! SKSpriteNode
        ground.physicsBody?.categoryBitMask = groundC
        
        //Creating player
        player = childNode(withName: "player") as! SKSpriteNode
        player.physicsBody?.categoryBitMask = playerC
        player.physicsBody?.contactTestBitMask = playerC
        player.physicsBody?.collisionBitMask = groundC
        
        
        //Crating buttons
        jumpButton = childNode(withName: "jump") as! SKSpriteNode
        jumpButton.name = "jumpButton"
        downButton = childNode(withName: "down") as! SKSpriteNode
        downButton.name = "downButton"
        shootButton = childNode(withName: "shoot") as! SKSpriteNode
        shootButton.name = "shootButton"
        leftButton = childNode(withName: "left") as! SKSpriteNode
        leftButton.name = "leftButton"
        rightButton = childNode(withName: "right") as! SKSpriteNode
        rightButton.name = "rightButton"
        
        //Creating a racket
        racket = childNode(withName: "racket") as! SKSpriteNode
        racket.physicsBody?.categoryBitMask = racketC
        racket2 = childNode(withName: "racket2") as! SKSpriteNode
        racket2.physicsBody?.categoryBitMask = racket2C
        
        //Creating the mana crystal
        mana = childNode(withName: "mana") as! SKSpriteNode
        mana.physicsBody?.categoryBitMask = manaC
        mana.physicsBody?.contactTestBitMask = enemyC
        mana.physicsBody?.collisionBitMask = enemyC
        
        var _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addStick), userInfo: nil, repeats: true)
        var _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(enemyToPlayer), userInfo: nil, repeats: true)
        
        self.physicsWorld.contactDelegate = self
        //view.showsPhysics = true
        
    }
    
    
    var lastShootingTime : CFTimeInterval = 0
    var delayBetweenShots : CFTimeInterval = 0.38
    var lastMoveTime: CFTimeInterval = 0
    var dalayMove : CFTimeInterval = 0.1
    
    override func update(_ currentTime: TimeInterval) {
        check()
        
        if isShooting{
            let delay = currentTime - lastShootingTime
            if delay >= delayBetweenShots {
                Shoot()
                lastShootingTime = currentTime
            }
        }
        
        if isMoving{
            let delay = currentTime - lastMoveTime
            if delay >= dalayMove {
                player.run(move(), withKey: "moveLeft")
                lastMoveTime = currentTime
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            //touch = touches.first! as UITouch
            let positionInScene = touch.location(in: self)
            let touchedNode =  self.atPoint(positionInScene)
            
            if let name = touchedNode.name{
                
                if name == "jumpButton"{
                    player.run(SKAction.animate(with: [SKTexture( imageNamed: "jumping"), SKTexture(imageNamed: "w1")], timePerFrame: 0.5), withKey: "jump2")
                    player.run(jump(), withKey: "jump")
                    
                }
                
                if name == "downButton"{
                    player.position.y = player.position.y - CGFloat(11)
                    down()
                    print("QUERO DESCER")
                }
                
                if name == "shootButton"{
                    isShooting = true
                }
                
                if name == leftButton.name{
                    isMovingLeft = true
                    isMoving = true
                    let walk = SKAction.animate(with: [SKTexture(imageNamed: "w1"), SKTexture(imageNamed: "w2")], timePerFrame: 0.2)
                    let walkForever = SKAction.repeatForever(walk)
                    player.run(walkForever, withKey: "walking")
                }
                
                if name == rightButton.name{
                    isMovingRight = true
                    isMoving = true
                }
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode =  self.atPoint(positionInScene)
        
        player.removeAction(forKey: "jump")
        
        if let name = touchedNode.name{
            
            if name == "jumpButton"{
                
            }
            
            if name == "downButton"{
                player.position.y = player.position.y - CGFloat(11)
            }
            
            if name == "shootButton"{
                isShooting = false
            }
            
            if name == leftButton.name{
                isMovingLeft = false
                isMoving = false
                player.removeAction(forKey: "moveLeft")
                player.removeAction(forKey: "walking")
            }
            
            if name == rightButton.name{
                isMovingRight = false
                isMoving = false
                player.removeAction(forKey: "moveLeft")
                player.removeAction(forKey: "walking")
            }
            
        }
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode =  self.atPoint(positionInScene)
        
        player.removeAction(forKey: "jump")
        
        if let name = touchedNode.name{
            
            if name == "jumpButton"{
                
            }
            
            if name == "downButton"{
                player.position.y = player.position.y - CGFloat(11)
            }
            
            if name == "shootButton"{
                isShooting = false
            }
            
            if name == leftButton.name{
                isMovingLeft = false
                isMoving = false
                player.removeAction(forKey: "moveLeft")
                player.removeAction(forKey: "walking")
            }
            
            if name == rightButton.name{
                isMovingRight = false
                isMoving = false
                player.removeAction(forKey: "moveLeft")
                player.removeAction(forKey: "walking")
            }
            
        }
        
        
    }
    
    
    
    func playSound() {
        let url = Bundle.main.url(forResource: "PerituneMaterial_BattleField2_loop", withExtension: "mp3")!
        
        do {
            Aplayer = try AVAudioPlayer(contentsOf: url)
            guard let player = Aplayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func castSpell() {
        let url = Bundle.main.url(forResource: "spell", withExtension: "mp3")!
        
        do {
            spellCast = try AVAudioPlayer(contentsOf: url)
            guard let player = spellCast else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func diSpell() {
        let url = Bundle.main.url(forResource: "disapper", withExtension: "wav")!
        
        do {
            dispell = try AVAudioPlayer(contentsOf: url)
            guard let player = dispell else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func jump() -> SKAction{
        let jump = SKAction.moveBy(x: 0, y: 420, duration: 0.4)
        return jump
    }
    
    func down(){
        playerContact = false
    }
    
    var direction = CGFloat()
    func move() -> SKAction{
        if isMovingRight{
            direction = -1
        }
        else if isMovingLeft { direction = 1}
        
        let moveLeftAction = SKAction.moveBy(x: -20 * direction, y: 0, duration: 0.1)
        let repeatForever = SKAction.repeatForever(moveLeftAction)
        
        
        let sequence = SKAction.sequence([moveLeftAction,repeatForever])
        return sequence
    }
    
    func Shoot(){
        
        shoot = SKSpriteNode(imageNamed: "ball")
        shoot.position = player.position
        shoot.position.x += 100
        shoot.scale(to: CGSize(width: 35, height: 20))
        
        shoot.physicsBody = SKPhysicsBody(texture: shoot.texture!,
                                          size: CGSize(width: shoot.texture!.size().width * 0.05, height: shoot.texture!.size().height * 0.05) )
        shoot.physicsBody?.categoryBitMask = shootC
        shoot.physicsBody?.contactTestBitMask = enemyC
        shoot.physicsBody?.collisionBitMask = enemyC
        shoot.physicsBody?.isDynamic = false
        shoot.physicsBody?.affectedByGravity = false
        shoot.physicsBody?.usesPreciseCollisionDetection = true
        
        
        self.addChild(shoot)
        
        let move = SKAction.moveTo(x: 1440, duration: 1.5)
        let removeChild = SKAction.removeFromParent()
        var actionArray = [SKAction]()
        actionArray.append(move)
        actionArray.append(removeChild)
        shoot.run(SKAction.sequence(actionArray))
        
        player.run(SKAction.animate(with: [SKTexture( imageNamed: "shoot"), SKTexture(imageNamed: "w1")], timePerFrame: 0.5), withKey: "shot")
        
        castSpell()
        
    }
    
    @objc func addStick() {
        
        var stickAray = [CGPoint(x: 1440 , y: -200), CGPoint(x: 1440 , y: 0), CGPoint(x: 1440 , y: 280)]
        
        stick = SKSpriteNode(imageNamed: "enemy")
        let random = Int(arc4random_uniform(UInt32(stickAray.count)))
        stick.position = stickAray[random]
        stick.scale(to: CGSize(width: 70, height: 60))
        self.addChild(stick)
        
        
        stick.physicsBody = SKPhysicsBody(texture: stick.texture!,
                                          size: CGSize(width: stick.texture!.size().width * 0.05, height: stick.texture!.size().height * 0.05) )
        stick.physicsBody?.categoryBitMask = enemyC
        stick.physicsBody?.contactTestBitMask = playerC | manaC
        stick.physicsBody?.collisionBitMask = playerC | shootC | manaC
        stick.physicsBody?.isDynamic = true
        stick.physicsBody?.affectedByGravity = false
        
        
        
        let move = SKAction.move(to: mana.position, duration: 10)
        let stickRotation = SKAction.rotate(byAngle: 360, duration: 0.1)
        let forever = SKAction.repeatForever(stickRotation)
        let group = SKAction.group([move])
        let removeChild = SKAction.removeFromParent()
        var actionArray = [SKAction]()
        actionArray.append(group)
        actionArray.append(removeChild)
        stick.run(SKAction.sequence(actionArray), withKey: "Move")
        stick.run(forever, withKey: "rotate")
        
    }
    
    @objc func enemyToPlayer() {
        
        var stickAray = [CGPoint(x: 1240 , y: -400), CGPoint(x: 1340 , y: 400), CGPoint(x: -800 , y: 0)]
        
        stick = SKSpriteNode(imageNamed: "enemy")
        let random = Int(arc4random_uniform(UInt32(stickAray.count)))
        stick.position = stickAray[random]
        stick.scale(to: CGSize(width: 70, height: 60))
        self.addChild(stick)
        
        
        stick.physicsBody = SKPhysicsBody(texture: stick.texture!,
                                          size: CGSize(width: stick.texture!.size().width * 0.05, height: stick.texture!.size().height * 0.05) )
        stick.physicsBody?.categoryBitMask = enemyC
        stick.physicsBody?.contactTestBitMask = playerC | manaC
        stick.physicsBody?.collisionBitMask = playerC | shootC | manaC
        stick.physicsBody?.isDynamic = true
        stick.physicsBody?.affectedByGravity = false
        
        
        
        let move = SKAction.move(to: player.position, duration: 10)
        let stickRotation = SKAction.rotate(byAngle: 360, duration: 0.1)
        let forever = SKAction.repeatForever(stickRotation)
        let group = SKAction.group([move])
        let removeChild = SKAction.removeFromParent()
        var actionArray = [SKAction]()
        actionArray.append(group)
        actionArray.append(removeChild)
        stick.run(SKAction.sequence(actionArray), withKey: "Move")
        stick.run(forever, withKey: "rotate")
        
    }
    
    func check(){
        if player.position.y >= racket.position.y - 10 + racket.size.height/2 + player.size.height/2 {
            playerContact = true
            if playerContact{
                player.physicsBody?.collisionBitMask = groundC | racketC
            }
            
        } else {
            playerContact = false
            player.physicsBody?.collisionBitMask = groundC
        }
        
        if player.position.y > racket2.position.y - 10 + racket2.size.height/2 + player.size.height/2 {
            playerContact2 = true
            if playerContact2{
                player.physicsBody?.collisionBitMask = groundC | racket2C
            }
            
        }
        
    }
    
}
var playerContact = false
var playerContact2 = false
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        
        
        if bodyA == enemyC && bodyB == shootC{
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
            
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
            
            diSpell()
        }
        
        if bodyA == shootC && bodyB == enemyC{
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
            
            diSpell()
        }
        
        if bodyA == manaC && bodyB == enemyC{
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
            
            y -= 1
            
            if y == 0 {
                guard let gameScene = SKScene(fileNamed: "GameOverScene") else {return}
                gameScene.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                view?.presentScene(gameScene, transition: reveal)
            }
            
        }
        if bodyB == manaC && bodyA == enemyC{
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
            
            y -= 1
            
            if y == 0 {
                guard let gameScene = SKScene(fileNamed: "GameOverScene") else {return}
                gameScene.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                view?.presentScene(gameScene, transition: reveal)
                self.Aplayer?.stop()
            }
        }
        
        if bodyB == enemyC && bodyA == playerC{
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
            
            i -= 1
            
            player.run(SKAction.animate(with: [SKTexture( imageNamed: "hurt"), SKTexture(imageNamed: "w1")], timePerFrame: 0.5), withKey: "dameged")
            
            if i == 0 {
                guard let gameScene = SKScene(fileNamed: "GameOverScene") else {return}
                gameScene.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                view?.presentScene(gameScene, transition: reveal)
                self.Aplayer?.stop()
            }
        }
        
        manaLife.text = "X\(y)"
        life.text = "X\(i)"
    }
}













