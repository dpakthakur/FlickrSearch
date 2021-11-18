//
//  HttpManagerTests.swift
//  FlickrSearchTests
//
//  Created by Deepak Thakur on 18/11/21.
//

import XCTest
@testable import FlickrSearch

class FlickrNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchValidText() {
        
        let expectatn = expectation(description: "Returns json response")
        
        SearchService().request("cats", pageNo: 1) { (result) in
            
            switch result {
            case .success(let results):
                if results != nil {
                    XCTAssert(true, "Success")
                    expectatn.fulfill()
                } else {
                    XCTFail("No results")
                }
            case .failure(let message):
                XCTFail(message)
            case .error(let error):
                XCTFail(error)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testValidatePhotoImageURL() {
        
        let expectatn = expectation(description: "Returns all fields to create valid image url")
        
        SearchService().request("cats", pageNo: 1) { (result) in
            
            switch result {
            case .success(let results):
                
                guard let photosCount = results?.photo.count else {
                    XCTFail("No photos returned")
                    return
                }
                
                if photosCount > 0 {
                    XCTAssert(true, "Returned photos")
                    
                    // Pick first photo to test image url
                    let photo = results?.photo.first
                    
                    if photo?.farm == nil {
                        XCTFail("No farm id returned")
                    }
                    
                    if photo?.server == nil {
                        XCTFail("No server id returned")
                    }
                    
                    if photo?.id == nil {
                        XCTFail("No photo id returned")
                    }
                    
                    if photo?.secret == nil {
                        XCTFail("No secret id returned")
                    }
                    
                    XCTAssert(true, "Success")
                    expectatn.fulfill()
                }
            case .failure(let message):
                XCTFail(message)
            case .error(let error):
                XCTFail(error)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSearchInvalidText() {
        
        let expectatn = expectation(description: "Returns error message")
        
        SearchService().request("", pageNo: 1) { (result) in
            switch result {
            case .success( _):
                XCTFail("No results")
            case .failure( _):
                XCTAssert(true, "Success")
                expectatn.fulfill()
            case .error( _):
                XCTAssert(true, "Success")
                expectatn.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

