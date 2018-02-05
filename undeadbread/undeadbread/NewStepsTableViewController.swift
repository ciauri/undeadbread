//
//  NewStepsTableViewController.swift
//  undeadbread
//
//  Created by stephenciauri on 2/1/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class NewStepsTableViewController: UITableViewController {
    
    var editingSectionIndex: Int?
    var sections: [Recipe.Section] = [Recipe.Section(title: "", steps: [Step(instructions: "", rations: [])])]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEditing(true, animated: false)
        if let sectionToEdit = editingSectionIndex {
            title = NSLocalizedString("Edit Steps", comment: "Title for page where recipe steps are edited")
            DispatchQueue.main.async {[tableView] in
                let targetIndexPath = IndexPath(row: 0, section: sectionToEdit)
                tableView?.scrollToRow(at: targetIndexPath, at: .top, animated: false)
                let cell = tableView?.cellForRow(at: targetIndexPath) as! TextFieldTableViewCell
                cell.textField.becomeFirstResponder()
            }
        }
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
        return sections[section].title != "" ? sections[section].title : NSLocalizedString("New Section", comment: "New section placeholder")
    }
    
    func presentActionSheet(from indexPath: IndexPath) {
        let sheet = UIAlertController(title: NSLocalizedString("Add", comment: "Dialog to add append a step, section, or photo"), message: NSLocalizedString("Which of the following would you like to append?", comment: "Which of the following would you like to append?"), preferredStyle: .actionSheet)

        let stepAction = UIAlertAction(title: NSLocalizedString("Step", comment: "A step in a recipe"), style: .default) {[weak self] (action) in
            if let `self` = self {
                self.sections[indexPath.section].steps.append(Step(instructions: "", rations: []))
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }, completion: { (_) in
                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    let cell = self.tableView.cellForRow(at: indexPath) as? TextViewTableViewCell
                    cell?.textView.becomeFirstResponder()
                })
            }
        }
        
        let photoAction = UIAlertAction(title: NSLocalizedString("Photo", comment: "A photograph of the step in a recipe"), style: .default, handler: nil)
        let sectionAction = UIAlertAction(title: NSLocalizedString("Section", comment: "A section in a list of recipe steps"), style: .default) {[weak self] (action) in
            if let `self` = self {
                self.sections.insert(Recipe.Section(title: "", steps: [Step(instructions: "", rations: [])]), at: indexPath.section + 1)
                let newSection = indexPath.section + 1
                self.tableView.performBatchUpdates({
                    self.tableView.insertSections([newSection], with: .automatic)
                }, completion: { (_) in
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: newSection), at: .middle, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: newSection)) as? TextFieldTableViewCell
                    cell?.textField.becomeFirstResponder()
                })
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        [stepAction, photoAction, sectionAction, cancelAction].forEach({sheet.addAction($0)})
        present(sheet, animated: true, completion: nil)
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 && indexPath.row != tableView.lastRowInSection(section: indexPath.section)
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sections[indexPath.section].steps.remove(at: indexPath.row - 1)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: { _ in
                tableView.reloadSections([indexPath.section], with: .automatic)
            })
        } else if editingStyle == .insert {
            sections[indexPath.section].steps.insert(Step(instructions: "", rations: []), at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let lastRow = tableView.lastRowInSection(section: proposedDestinationIndexPath.section)
        guard proposedDestinationIndexPath.row != 0 &&
        (proposedDestinationIndexPath.section != sourceIndexPath.section ? proposedDestinationIndexPath.row <= lastRow : proposedDestinationIndexPath.row < lastRow) else {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let step = sections[fromIndexPath.section].steps.remove(at: fromIndexPath.row - 1)
        sections[to.section].steps.insert(step, at: to.row - 1)
        DispatchQueue.main.async {
            tableView.reloadSections([fromIndexPath.section, to.section], with: .none)
        }
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 && indexPath.row != tableView.lastRowInSection(section: indexPath.section)
    }
 

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
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func textViewDidChange(textView: UITextView, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let step = Step(instructions: textView.text.trimmingCharacters(in: .whitespacesAndNewlines), rations: [])
            sections[indexPath.section].steps[indexPath.row - 1] = step
        }
    }
}

extension NewStepsTableViewController: TextFieldTableViewCellDelegate {
    func textFieldDidChange(text: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let section = Recipe.Section(title: text.trimmingCharacters(in: .whitespacesAndNewlines), steps: sections[indexPath.section].steps)
            sections[indexPath.section] = section
        }
    }
}


