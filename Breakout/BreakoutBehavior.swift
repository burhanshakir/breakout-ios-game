//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Burhanuddin Shakir on 30/03/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    var gravity = UIGravityBehavior()
    
    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
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
        dynamicAnimator?.referenceView?.addSubview(brick)
        
        collider.collisionMode = .boundaries
        
        collider.addBoundary(withIdentifier: name as NSCopying, from: CGPoint(x:brick.bounds.size.width - brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y), to: CGPoint(x :brick.bounds.size.width + brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y))
        
//        collider.addBoundary(withIdentifier: name as NSCopying, for: UIBezierPath(rect: brick.frame))

        
        collider.addItem(brick)
        itemBehavior.addItem(brick)
    }
    
    
    func addBoard(_ board: UIView) {
        dynamicAnimator?.referenceView?.addSubview(board)
        
        collider.collisionMode = .boundaries
        
//        collider.addBoundary(withIdentifier: "Board" as NSCopying, from: CGPoint(x:board.bounds.size.width - board.frame.origin.x, y : board.bounds.size.height - board.frame.origin.y), to: CGPoint(x :board.bounds.size.width + board.frame.origin.x, y : board.bounds.size.height - board.frame.origin.y))

        collider.addBoundary(withIdentifier: "BoardItem" as NSCopying, for: UIBezierPath(rect: board.frame))
        
        collider.addItem(board)
        itemBehavior.addItem(board)
    }
    
    func addBall(_ ball : UIView){
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        gravity.addItem(ball)
        itemBehavior.addItem(ball)
    }
    
    func launchBall(_ ball: UIView, _ board: UIView) {
        
        
        pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.instantaneous);
        pushBehavior.setAngle( .pi / -4 , magnitude: 1);
        pushBehavior.active = true
        
        addChildBehavior(pushBehavior)
        
        print("Board position during launch1: \(String(describing: board.frame.origin))")
        
    }
   
}
