//
//  BreakoutVC.swift
//  Breakout
//
//  Created by Burhanuddin Shakir on 30/03/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class BreakoutVC: UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet weak var gameView: GameView!
    
    var boardView : BoardView?
    var ballView : BallView?
    
    let defaults: UserDefaults = UserDefaults.standard

    var isBallReleased : Bool = false
    
    private var breakoutBehavior = BreakoutBehavior()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        animator.addBehavior(self.breakoutBehavior)
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.delegate = self
        
        updateUI()
    }
    
    func updateUI(){
        displayBricks()
        displayBoard()
        dropBall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        removeAllViews()
        updateUI()
    }
    
    func removeAllViews(){
        for subview in gameView.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func displayBricks(){
        
        let brickWidth = gameView.bounds.size.width/5
        let brickHeight = 30
        var numberOfBricks = 25
        
        if let bricks = defaults.object(forKey: "numberOfBricks") as? Int{
            numberOfBricks = bricks
        }
        for index in 0...(numberOfBricks-1){
            
            let row = index / 5
            let column = index % 5
            
            var brick = CGRect()
            
            brick.origin = CGPoint.zero
            brick.origin.x = CGFloat(row) * brickWidth
            brick.origin.y = CGFloat(column * brickHeight)
            
            brick.size = CGSize.init(width: brickWidth, height: 30)
            let brickView =  RectangleView(frame: brick)
            
            breakoutBehavior.addBrick(brickView, named: "Brick\(index)")
            gameView.addSubview(brickView)
        }
        
        
        
        
    }
    
    func displayBoard(){
        
        var board = CGRect()
        
        board.origin = CGPoint.zero
        board.origin.x = gameView.bounds.size.width/2 - Constants.boardSize.width/2
        board.origin.y = gameView.bounds.size.height - Constants.boardSize.height * 1.5
        
        board.size = Constants.boardSize
        boardView =  BoardView(frame: board)
        
//        breakoutBehavior.addBoard(boardView!)
        gameView.addSubview(boardView!)
        
    }
    
    func dropBall(){
        var ball = CGRect()
        
        ball.origin = CGPoint.zero
        ball.origin.x = gameView.bounds.size.width/2 - Constants.ballSize.width/2
        ball.origin.y = gameView.bounds.size.height - Constants.boardSize.height * 1.5 - Constants.ballSize.height
        
        ball.size = Constants.ballSize
        ballView =  BallView(frame: ball)
        
        breakoutBehavior.addBall(ballView!)
        gameView.addSubview(ballView!)
    }
    
    struct Constants {
        static let boardSize = CGSize.init(width: 100, height: 10)
        static let ballSize = CGSize.init(width: 20, height: 20)
    }

    @IBAction func dragBoard(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.gameView)
        
        print("Board position while panning : \(String(describing: boardView?.frame.origin))")
        print("Translation:\(translation)")
        
        
        boardView?.frame.origin.x += translation.x
        
        if !isBallReleased{
            
            ballView?.frame.origin.x += translation.x
        }

        sender.setTranslation(CGPoint.zero, in: self.gameView)

    }
    @IBAction func launchBall(_ sender: UITapGestureRecognizer) {
        
//        let point = sender.location(in: gameView)
//
//        UIView.animate(withDuration: 1.5) {
//            self.ballView?.center = CGPoint(x: point.x, y: point.y)
//        }
        print("Board position before launch: \(String(describing: boardView?.frame.origin))")
        
        isBallReleased = true
        breakoutBehavior.launchBall(ballView!, (boardView)!)
        
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("Ball Stopped")
        print("Board position after launch: \(String(describing: boardView?.frame.origin))")
//        animator.removeAllBehaviors()

      
    }

}

class RectangleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.randomColor
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .rectangle
    }
}

class BoardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .rectangle
    }
}

class BallView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
            return .ellipse
    }
}

extension UIColor {
    static var randomColor: UIColor {
        let randomHue = CGFloat(arc4random()) / CGFloat(Int32.max)
        return UIColor(hue: randomHue, saturation: 1.0, brightness: 1.0, alpha: 0.5)
    }
}


