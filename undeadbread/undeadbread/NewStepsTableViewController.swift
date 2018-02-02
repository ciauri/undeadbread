//
//  NewStepsTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 2/1/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class NewStepsTableViewController: UITableViewController {
    
    var sections: [Recipe.Section] = [Recipe.Section(title: "Test Section", steps: [Step(instructions: "", rations: [])])]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections[section].steps.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = NSLocalizedString("Section Title", comment: "The title of a section of instructions")
            cell.textField.text = section.title
            cell.textField.delegate = cell
            cell.delegate = self
            return cell
        } else  if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
            return tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
        } else {
            let step = section.steps[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! TextViewTableViewCell
            cell.numberingLabel.text = "\(indexPath.row)."
            cell.textView.text = step.instructions
            cell.textView.delegate = cell
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.lastRowInSection(section: indexPath.section) {
            presentActionSheet(from: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func presentActionSheet(from indexPath: IndexPath) {
        let sheet = UIAlertController(title: NSLocalizedString("Add", comment: "Dialog to add append a step, section, or photo"), message: NSLocalizedString("Which of the following would you like to append?", comment: "Which of the following would you like to append?"), preferredStyle: .actionSheet)

        let stepAction = UIAlertAction(title: NSLocalizedString("Step", comment: "A step in a recipe"), style: .default) {[weak self] (action) in
            if let `self` = self {
                self.sections[indexPath.section].steps.append(Step(instructions: "New step", rations: []))
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        let photoAction = UIAlertAction(title: NSLocalizedString("Photo", comment: "A photograph of the step in a recipe"), style: .default, handler: nil)
        let sectionAction = UIAlertAction(title: NSLocalizedString("Section", comment: "A section in a list of recipe steps"), style: .default) {[weak self] (action) in
            if let `self` = self {
                self.sections.insert(Recipe.Section(title: "Test Section", steps: [Step(instructions: "", rations: [])]), at: indexPath.section + 1)
                self.tableView.beginUpdates()
                self.tableView.insertSections([indexPath.section + 1], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        [stepAction, photoAction, sectionAction, cancelAction].forEach({sheet.addAction($0)})
        present(sheet, animated: true, completion: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewStepsTableViewController: TextViewTableViewCellDelegate {
    func textViewHeightDidChange(in cell: UITableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidChange(textView: UITextView, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let step = Step(instructions: textView.text, rations: [])
            sections[indexPath.section].steps[indexPath.row - 1] = step
        }
    }
}

extension NewStepsTableViewController: TextFieldTableViewCellDelegate {
    func textFieldDidChange(text: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let section = Recipe.Section(title: text, steps: sections[indexPath.section].steps)
            sections[indexPath.section] = section
        }
    }
}


