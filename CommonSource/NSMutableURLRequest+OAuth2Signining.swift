//
//  NSMutableURLRequest+OAuth2Signining.swift
//  SwiftyGmail
//
//  Created by Atai Barkai on 2/12/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation

internal extension NSMutableURLRequest {
	
	func signOAuth2(withOAuth2Token oAuth2Token: String){
		self.setValue("Bearer \(oAuth2Token)", forHTTPHeaderField: "Authorization")
	}
	
}