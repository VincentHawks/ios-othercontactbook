//
//  ContactInfoViewControllerDelegate.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 07.04.2021.
//

import Foundation
import UIKit
import YYImage

class ContactInfoViewControllerDelegate {
    
    func fetchGif(from url: URL, callback: ((UIImage) -> Void)) {
        let sem = DispatchSemaphore(value: 0)
        var resultError: Error?
        var resultImage: UIImage?
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {
            data, response, error in
            
            defer {
                sem.signal()
            }
            
            guard error == nil else {
                resultError = error!
                return
            }
            
            guard let data = data else {
                return
            }
            
            let decoder = YYImageDecoder(data: data, scale: 1.0)
            guard let image = decoder?.frame(at: 0, decodeForDisplay: true)?.image else {
                return
            }
            
            resultImage = image
            
        })
        task.resume()
        let timeoutResult = sem.wait(timeout: DispatchTime.now() + .seconds(10))
        
        if let error = resultError {
            print(error.localizedDescription)
        } else {
            switch timeoutResult {
            case .success:
                guard let finalImage = resultImage else {
                    print("Error while loading image")
                    return
                }
                callback(finalImage)
            case .timedOut:
                print("Image loading timed out")
            }
        }
    }
    
}
