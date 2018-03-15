//
//  FlickrGalleryViewModelTests.swift
//  FlickrGalleryTests
//
//  Created by Grzegorz Izworski on 15/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import XCTest

class FlickrGalleryViewModelTests: XCTestCase {
    let testItemA = FlickrGalleryTableViewCellViewModel()
    let testItemB = FlickrGalleryTableViewCellViewModel()
    let testItemC = FlickrGalleryTableViewCellViewModel()
    
    override func setUp() {
        super.setUp()
        
        testItemA.title = "testItemA"
        testItemA.tags = "home aa"
        testItemA.dateTaken = Date(timeIntervalSinceReferenceDate: 100)
        testItemA.datePublished = Date(timeIntervalSinceReferenceDate: 20)
        
        testItemB.title = "testItemB"
        testItemB.tags = "aa"
        testItemB.dateTaken = Date(timeIntervalSinceReferenceDate: 1000)
        testItemB.datePublished = Date(timeIntervalSinceReferenceDate: 2000)
        
        testItemC.title = "testItemC"
        testItemC.tags = ""
        testItemC.dateTaken = Date(timeIntervalSinceReferenceDate: 10)
        testItemC.datePublished = Date(timeIntervalSinceReferenceDate: 200)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFilteringItems() {
        let viewModel = FlickrGalleryViewModel()
        
        viewModel.flickrGalleryItems.append(testItemA)
        viewModel.flickrGalleryItems.append(testItemB)
        viewModel.flickrGalleryItems.append(testItemC)
        
        viewModel.filterFlickrGalleryItems(byText: "home")
        
        XCTAssertTrue(viewModel.flickrGalleryItems.count == 1)
        XCTAssertTrue(viewModel.flickrGalleryItems[0].tags.contains("home"))
        
        viewModel.filterFlickrGalleryItems(byText: "aa")
        
        XCTAssertTrue(viewModel.flickrGalleryItems.count == 2)
        XCTAssertTrue(viewModel.flickrGalleryItems[0].tags.contains("aa"))
        XCTAssertTrue(viewModel.flickrGalleryItems[1].tags.contains("aa"))
        
        viewModel.filterFlickrGalleryItems(byText: "")
        XCTAssertTrue(viewModel.flickrGalleryItems.count == 3)
    }
    
    func testImageCaching() {
        let viewModel = FlickrGalleryViewModel()
        
        let image = viewModel.getCachedFlickrFeedImage(forUrl: "")
        
        XCTAssertTrue(image == nil)
        
        let dummyImage = UIImage()
        viewModel.addFlickrFeedImageToCache(image: dummyImage, key: "dummyKey")
        
        let obtainedDummyImage = viewModel.getCachedFlickrFeedImage(forUrl: "dummyKey")
        
        XCTAssertTrue(obtainedDummyImage != nil)
        XCTAssertTrue(obtainedDummyImage == dummyImage)
    }
    
    func testSortingItemsByDateTaken() {
        let viewModel = FlickrGalleryViewModel()
        
        viewModel.flickrGalleryItems.append(testItemA)
        viewModel.flickrGalleryItems.append(testItemB)
        viewModel.flickrGalleryItems.append(testItemC)
        
        viewModel.sortFlickrGalleryItemsByDate(field: .dateTaken, ordering: .orderedDescending)
        
        XCTAssertTrue(viewModel.flickrGalleryItems[0] === testItemB)
        XCTAssertTrue(viewModel.flickrGalleryItems[1] === testItemA)
        XCTAssertTrue(viewModel.flickrGalleryItems[2] === testItemC)
    }
    
    func testSortingItemsByDatePublished() {
        let viewModel = FlickrGalleryViewModel()
        
        viewModel.flickrGalleryItems.append(testItemA)
        viewModel.flickrGalleryItems.append(testItemB)
        viewModel.flickrGalleryItems.append(testItemC)
        
        viewModel.sortFlickrGalleryItemsByDate(field: .datePublished, ordering: .orderedDescending)
        
        XCTAssertTrue(viewModel.flickrGalleryItems[0] === testItemB)
        XCTAssertTrue(viewModel.flickrGalleryItems[1] === testItemC)
        XCTAssertTrue(viewModel.flickrGalleryItems[2] === testItemA)
    }
}
