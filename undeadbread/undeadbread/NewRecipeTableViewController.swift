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
    private var ingredients: [Ration] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadSections([Section.ingredients.rawValue], with: .automatic)
            }
        }
    }
    private var stepSections: [Recipe.Section] = [] {
        didSet {
            var rowIndex = 0
            for (sectionIndex, stepSection) in stepSections.enumerated() {
                stepSectionMap[rowIndex] = sectionIndex
                rowIndex += 1
                for _ in stepSection.steps {
                    stepSectionMap[rowIndex] = sectionIndex
                    rowIndex += 1
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadSections([Section.steps.rawValue], with: .automatic)
            }
        }
    }
    
    private var stepSectionMap: [Int: Int] = [:]
    
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
                return stepSections.map({$0.steps.count + 1}).reduce(0, +) + 1
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
                    return cell
                }
            case .steps:
                if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
                    return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
                } else if let sectionIndex = stepSectionMap[indexPath.row] {
                    var rowsInPreviousSections = 0
                    for index in 0..<sectionIndex {
                        rowsInPreviousSections += 1
                        for _ in stepSections[index].steps {
                            rowsInPreviousSections += 1
                        }
                    }
                    let currentSectionRowIndex = indexPath.row - rowsInPreviousSections
                    let stepSection = stepSections[sectionIndex]
                    if currentSectionRowIndex == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath)
                        cell.textLabel?.text = stepSection.title
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath)
                        let stepIndex = currentSectionRowIndex - 1
                        cell.textLabel?.text = "\(stepIndex + 1). \(stepSection.steps[stepIndex].instructions)"
                        return cell
                    }
                } else {
                    return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                }
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.name
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .ingredients:
                if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
                    performSegue(withIdentifier: "ingredientUnits", sender: self)
                }
            case .steps:
                if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
                    performSegue(withIdentifier: "stepsEditor", sender: self)
                }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingredientUnits",
            let selectedRow = tableView.indexPathForSelectedRow,
            selectedRow.section == Section.ingredients.rawValue,
            selectedRow.row != tableView.numberOfRows(inSection: selectedRow.section) - 1,
            let destination = segue.destination as? NewIngredientTableViewController {
            destination.existingRation = ingredients[selectedRow.row]
            destination.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Segue
extension NewRecipeTableViewController {
    @IBAction func unwindFromNewIngredient(segue: UIStoryboardSegue) {
        guard let source = segue.source as? NewIngredientTableViewController,
            source.existingRation == nil,
            let ingredient = source.currentRation else {
                return
        }
        ingredients.append(ingredient)
    }
    
    @IBAction func unwindFromStepsEditor(segue: UIStoryboardSegue) {
        guard let source = segue.source as? NewStepsTableViewController else {
            return
        }
        stepSections = source.sections
    }
}

extension NewRecipeTableViewController: IngredientModifiedDelegate {
    func didUpdate(ingredient: Ration) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow,
            selectedIndexPath.section == Section.ingredients.rawValue {
            ingredients[selectedIndexPath.row] = ingredient
        }
    }
}
