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
    // MARK: - Injections
    var existingRation: Ration?
    weak var delegate: IngredientModifiedDelegate?

    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
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
        pickerView(unitPickerView, didSelectRow: 0, inComponent: 0)
        return field
    }()
    
    private var measurements: [Dimension] {
        let masses: [Dimension] = Ration.acceptableMasses
        let volumes: [Dimension] = Ration.acceptableVolumes
        return masses + volumes
    }
    
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
    
    var currentRation: Ration? {
        guard let measurement = currentMeasurement,
            let name = nameTextField.text else {
                return nil
        }
        return Ration(amount: measurement, ingredient: Ingredient(name: name, recipe: nil))
    }
    
    // MARK: - Search
    
    lazy var resultsTableViewController: BaseResultsTableViewController = {
        let controller = BaseResultsTableViewController()
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        if let existingRation = existingRation {
            title = NSLocalizedString("Edit Ingredient", comment: "Edit ingredient title")
            navigationItem.rightBarButtonItem = nil
            nameTextField.text = existingRation.ingredient.name
            amountTextField.text = String(existingRation.amount.value)
            currentUnit = (existingRation.amount.unit as! Dimension)
            if let index = measurements.index(of: currentUnit!) {
                (dummyTextField.inputView as? UIPickerView)?.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let delegate = delegate,
            let ration = self.currentRation {
            delegate.didUpdate(ingredient: ration)
        }
    }


    @IBAction func unitCellTapped(sender cell: UITableViewCell) {
        dummyTextField.becomeFirstResponder()
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

extension NewIngredientTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            // nobody cares
        } else {
            let ingredient = resultsTableViewController.filteredResults[indexPath.row]
            nameTextField.text = ingredient.description
            searchController.isActive = false
        }
    }
}

extension NewIngredientTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let resultController = searchController.searchResultsController as? BaseResultsTableViewController {
            // TODO: Real results
            resultController.filteredResults = [Ingredient(name: "Water", recipe: nil)]
            resultController.tableView.reloadData()
        }
    }
}

extension NewIngredientTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
