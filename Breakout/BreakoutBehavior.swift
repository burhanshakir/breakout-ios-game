//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Burhanuddin Shakir on 30/03/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit


class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var gravity = UIGravityBehavior()
    
    var bricks: [String:UIView] = [:]
    var ballElasticty:Double = 0
    
    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.collisionMode = .boundaries
        collider.collisionDelegate=self

        return collider
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehaviour =  UIDynamicItemBehavior()
        itemBehaviour.allowsRotation = false
        itemBehaviour.elasticity = 0.5
        itemBehaviour.friction = 0.0
        itemBehaviour.resistance = 0.0
        
        return itemBehaviour
    }()
    
    var pushBehavior = UIPushBehavior()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addBrick(_ brick: UIView, named name: String) {
        
        collider.removeBoundary(withIdentifier: name as NSCopying)

        collider.addBoundary(withIdentifier: name as NSCopying, for: UIBezierPath(rect: brick.frame))
        
        bricks[name] = brick
        
        
    }
    
    // Adding collision boundaries
    func addBoundary(_ path:UIBezierPath, identifier:String){
        collider.removeBoundary(withIdentifier: identifier as NSCopying)
        collider.addBoundary(withIdentifier: identifier as NSCopying, for: path)
    }
    
    // Displaying ball(s) for the game
    func addBall(_ ball : UIView, elasticity: Double){
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        gravity.addItem(ball)
        ballElasticty = elasticity
        itemBehavior.elasticity = CGFloat(elasticity)
        itemBehavior.addItem(ball)
    }
    
    // Launching ball on tap
    func launchBall(_ balls: [UIView], _ board: UIView) {
        
        
        pushBehavior = UIPushBehavior(items: balls, mode: UIPushBehaviorMode.instantaneous);
        pushBehavior.setAngle( .pi / -4 , magnitude: 0.5);
        pushBehavior.active = true
        
        addChildBehavior(pushBehavior)
        
        print("Board position during launch1: \(String(describing: board.frame.origin))")
        
    }
    
    func removeBrickAndBoard(_ view: UIView) {
        
        collider.removeAllBoundaries()
        bricks.removeAll()
        view.removeFromSuperview()
    }
    
    func remove(forIdentifier name: NSCopying){
        collider.removeBoundary(withIdentifier: name)
        
        let brick:UIView = bricks[name as! String]!
        
//        UIView.animate(withDuration: 1,delay:0.5, animations: {brick.removeFromSuperview()})
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            brick.removeFromSuperview()
        }, completion: nil)
        
        bricks.removeValue(forKey: name as! String)
        if bricks.count == 0{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "game over"), object: nil)
        }
        
        
    
    }

    func removeBall(_ ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        itemBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        // Events when ball collides with different game objects
        if identifier as! String == "wall"{
            print("TOUCHED WALL")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "game over"), object: nil)
            
        }
        else if identifier as! String == "boardItem"{
            print("TOUCHED BOARD")
            
            
            let linVeloc = itemBehavior.linearVelocity(for: item)
            itemBehavior.addLinearVelocity(CGPoint(x: linVeloc.x/CGFloat(ballElasticty*1.5), y: linVeloc.y/CGFloat(ballElasticty*1.5)), for: item)
            
        }
            
        else {
            print("TOUCHED BRICK")

            remove(forIdentifier: identifier!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "add score"), object: nil)


        }
        
      
    }
    
}
