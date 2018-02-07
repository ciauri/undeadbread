//
//  RecipeResultsTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/28/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class RecipeResultsTableViewController: UITableViewController {
    
    var filteredResults = [Recipe]()

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult")!
        let recipe = filteredResults[indexPath.row]
        
        cell.textLabel?.text = recipe.name
        return cell
    }

}
