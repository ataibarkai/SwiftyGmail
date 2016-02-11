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
		
		enum TestDescriptor: GmailDescriptor{
			static func username() -> String {
				return "atai.barkai@gmail.com"
			}
			
			static func oauth2Token() -> String {
				return "ya29.hQIm05lS-0lBj91XO1rRNTvErMW9U9YlTS7Lv6WKQrAWjpEN0LfNm3BOH2ROfIAU7_io"
			}
		}
		
		let TestGmailProvider = Gmail<TestDescriptor>.provider()
		
		TestGmailProvider.request(Gmail.SearchMessages("from: frmsaul@gmail.com")) { (result) -> () in
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
