//
//  CachingImage.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation
import UIKit

//Good to Have: Currently this is a temporary cache, we can go with third party libraies like kingfisher to have a permanent cache.
let imageCache = NSCache<AnyObject, AnyObject>()

class CachingImage: UIImageView {

    var imageURL: URL?
    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        // setup activityIndicator...
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url
        image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}

