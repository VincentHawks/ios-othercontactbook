//
//  CachingRepository.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 31.03.2021.
//

import Foundation

protocol CachingContactRepository {
    
    func saveToCache() throws
    func fetchFromCache() -> [Contact]
    func fetchFromCacheOrThrow() throws -> [Contact]
}
