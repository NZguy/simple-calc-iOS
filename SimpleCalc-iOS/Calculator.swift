//
//  Calculator.swift
//  SimpleCalc-iOS
//
//  Created by Duncan Andrew on 4/19/17.
//  Copyright © 2017 Duncan Andrew. All rights reserved.
//

import UIKit

class Calculator: NSObject {

    enum calcOperation: String{
        case Plus = "+", Minus = "-", Multiply = "×", Divide = "÷", Modulus = "%", Count = "Count", Average = "Avg", Factorial = "Fact"
    }
    
    struct Equation {
        var numbers : [Double]
        var operation : calcOperation
        var answer : Double
    }
    
    let debug = false
    var operation: calcOperation?
    var inputString: String = ""
    var numbers = [Double]()
    var operationPressed = false
    var history : [Equation] = [Equation]()
    // Question: Is there a better way of doing this
    // Needed to display errors when they occur
    var currentViewController: UIViewController?
    
    static let sharedInstance = Calculator()
    
    private override init() {
        super.init()
    }

    
    public func numberPressed(_ sender: UIButton) {
        if operation == calcOperation.Factorial{
            // Factorial can only have one input
            calcError(message: "Factorial only supports one input")
        }else if Double(inputString) == 0{
            inputString = sender.titleLabel!.text!
            operationPressed = false
        }else{
            inputString += sender.titleLabel!.text!
            operationPressed = false
        }
    }
    
    public func operationPressed(_ sender: UIButton) {
        if operation == nil{
            
            var errorFound = false
            
            // Set operation to what was entered
            let inputOperation = sender.titleLabel!.text!
            if inputOperation == calcOperation.Plus.rawValue{
                operation = calcOperation.Plus
            }else if inputOperation == calcOperation.Minus.rawValue{
                operation = calcOperation.Minus
            }else if inputOperation == calcOperation.Multiply.rawValue{
                operation = calcOperation.Multiply
            }else if inputOperation == calcOperation.Divide.rawValue{
                operation = calcOperation.Divide
            }else if inputOperation == calcOperation.Modulus.rawValue{
                operation = calcOperation.Modulus
            }else if inputOperation == calcOperation.Factorial.rawValue{
                operation = calcOperation.Factorial
            }else if inputOperation == calcOperation.Average.rawValue{
                operation = calcOperation.Average
            }else if inputOperation == calcOperation.Count.rawValue{
                operation = calcOperation.Count
            }else{
                calcError(message: inputOperation + " is not a supported operation")
                errorFound = true
            }
            
            if(!errorFound){
                operationPressed = true
                setNumber()
            }
            
        } else {
            
            let inputOperation = sender.titleLabel!.text!
            // Check if we are averaging or counting
            if (operation == calcOperation.Average && inputOperation == calcOperation.Average.rawValue) || (operation == calcOperation.Count && inputOperation == calcOperation.Count.rawValue){
                
                operationPressed = true
                setNumber()
                
            }else{
                // Error this operation cannot be used multiple times in one calculation
                // or Avg and Fact were combined
                calcError(message: "This operation is not supported")
            }
        }
    }
    
    func equalsPressed(_ sender: Any) {
        setNumber()
        let answer = calcAnswer()
        // Keep a history of equations entered
        if answer != nil{
            history.append(Equation(numbers: numbers, operation: operation!, answer: answer!))
        }
        resetCalc()
        if answer != nil{
            if answer! == floor(answer!){
                inputString = String(Int(answer!))
            }else{
                inputString = String(answer!)
            }
        }
    }
    
    func backspacePressed(_ sender: Any) {
        if operationPressed {
            // Remove the last operation
            operationPressed = false
            if(numbers.count <= 1){
                // If we are down to the last number input undo the operation
                operation = nil
            }
            
            // Convert last input back into string
            let lastIndex = numbers.count - 1
            if numbers[lastIndex] == floor(numbers[lastIndex]){
                inputString = String(Int(numbers[lastIndex]))
            }else{
                inputString = String(numbers[lastIndex])
            }
            numbers.remove(at: lastIndex)
            
        }else if numbers.count <= 0 && inputString.isEmpty{
            // Do nothing, these's nothing to backspace
        }else{
            // Backspace the current input
            inputString = inputString.substring(to: inputString.index(inputString.endIndex, offsetBy: -1))
            if inputString.isEmpty && numbers.count > 0{
                operationPressed = true
            }
        }
    }
    
    func clearPressed(_ sender: Any) {
        resetCalc()
    }
    
    func setNumber(){
        // If input is empty set number to 0 else try to parse it
        var inputDouble: Double?
        if inputString.isEmpty{
            inputDouble = 0
        }else{
            inputDouble = Double(inputString)
        }
        
        if inputDouble == nil{
            calcError(message: inputString + " is not a number")
        }else{
            numbers.append(inputDouble!)
            inputString = ""
        }
    }
    
    func displayMath() -> String{
        if debug{
            print(numbers)
            print(numbers.count)
            print(inputString)
            if operation != nil{
                print(operation!)
            }
            print(operationPressed)
        }
        
        var displayString = ""
        if operation == nil{
            displayString = inputString
        }else{
            for index in 0...numbers.count-1{
                var number = 0
                if(numbers[index] == floor(numbers[index])){
                    // Number is an int
                    number = Int(numbers[index])
                    if(index < numbers.count-1){
                        displayString += "\(number) \(operation!.rawValue) "
                    }else{
                        displayString += "\(number) "
                    }
                }else{
                    // Number is a double
                    if(index < numbers.count-1){
                        displayString += "\(numbers[index]) \(operation!.rawValue) "
                    }else{
                        displayString += "\(numbers[index]) "
                    }
                }
                
                
            }
            if operationPressed {
                displayString += "\(operation!.rawValue)"
            }else if !inputString.isEmpty{
                displayString += "\(operation!.rawValue) \(inputString)"
            }
        }
        
        return displayString
    }
    
    func resetCalc(){
        numbers.removeAll()
        operation = nil
        operationPressed = false
        inputString = ""
    }
    
    func calcError(message: String){
        if currentViewController != nil{
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            currentViewController!.present(alert, animated: true, completion: nil)
            resetCalc()
        }
    }
    
    func calcAnswer() -> Double?{
        if operation == calcOperation.Plus{
            return numbers[0] + numbers[1]
        }else if operation == calcOperation.Minus{
            return numbers[0] - numbers[1]
        }else if operation == calcOperation.Multiply{
            return numbers[0] * numbers[1]
        }else if operation == calcOperation.Divide{
            return numbers[0] / numbers[1]
        }else if operation == calcOperation.Modulus{
            if numbers[0] == floor(numbers[0]) && numbers[1] == floor(numbers[1]){
                let result = Int(numbers[0]) % Int(numbers[1])
                return Double(result)
            }else{
                calcError(message: "Modulus can only be performed on integers")
                return nil
            }
        }else if operation == calcOperation.Average{
            var sum = 0.0
            for i in 0...(numbers.count-1){
                sum = sum + numbers[i]
            }
            let result = sum / Double(numbers.count)
            return result
        }else if operation == calcOperation.Count{
            return Double(numbers.count)
        }else if operation == calcOperation.Factorial{
            if numbers[0] >= 0 && floor(numbers[0]) == numbers[0]{
                var result = 0
                if numbers[0] == 0{
                    result = 0
                }else{
                    result = 1
                    for i in 1...Int(numbers[0]){
                        result = result * i
                    }
                }
                return Double(result)
            }else {
                calcError(message: "Factorial can only be called on one positive integer")
                return nil
            }
        }
        // This should never happen
        return nil
    }

    
}
