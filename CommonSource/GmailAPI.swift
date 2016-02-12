//
//  GmailAPI.swift
//  SwiftyGmail
//
//  Created by Atai Barkai on 2/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation
import Moya


public enum Gmail {
	
	case SearchMessages(onUsername: String, withSearchString: String)
}

extension Gmail{
	
	// each Gmail API call
	public var username: String {
		switch self {
		case .SearchMessages(onUsername: let username, withSearchString: _):
			return username
		}
	}
}

extension Gmail: TargetType {
	public var baseURL: NSURL { return NSURL(string: "https://www.googleapis.com/gmail/v1/users/\(self.username)")! }
	public var path: String {
		
		switch self {
		case .SearchMessages(_):
			return "/messages"
		}

	}
	public var method: Moya.Method {
		switch self{
		case .SearchMessages(_):
			return .GET
		}
	}
	
	public var parameters: [String: AnyObject]? {
		switch self {
		case .SearchMessages(onUsername: _, withSearchString: let searchString):
			return [
				"q": searchString,
			]
		}
	}
	
	public var sampleData: NSData {
		switch self {
		default:
			return "".dataUsingEncoding(NSUTF8StringEncoding)!
		}
	}
}


extension Gmail {
	
	static func provider(withClientId clientId: String,	scope: String) throws -> MoyaProvider<Gmail>{
		
		guard let bundleId = NSBundle.mainBundle().bundleIdentifier
			else { throw NSError(domain: "no bundle identifier exists for this app", code: -1, userInfo: nil) }
		
		let oauth2Object = GmailOAuth2.newOauth2Object(
			withClientId: clientId,
			scope: scope,
			redirect_uris: ["\(bundleId):/oauth/callback"]
		)
		
		
		let requestClosure = { (endpoint: Endpoint<Gmail>, done: NSURLRequest -> Void) in
			
			// NOTE: we MUST make sure to call the done(...) closure at some point
			// HOWEVER this is not statically enforced due to the asynchronous nature of this API.
			// TODO: This is pretty fucking ugly. Major stylistic improvements can be made to this convention-based protocol
			// both on on OAuth2's side and on Moya's side. Perhaps just one side would make a big difference.
			//
			// In the meantime we will keep a close watch of possibile branches to make sure we indeed call `done(...)`.
			

			// -------------------------------
			// Declerative definition of intended behavior:
			oauth2Object.afterAuthorizeOrFailure = { a in
				// 2 options: (1) parameters are valid | (2) parameters are invalid

				// option (1): parameters are valid
				if	let mutableRequest = endpoint.urlRequest.mutableCopy() as? NSMutableURLRequest,
					let accessToken = oauth2Object.accessToken {
						mutableRequest.signOAuth2(withOAuth2Token: accessToken)
						done(mutableRequest)	// option 1 - call done()
				}
				// option (2): parameters are invalid
				else{
					done(endpoint.urlRequest)	// option 2 - call done()
				}
			}
			
			// -------------------------------
			// Imperative call to actual initiation of authorization:
			oauth2Object.authorize()
			
		}
		
		return MoyaProvider<Gmail>(requestClosure: requestClosure)
	}
}
