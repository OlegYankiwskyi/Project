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
    // add computed property get set labelResult
    
    var mainLable: String? {
        get {
            return resultLabel.text
        }
        set {
            resultLabel.text = newValue
        }
    }
    
    var status = Status()
    
    
    @IBAction func onButtonDigit(_ sender: UIButton) {
        guard let inputValue = mainLable else {
            cleanLable()
            status.reset()
            setOperationLable()
            return
        }
        
        if inputValue == "0" {
            mainLable = "\(sender.tag)"
            return
        }
        else if inputValue == "-0" {//FIX ME : addMetod for checking
            mainLable = "-\(sender.tag)"
            return
        }
        
        switch status.input {
            
            case .result , .oldValue:
                status.input = .myValue
                status.doneOperation = false
                mainLable = "\(sender.tag)"
            
            case .myValue:
                mainLable = inputValue + "\(sender.tag)"
        }
    }
    
    @IBAction func onUnarOperation(_ sender: UIButton) {
        guard let inputValue = mainLable , let newValue = Double(inputValue) else {
            cleanLable()
            status.reset()
            setOperationLable()
            return
        }
        var result = 0.0
        
        switch sender.tag {
        case MathOperation.cosine.rawValue:
            result = cos(newValue * .pi / 180)
            
        case MathOperation.sinus.rawValue:
            result = sin(newValue * .pi / 180)

        case MathOperation.tangent.rawValue:
            result = tan(newValue * .pi / 180)

        case MathOperation.cotangent.rawValue:
            result = pow(tan(newValue * .pi / 180),-1)

        case MathOperation.squareNumber.rawValue:
            result = pow(newValue,2)

        case MathOperation.cubeNumber.rawValue:
            result = pow(newValue,3)
        
        case MathOperation.exponentPower.rawValue:
            let exponent = 2.71828182846
            result = pow(exponent,newValue)
        
        default:
            return
        }
        mainLable = parseToString(value: result)
    }
    
    @IBAction func onBinarOpetation(_ sender: UIButton) {
        guard let inputValue = mainLable, let newValue = Double(inputValue) else {
            cleanLable()
            status.reset()
            setOperationLable()
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
        
        switch operationType {
            case MathOperation.plus:
                status.oldOperation = .plus
                setOperationLable(operation: "+")//FIXME add func no parametr func changeOperation(){ status.oldOperation = .plus}
            
            case MathOperation.minus:
                status.oldOperation = .minus
                setOperationLable(operation: "-")
            
            case MathOperation.multiplication:
                status.oldOperation = .multiplication
                setOperationLable(operation: "*")
            
            case MathOperation.division:
                status.oldOperation = .division
                setOperationLable(operation: "/")
            
            case MathOperation.power:
                status.oldOperation = .power
                setOperationLable(operation: "xʸ")

            default:
                return
        }
    }

    
    @IBAction func onButtonChangeSign(_ sender: UIButton) {
        guard let inputValue = mainLable else {
            cleanLable()
            status.reset()
            return
        }
        
        switch status.input {
            
        case .oldValue:
            status.input = .myValue
            status.doneOperation = false
            mainLable = "\(sender.tag)"

        case .result , .myValue:
            
            if hasMinus(value: inputValue) {
                mainLable = inputValue.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
            } else {
                mainLable = "-" + inputValue
            }
        }
    }
    
    func hasMinus(value: String) -> Bool {
        if value.contains("-") {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func onButtonEqual(_ sender: UIButton) {
        guard let inputValue = mainLable, let newValue = Double(inputValue) , !status.doneOperation else {
            return
        }
        calculate(newValue: newValue)
        setOperationLable()
    }

    
    @IBAction func onButtonDot(_ sender: UIButton) {
        guard let inputValue = mainLable, !inputValue.isEmpty else {
            cleanLable()
            status.reset()
            setOperationLable()
            return
        }
        
        switch status.input {
            
        case .result , .oldValue:
            status.input = .myValue
            status.doneOperation = false
            mainLable = "0."
            
        case .myValue:
            if !inputValue.contains(".") {
                mainLable = inputValue + "."
            }
        }
    }
    
    @IBAction func onButtonReset(_ sender: UIButton) {
        cleanLable()
        status.reset()
        setOperationLable()
    }
    @IBAction func onButtonClear(_ sender: UIButton) {
        cleanLable()
    }
    
    func result(newValue: Double) -> Double? {

        switch status.oldOperation {
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
    
    func calculate(newValue: Double) { // create two function result(oldValue , newValue , operation ) ,

        if let value = result(newValue: newValue) {
            status.oldResult = value
            status.doneOperation = true
            status.input = .result
            mainLable = parseToString(value: value)
        } else {
            cleanLable()
            status.reset()
            setOperationLable()
        }
    }
    
    func parseToString(value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%.0f", value) : String(value)
    }
    
    func cleanLable() {
        mainLable = "0" // add computed property get set labelResult
    }
    
    
    func setOperationLable(operation: String = "") { //FIX ME rename setOperationLable
        operationLabel.text = operation
    }

}

