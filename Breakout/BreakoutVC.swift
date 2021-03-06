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
    
    @IBOutlet weak var scoreLbl: UILabel!
    var boardView : BoardView?
    var ballView : BallView?
    
    let defaults: UserDefaults = UserDefaults.standard

    var isBallReleased : Bool = false
    var balls : [BallView] = []
    var score = 0
    let ballOffSet = 10
    
    private var breakoutBehavior = BreakoutBehavior()
   
    // MARK : Animator
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        animator.addBehavior(self.breakoutBehavior)
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.delegate = self
        
        updateUI()
        
        // Setting up notification observer to update UI on basis of events in the game
        NotificationCenter.default.addObserver(self, selector: #selector(BreakoutVC.gameOver), name: NSNotification.Name(rawValue: "game over"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BreakoutVC.increaseScore), name: NSNotification.Name(rawValue: "add score"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        removeViews()
        updateUI()
    }
    
    // MARK: Game Objects
    
    func updateUI(){
        createBottomWall()
        displayBricks()
        displayBoard()
        dropBalls()
        
        isBallReleased = false
        score = 0
        
        scoreLbl.text = "Score: \(String(score))"
        
    }
    
    func createBottomWall(){
        
        let wallPoint = CGPoint(x: 0, y: gameView.bounds.size.height)
        let wallSize = CGSize(width: gameView.bounds.size.width, height: 2)
        
        let path = UIBezierPath(rect: CGRect(origin: wallPoint, size: wallSize))
        
        breakoutBehavior.addBoundary(path, identifier: "wall")
        
    }
    
    
    func removeViews(){
        for view in gameView.subviews {
            if view.isKind(of: BallView.self){
                breakoutBehavior.removeBall(view)
            }
            else{
                breakoutBehavior.removeBrickAndBoard(view)
            }
        }
        
        balls.removeAll()
        
    }
    
    func displayBricks(){
        
        let brickWidth = gameView.bounds.size.width/5
        let brickHeight = 30
        var numberOfBricks = 25
        
        if let bricks = defaults.object(forKey: "numberOfBricks") as? Int{
            numberOfBricks = bricks
        }
        
        let noOfColumns = numberOfBricks / 5
        for index in 0...(numberOfBricks-1){
            
            let row = index / noOfColumns
            let column = index % noOfColumns
            
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
        
//        breakoutBehavior.addBoardBoundary(boardView!)
        breakoutBehavior.addBoundary(UIBezierPath(rect: board), identifier: "boardItem")
        gameView.addSubview(boardView!)
        
    }
    
    func dropBalls(){
        
        var numberOfBalls = 1
        var elasticity = 0.5
        
        if let balls = defaults.object(forKey: "numberOfBalls") as? Int{
            numberOfBalls = balls
        }
        
        if let bounce = defaults.object(forKey: "bounciness") as? Int{
            elasticity = Double(bounce)
        }
        
        for index in 1...numberOfBalls {
            
            var ball = CGRect()
            
            ball.origin = CGPoint.zero
            ball.origin.x = gameView.bounds.size.width/2 - Constants.ballSize.width/2 + CGFloat(ballOffSet * index)
            ball.origin.y = gameView.bounds.size.height - Constants.boardSize.height * 1.5 - Constants.ballSize.height
            
            ball.size = Constants.ballSize
            ballView =  BallView(frame: ball)
            
            breakoutBehavior.addBall(ballView!, elasticity: elasticity)
            
            gameView.addSubview(ballView!)
            
            balls.append(ballView!)
            
        }
        
    }
    
    struct Constants {
        static let boardSize = CGSize.init(width: 100, height: 10)
        static let ballSize = CGSize.init(width: 20, height: 20)
    }

    // MARK: Actions
    
    @IBAction func dragBoard(_ sender: UIPanGestureRecognizer) {
        
        if isBallReleased{
            
            let translation = sender.translation(in: self.gameView)
            
            print("Board position while panning : \(String(describing: boardView?.frame.origin))")
            print("Translation:\(translation)")
            
            
            boardView?.frame.origin.x += translation.x
//             breakoutBehavior.addBoardBoundary(boardView!)
            breakoutBehavior.addBoundary(UIBezierPath(rect: (boardView?.frame)!), identifier: "boardItem")
            if !isBallReleased{
                
                ballView?.frame.origin.x += translation.x
            }
            
            sender.setTranslation(CGPoint.zero, in: self.gameView)
            
        }
        
        

    }
    @IBAction func launchBall(_ sender: UITapGestureRecognizer) {
        
//        let point = sender.location(in: gameView)
//
//        UIView.animate(withDuration: 1.5) {
//            self.ballView?.center = CGPoint(x: point.x, y: point.y)
//        }
        print("Board position before launch: \(String(describing: boardView?.frame.origin))")
        
        if !isBallReleased{
            isBallReleased = true
            
            breakoutBehavior.launchBall(balls, (boardView)!)
        }
        
        
        
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("Ball Stopped")
        print("Board position after launch: \(String(describing: boardView?.frame.origin))")
//        animator.removeAllBehaviors()

      
    }
    
    // MARK: Notification event functions
    @objc func gameOver(){
        
        removeViews()
        
        let alert = UIAlertController(title: "Game Over", message: "Do you want to play again ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in
            switch action.style{
                
            case .default:
                self.updateUI()
            case .cancel:
                print("Cancel")
            case .destructive:
                print("Destructive")
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func increaseScore(){
        
        score = score + 1
        scoreLbl.text = "Score: \(String(score))"
        
    }

}

// Custom classes for game objects
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


