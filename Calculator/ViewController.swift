//
//  ViewController.swift
//  Calculator
//
//  Created by Oleg Yankiwskyi on 4/3/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

enum MathOperation: Int {
    case none = 99,
     plus,
     minus,
     multiplication,
     division
}

enum Input {
    case result
    case myValue
    case oldValue
}

struct Status {
    var oldResult = 0.0
    var oldOperation: MathOperation = .none
    var doneOperation = true
    var input: Input = .myValue
    
    mutating func reset() {
        oldResult = 0.0
        oldOperation = .none
        doneOperation = true
        input = .myValue
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var buttonNumbers: [UIButton]!
    
    var status = Status()
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let inputValue = Double(resultLabel.text!) , !status.doneOperation else {
            return
        }
        calculate(newValue: inputValue)
    }
    
    @IBAction func onButtonDigit(_ sender: UIButton) {
        switch status.input {
        case .result:
            status.input = .myValue
            status.doneOperation = false
            resultLabel.text = "\(sender.tag)"
        case .myValue:
            resultLabel.text = resultLabel.text! + "\(sender.tag)"
        case .oldValue:
            status.input = .myValue
            status.doneOperation = false
            resultLabel.text = "\(sender.tag)"
        }
    }
    
    @IBAction func onButtonChangeSign(_ sender: UIButton) {
        guard let inputValue = resultLabel.text else {
            resultLabel.text = ""
            status.reset()
            return
        }
        if inputValue.range(of:"-") != nil {
            resultLabel.text = inputValue.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        } else {
            resultLabel.text = "-" + inputValue
        }
    }
    @IBAction func onButtonOpetation(_ sender: UIButton) {
        guard let inputValue = resultLabel.text, !inputValue.isEmpty, let newValue = Double(inputValue) else {
            return
        }
        

        if status.doneOperation == false {
            calculate(newValue: newValue)
        }
        else {
            status.input = .oldValue
            status.oldResult = newValue
            status.doneOperation = false
        }

        switch sender.tag {

        case MathOperation.plus.rawValue:
            status.oldOperation = .plus
        case MathOperation.minus.rawValue:
            status.oldOperation = .minus
        case MathOperation.multiplication.rawValue:
            status.oldOperation = .multiplication
        case MathOperation.division.rawValue:
            status.oldOperation = .division
        default:
            return
        }
    }
    
    
    @IBAction func onButtonReset(_ sender: UIButton) {
        resultLabel.text = ""
        status.reset()
    }
    @IBAction func onButtonClear(_ sender: UIButton) {
        resultLabel.text = ""
    }
    
    @IBAction func onButtonDot(_ sender: UIButton) {
        guard let inputValue = resultLabel.text, !inputValue.isEmpty else {
            return
        }
        
        if inputValue.range(of:".") == nil {
            resultLabel.text = inputValue + "."
        }
    }
    
    func calculate(newValue: Double) {
        var newValue = newValue
        
        switch status.oldOperation {
        case .plus:
            newValue = status.oldResult + newValue
        case .minus:
            newValue = status.oldResult - newValue
        case .multiplication:
            newValue = status.oldResult * newValue
        case .division:
            newValue = status.oldResult / newValue
        default:
            return
        }
        status.oldResult = newValue
        status.doneOperation = true
        status.input = .result
        resultLabel.text = String(newValue)
    }

}

