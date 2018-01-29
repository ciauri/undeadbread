//
//  RecipeListTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/14/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UITableViewController {
    var recipes = [Recipe]()
    
    lazy var resultsTableViewController: RecipeResultsTableViewController = {
        let controller = RecipeResultsTableViewController()
        controller.tableView.delegate = self
        return controller
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: resultsTableViewController)
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchBar.sizeToFit()
        return controller
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath)
        let recipe = recipes[indexPath.row]
        
        cell.textLabel?.text = recipe.name

        return cell
    }
}

extension RecipeListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension RecipeListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension RecipeListTableViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
}
