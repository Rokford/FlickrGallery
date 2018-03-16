//
//  FlickrGalleryViewModel.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 11/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrGalleryViewModel: NSObject {
    let sortAlertMessage = "Sort the items list. Please note that refreshing the list will reset this settings."
    let sortByDateTakenMessage = "Sort by date taken (newest first)"
    let sortByDatePublishedMessage = "Sort by date published (newest first)"
    let cancelSortAlertTitle = "Cancel"
    
    var flickrGalleryItems: [FlickrGalleryTableViewCellViewModel] = []
    var flickrGalleryNotFilteredItems: [FlickrGalleryTableViewCellViewModel] = []
    var delegate: FlickrGalleryViewModelDelegate?
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    func sortFlickrGalleryItemsByDate(field: FlickrGalleryTableViewCellViewModel.dateFields, ordering: ComparisonResult) {
        if ordering == .orderedDescending {
            if field == .dateTaken {
                flickrGalleryItems.sort(by: { ($0.dateTaken ?? .distantPast) > ($1.dateTaken ?? .distantPast)})
            } else {
                flickrGalleryItems.sort(by: { ($0.datePublished ?? .distantPast) > ($1.datePublished ?? .distantPast)})
            }
        }
    }
    
    func filterFlickrGalleryItems(byText text: String) {
        if flickrGalleryNotFilteredItems.count == 0 {
            flickrGalleryNotFilteredItems = flickrGalleryItems
        }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            flickrGalleryItems = flickrGalleryNotFilteredItems
        } else {
            flickrGalleryItems = flickrGalleryNotFilteredItems
            for (i,item) in flickrGalleryItems.enumerated().reversed() {
                if item.tags.lowercased().range(of:text.lowercased()) == nil {
                    flickrGalleryItems.remove(at: i)
                }
            }
        }
    }
    
    func getCachedFlickrFeedImage(forUrl url: String) -> UIImage? {
        if (self.cache.object(forKey: url as AnyObject) != nil){
            return self.cache.object(forKey: url as AnyObject) as? UIImage
        }
        
        return nil
    }
    
    func addFlickrFeedImageToCache(image: UIImage, key: String) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    func downloadFlickrFeed() {
        let flickrDownloadService = FlickrFeedDownloadService()
        
        flickrDownloadService.downloadFlickrFeed() {
            items, error in
            if let errorToPass = error {
                self.delegate?.showDownloadError(errorToPass)
            } else {
                self.flickrGalleryItems = items
                self.delegate?.refreshList()
            }
        }
    }
    
    func getFlickrFeedImage(for url: String, onCompletion: @escaping (UIImage?) -> Void) {
        // return cached image if it exists
        if (self.cache.object(forKey: url as AnyObject) != nil){
            onCompletion(self.cache.object(forKey: url as AnyObject) as? UIImage)
        } else {
            let flickrDownloadService = FlickrFeedDownloadService()
            
            flickrDownloadService.downloadFlickrFeedImage(for: url) {
                image, error in
                if let errorToPass = error {
                    self.delegate?.showDownloadError(errorToPass)
                } else {
                    self.cache.setObject(image!, forKey: url as AnyObject)
                    onCompletion(image)
                }
            }
        }
    }
}

protocol FlickrGalleryViewModelDelegate {
    func refreshList()
    func showDownloadError(_ error: NSError)
}
