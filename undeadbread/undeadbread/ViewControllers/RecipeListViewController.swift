//
//  RecipeListViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 8/14/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = [] {
        didSet {
            recipes.forEach({RecipeService.shared.add(recipe: $0)})
            DispatchQueue.main.async {[weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadRecipesFromDisk()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recipes = RecipeService.shared.recipes
        UserDefaults.standard.set(try? JSONEncoder().encode(recipes), forKey: "savedRecipes")
    }
    
    func loadRecipesFromDisk() {
        if let data = UserDefaults.standard.data(forKey: "savedRecipes"),
            let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            self.recipes = recipes
        } else {
            let water = Ingredient(name: "Water", recipe: nil)
            let step1 = Step(instructions: "Pour the %@ into the bowl", rations: [Ration(amount: Measurement(value: 100, unit: UnitMass.grams), ingredient: water)], imageURL: nil)
            let step2 = Step(instructions: "???", rations: [], imageURL: nil)
            let step3 = Step(instructions: "profit", rations: [], imageURL: nil)
            let section1 = Recipe.Section(title: "The only section", steps: [step1, step2, step3])
            let recipe = Recipe(name: "Tartine Sourdough", ingredients: [water], rations: [], sections: [section1])
            
            recipes = [recipe]
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let detailVC = segue.destination as! RecipeDetailViewController
            detailVC.recipe = recipes[tableView.indexPathForSelectedRow!.row]
            detailVC.photoService = PhotoService.shared
            detailVC.recipeService = RecipeService.shared
        }
    }


}

extension RecipeListViewController {
    @IBAction func unwindFromNewRecipeViewController(segue: UIStoryboardSegue) {
        if let source = segue.source as? NewRecipeTableViewController,
            let recipe = source.newRecipe {
            recipes.append(recipe)
        }
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "recipe", for: indexPath)
        let recipe = recipes[indexPath.row]
        detailCell.textLabel?.text = recipe.name
        detailCell.detailTextLabel?.text = "\(recipe.sections.map({$0.steps.count}).reduce(0, +)) steps"
        return detailCell
    }
}

extension RecipeListViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        recipes.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

}
