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
        
    }
    
    func addBrick(_ brick: UIView) {
        dynamicAnimator?.referenceView?.addSubview(brick)
        
        collider.collisionMode = .boundaries
        
        collider.addBoundary(withIdentifier: "brick" as NSCopying, from: CGPoint(x:brick.bounds.size.width - brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y), to: CGPoint(x :brick.bounds.size.width + brick.frame.origin.x, y : brick.bounds.size.height + brick.frame.origin.y))
        
        collider.addItem(brick)
        itemBehavior.addItem(brick)
    }
    
    func addBoard(_ board: UIView) {
        dynamicAnimator?.referenceView?.addSubview(board)
        
        collider.collisionMode = .boundaries
        
        collider.addBoundary(withIdentifier: "board" as NSCopying, from: CGPoint(x:board.bounds.size.width - board.frame.origin.x, y : board.bounds.size.height - board.frame.origin.y), to: CGPoint(x :board.bounds.size.width + board.frame.origin.x, y : board.bounds.size.height - board.frame.origin.y))
        
        
        collider.addItem(board)
        itemBehavior.addItem(board)
    }
    
    func launchBall(_ ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        
        pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.instantaneous);
        pushBehavior.setAngle( .pi / -2 , magnitude: 10);
        pushBehavior.active = true

        collider.addItem(ball)
        itemBehavior.addItem(ball)
        
        addChildBehavior(pushBehavior)
        
    }
   
}
