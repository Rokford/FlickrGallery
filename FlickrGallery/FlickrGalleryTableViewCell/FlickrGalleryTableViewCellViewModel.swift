//
//  FlickrGalleryTableViewCellViewModel.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 11/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrGalleryTableViewCellViewModel: NSObject {
    var title: String = ""
    var imageUrl: String = ""
    var dateTaken: Date?
    var datePublished: Date?
    var author: String = ""
    var tags: String = ""
    
    enum dateFields {
        case dateTaken
        case datePublished
    }
    
    func parseAndSetDate(fromString dateString: String, field: dateFields) {
        if field == .dateTaken {
            if let date = dateFromString(dateString: dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                dateTaken = date
            }
        } else {
            if let date = dateFromString(dateString: dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX") {
                datePublished = date
            }
        }
    }
    
    func getDateAsString(_ field: dateFields) -> String {
        let date = field == .dateTaken ? dateTaken : datePublished
        if let dateToFormat = date {
            return stringFromDate(date: dateToFormat, dateFormat: "yyyy-MM-dd HH:mm:ss")
        } else {
            return "Unknown"
        }
    }
    
    func dateFromString(dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: dateString)
    }
    
    func stringFromDate(date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: date)
    }
}
