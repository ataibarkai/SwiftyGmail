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
		
		
		do {
			let testGmailProvider = try Gmail.provider(
				withClientId: "789483483852-tpo3hoakn0ocbdoc5hj1hlrfn3eld2dm.apps.googleusercontent.com",
				scope: "https://www.googleapis.com/auth/gmail.readonly"
			)
			
			testGmailProvider.request(
				Gmail.SearchMessages(
					onUsername: "atai.barkai@gmail.com",
					withSearchString: "from: frmsaul@gmail.com")
				) { (result) -> () in
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

			
		} catch let error {
			print("error: \(error)")
		}
		
	
		
		
		waitForExpectationsWithTimeout(10) { error in
			XCTAssertNil(error, "Error")
		}
		
	}
}
