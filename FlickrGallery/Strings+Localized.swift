//
//  Strings+Localized.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 19/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import Foundation

import Foundation
extension String {
    //MARK: FlickrGalleryViewController
    static let sortAlertMessage = "Sort the items list. Please note that refreshing the list will reset this settings."
    static let sortByDateTakenMessage = "Sort by date taken (newest first)"
    static let sortByDatePublishedMessage = "Sort by date published (newest first)"
    static let cancelSortAlertTitle = "Cancel"
    
    //MARK: FlickrGalleryTableViewCell
    static let dateTakenFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let datePublishedFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    static let dateDisplayedFormat = "yyyy-MM-dd HH:mm:ss"
    static let unknownDateString = "Unknown"
    
    //MARK: DownloadService
    static let noTitlePlaceholder = "Untitled"
    static let noAuthorPlaceholder = "Unknown"
}
