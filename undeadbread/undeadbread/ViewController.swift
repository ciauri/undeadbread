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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let water = Ingredient(name: "Water", recipe: nil)
        let step1 = Step(instructions: "Pour the %@ into the bowl", rations: [Ration(amount: Measurement(value: 100, unit: UnitMass.grams), ingredient: water)])
        let step2 = Step(instructions: "???", rations: [])
        let step3 = Step(instructions: "profit", rations: [])
        let section1 = Recipe.Section(title: "The only section", steps: [step1, step2, step3])
        let recipe = Recipe(name: "Tartine Sourdough", ingredients: [water], sections: [section1])
        
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
        detailCell.detailTextLabel?.text = "\(recipe.sections.map({$0.steps.count}).reduce(0, +)) steps"
        return detailCell
    }
}
