//
//  NewRecipeTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/14/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class NewRecipeTableViewController: UITableViewController {
    lazy private var name: String = ""
    lazy private var ingredients: [Ration] = []
    lazy private var steps: [Step] = []
    
    private enum Section: Int {
        case name
        case ingredients
        case steps
        
        var name: String {
            switch self {
            case .name:
                return NSLocalizedString("Name", comment: "Name of recipe")
            case .ingredients:
                return NSLocalizedString("Ingredients", comment: "List of ingredients")
            case .steps:
                return NSLocalizedString("Steps", comment: "Exhaustive list of instructions to complete the recipe")
            }
        }
        
        static var count: Int {
            return 3
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .name:
                return 1
            case .ingredients:
                return ingredients.count + 1
            case .steps:
                return steps.count + 1
            }
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
                cell.textField.text = name
                return cell
            case .ingredients:
                let totalRows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row == totalRows - 1 {
                    // Last cell in section
                    return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
                    let ration = ingredients[indexPath.row]
                    cell.textLabel?.text = ration.ingredient.name
                    cell.detailTextLabel?.text = ration.formattedAmountAndUnit
                }
            case .steps:
                return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
            }
        } else {
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.name
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .ingredients:
                performSegue(withIdentifier: "ingredientUnits", sender: self)
            case .steps:
                performSegue(withIdentifier: "stepsEditor", sender: self)
            default:
                break;
            }
        }
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
