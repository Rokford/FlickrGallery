//
//  FlickrGalleryTableViewCellViewModelTests.swift
//  FlickrGalleryTests
//
//  Created by Grzegorz Izworski on 15/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import XCTest

class FlickrGalleryTableViewCellViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGettingStringFromDateAndGettingDateFromString() {
        let viewModel = FlickrGalleryTableViewCellViewModel()
        let dateFormatA = "yyyy-MM-dd HH:mm:ss"
        let dateFormatB = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatC = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        let date = Date(timeIntervalSinceReferenceDate: 0)
        
        var stringFromDate = viewModel.stringFromDate(date: date, dateFormat: dateFormatA)
        
        var dateFromString = viewModel.dateFromString(dateString: stringFromDate, dateFormat: dateFormatA)
        
        XCTAssertTrue(date.compare(dateFromString!) == .orderedSame)
        
        stringFromDate = viewModel.stringFromDate(date: date, dateFormat: dateFormatB)
        
        dateFromString = viewModel.dateFromString(dateString: stringFromDate, dateFormat: dateFormatB)
        
        XCTAssertTrue(date.compare(dateFromString!) == .orderedSame)
        
        stringFromDate = viewModel.stringFromDate(date: date, dateFormat: dateFormatC)
        
        dateFromString = viewModel.dateFromString(dateString: stringFromDate, dateFormat: dateFormatC)
        
        XCTAssertTrue(date.compare(dateFromString!) == .orderedSame)
        
        dateFromString = viewModel.dateFromString(dateString: stringFromDate, dateFormat: "wrongFormat")
        
        XCTAssertTrue(dateFromString == nil)
    }
}
