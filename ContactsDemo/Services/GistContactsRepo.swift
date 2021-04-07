//
//  GistContactsRepo.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

class TimeoutError : Error {}

class GistContactsRepo: ContactsRepository {
    
    private let url: URL
    private let decoder: JSONDecoder
    
    private var contacts: [Contact] = []
    
    private struct ContactsResponse: Decodable {
        let firstname: String
        let lastname: String
        let phone: String
        let email: String
        let photoUrl: String?
    }
    
    init(url: URL) {
        self.url = url
        decoder = JSONDecoder()
    }
    
    private func parse(json: Data) throws -> [Contact] {
        return try self.decoder.decode([ContactsResponse].self, from: json).map {
            var url: URL?
            if let urlString = $0.photoUrl {
                url = URL(string: urlString)
            }
            return Contact(recordId: UUID().uuidString,
                    firstName: $0.firstname,
                    lastName: $0.lastname,
                    phone: $0.phone,
                    birthday: nil,
                    photoUrl: url)
        }
    }
    
    func getContacts() throws -> [Contact] {
        
        guard contacts.isEmpty else {
            return contacts
        }
        
        let sem = DispatchSemaphore(value: 0)
        let request = URLRequest(url: url)
        
        var resultError: Error? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                sem.signal()
            }
            
            guard error == nil else {
                resultError = error
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                self.contacts = try self.parse(json: data)
            } catch {
                resultError = error
            }
        }
        task.resume()
        
        let result = sem.wait(timeout: DispatchTime.now() + .seconds(30))
        
        if result == .timedOut {
            resultError = TimeoutError()
        }
        
        if let error = resultError {
            throw error
        }
        
        return contacts
    }
    
    func add(contact: ContactsData) throws {
        let contactWithID = Contact(
            recordId: UUID().uuidString,
            firstName: contact.firstName,
            lastName: contact.lastName,
            phone: contact.phone,
            birthday: contact.birthday,
            photoUrl: contact.photoUrl
        )
        contacts.append(contactWithID)
    }
    
    func delete(contact: Contact) throws {
        contacts.removeAll(where: {$0.recordId == contact.recordId})
    }
    
    func update(contact: Contact) throws {
        guard let index = contacts.firstIndex(where: {
            $0.recordId == contact.recordId
        }) else {
            print("Attempting to modify a nonexistent contact")
            return
        }
        contacts[index] = contact
    }
}

extension GistContactsRepo: CachingContactRepository {
    
    private func cachePath() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cache.dat")
    }
    
    func saveToCache() throws {
        let path = cachePath()
        let contactsData = try JSONEncoder().encode(self.contacts)
        try contactsData.write(to: path)
    }
    
    func fetchFromCache() -> [Contact] {
        do {
            contacts = try fetchFromCacheOrThrow()
        } catch {
            print("Failed to fetch from cache, reason: \(error.localizedDescription)")
        }
        return contacts
    }
    
    func fetchFromCacheOrThrow() throws -> [Contact] {
        let path = cachePath()
        let cachedData = try Data(contentsOf: path)
        contacts = try decoder.decode([Contact].self, from: cachedData)
        return contacts
    }
}
