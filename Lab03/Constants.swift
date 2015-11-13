//
//  Constants.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/31/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import Foundation
import CoreLocation


struct Constants {

	static let API_KEY = ""
	static let KEY = "key"
	
	static let PROTOCOL = "https://"
	static let BASE_URL = "maps.googleapis.com/"
	static let SERVICE_REQUESTED = "maps/api/"
	static let PATH = "distancematrix/"
	static let RESPONSE_TYPE = "json"
	static let PARAM_1_NAME = "origins"
	static let PARAM_2_NAME = "destinations"

	static let SHOW_BUILDING_DETAILS_VIEW_SEGUE = "showBuildingDetails";
	static let SHOW_BUILDING_IMAGE_VIEW_SEGUE = "showBuildingImage";

	static let SJSU_SW : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.331361, -121.886478);
	static let SJSU_NE : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.338800, -121.876243);

	static let SHORTCUT_MLK = "King Library";
	static let SHORTCUT_ENGG_BLDG = "SJSU Engineering Building";
	static let SHORTCUT_SUB = "Student Union";
	static let SHORTCUT_BBC = "Boccardo Business Complex";
}