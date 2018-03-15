//
//  FlickrFeedDownloadService.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 11/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrFeedDownloadService: NSObject {
    let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    typealias ServiceResponse = (AnyObject?, HTTPURLResponse?, NSError?) -> Void
    
    func downloadFlickrFeed(onCompletion: @escaping ([FlickrGalleryTableViewCellViewModel], NSError?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        makeHTTPRequest(url) {
            json, response, error in
            let parsedItems = self.parseFeedJsonIntoItemsArray(json)
            
            onCompletion(parsedItems, error)
        }
    }
    
    func parseFeedJsonIntoItemsArray(_ json: AnyObject?) -> [FlickrGalleryTableViewCellViewModel] {
        
        func getStringOrPlaceholder(string: String, placeholder: String) -> String {
            if string.trimmingCharacters(in: .whitespaces).isEmpty {
                return placeholder
            }
            
            return string
        }
        
        var parsedItems = [FlickrGalleryTableViewCellViewModel]()
        
        guard let parsedJson = json, let itemsArray = parsedJson["items"] as? NSArray else {
            return parsedItems
        }
        for unwrappedItem in itemsArray {
            if let item = unwrappedItem as? [String: Any] {
                let flickrGalleryTableViewCellViewModel = FlickrGalleryTableViewCellViewModel()
                
                if let title = item["title"] as? String {
                    flickrGalleryTableViewCellViewModel.title = getStringOrPlaceholder(string: title, placeholder: "Untitled")
                }
                if let author = item["author"] as? String {
                    flickrGalleryTableViewCellViewModel.author = getStringOrPlaceholder(string: author, placeholder: "Unknown")
                }
                if let dateTaken = item["date_taken"] as? String {
                    flickrGalleryTableViewCellViewModel.parseAndSetDate(fromString: dateTaken, field: .dateTaken)
                }
                if let datePublished = item["published"] as? String {
                    flickrGalleryTableViewCellViewModel.parseAndSetDate(fromString: datePublished, field: .datePublished)
                }
                if let tags = item["tags"] as? String {
                    flickrGalleryTableViewCellViewModel.tags = getStringOrPlaceholder(string: tags, placeholder: "-")
                }
                if let imageWrapper = item["media"] as? [String: Any] {
                    if let imageUrl = imageWrapper["m"] as? String {
                        flickrGalleryTableViewCellViewModel.imageUrl = imageUrl
                    }
                }
                
                parsedItems.append(flickrGalleryTableViewCellViewModel)
            }
        }
        
        return parsedItems
    }
    
    func downloadFlickrFeedImage(for itemUrl: String, onCompletion: @escaping (UIImage?, NSError?) -> Void) {
        guard let url = URL(string: itemUrl) else {
            return
        }
        
        var task = URLSessionDownloadTask()
        
        task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            if let data = try? Data(contentsOf: url){
                let img:UIImage? = UIImage(data: data)
                
                onCompletion(img, error as NSError?)
            }
        })
        task.resume()
    
    }
    
    fileprivate func makeHTTPRequest(_ url: URL, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            var json: Any?
            var error: NSError?
            var httpResponseCode = -1
            
            if let response = (response as? HTTPURLResponse) {
                httpResponseCode = response.statusCode
            }
            
            if httpResponseCode != 200 {
                error = NSError(domain: "FlickrFeed", code: httpResponseCode, userInfo: nil)
            }
            
            if data != nil {
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                } catch let anError as NSError {
                    error = anError
                }
            }
            onCompletion(json as AnyObject, response as? HTTPURLResponse, error)
        }
        task.resume()
    }
}
