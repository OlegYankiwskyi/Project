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
    division,
    cosine,
    sinus,
    tangent,
    cotangent,
    squareNumber,
    cubeNumber,
    power,
    exponentPower
    
    var stringRepresentation: String {
        switch self
        {
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        case .power:
            return "xʸ"
        default:
            return ""
        }
    }
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
    
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var displayInput: Double? {
        get {
            if let input = resultLabel.text , let result = Double(input) {
                return result
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                resultLabel.text = parseToString(value: value)
            }
        }
    }
    
    var status = Status()
    
    @IBAction func onButtonDigit(_ sender: UIButton) {
        guard let inputValue = displayInput else {
            cleanLabel()
            status.reset()
            setOperation()
            return
        }

        switch status.input
        {
        case .result , .oldValue:
            status.input = .myValue
            status.doneOperation = false
            displayInput = Double(sender.tag)
            
        case .myValue:
            displayInput = inputValue * 10 + Double(sender.tag)
        }
    }

    
    @IBAction func onUnarOperation(_ sender: UIButton) {
        guard let newValue = displayInput else {
            cleanLabel()
            status.reset()
            setOperation()
            return
        }
        var result = 0.0
        
        guard let operationType = MathOperation(rawValue: sender.tag) else {
            return
        }
        
        switch operationType
        {
        case MathOperation.cosine:
            result = cos(newValue * .pi / 180)
            
        case MathOperation.sinus:
            result = sin(newValue * .pi / 180)
            
        case MathOperation.tangent:
            result = tan(newValue * .pi / 180)
            
        case MathOperation.cotangent:
            result = pow(tan(newValue * .pi / 180),-1)
            
        case MathOperation.squareNumber:
            result = pow(newValue,2)
            
        case MathOperation.cubeNumber:
            result = pow(newValue,3)
            
        case MathOperation.exponentPower:
            let exponent = 2.71828182846
            result = pow(exponent,newValue)
            
        default:
            return
        }
        displayInput = result
    }
    
    @IBAction func onBinarOpetation(_ sender: UIButton) {
        guard let newValue = displayInput else {
            cleanLabel()
            status.reset()
            setOperation()
            return
        }
        
        if !status.doneOperation {
            calculate(newValue: newValue)
        } else {
            status.input = .oldValue
            status.oldResult = newValue
        }
        
        guard let operationType = MathOperation(rawValue: sender.tag) else {
            return
        }
        
        setOperation(operation: operationType)
        
    }
    
    @IBAction func onButtonChangeSign(_ sender: UIButton) {
        guard let inputValue = displayInput else {
            cleanLabel()
            status.reset()
            setOperation()
            return
        }
        
        switch status.input
        {
        case .oldValue:
            status.input = .myValue
            status.doneOperation = false
            displayInput = Double(sender.tag)
            
        case .result , .myValue:
            displayInput = inputValue * -1.0
        }
    }
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let newValue = displayInput, !status.doneOperation else {
            return
        }
        calculate(newValue: newValue)
        setOperation()
    }
    
    @IBAction func onButtonReset(_ sender: UIButton) {
        cleanLabel()
        status.reset()
        setOperation()
    }
    @IBAction func onButtonClear(_ sender: UIButton) {
        cleanLabel()
    }
    
    func result(newValue: Double) -> Double? {
        
        switch status.oldOperation
        {
        case .plus:
            return status.oldResult + newValue
            
        case .minus:
            return status.oldResult - newValue
            
        case .multiplication:
            return status.oldResult * newValue
            
        case .division:
            return status.oldResult / newValue
            
        case .power:
            return pow(status.oldResult,newValue)
            
        default:
            return nil
        }
    }
    
    func calculate(newValue: Double) {
        
        if let value = result(newValue: newValue) {
            status.oldResult = value
            status.doneOperation = true
            status.input = .result
            displayInput = value
        } else {
            cleanLabel()
            status.reset()
            setOperation()
        }
    }
    
    func parseToString(value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%g", value) : String(value)
    }
    
    func cleanLabel() {
        displayInput = 0.0
    }
    
    func setOperation(operation: MathOperation = MathOperation.none) {
        status.oldOperation = operation
        operationLabel.text = operation.stringRepresentation
    }
}

