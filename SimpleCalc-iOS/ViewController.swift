//
//  ViewController.swift
//  SimpleCalc-iOS
//
//  Created by Duncan Andrew on 4/16/17.
//  Copyright © 2017 Duncan Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Operation: String{
        case Plus = "+", Minus = "-", Multiply = "×", Divide = "÷", Modulus = "%", Count = "Count", Average = "Avg", Factorial = "Fact"
    }
    
    var operation: Operation?
    var inputString: String = ""
    var numbers = [Double]()
    var operationPressed = false
    let debug = false
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if operation == Operation.Factorial{
            // Factorial can only have one input
            calcError(message: "Factorial only supports one input")
        }else if Double(inputString) == 0{
            inputString = sender.titleLabel!.text!
            operationPressed = false
        }else{
            inputString += sender.titleLabel!.text!
            operationPressed = false
        }
        
        displayMath()
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        if operation == nil{
            
            var errorFound = false
            
            // Set operation to what was entered
            let inputOperation = sender.titleLabel!.text!
            if inputOperation == Operation.Plus.rawValue{
                operation = Operation.Plus
            }else if inputOperation == Operation.Minus.rawValue{
                operation = Operation.Minus
            }else if inputOperation == Operation.Multiply.rawValue{
                operation = Operation.Multiply
            }else if inputOperation == Operation.Divide.rawValue{
                operation = Operation.Divide
            }else if inputOperation == Operation.Modulus.rawValue{
                operation = Operation.Modulus
            }else if inputOperation == Operation.Factorial.rawValue{
                operation = Operation.Factorial
            }else if inputOperation == Operation.Average.rawValue{
                operation = Operation.Average
            }else if inputOperation == Operation.Count.rawValue{
                operation = Operation.Count
            }else{
                calcError(message: inputOperation + " is not a supported operation")
                errorFound = true
            }
            
            if(!errorFound){
                operationPressed = true
                setNumber()
                displayMath()
            }
            
        } else {
            
            let inputOperation = sender.titleLabel!.text!
            // Check if we are averaging or counting
            if (operation == Operation.Average && inputOperation == Operation.Average.rawValue) || (operation == Operation.Count && inputOperation == Operation.Count.rawValue){
                
                operationPressed = true
                setNumber()
                displayMath()
                
            }else{
                // Error this operation cannot be used multiple times in one calculation 
                // or Avg and Fact were combined
                calcError(message: "This operation is not supported")
            }
        }
    }
    
    @IBAction func equalsPressed(_ sender: Any) {
        setNumber()
        let answer = calcAnswer()
        resetCalc()
        if answer == floor(answer){
            inputString = String(Int(answer))
        }else{
            inputString = String(answer)
        }
        displayMath()
    }
    
    @IBAction func backspacePressed(_ sender: Any) {
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
        displayMath()
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        resetCalc()
        displayMath()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        textLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
//        textLabel.numberOfLines = 0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func displayMath(){
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
        
        displayLabel.text = displayString
    }
    
    func resetCalc(){
        numbers.removeAll()
        operation = nil
        operationPressed = false
        inputString = ""
    }
    
    func calcError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        resetCalc()
        displayMath()
    }

    func calcAnswer() -> Double{
        if operation == Operation.Plus{
            return numbers[0] + numbers[1]
        }else if operation == Operation.Minus{
            return numbers[0] - numbers[1]
        }else if operation == Operation.Multiply{
            return numbers[0] * numbers[1]
        }else if operation == Operation.Divide{
            return numbers[0] / numbers[1]
        }else if operation == Operation.Modulus{
            if numbers[0] == floor(numbers[0]) && numbers[1] == floor(numbers[1]){
                let result = Int(numbers[0]) % Int(numbers[1])
                return Double(result)
            }else{
                calcError(message: "Modulus can only be performed on integers")
            }
        }else if operation == Operation.Average{
            var sum = 0.0
            for i in 0...(numbers.count-1){
                sum = sum + numbers[i]
            }
            let result = sum / Double(numbers.count)
            return result
        }else if operation == Operation.Count{
            return Double(numbers.count)
        }else if operation == Operation.Factorial{
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
            }
        }
        // This should never happen
        return 0.0
    }
    
}

/*
 For errors
 
 */
