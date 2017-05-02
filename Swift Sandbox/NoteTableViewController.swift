//
//  NoteTableViewController.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/2/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit
import os.log

class NoteTableViewController: UITableViewController {
    
    // This code declares a property and initializes it with a default value (an empty array of Note objects)
    var notes = [Note]()
    

    override func viewDidLoad() {
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        super.viewDidLoad()

        loadSampleNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequed using a cell identifier.
        let cellIdentifier = "NoteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("The dequeued cell is not an instance of NoteTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let note = notes[indexPath.row]
        
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        cell.photoImageView.image = note.photo

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new note", log: OSLog.default, type: .debug)
            case "ShowDetail":
                guard let noteDetailViewController = segue.destination as? NoteViewController
                    else {
                        fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedNoteCell = sender as? NoteTableViewCell else {
                    fatalError("Unexpected sender: \(sender!)")
                }
                guard let indexPath = tableView.indexPath(for: selectedNoteCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                let selectedNote = notes[indexPath.row]
                noteDetailViewController.note = selectedNote
            default: fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }
    
    @IBAction func unwindToNoteList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as?
            NoteViewController, let note = sourceViewController.note {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing note
                notes[selectedIndexPath.row] = note
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new note
                let newIndexPath = IndexPath(row: notes.count, section: 0)
                notes.append(note)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    
    private func loadSampleNotes() {
        let photo1 = UIImage(named: "note01")
        guard let note1 = Note(title: "Favorite Meal", note: "I really love tomatoes. If I could only ever eat tomatoes, that would be fine with me. I think I'll have a bowl of tomatoes for lunch.", photo: photo1) else {
            fatalError("Unable to instantiate note1")
        }
        guard let note2 = Note(title: "Can't stop thinking about tomatoes.", note: "Tomatoes are SO good! I really love tomatoes. If I could only ever eat tomatoes, that would be fine with me. I think I'll have a bowl of tomatoes for lunch.", photo: photo1) else {
            fatalError("Unable to instantiate note2")
        }
        notes += [note1, note2]
    }

}