//
//  TableViewController.swift
//  SimpleCalc-iOS
//
//  Created by Duncan Andrew on 4/19/17.
//  Copyright © 2017 Duncan Andrew. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let calc = Calculator.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "History"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calc.history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = printEquation(equation: calc.history[indexPath.item])
        return cell
    }
    
    // Question: Is there a better way to share these structs across classes?
    func printEquation(equation: Calculator.Equation) -> String{
        var ret = ""
        
        // Format numbers to remove decimal if they are ints
        var strNumbers = [String]()
        for number in equation.numbers{
            
            if floor(number) == number{
                //print("\(floor(number)) == \(number) == \(Int(number))")
                strNumbers.append(String(Int(number)))
            }else{
                strNumbers.append(String(number))
            }
        }
        var strAnswer = ""
        if floor(equation.answer) == equation.answer{
            strAnswer = String(Int(equation.answer))
        }else{
            strAnswer = String(equation.answer)
        }
        
        // Format equation as a string
        switch equation.operation{
        case Calculator.calcOperation.Plus, Calculator.calcOperation.Minus, Calculator.calcOperation.Divide, Calculator.calcOperation.Multiply, Calculator.calcOperation.Modulus:
            ret = "\(strNumbers[0]) \(equation.operation.rawValue) \(strNumbers[1]) = \(strAnswer)"
        case Calculator.calcOperation.Count, Calculator.calcOperation.Factorial, Calculator.calcOperation.Average:
            for number in strNumbers{
                ret += "\(number) "
            }
            ret += "\(equation.operation.rawValue) = \(strAnswer)"
        }
        return ret
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
