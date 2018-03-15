//
//  FlickrGalleryTests.swift
//  FlickrGalleryTests
//
//  Created by Grzegorz Izworski on 09/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import XCTest
@testable import FlickrGallery

class FlickrFeedDonwloadServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingJson() {
        if let path = Bundle.main.path(forResource: "jsonToTest", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
  
                let viewModel = FlickrFeedDownloadService()
                let itemsArray = viewModel.parseFeedJsonIntoItemsArray(jsonResult as AnyObject)
                
                XCTAssertTrue(itemsArray.count == 2)
                XCTAssertTrue(itemsArray[0].author == "nobody@flickr.com (\"fotomarian\")")
                
            } catch {
                XCTFail()
            }
        }
    }
    
    func testFlickrFeedDownloadTime() {
        let downloadService = FlickrFeedDownloadService()
        let urlExpectation = expectation(description: "Flickr Feed Download Time")
        
        self.measure {
            downloadService.downloadFlickrFeed(onCompletion: {
                items, error in
                if error == nil {
                    urlExpectation.fulfill()
                }
            })
            
            wait(for: [urlExpectation], timeout: 5)
        }
    }
    
    func testFlickrFeedImageDownloadTime() {
        let downloadService = FlickrFeedDownloadService()
        let urlExpectation = expectation(description: "Flickr Feed Image Download Time")
        
        self.measure {
            downloadService.downloadFlickrFeed(onCompletion: {
                items, error in
                if error == nil {
                    let firstItem = items[0]
                    downloadService.downloadFlickrFeedImage(for: firstItem.imageUrl, onCompletion: {
                        image, error in
                        if error == nil {
                            urlExpectation.fulfill()
                        }
                    })
                }
            })
            
            wait(for: [urlExpectation], timeout: 10)
        }
    }
}
