//
//  FlickrGalleryUITests.swift
//  FlickrGalleryUITests
//
//  Created by Grzegorz Izworski on 09/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import XCTest

class FlickrGalleryUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasicUIFlow() {
        let app = XCUIApplication()
        app.navigationBars["Flickr Gallery"].buttons["Sort"].tap()
        app.sheets.buttons.element(boundBy: 0).tap()
        app.tables.cells.element(boundBy: 0).tap()
        app.navigationBars["FlickrGallery.FlickrGalleryImageView"].buttons["Flickr Gallery"].tap()
    }
}
