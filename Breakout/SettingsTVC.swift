//
//  SettingsTVC.swift
//  Breakout
//
//  Created by Burhanuddin Shakir on 31/03/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    let defaults: UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var bricksLbl: UILabel!
    
    @IBOutlet weak var ballSC: UISegmentedControl!
    @IBOutlet weak var bricksStepper: UIStepper!
    @IBOutlet weak var bounceSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let numberOfbricks = defaults.object(forKey: "numberOfBricks") as? Int {
            bricksLbl.text = String(numberOfbricks)
            bricksStepper.value = Double(numberOfbricks)
        }
        
        if let numberOfballs = defaults.object(forKey: "numberOfBalls") as? Int {
            ballSC.selectedSegmentIndex = numberOfballs - 1
        }
        
        if let bounce = defaults.object(forKey: "bounciness") as? Float {
            bounceSlider.value = bounce
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    @IBAction func ballsChanged(_ sender: UISegmentedControl) {
        
        defaults.set(sender.selectedSegmentIndex + 1, forKey: "numberOfBalls")
        defaults.synchronize()
    }

    @IBAction func bricksChanged(_ sender: UIStepper) {
        
        defaults.set(sender.value, forKey: "numberOfBricks")
        defaults.synchronize()
        
        bricksLbl.text = String(Int(sender.value))
    }
    
    @IBAction func bounceChanged(_ sender: UISlider) {
        defaults.set(sender.value, forKey: "bounciness")
        defaults.synchronize()
    }

}
