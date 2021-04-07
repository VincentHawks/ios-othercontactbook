//
//  BirthdayNotificationService.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 07.04.2021.
//

import Foundation
import UIKit

class BirthdayNotificationService : NotificationService {
    
    func hasPermission() -> Bool {
        fatalError("not implemented")
    }
    
    func requestPermission() -> Bool {
        var allowed = false
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            if error == nil {
                allowed = true
            } else {
                print(error!.localizedDescription)
            }
        }
        return allowed
    }
    
    func registerNotification(for contact: ContactsData) {
        guard let birthday = contact.birthday else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Happy birthday!"
        content.body = "Remember to wish \(contact.firstName) \(contact.lastName) a happy birthday!"
        
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
    
    func unregisterNotification(for contact: Contact) {
        fatalError("not implemented")
    }
    
}
