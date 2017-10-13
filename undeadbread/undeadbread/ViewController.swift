//
//  ViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 8/14/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let water = Ingredient(named: "Water")
        let step1 = Step()
        step1.instructions = "Pour the %@ into the bowl"
        let ration = Step.Ration(amount: Measurement(value: 100, unit: UnitMass.grams), ingredient: water)
        step1.rations = [ration]
        let step2 = Step()
        step2.instructions = "???"
        let step3 = Step()
        step3.instructions = "profit!"
        
        let recipe = Recipe(named: "Tartine Sourdough")
        recipe.ingredients = [water]
        recipe.steps = [step1, step2, step3]
        let section1 = Recipe.Section(title: "The only section", numberOfRows: 3)
        recipe.sections = [section1]
        
        recipes = [recipe]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let detailVC = segue.destination as! RecipeDetailViewController
            detailVC.recipe = recipes[tableView.indexPathForSelectedRow!.row]
        }
    }


}

extension ViewController: UITableViewDataSource {
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
        detailCell.detailTextLabel?.text = "\(recipe.steps.count) steps"
        return detailCell
    }
}
