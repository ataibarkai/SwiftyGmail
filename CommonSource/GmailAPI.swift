//
//  GmailAPI.swift
//  SwiftyGmail
//
//  Created by Atai Barkai on 2/11/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation
import Moya





public protocol GmailDescriptor{
	
	static func username() -> String
	static func oauth2Token() -> String
}

public enum Gmail<Descriptor: GmailDescriptor> {
	case SearchMessages(String)
}

extension Gmail: TargetType {
	public var baseURL: NSURL { return NSURL(string: "https://www.googleapis.com/gmail/v1/users/\(Descriptor.username())")! }
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
		case .SearchMessages(let searchString):
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
	static func provider() -> MoyaProvider<Gmail<Descriptor>>{
		
		let requestClosure = { (endpoint: Endpoint< Gmail<Descriptor> >, done: NSURLRequest -> Void) in
			let request = endpoint.urlRequest // This is the request Moya generates
			
			let token = Descriptor.oauth2Token()
			let mutableRequest = request.mutableCopy() as! NSMutableURLRequest
			mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			
			done(mutableRequest)
		}
		
		return MoyaProvider< Gmail<Descriptor> >(requestClosure: requestClosure)
	}
}
