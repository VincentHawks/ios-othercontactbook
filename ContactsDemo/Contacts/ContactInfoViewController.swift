//
//  NewContactViewController.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import UIKit
import YYImage

class ContactInfoViewController: UIViewController {

    private var contactID: String! {
        get {
            return oldContact?.recordId
        }
    }
    
    var oldContact: Contact!
    let delegate = ContactInfoViewControllerDelegate()
    
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet weak var proceduralAvatar: AvatarView!
    @IBOutlet weak var gifAvatar: YYAnimatedImageView!
    
    
    var onResult: ((Contact) -> Void)?
    
    override func viewDidLoad() {
        firstNameField.text = oldContact?.firstName
        lastNameField.text = oldContact?.lastName
        phoneField.text = oldContact?.phone
        proceduralAvatar.firstName = oldContact.firstName
        proceduralAvatar.lastName = oldContact.lastName
        
        if let url = oldContact.photoUrl {
            async { [weak self] in
                self?.delegate.fetchGif(from: url) {
                    image in
                    print("in callback")
                    asyncMain {
                        self?.gifAvatar.image = image
                        self?.gifAvatar.sizeToFit()
                        self?.gifAvatar.startAnimating()
                        self?.gifAvatar.isHidden = false
                        self?.proceduralAvatar.isHidden = true
                    }
                    
                }
            }
        }
        print("end of viewdidload")
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard contactID == oldContact?.recordId ||
              firstNameField.text != oldContact?.firstName ||
              lastNameField.text != oldContact?.lastName ||
              phoneField.text != oldContact?.phone
        else {
            return
        }
        
        onResult?(
            Contact(
                recordId: contactID,
                firstName: firstNameField.text ?? "",
                lastName: lastNameField.text ?? "",
                phone: phoneField.text ?? "",
                birthday: oldContact.birthday,
                photoUrl: oldContact.photoUrl
            )
        )
        navigationController?.popViewController(animated: true)
    }
}
