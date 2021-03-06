//
//  ContactsRepository.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

struct Contact {
    let recordId: String
    let firstName: String
    let lastName: String
    let phone: String
    let birthday: DateComponents?
    let photoUrl: URL?
}

struct ContactsData {
    let firstName: String
    let lastName: String
    let phone: String
    let birthday: DateComponents?
    let photoUrl: URL?
}


protocol ContactsRepository {
    
    func getContacts() throws -> [Contact]
    
    func add(contact: ContactsData) throws
    func delete(contact: Contact) throws
    func update(contact: Contact) throws
}

extension Contact : Codable {}
