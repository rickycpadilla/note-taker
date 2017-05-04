//
//  NoteViewController.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/1/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit
import os.log

class NoteViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var note: Note?
    var id: Int?
    var photoUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks.
        titleTextField.delegate = self
        noteTextField.delegate = self
        
        // Set up views if editing an existing Note.
        if let note = note {
            
            navigationItem.title = note.title
            titleTextField.text = note.title
            noteTextField.text = note.note
            photoImageView.image = note.photo
            id = note.id
            photoUrl = note.photoUrl
            
        } else {
            
            // Setup new note id
            id = Int(Date().timeIntervalSince1970 * 1000)
        }
        
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let title = titleTextField.text ?? ""
        let noteText = noteTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the note to be passed to NoteTableViewController after the unwind segue
        note = Note()
        note!.id = id!
        note!.title = title
        note!.note = noteText
        note!.photo = photo
        note!.photoUrl = photoUrl!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == titleTextField {
            noteTextField.becomeFirstResponder()
        }
        return true
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddNoteMode = presentingViewController is UINavigationController
        if isPresentingInAddNoteMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The NoteViewController is not inside a navigation controller")
        }
        
    }
    
    @IBAction func selectImagefromLibrary(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else {
                fatalError("Expecetd a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // create a name for image
        let timestamp = Date().timeIntervalSince1970 * 1000
        var fileName = String(timestamp)
        
        if let i = fileName.characters.index(of: ".") {
            fileName.remove(at: i)
            fileName += ".png"
        }
        
        // Store image in Documents
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try UIImagePNGRepresentation(selectedImage)!.write(to: fileURL)
                print("Image Added Successfully")
            } catch {
                print(error)
            }
        } else {
            print("Image Not Added")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        photoUrl = fileName
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateSaveButtonState()
        navigationItem.title = titleTextField.text
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let titleText = titleTextField.text ?? ""
        let noteText = noteTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty || !noteText.isEmpty
    }

}

