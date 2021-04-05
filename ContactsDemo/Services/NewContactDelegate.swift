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
    
    var otherDelegate: CNContactViewControllerDelegate?
    
    override init (){
        super.init()
        otherDelegate = self
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
            birthday: contact.birthday
        )
        
        if let birthday = contact.birthday {
            
            let content = UNMutableNotificationContent()
            content.title = "Happy birthday!"
            content.body = "Remember to wish \(contact.givenName) \(contact.familyName) a happy birthday!"
            
            let date = Date()
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.month = birthday.month
            dateComponents.day = birthday.day
            dateComponents.hour = Calendar.current.component(.hour, from: date)
            dateComponents.minute = Calendar.current.component(.minute, from: date) + 1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error creating notification: \(String(describing: error?.localizedDescription))")
                }
            })
        }
        
        if let callback = onSave {
            callback(uiContact)
        } else {
            print("Save callback not found")
        }
        
        viewController.dismiss(animated: true)
    }
}
