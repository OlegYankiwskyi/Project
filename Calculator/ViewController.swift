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
    
    var status = Status()
    
    
    @IBAction func onButtonDigit(_ sender: UIButton) {
        guard let inputValue = resultLabel.text else {
            cleanLable()
            status.reset()
            return
        }
        
        if inputValue == "0" {
            resultLabel.text = "\(sender.tag)"
            return
        }
        else if inputValue == "-0" {
            resultLabel.text = "-\(sender.tag)"
            return
        }
        
        switch status.input {
            
            case .result , .oldValue:
                status.input = .myValue
                status.doneOperation = false
                resultLabel.text = "\(sender.tag)"
            
            case .myValue:
                resultLabel.text = inputValue + "\(sender.tag)"
        }
    }
    
    @IBAction func onUnarOperation(_ sender: UIButton) {
        guard let inputValue = Double(resultLabel.text!) else {
            cleanLable()
            status.reset()
            return
        }
        var result = 0.0
        
        switch sender.tag {
        case MathOperation.cosine.rawValue:
            result = cos(inputValue * Double.pi / 180)
            
        case MathOperation.sinus.rawValue:
            result = sin(inputValue * Double.pi / 180)

        case MathOperation.tangent.rawValue:
            result = tan(inputValue * Double.pi / 180)

        case MathOperation.cotangent.rawValue:
            result = pow(tan(inputValue * Double.pi / 180),-1)

        case MathOperation.squareNumber.rawValue:
            result = pow(inputValue,2)

        case MathOperation.cubeNumber.rawValue:
            result = pow(inputValue,3)
        
        case MathOperation.exponentPower.rawValue:
            let exponent = 2.71828182846
            result = pow(exponent,inputValue)
        
        default:
            return
        }
        resultLabel.text = result.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%.0f", result) : String(result)

    }
    
    @IBAction func onBinarOpetation(_ sender: UIButton) {
        guard let newValue = Double(resultLabel.text!) else {
            cleanLable()
            status.reset()
            return
        }

        if status.doneOperation == false {
            calculate(newValue: newValue)
        } else {
            status.input = .oldValue
            status.oldResult = newValue
        }

        switch sender.tag {
        case MathOperation.plus.rawValue:
            status.oldOperation = .plus
            cleanOperationLabel(operation: "+")
            
        case MathOperation.minus.rawValue:
            status.oldOperation = .minus
            cleanOperationLabel(operation: "-")
        case MathOperation.multiplication.rawValue:
            status.oldOperation = .multiplication
            cleanOperationLabel(operation: "*")
            
        case MathOperation.division.rawValue:
            status.oldOperation = .division
            cleanOperationLabel(operation: "/")
        
        case MathOperation.power.rawValue:
            status.oldOperation = .power
            cleanOperationLabel(operation: "xʸ")

        default:
            return
        }
    }
    
    @IBAction func onButtonChangeSign(_ sender: UIButton) {
        guard let inputValue = resultLabel.text else {
            cleanLable()
            status.reset()
            return
        }
        
        switch status.input {
            
        case .oldValue:
            status.input = .myValue
            status.doneOperation = false
            resultLabel.text = "\(sender.tag)"

        case .result , .myValue:
            
            if inputValue.contains("-") {
                resultLabel.text = inputValue.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            } else {
                resultLabel.text = "-" + inputValue
            }
            
        }
    }
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let inputValue = Double(resultLabel.text!) , !status.doneOperation else {
            return
        }
        calculate(newValue: inputValue)
        cleanOperationLabel()
    }

    
    @IBAction func onButtonDot(_ sender: UIButton) {
        guard let inputValue = resultLabel.text, !inputValue.isEmpty else {
            cleanLable()
            status.reset()
            return
        }
        
        switch status.input {
            
        case .result , .oldValue:
            status.input = .myValue
            status.doneOperation = false
            resultLabel.text = "0."
            
        case .myValue:
            if !inputValue.contains(".") {
                resultLabel.text = inputValue + "."
            }
        }
    }
    
    @IBAction func onButtonReset(_ sender: UIButton) {
        cleanLable()
        status.reset()
        cleanOperationLabel()
    }
    @IBAction func onButtonClear(_ sender: UIButton) {
        cleanLable()
    }
    
    func calculate(newValue: Double) {
        var newValue = newValue
        print(status)

        switch status.oldOperation {
        case .plus:
            newValue = status.oldResult + newValue
            
        case .minus:
            newValue = status.oldResult - newValue
            
        case .multiplication:
            newValue = status.oldResult * newValue
            
        case .division:
            newValue = status.oldResult / newValue
            
        case .power:
            newValue = pow(status.oldResult,newValue)

        default:
            return
        }

        status.oldResult = newValue
        status.doneOperation = true
        status.input = .result
        resultLabel.text = newValue.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%.0f", newValue) : String(newValue)
    }
    
    func cleanLable() {
        resultLabel.text = "0"
    }
    func cleanOperationLabel(operation: String = "") {
        operationLabel.text = operation
    }

}

