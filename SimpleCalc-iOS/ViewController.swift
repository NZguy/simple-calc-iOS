//
//  ViewController.swift
//  SimpleCalc-iOS
//
//  Created by Duncan Andrew on 4/16/17.
//  Copyright © 2017 Duncan Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let calc = Calculator.sharedInstance
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func numberPressed(_ sender: UIButton) {
        calc.numberPressed(sender)
        displayScreen()
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        calc.operationPressed(sender)
        displayScreen()
    }
    
    @IBAction func equalsPressed(_ sender: Any) {
        calc.equalsPressed(sender)
        displayScreen()
    }
    
    @IBAction func backspacePressed(_ sender: Any) {
        calc.backspacePressed(sender)
        displayScreen()
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        calc.clearPressed(sender)
        displayScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.currentViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayScreen(){
        displayLabel.text = calc.displayMath()
    }
    
}

/*
 For errors
 
 */
