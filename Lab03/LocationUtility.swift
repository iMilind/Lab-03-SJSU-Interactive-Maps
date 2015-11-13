//
//  LocationUtility.swift
//  Lab03
//
//  Created by Milind Mahajan on 11/10/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit
import CoreLocation


protocol LocationUtilityProtocol {
	
	func didUpdateLocation(location : CLLocationCoordinate2D);
	func didFail(error : NSError);
	func didChangeStatus(status : CLAuthorizationStatus);
}

class LocationUtility: NSObject, CLLocationManagerDelegate {

	var currentLocation : CLLocationCoordinate2D;
	var delegate : LocationUtilityProtocol?;

	override init() {
		
		self.currentLocation = CLLocationCoordinate2D();
	}

	
	/**************************************************************************************************
									CLLocationManagerDelegate
	**************************************************************************************************/
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		currentLocation = (locations.last?.coordinate)!;
//		currentLocation = CLLocationCoordinate2D(latitude: 37.334589, longitude: -121.876718);
		if let delegate = self.delegate {
			
			delegate.didUpdateLocation(currentLocation);
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		
		NSLog("in locationManager didFailWithError");
		if let delegate = self.delegate {
			
			delegate.didFail(error);
		}
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		
		if let delegate = self.delegate {
			
			delegate.didChangeStatus(status);
		}
	}
}