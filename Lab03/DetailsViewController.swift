//
//  DetailsViewController.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/29/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit
import CoreLocation


class DetailsViewController: UIViewController, LocationUtilityProtocol {

	@IBOutlet weak var buildingNameLabel: UILabel!
	@IBOutlet weak var buildingAddressTextView: UITextView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var walkingDistanceLabel: UILabel!
	@IBOutlet weak var buildingImageButton: UIButton!
	
	var building : Building!;
	var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D();
	
	var count : Int = 1;
	var timer : NSTimer = NSTimer();
	
	let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge);

	var locationUtil : LocationUtility = LocationUtility.init();
	var locationManager : CLLocationManager = CLLocationManager();
	
	
	/**************************************************************************************************
										View Controller Lifecycle
	**************************************************************************************************/

	override func viewDidLoad() {

		super.viewDidLoad()
		self.title = "Building Details";
		self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
		self.navigationController!.navigationItem.backBarButtonItem?.title = "Map";

		locationManager = CLLocationManager.init();
		locationManager.delegate = locationUtil;
		locationUtil.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest

		let selector : Selector = Selector("requestWhenInUseAuthorization");
		if (self.locationManager.respondsToSelector(selector)) {
			
			self.locationManager.requestWhenInUseAuthorization()
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		
		buildingNameLabel.text = building.name;
		buildingAddressTextView.text = building.address;
		let backgroundImage : UIImage = UIImage(imageLiteral: building.imageName!);
		buildingImageButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
		
		buildingImageButton.clipsToBounds = true;
		buildingImageButton.layer.cornerRadius = 10.0;
		buildingImageButton.layer.borderWidth = 5.0;
		buildingImageButton.layer.borderColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0).CGColor;
		
		let selector : Selector = Selector("changeBorderColor")
		timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: selector, userInfo: nil, repeats: true)
		
		activityIndicator.color = UIColor.blackColor();
		activityIndicator.center = self.view.center;
		activityIndicator.hidesWhenStopped = true;
		self.view.addSubview(activityIndicator);
	}
	
	override func viewDidAppear(animated: Bool) {

		if (CLLocationManager.locationServicesEnabled()) {
			
			locationManager.startUpdatingLocation()
		}

		getDistanceMatrix();
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		timer.invalidate();
	}

    override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning()
    }
	
	
	/**************************************************************************************************
												Navigation
	**************************************************************************************************/
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == Constants.SHOW_BUILDING_IMAGE_VIEW_SEGUE {
			
			let imageViewController : BuidlingImageViewController = segue.destinationViewController as! BuidlingImageViewController;
			imageViewController.building = building;
		}
	}
	
	
	/**************************************************************************************************
											User events
	**************************************************************************************************/
	
	@IBAction func didTouchImageButton() {
		
		performSegueWithIdentifier(Constants.SHOW_BUILDING_IMAGE_VIEW_SEGUE, sender: self)
	}
	
	
	/**************************************************************************************************
										LocationUtilityProtocol
	**************************************************************************************************/
	
	func didUpdateLocation(location : CLLocationCoordinate2D) {
		
		currentLocation = location;
		getDistanceMatrix();
	}
	
	func didFail(error : NSError) {
		
		if (error.code == 1) {
			
			let alertController = alertControllerWithMessage("Please enable location service from Settings->Privacy->Location Services");
			
			let settingsAction = UIAlertAction(title: "Go to settings", style: .Default, handler: { (_) -> Void in
				
				self.openSettings();
			});
			
			alertController.addAction(settingsAction);
			
			presentViewController(alertController, animated: true, completion: { () -> Void in
				
				self.locationManager.startUpdatingLocation();
			});
		} else {
			
			let alertController = alertControllerWithMessage("Failed to update location. Please enable location service in Settings->Privacy->Location Services");
			presentViewController(alertController, animated: true, completion: nil);
		}
	}
	
	func didChangeStatus(status : CLAuthorizationStatus) {
		
		if (CLLocationManager.authorizationStatus() == .Denied ||
			CLLocationManager.authorizationStatus() == .Restricted ||
			CLLocationManager.authorizationStatus() == .NotDetermined) {
				
				let selector : Selector = Selector("requestWhenInUseAuthorization");
				if (self.locationManager.respondsToSelector(selector)) {
					
					self.locationManager.requestWhenInUseAuthorization()
				}
		}
		if (status == .AuthorizedWhenInUse || status == .AuthorizedAlways) {
			
			locationManager.startUpdatingLocation();
		}
	}
	
	
	/**************************************************************************************************
											Helper methods
	**************************************************************************************************/
	
	func getDataMatrixFrom (response : NSDictionary) -> NSDictionary {
		
		let rows : NSArray = NSArray(array: (response.objectForKey("rows") as! NSArray));
		
		let subDictionary : NSDictionary = NSDictionary(dictionary: (rows.lastObject as! NSDictionary));
		
		let elements : NSArray = NSArray(array: (subDictionary.objectForKey("elements") as! NSArray));
		
		let dataMatrix : NSDictionary = NSDictionary(dictionary: (elements.lastObject as! NSDictionary));
		
		return dataMatrix;
	}
	
	func changeBorderColor () {
		
		count++;
		
		if (count%2 == 0) {
			
			buildingImageButton.layer.borderColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0).CGColor;
		} else {
			
			buildingImageButton.layer.borderColor = UIColor.whiteColor().CGColor;
		}
	}

	func openSettings () {
		
		let stringUrl : String = String(format: "%@BundleID", UIApplicationOpenSettingsURLString);
		let settingsUrl = NSURL(string: stringUrl)
		
		UIApplication.sharedApplication().openURL(settingsUrl!)
	}
	
	func getDistanceMatrix () {
		
		activityIndicator.startAnimating();

		let fromLocation : String = String(format: "%f,%f", currentLocation.latitude, currentLocation.longitude);
		let toLocation : String = String(building.address.stringByReplacingOccurrencesOfString(" ", withString: "+"));
		
		if (currentLocation.latitude != 0.0 && currentLocation.longitude != 0.0) {
			
			let url : NSURL = URLBuilder.prepareUrlUsing(fromLocation, toLocation: toLocation);
			ConnectionUtility.getDataFrom(url, onCompletion: { (responseDictionary : [NSObject : AnyObject]!, error : NSError!) -> Void in
				
				if (error != nil) {
					
					let errorAlert : UIAlertController = UIAlertController(title: "Error!", message: "Unable to get distance location", preferredStyle: UIAlertControllerStyle.Alert);
					
					let dismissAction : UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil);
					errorAlert.addAction(dismissAction);
					
					self.presentViewController(errorAlert, animated: true, completion: nil);
					
				} else {
					
					let dataMatrix : NSDictionary = self.getDataMatrixFrom(responseDictionary as NSDictionary);
					
					let distanceMatrix : NSDictionary = NSDictionary(dictionary: (dataMatrix.objectForKey("distance") as! NSDictionary));
					let timeMatrix : NSDictionary = NSDictionary(dictionary: (dataMatrix.objectForKey("duration") as! NSDictionary));
					
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						
						self.timeLabel.text = timeMatrix.objectForKey("text") as? String;
						self.walkingDistanceLabel.text = distanceMatrix.objectForKey("text") as? String;
						
						self.activityIndicator.stopAnimating();
					});
				}
			})
		} else {
			
			let errorAlert : UIAlertController = UIAlertController(title: "Error!", message: "Unable to get user location", preferredStyle: UIAlertControllerStyle.Alert);
			
			let dismissAction : UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil);
			errorAlert.addAction(dismissAction);
			
			presentViewController(errorAlert, animated: true, completion: nil);
			activityIndicator.stopAnimating();
		}
	}
	
	func alertControllerWithMessage(message : String) -> UIAlertController {
		
		let alertController = UIAlertController (title: "Error!", message: message, preferredStyle: .Alert)
		
		let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
		alertController.addAction(dismissAction)
		
		return alertController;
	}
	
	func isLocationServiceEnabled () -> Bool {
		
		if (CLLocationManager.locationServicesEnabled()) {
			
			if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse ||
				CLLocationManager.authorizationStatus() == .AuthorizedAlways) {
					
					return true;
			}
		}
		
		return false;
	}
}