//
//  NoteTableViewController.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/2/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class NoteTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // This code declares a property and initializes it with a default value (an empty array of Note objects)
    var notes = [Note]()

    override func viewDidLoad() {
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        super.viewDidLoad()

        loadStoredNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        cell.photoImageView.image = note.photo

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Remove from Realm
            let selectedNote = realm.objects(Note.self).filter("id == \(notes[indexPath[1]].id)").first
            try! realm.write {
                realm.delete(selectedNote!)
            }
            
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // In a storyboard-based application, do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "AddItem":
                os_log("Adding a new note", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                // Get the new view controller using segue.destinationViewController.
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
                
                // Pass the selected note to the new view controller.
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
                
                // Update note in Realm
                let selectedNote = realm.objects(Note.self).filter("id == \(note.id)").first
                try! realm.write {
                    selectedNote!.title = note.title
                    selectedNote!.note = note.note
                    selectedNote!.photoUrl = note.photoUrl
                }
                
            } else {
                // Add a new note
                let newIndexPath = IndexPath(row: notes.count, section: 0)
                notes.append(note)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                print("Adding a note", note.id)
                
                // Insert into Realm here
                let myNote = Note()
                myNote.id = note.id
                myNote.title = note.title
                myNote.note = note.note
                myNote.photoUrl = note.photoUrl
                realm.beginWrite()
                realm.add(myNote)
                try! realm.commitWrite()
                
            }
            
        }
    }
    
    private func loadStoredNotes() {

        let results = realm.objects(Note.self)
        
        for result in results {
            
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            
            if let dirPath = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(result.photoUrl)
                let image    = UIImage(contentsOfFile: imageURL.path)
                
                let note = Note()
                note.id = result.id
                note.title = result.title
                note.note = result.note
                note.photo = image
                note.photoUrl = result.photoUrl
                notes += [note]
            }
            
        }
    }

}
