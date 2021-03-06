//
//  NewRecipeTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/14/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit



class NewRecipeTableViewController: UITableViewController {
    
    var photoService: PhotoServiceProtocol! = PhotoService.shared
    
    var editingRecipe: Recipe? {
        didSet {
            ingredients = editingRecipe?.rations ?? []
            stepSections = editingRecipe?.sections ?? []
            name = editingRecipe?.name ?? ""
        }
    }
    var newRecipe: Recipe? {
        guard name.count > 0,
            ingredients.count > 0,
            stepSections.count > 0 else {
                return nil
        }
        return Recipe(name: name, ingredients: ingredients.map({$0.ingredient}), rations: ingredients, sections: stepSections, uuid: editingRecipe?.uuid)
    }
    
    lazy private var name: String = ""
    private var ingredients: [Ration] = [] {
        willSet {
            // Handling deletion in property observers has odd, undefined behavior, so we handle that case separately
            if newValue.count >= ingredients.count {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
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
        
        if editingRecipe != nil {
            title = "Edit Recipe"
        }
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
                if stepSections.count == 0 {
                    return stepSections.map({$0.steps.count + 1}).reduce(0, +) + 1
                } else {
                    return stepSections.map({$0.steps.count + 1}).reduce(0, +)
                }
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
                cell.textField.delegate = cell
                cell.delegate = self
                return cell
            case .ingredients:
                if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
                    // Last cell in section
                    return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
                } else {
                    let ration = ingredients[indexPath.row]
                    let reuseId = ration.ingredient.recipe == nil ? "ingredientCell" : "recipeCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
                    cell.textLabel?.text = ration.ingredient.name
                    cell.detailTextLabel?.text = ration.formattedAmountAndUnit
                    return cell
                }
            case .steps:
                if stepSections.count == 0 {
                    return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
                } else if let sectionIndex = stepSectionMap[indexPath.row] {
                    let currentSectionRowIndex = rowForSection(index: sectionIndex, withRow: indexPath.row)
                    let stepSection = stepSections[sectionIndex]
                    if currentSectionRowIndex == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath)
                        cell.textLabel?.text = stepSection.title
                        return cell
                    } else {
                        let stepIndex = currentSectionRowIndex - 1
                        let step = stepSection.steps[stepIndex]
                        if let url = step.imageURL,
                            let filename = url.pathComponents.last {
                            guard let photo = photoService.getPhoto(named: filename) else {
                                return UITableViewCell()
                            }
                            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! SquareImageTableViewCell
                            cell.squareImageView?.image = photo
                            return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath)
                            cell.textLabel?.text = "\(stepIndex + 1). \(stepSection.steps[stepIndex].instructions)"
                            return cell
                        }
                    }
                } else {
                    fatalError("git gud")
                }
            }
        } else {
            fatalError("git gud")
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
                if stepSections.count == 0 {
                    performSegue(withIdentifier: "stepsEditor", sender: self)
                } else if let sectionIndex = stepSectionMap[indexPath.row],
                    rowForSection(index: sectionIndex, withRow: indexPath.row) == 0 {
                    // Section title tapped
                    performSegue(withIdentifier: "stepsEditor", sender: stepSections)
                }
            default:
                break;
            }
        }
    }
    
    // MARK: - Editing
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Section(rawValue: indexPath.section) == .ingredients && indexPath.row != tableView.lastRowInSection(section: indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                self.ingredients.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == .insert {
            
        }
    }
    
    // MARK: - Helpers
    
    func rowForSection(index sectionIndex: Int, withRow row: Int) -> Int {
        var rowsInPreviousSections = 0
        for index in 0..<sectionIndex {
            rowsInPreviousSections += 1
            for _ in stepSections[index].steps {
                rowsInPreviousSections += 1
            }
        }
        return row - rowsInPreviousSections
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewIngredientTableViewController {
            destination.searchableIngredients = IngredientService.shared.ingredients as [Named] + RecipeService.shared.recipes as [Named]
        } else if let destination = segue.destination as? NewStepsTableViewController {
            destination.photoService = PhotoService.shared
        }
        
        if segue.identifier == "ingredientUnits",
            let selectedRow = tableView.indexPathForSelectedRow,
            selectedRow.section == Section.ingredients.rawValue,
            selectedRow.row != tableView.numberOfRows(inSection: selectedRow.section) - 1,
            let destination = segue.destination as? NewIngredientTableViewController {
            destination.existingRation = ingredients[selectedRow.row]
            destination.delegate = self
        } else if segue.identifier == "stepsEditor",
            let destination = segue.destination as? NewStepsTableViewController,
            let sections = sender as? [Recipe.Section],
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let sectionIndex = stepSectionMap[selectedIndexPath.row] {
            destination.sections = sections
            destination.editingSectionIndex = sectionIndex
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "addNewRecipe" {
            let editing = editingRecipe != nil
            if editing {
                performSegue(withIdentifier: "editRecipe", sender: nil)
            }
            return editingRecipe == nil
        } else {
            return true
        }
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
        
        for (index, section) in source.sections.enumerated() {
            var steps: [Step] = []
            for step in section.steps {
                if step.instructions.count > 0 || step.imageURL != nil {
                    steps.append(step)
                }
            }
            source.sections[index].steps = steps
        }
        source.sections = source.sections.filter({$0.steps.count > 0})
        stepSections = source.sections
    }
}

extension NewRecipeTableViewController: TextFieldTableViewCellDelegate {
    func textFieldDidChange(text: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell),
            indexPath.section == Section.name.rawValue {
            name = text
        }
    }
}

extension NewRecipeTableViewController: IngredientModifiedDelegate {
    func didUpdate(ingredient: Ration) {
        if ingredient.ingredient.name.count > 0,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            selectedIndexPath.section == Section.ingredients.rawValue {
            ingredients[selectedIndexPath.row] = ingredient
        }
    }
}
