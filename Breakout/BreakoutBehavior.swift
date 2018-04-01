//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Burhanuddin Shakir on 30/03/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

var bricks: [String:UIView] = [:]

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var gravity = UIGravityBehavior()
    
    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.collisionMode = .boundaries
        collider.collisionDelegate=self

        return collider
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehaviour =  UIDynamicItemBehavior()
        itemBehaviour.allowsRotation = true
        itemBehaviour.elasticity = 0.8
        return itemBehaviour
    }()
    
    var pushBehavior = UIPushBehavior()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
        addChildBehavior(pushBehavior)
        
    }
    
    func addBrick(_ brick: UIView, named name: String) {
//        dynamicAnimator?.referenceView?.addSubview(brick)
        
//        collider.collisionMode = .boundaries
//
//        collider.addBoundary(withIdentifier: name as NSCopying, from: CGPoint(x:brick.bounds.size.width - brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y), to: CGPoint(x :brick.bounds.size.width + brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y))
        
        collider.removeBoundary(withIdentifier: name as NSCopying)

        
        collider.addBoundary(withIdentifier: name as NSCopying, for: UIBezierPath(rect: brick.frame))
        
        bricks[name] = brick
        
//        collider.addItem(brick)
//        itemBehavior.addItem(brick)
        
    }
    
    
    func addBoardBoundary(_ board: UIView){
        collider.removeBoundary(withIdentifier: "boardItem" as NSCopying)
        collider.addBoundary(withIdentifier: "boardItem" as NSCopying, for: UIBezierPath(rect: board.frame))
    }
    
    func addBall(_ ball : UIView){
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        gravity.addItem(ball)
        itemBehavior.addItem(ball)
    }
    
    func launchBall(_ balls: [UIView], _ board: UIView) {
        
        
        pushBehavior = UIPushBehavior(items: balls, mode: UIPushBehaviorMode.instantaneous);
        pushBehavior.setAngle( .pi / -4 , magnitude: 1);
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
        
        brick.removeFromSuperview()
    }

    func removeBall(_ ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        itemBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if identifier as! String != "boardItem"{
            print("TOUCHED BRICK")
            
            remove(forIdentifier: identifier!)
            
        }
    }
    
}
