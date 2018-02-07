//
//  BaseResultsTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/28/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class BaseResultsTableViewController: UITableViewController {
    
    var filteredResults = [CustomStringConvertible]()
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recipeResult")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult")!
        let result = filteredResults[indexPath.row]
        
        cell.textLabel?.text = result.description
        return cell
    }
    
}
