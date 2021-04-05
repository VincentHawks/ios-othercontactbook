//
//  HardcodedRepo.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

class HardcodedRepo {
    private var records: [CallRecord] = []
    private var contacts: [Contact] = [
        Contact(recordId: "1", firstName: "1", lastName: "", phone: "1234567890", birthday: nil),
        Contact(recordId: "2", firstName: "2", lastName: "", phone: "657686433", birthday: nil),
        Contact(recordId: "3", firstName: "3", lastName: "", phone: "432563", birthday: nil),
        Contact(recordId: "4", firstName: "4", lastName: "", phone: "8756765", birthday: nil),
    ]
}

extension HardcodedRepo: ContactsRepository {
    func getContacts() throws -> [Contact] {
        return contacts
    }
    
    func add(contact: ContactsData) throws {
        contacts.append(Contact(
                            recordId: UUID().uuidString,
                            firstName: contact.firstName,
                            lastName: contact.lastName,
                            phone: contact.phone,
                            birthday: contact.birthday
        ))
    }
    
    func delete(contact: Contact) throws {
        contacts.removeAll(where: {$0.recordId == contact.recordId})
    }
    
    func update(contact: Contact) throws {
        guard let index = contacts.firstIndex(where: {$0.recordId == contact.recordId}) else {
            print("Attempting to modify a nonexistent contact")
            return
        }
        contacts[index] = contact
    }
}

extension HardcodedRepo: CallHistoryRepository {
    
    func getHistory() throws -> [CallRecord] {
        return records
    }
    
    func add(record: CallRecord) throws {
        records.append(record)
    }
    
    
}
