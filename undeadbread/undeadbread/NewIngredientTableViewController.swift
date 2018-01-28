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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let existingRation = existingRation {
            navigationItem.rightBarButtonItem = nil
            nameTextField.text = existingRation.ingredient.name
            amountTextField.text = String(existingRation.amount.value)
            currentUnit = (existingRation.amount.unit as! Dimension)
            if let index = measurements.index(of: currentUnit!) {
                (self.dummyTextField.inputView as? UIPickerView)?.selectRow(index, inComponent: 0, animated: false)
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
