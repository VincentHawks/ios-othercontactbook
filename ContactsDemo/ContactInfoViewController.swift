//
//  NewContactViewController.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import UIKit

class ContactInfoViewController: UIViewController {

    private var contactID: String! {
        get {
            return oldContact?.recordId
        }
    }
    
    var oldContact: Contact?
    
    @IBOutlet private var firstNameField: UITextField!
    @IBOutlet private var lastNameField: UITextField!
    @IBOutlet private var phoneField: UITextField!
    
    var onResult: ((Contact) -> Void)?
    
    override func viewDidLoad() {
        firstNameField.text = oldContact?.firstName
        lastNameField.text = oldContact?.lastName
        phoneField.text = oldContact?.phone
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard contactID == oldContact?.recordId ||
              firstNameField.text != oldContact?.firstName ||
              lastNameField.text != oldContact?.lastName ||
              phoneField.text != oldContact?.phone
        else {
            return
        }
        
        onResult?(Contact(recordId: contactID, firstName: firstNameField.text ?? "", lastName: lastNameField.text ?? "", phone: phoneField.text ?? "", birthday: nil))
        navigationController?.popViewController(animated: true)
    }
}
