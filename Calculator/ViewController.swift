//
//  ViewController.swift
//  Calculator
//
//  Created by Oleg Yankiwskyi on 4/3/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

extension Double {
    func convertToString() -> String {
        return self.truncatingRemainder(dividingBy: 1.0) == 0 ? String(format: "%g", self) : String(self)
    }
}

enum MathError: Error {
    case infinity
    case error
    case badValueTangent
    case badValueCotangent
    
    var description: String {
        switch self {
        case .infinity:
            return "Error value is infinity"
        case .error:
            return "Error"
        case .badValueTangent:
            return "Error, bad value for tangent"
        case .badValueCotangent:
            return "Error, bad value for cotangent"
        }
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
    case newValue
    case oldValue
}

struct Status {
    var oldResult = 0.0
    var oldOperation: MathOperation = .none
    var isOperationDone = true
    var input: Input = .newValue
    
    mutating func reset() {
        oldResult = 0.0
        oldOperation = .none
        isOperationDone = true
        input = .newValue
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    var status = Status()
    
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
                resultLabel.text = value.convertToString()
            }
        }
    }
    
    @IBAction func digitButtonAction(_ sender: UIButton) {
        guard let inputValue = displayInput else {
            reset()
            return
        }
        
        switch status.input  {
        case .result:
            status.input = .newValue
            displayInput = Double(sender.tag)
            
        case .oldValue:
            status.input = .newValue
            status.isOperationDone = false
            displayInput = Double(sender.tag)
            
        case .newValue:
            displayInput = inputValue * 10 + Double(sender.tag)
        }
    }
    
    
    @IBAction func onUnarOperation(_ sender: UIButton) {
        guard let newValue = displayInput, let operationType = MathOperation(rawValue: sender.tag) else {
            reset()
            return
        }
        
        do {
            try displayInput = countUnar(value: newValue, operation: operationType)
        } catch MathError.infinity {
            reset()
            resultLabel.text = MathError.infinity.description
        } catch MathError.badValueTangent {
            reset()
            resultLabel.text = MathError.badValueTangent.description
        } catch MathError.badValueCotangent {
            reset()
            resultLabel.text = MathError.badValueCotangent.description
        }
        catch {
            reset()
            resultLabel.text = MathError.error.description
        }
        
    }
    
    @IBAction func onBinarOpetation(_ sender: UIButton) {
        guard let newValue = displayInput else {
            reset()
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
            reset()
            return
        }
        
        switch status.input {
        case .oldValue, .result:
            status.input = .newValue
            status.isOperationDone = false
            displayInput = Double(sender.tag)
            
        case .newValue:
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
        reset()
    }
    
    @IBAction func onButtonClear(_ sender: UIButton) {
        cleanLabel()
    }
    
    func countBinar(newValue: Double, oldValue: Double, operation: MathOperation) throws -> Double {
        var result = Double()
        
        switch operation {
        case .plus:
            result = oldValue + newValue
            
        case .minus:
            result = oldValue - newValue
            
        case .multiplication:
            result = oldValue * newValue
            
        case .division:
            if newValue == 0 { throw MathError.infinity }
            result = oldValue / newValue
            
        case .power:
            result = pow(oldValue,newValue)
            
        default:
            throw MathError.error
        }
        
        if result == Double.infinity || result == -Double.infinity {
            throw MathError.infinity
        } else {
            return result
        }
    }
    
    func countUnar(value: Double, operation: MathOperation) throws -> Double {
        var result = Double()
        
        switch operation {
        case .cosine:
            result = cos(value * .pi / 180)
            
        case .sinus:
            result = sin(value * .pi / 180)
            
        case .tangent:
            let remainder = value.truncatingRemainder(dividingBy: 360)
            if remainder == 90 || remainder == 270 {
                throw MathError.badValueTangent
            }
            result = tan(value * .pi / 180)
            
        case .cotangent:
            let remainder = value.truncatingRemainder(dividingBy: 360)
            if remainder == 0 || remainder == 180 {
                throw MathError.badValueCotangent
            }
            result = pow(tan(value * .pi / 180),-1)
            
        case .squareNumber:
            result = pow(value,2)
            
        case .cubeNumber:
            result = pow(value,3)
            
        case .exponentPower:
            let exponent = 2.71828182846
            result = pow(exponent,value)
            
        default:
            throw MathError.error
        }
        
        if result == Double.infinity || result == -Double.infinity  {
            throw MathError.infinity
        } else {
            return result
        }
    }
    
    func updateCalculation(newValue: Double) {
        var result = 0.0
        
        do {
            result = try countBinar(newValue: newValue, oldValue: status.oldResult, operation: status.oldOperation)
            displayInput = result
            status.oldResult = result
            status.isOperationDone = true
            status.input = .result
            displayInput = result
            
        } catch MathError.infinity {
            reset()
            resultLabel.text = MathError.infinity.description
        } catch {
            reset()
            resultLabel.text = MathError.error.description
        }
    }
    
    func cleanLabel() {
        displayInput = 0.0
    }
    
    func setOperation(operation: MathOperation = .none) {
        status.oldOperation = operation
        operationLabel.text = operation.stringRepresentation
    }
    
    func reset() {
        cleanLabel()
        status.reset()
        setOperation()
    }
}



