//
//  RecipeDetailViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 8/14/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var photoService: PhotoServiceProtocol?
    
    var recipe: Recipe! {
        didSet {
            var rowIndex = 0
            for (sectionIndex, stepSection) in recipe.sections.enumerated() {
                stepSectionMap[rowIndex] = sectionIndex
                rowIndex += 1
                for _ in stepSection.steps {
                    stepSectionMap[rowIndex] = sectionIndex
                    rowIndex += 1
                }
            }
        }
    }
    
    private var stepSectionMap: [Int: Int] = [:]
    
    enum Section: Int {
        case ingredients
        case steps
        
        var name: String {
            switch self {
            case .ingredients:
                return NSLocalizedString("Ingredients", comment: "Recipe ingredients")
            case .steps:
                return NSLocalizedString("Steps", comment: "Steps in an recipe section")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = recipe.name
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipeSection = Section(rawValue: section) {
            switch recipeSection {
            case .ingredients:
                return recipe.rations.count
            case .steps:
                return recipe.sections.map({$0.steps.count + 1}).reduce(0, +)
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .ingredients:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
                let ration = recipe.rations[indexPath.row]
                cell.textLabel?.text = ration.ingredient.name
                cell.detailTextLabel?.text = ration.formattedAmountAndUnit
                return cell
            case .steps:
                if let sectionIndex = stepSectionMap[indexPath.row] {
                    let currentSectionRowIndex = rowForSection(index: sectionIndex, withRow: indexPath.row)
                    let stepSection = recipe.sections[sectionIndex]
                    if currentSectionRowIndex == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath)
                        cell.textLabel?.text = stepSection.title
                        return cell
                    } else {
                        let stepIndex = currentSectionRowIndex - 1
                        let step = stepSection.steps[stepIndex]
                        if let url = step.imageURL,
                            let filename = url.pathComponents.last {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! SquareImageTableViewCell
                            if let image = photoService?.getPhoto(named: filename) {
                                cell.squareImageView?.image = image
                            }
                            return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath)
                            cell.textLabel?.text = "\(stepIndex + 1). \(stepSection.steps[stepIndex].instructions)"
                            return cell
                        }
                    }
                } else {
                    return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                }
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.name ?? nil
    }
    
    // MARK: - Helpers
    
    func rowForSection(index sectionIndex: Int, withRow row: Int) -> Int {
        var rowsInPreviousSections = 0
        for index in 0..<sectionIndex {
            rowsInPreviousSections += 1
            for _ in recipe.sections[index].steps {
                rowsInPreviousSections += 1
            }
        }
        return row - rowsInPreviousSections
    }
}
