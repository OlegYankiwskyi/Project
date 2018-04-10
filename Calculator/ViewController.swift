//
//  ViewController.swift
//  Calculator
//
//  Created by Oleg Yankiwskyi on 4/3/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

extension Double {
    func parseToString() -> String {
        return self.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%g", self) : String(self)
    }
}

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
        switch self {
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
    var isOperationDone = true
    var input: Input = .myValue
    
    mutating func reset() {
        oldResult = 0.0
        oldOperation = .none
        isOperationDone = true
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
                resultLabel.text = value.parseToString()
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

        switch status.input  {
        case .result , .oldValue:
            status.input = .myValue // new Value
            status.isOperationDone = false
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
        
        switch operationType {
        case .cosine:
            result = cos(newValue * .pi / 180)
            
        case .sinus:
            result = sin(newValue * .pi / 180)
            
        case .tangent:
            result = tan(newValue * .pi / 180)
            
        case .cotangent:
            result = pow(tan(newValue * .pi / 180),-1)
            
        case .squareNumber:
            result = pow(newValue,2)
            
        case .cubeNumber:
            result = pow(newValue,3)
            
        case .exponentPower:
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
        
        if !status.isOperationDone {
            updateCalculation(newValue: newValue)
        } else {
            status.input = .oldValue
            status.oldResult = newValue
        }
        
        if let operationType = MathOperation(rawValue: sender.tag) {
            setOperation(operation: operationType)
        }
        
    }
    
    @IBAction func onButtonChangeSign(_ sender: UIButton) {
        guard let inputValue = displayInput else {
            cleanLabel()
            status.reset()
            setOperation()
            return
        }
        
        switch status.input {
        case .oldValue:
            status.input = .myValue
            status.isOperationDone = false
            displayInput = Double(sender.tag)
            
        case .result , .myValue:
            displayInput = inputValue * -1.0
        }
    }
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let newValue = displayInput, !status.isOperationDone else {
            return
        }
        updateCalculation(newValue: newValue)
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
    
    func count(newValue: Double, oldValue: Double, operation: MathOperation) -> Double? {
        
        switch operation {
        case .plus:
            return oldValue + newValue
            
        case .minus:
            return oldValue - newValue
            
        case .multiplication:
            return oldValue * newValue
            
        case .division:
            return oldValue / newValue
            
        case .power:
            return pow(oldValue,newValue)
            
        default:
            return nil
        }
    }
    
    func updateCalculation(newValue: Double) {
        
        if let result = count(newValue: newValue, oldValue: status.oldResult, operation: status.oldOperation) {
            status.oldResult = result
            status.isOperationDone = true
            status.input = .result
            displayInput = result
        }
        else {
            cleanLabel()
            status.reset()
            setOperation()
        }
    }
    
    func cleanLabel() {
        displayInput = 0.0
    }
    
    func setOperation(operation: MathOperation = .none) {
        status.oldOperation = operation
        operationLabel.text = operation.stringRepresentation
    }
}



