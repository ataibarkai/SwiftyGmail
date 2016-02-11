//
//  TestSearchMessages.swift
//  SwiftyGmail
//
//  Created by Atai Barkai on 2/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import XCTest
@testable import SwiftyGmail


class TestSearchMessages: XCTestCase {

	func testBasic() {
		
		let expectation_retrievedGmailMessages = expectationWithDescription("expectation_retrievedGmailMessages")
		
		GmailProvider.request(Gmail.SearchMessages("from: frmsaul@gmail.com")) { (result) -> () in
			expectation_retrievedGmailMessages.fulfill()
			switch result{
			case .Success(let t):
				print(t)
				print(try? t.mapJSON())
			case .Failure(let error):
				print(error)
				XCTFail("gmail provider request failed")
			}
		}
		
		waitForExpectationsWithTimeout(10) { error in
			XCTAssertNil(error, "Error")
		}
		
	}
}
