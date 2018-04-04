//
//  ViewController.swift
//  Calculator
//
//  Created by Oleg Yankiwskyi on 4/3/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

enum mathOperation {
    case none
    case plus
    case minus
    case multiplication
    case division
}

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet var buttonNumbers: [UIButton]!
    
    var oldResult = 0.0
    var oldOperation = mathOperation.none;
    
    @IBAction func onButtonDigit(_ sender: UIButton) {
        resultLabel.text = resultLabel.text! + "\(sender.tag)"
//        resultLabel.text += "\(sender.tag)"
    }
    
    func clearLabelResult() -> String? {
        let labelText = resultLabel.text
        resultLabel.text = ""
        return labelText
    }
    
    @IBAction func onButtonEquil(_ sender: UIButton) {
        print("first")
        guard let inputValue = Double(clearLabelResult()!) else {
            print("clearLabelResult return nil")
            return
        }
        print("start test")
        switch oldOperation {
        case .none:
            break
        case .plus:
            let newValue = oldResult + inputValue
            oldResult = newValue
            resultLabel.text = String(newValue)
        case .minus:
            print("start case")
            let newValue = oldResult - inputValue
            oldResult = newValue
            resultLabel.text = String(newValue)
            print("end case")
        case .multiplication:
            let newValue = oldResult * inputValue
            oldResult = newValue
            resultLabel.text = String(newValue)
        case .division:
            let newValue = oldResult / inputValue
            oldResult = newValue
            resultLabel.text = String(newValue)
        }
    }
    @IBAction func onButtonMinus(_ sender: UIButton) {
        if let input = clearLabelResult() {
            oldResult = Double(input)!
            oldOperation = .minus
        }
        print("old result : \(oldResult)")
        print("old operation : \(oldOperation)")

    }
    

    @IBAction func onButtonClear(_ sender: UIButton) {
        let _ = clearLabelResult()
    }

}

