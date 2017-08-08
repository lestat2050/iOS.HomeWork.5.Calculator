//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Yaroslav Surovtsev on 7/28/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    let decimalChar = "."
    
    var stillTyping = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            if newValue.isInfinite {
                displayLabel.text = "NaN"
            } else if newValue == Double(Int(newValue)) {
                displayLabel.text = String(Int(newValue))
            } else {
                displayLabel.text = String(newValue)
            }
        }
    }
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func onTouchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if stillTyping {
            let textInDisplay = displayLabel.text!
            if digit != decimalChar ||
                displayLabel.text!.range(of: decimalChar) == nil {
                displayLabel.text = textInDisplay + digit
            }
        } else {
            if digit == decimalChar {
                displayLabel.text = "0\(digit)"
            } else {
                displayLabel.text = digit
            }
        }
        
        stillTyping = true
    }
    
    @IBAction func onTouchOperation(_ sender: UIButton) {
        if stillTyping {
            brain.setOperand(displayValue)
            stillTyping = false
        }
        
        if let operation = sender.currentTitle {
            brain.performOperand(operation)
        }
        
        displayValue = brain.result
    }
    
    @IBAction func onTouchChangeSign(_ sender: UIButton) {
        displayValue = -displayValue
    }
    
}

