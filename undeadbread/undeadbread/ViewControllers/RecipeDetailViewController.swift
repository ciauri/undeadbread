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
    var recipeService: RecipeService!
    
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
    
    private var scrolledForTitle: Bool = false
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !scrolledForTitle {
            resizeLargeTitleAndScroll()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrolledForTitle = false
    }
    
    private func resizeLargeTitleAndScroll() {
        if let navBarSubviews = navigationController?.navigationBar.subviews {
            for subView in navBarSubviews where NSStringFromClass(type(of: subView)).contains("LargeTitle"){
                if let label = subView.subviews.first as? UILabel {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    let oldLabelHeight = label.frame.size.height
                    let largeTitleSubviewContentWidth = subView.frame.size.width - subView.layoutMargins.left - subView.layoutMargins.right
                    let properlySizedLabel = label.sizeThatFits(CGSize(width: largeTitleSubviewContentWidth, height: CGFloat.greatestFiniteMagnitude))
                    label.frame.size = properlySizedLabel
                    let labelHeightDiff = label.frame.size.height - oldLabelHeight
                    let needsResize = label.frame.size.height > subView.frame.size.height
                    if needsResize {
                        tableView.setContentOffset(CGPoint(x: 0, y: -labelHeightDiff ), animated: true)
                    }
                    scrolledForTitle = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nestedRecipe",
            let destination = segue.destination as? RecipeDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            let nestedRecipe = recipe.ingredients[selectedIndexPath.row].recipe
            destination.recipe = nestedRecipe
            destination.photoService = photoService
        } else if segue.identifier == "editRecipe",
            let destination = segue.destination as? NewRecipeTableViewController {
            destination.editingRecipe = recipe
            destination.photoService = photoService
        }
    }
    
    @IBAction func unwindFromEditRecipe(segue: UIStoryboardSegue) {
        if let source = segue.source as? NewRecipeTableViewController {
            recipe = source.newRecipe
            recipeService.add(recipe: recipe)
            title = recipe.name
            DispatchQueue.main.async {[tableView] in
                tableView?.reloadData()
            }
        }
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
                let ration = recipe.rations[indexPath.row]
                let reuseId = ration.ingredient.recipe == nil ? "ingredientCell" : "recipeCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
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
                    fatalError("git gud")
                }
            }
        } else {
            fatalError("git gud")
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
