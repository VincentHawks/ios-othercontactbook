//
//  NewContactDelegate.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 05.04.2021.
//

import Foundation
import Contacts
import ContactsUI


class NewContactDelegate: NSObject, CNContactViewControllerDelegate {
    
    var onSave: ((ContactsData) -> Void)?
    
    var notificationService: NotificationService
    
    override init (){
        notificationService = BirthdayNotificationService()
        super.init()
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        guard let contact = contact else {
            viewController.dismiss(animated: true)
            return
        }
        
        let uiContact = ContactsData(
            firstName: contact.givenName,
            lastName: contact.familyName,
            phone: contact.phoneNumbers.first?.value.stringValue ?? "",
            birthday: contact.birthday,
            photoUrl: nil
        )
        
        if contact.birthday != nil,
           notificationService.requestPermission() {
            notificationService.registerNotification(for: uiContact)
        }
        
        if let callback = onSave {
            callback(uiContact)
        } else {
            print("Save callback not found")
        }
        
        viewController.dismiss(animated: true)
    }
}
