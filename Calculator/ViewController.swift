//
//  ViewController.swift
//  Calculator
//
//  Created by Oleg Yankiwskyi on 4/3/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

enum MathOperation: Int  {
    case none = 99,
     plus,
     minus,
     multiplication,
     division
}

struct Status {
    var oldResult = 0.0
    var oldOperation: MathOperation = .none
    var doneOperation = true
    
    mutating func reset() {
        oldResult = 0.0
        oldOperation = .none
        doneOperation = true
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var buttonNumbers: [UIButton]!
    
    var status = Status()
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let inputValue = Double(clearLabelResult()!) else {
            return
        }
        calculate(newValue: inputValue)
    }
    @IBAction func onButtonDigit(_ sender: UIButton) {
        resultLabel.text = resultLabel.text! + "\(sender.tag)"
    }
    
    @IBAction func onButtonOpetation(_ sender: UIButton) {
        guard let inputValue = clearLabelResult(), !inputValue.isEmpty, let newValue = Double(inputValue) else {
            clearLabelResult()
            return
        }
        print("doneOperation : \(status.doneOperation)")
        print("oldResult : \(status.oldResult)")
        print("oldOperation: \(status.oldOperation)")

        if status.doneOperation == false {
            calculate(newValue: newValue)
        }
        else {
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
    
    @discardableResult
    func clearLabelResult() -> String? {
        let labelText = resultLabel.text
        resultLabel.text = ""
        return labelText
    }
    
    
    @IBAction func onButtonClear(_ sender: UIButton) {
        clearLabelResult()
        status.reset()
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
        resultLabel.text = String(newValue)
    }

}

