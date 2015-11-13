//
//  URLBuilder.swift
//  Lab03
//
//  Created by Milind Mahajan on 11/9/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit

class URLBuilder: NSObject {
	
	internal static func prepareUrlUsing(fromLocation : String!, toLocation : String!) -> NSURL {
		
		var stringUrl : String = String(format: "%@%@%@%@%@?%@=%@&%@=%@&%@=%@",Constants.PROTOCOL, Constants.BASE_URL, Constants.SERVICE_REQUESTED, Constants.PATH, Constants.RESPONSE_TYPE, Constants.PARAM_1_NAME, fromLocation, Constants.PARAM_2_NAME, toLocation, Constants.KEY, Constants.API_KEY);
		
		stringUrl = stringUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
		
		return NSURL(string: stringUrl)!;
	}
}
