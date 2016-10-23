//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Руслан Абдулхаликов on 23.09.16.
//  Copyright © 2016 Ruslan Abdulkhalikov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsTheMiddleOfTyping = false
    
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTheMiddleOfTyping {
            if display.text!.range(of: ".") != nil && digit == "." {
                return
            }
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
    
            if digit == "00" && displayValue == 0 {
                return
            }
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
        }
        userIsTheMiddleOfTyping = true
    }
  
    
    private var  displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            displayValue = brain.result
        }
    }

}

