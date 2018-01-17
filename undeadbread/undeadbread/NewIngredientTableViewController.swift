//
//  NewIngredientTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 1/16/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class NewIngredientTableViewController: UITableViewController {
    let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
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

    var measurements: [Dimension] {
        let masses: [Dimension] = Ration.acceptableMasses
        let volumes: [Dimension] = Ration.acceptableVolumes
        return masses + volumes
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
}
