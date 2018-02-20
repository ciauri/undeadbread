//
//  NewIngredientTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/16/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

protocol IngredientModifiedDelegate: class {
    func didUpdate(ingredient: Ration)
}

class NewIngredientTableViewController: UITableViewController {
    // MARK: - Public
    var currentRation: Ration? {
        guard let measurement = currentMeasurement,
            let name = nameTextField.text else {
                return nil
        }
        return Ration(amount: measurement, ingredient: Ingredient(name: existingRecipe?.name ?? name, recipe: existingRecipe))
    }
    // MARK: - Injections
    var existingRation: Ration? {
        didSet {
            existingRecipe = existingRation?.ingredient.recipe
        }
    }
    var searchableIngredients: [Named] = []
    weak var delegate: IngredientModifiedDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    // MARK: - Private
    
    // MARK: - Helpers
    private let measurementFormatter: MeasurementFormatter = MeasurementFormatter()

    lazy private var dummyTextField: UITextField = {
        let field = UITextField(frame: CGRect.zero)
        let unitPickerView: UIPickerView = UIPickerView(frame: CGRect.zero)
        unitPickerView.dataSource = self
        unitPickerView.delegate = self
        unitPickerView.showsSelectionIndicator = true
        field.inputView = unitPickerView
        view.addSubview(field)
        if existingRation == nil {
            pickerView(unitPickerView, didSelectRow: 0, inComponent: 0)
        }
        return field
    }()
    
    private let measurements: [Dimension]  = Ration.acceptableMasses as [Dimension] + Ration.acceptableVolumes as [Dimension]
    
    private var currentUnit: Dimension? {
        didSet {
            guard let currentUnit = currentUnit else {
                return
            }
            DispatchQueue.main.async { [measurementFormatter, unitLabel] in
                unitLabel?.text = measurementFormatter.string(from: currentUnit)
            }
        }
    }
    
    private var currentMeasurement: Measurement<Unit>? {
        guard let amountText = amountTextField.text,
            let floatAmount = Double(amountText),
            let currentUnit = currentUnit else {
                return nil
        }
        return Measurement(value: floatAmount, unit: currentUnit)
    }
    
    private var existingRecipe: Recipe? {
        didSet {
            DispatchQueue.main.async { [recipeLabel, existingRecipe] in
                recipeLabel?.text = existingRecipe?.name
            }
        }
    }

    
    // MARK: - Search
    
    lazy private var resultsTableViewController: BaseResultsTableViewController = {
        let controller = BaseResultsTableViewController(style: .grouped)
        controller.selectedDelegate = self
        return controller
    }()
    
    lazy private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: resultsTableViewController)
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        if let existingRation = existingRation {
            title = NSLocalizedString("Edit Ingredient", comment: "Edit ingredient title")
            navigationItem.rightBarButtonItem = nil
            recipeLabel.text = existingRation.ingredient.name
            nameTextField.text = existingRation.ingredient.name
            amountTextField.text = String(existingRation.amount.value)
            currentUnit = existingRation.amount.unit as? Dimension
            if let currentUnit = currentUnit,
                let index = measurements.index(of: currentUnit) {
                (dummyTextField.inputView as? UIPickerView)?.selectRow(index, inComponent: 0, animated: false)
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get updated recipe if needed
        if let recipe = existingRecipe {
            existingRecipe = RecipeService.shared.recipes.first(where: {$0.uuid == recipe.uuid})
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let delegate = delegate,
            let ration = self.currentRation {
            delegate.didUpdate(ingredient: ration)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RecipeDetailViewController {
            destination.recipe = existingRecipe
            destination.photoService = PhotoService.shared
            destination.recipeService = RecipeService.shared
        }
    }
    
    //MARK: - IBActions
    @IBAction func unitCellTapped(sender cell: UITableViewCell) {
        dummyTextField.becomeFirstResponder()
    }

    @IBAction func removeRecipeTapped(_ sender: Any) {
        existingRecipe = nil
        DispatchQueue.main.async { [tableView, nameTextField] in
            nameTextField?.text = nil
            tableView?.reloadData()
        }
    }
    
}


// MARK: - DataSource Overrides
extension NewIngredientTableViewController {
    private enum Section: Int {
        case recipe = 0
        case name
        case amount
        case units
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionEnum = Section(rawValue:section)
        let recipeSelected = existingRecipe != nil
        switch sectionEnum {
        case .some(.recipe):
            return recipeSelected ? super.tableView(tableView, numberOfRowsInSection: section) : 0
        case .some(.name):
            return recipeSelected ? 0 : super.tableView(tableView, numberOfRowsInSection: section)
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
}

// MARK: - Delegate Overrides
extension NewIngredientTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionEnum = Section(rawValue:section)
        let recipeSelected = existingRecipe != nil
        switch sectionEnum {
        case .some(.recipe):
            return recipeSelected ? super.tableView(tableView, heightForHeaderInSection: section) : 0
        case .some(.name):
            return recipeSelected ? 0 : super.tableView(tableView, heightForHeaderInSection: section)
        default:
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionEnum = Section(rawValue:section)
        let recipeSelected = existingRecipe != nil
        switch sectionEnum {
        case .some(.recipe):
            return recipeSelected ? super.tableView(tableView, titleForHeaderInSection: section) : nil
        case .some(.name):
            return recipeSelected ? nil : super.tableView(tableView, titleForHeaderInSection: section)
        default:
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
}

extension NewIngredientTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurements.count
    }
}

extension NewIngredientTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementFormatter.string(from: measurements[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentUnit = measurements[row]
    }
}

// MARK: - Search

extension NewIngredientTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let resultController = searchController.searchResultsController as? BaseResultsTableViewController,
            let searchText = searchController.searchBar.text?.lowercased() {
            if searchText.count > 0 {
                resultController.filteredResults = searchableIngredients.filter({$0.name.lowercased().contains(searchText)})
            } else {
                resultController.filteredResults = searchableIngredients
            }
            resultController.tableView.reloadData()
        }
    }
}

extension NewIngredientTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension NewIngredientTableViewController: ResultSelectedDelegate {
    func resultSelected(at indexPath: IndexPath) {
        let ingredient = resultsTableViewController.filteredResults[indexPath.row]
        searchController.isActive = false
        existingRecipe =  ingredient as? Recipe ?? nil

        DispatchQueue.main.async {[tableView, nameTextField] in
            nameTextField?.text = ingredient.name
            tableView?.reloadData()
        }
    }
}

extension NewIngredientTableViewController: UISearchControllerDelegate {
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
