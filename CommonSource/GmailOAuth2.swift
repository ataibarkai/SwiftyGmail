
//
//  GmailOAuth2.swift
//  SwiftyGmail
//
//  Created by Atai Barkai on 2/12/16.
//  Copyright © 2016 Atai Barkai. All rights reserved.
//

import Foundation
import OAuth2

public enum GmailOAuth2 {
	
	public static let k_OAuthNotificationName = "OAuthNotificationName"
	
	internal static func newOauth2Object(
		withClientId clientId: String,
		scope: String,
		redirect_uris: [String]) -> OAuth2CodeGrant {
			
			let oauth2 = OAuth2CodeGrant(settings: [
				"client_id": clientId,
				"client_secret": "",
				"authorize_uri": "https://accounts.google.com/o/oauth2/auth",
				"token_uri": "https://accounts.google.com/o/oauth2/token",   // code grant only!
				"scope": scope,
				"redirect_uris": redirect_uris,   // don't forget to register this scheme
				"keychain": true,     // if you DON'T want keychain integration
				//	"state": 7,
				"title": "Gmail Login"  // optional title to show in views
				] as OAuth2JSON
			)
			
			
			NSNotificationCenter.defaultCenter().addObserverForName(GmailOAuth2.k_OAuthNotificationName, object: nil, queue: nil) { (notification: NSNotification) -> Void in
				if let url = notification.object as? NSURL {
					oauth2.handleRedirectURL(url)
				}
			}
			
			return oauth2
	}
	
}