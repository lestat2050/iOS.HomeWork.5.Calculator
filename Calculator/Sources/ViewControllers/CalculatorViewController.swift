//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Yaroslav Surovtsev on 7/28/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var displayLabel: UILabel!
    
    //MARK: - Properties
    
    let decimalChar = "."
    var stillTyping = false
    var brain = CalculatorBrain()
    var displayValue: Double {
        get {
            return Double(displayLabel.text!.removeSeparator())!
        }
        set {
            if newValue.isInfinite || newValue >= Double(Int.max)  {
                displayLabel.text = "Error"
            } else if newValue == Double(Int(newValue)) {
                displayLabel.text = CalculatorBrain.numberFormatter.string(for: Int(newValue))
            } else {
                displayLabel.text = CalculatorBrain.numberFormatter.string(for: newValue)
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func onTouchDigit(_ sender: UIButton) {
        let textInDisplay = displayLabel.text!        
        let digit = sender.currentTitle!
        
        if textInDisplay == "Error" {
            return
        }
        
        if stillTyping {
            if digit == decimalChar, displayLabel.text!.range(of: decimalChar) == nil {
                displayLabel.text = textInDisplay + digit
            } else {
                displayValue = Double(textInDisplay.removeSeparator() + digit)!
            }
        } else {
            if digit == decimalChar {
                displayLabel.text = "0\(digit)"
            } else {
                displayLabel.text = digit
            }
            stillTyping = true
        }
    }
    
    @IBAction func onTouchOperation(_ sender: UIButton) {
        if displayLabel.text! == "Error" {
            brain.performOperand("C")
            displayValue = brain.result
            return
        }
        
        if stillTyping {
            brain.setOperand(displayValue)
            stillTyping = false
        }
        
        if let operation = sender.currentTitle {
            brain.performOperand(operation)
        }
        
        displayValue = brain.result
    }
}

