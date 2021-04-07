//
//  NotificationService.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 07.04.2021.
//

import Foundation

protocol NotificationService {
    
    /// Checks whether the application has the permission to send notifications. Returns true if permission granted, false otherwise
    func hasPermission() -> Bool
    
    /// Requests user permission for notifications, returns true on success
    func requestPermission() -> Bool
    
    func registerNotification(for contact: ContactsData)
    func unregisterNotification(for contact: Contact)
    
}
