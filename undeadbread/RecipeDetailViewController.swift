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
    
    var recipe: Recipe!
    
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
                return recipe.ingredients.count
            case .steps:
                return recipe.sections.map({$0.steps.count}).reduce(0, +)
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .ingredients:
                let ingredient = recipe.ingredients[indexPath.row]
                cell.textLabel?.text = "- \(ingredient)"
            case .steps:
                let steps: [Step] = recipe.sections.map({$0.steps}).reduce([], +)
                let step = steps[indexPath.row]
                cell.textLabel?.text = "\(step)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.name ?? nil
    }
}
