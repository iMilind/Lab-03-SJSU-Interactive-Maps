//
//  ViewController.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/29/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, LocationUtilityProtocol {

	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var mapImageView: UIImageView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var kingLib: UIButton!
	@IBOutlet weak var ycHallButton: UIButton!
	@IBOutlet weak var spGarageButton: UIButton!
	@IBOutlet weak var enggBldgButton: UIButton!
	@IBOutlet weak var suBldgButton: UIButton!
	@IBOutlet weak var bbcBldg: UIButton!

	var searchResult : NSMutableArray = NSMutableArray();
	var selectedBuilding : Building = Building();
	var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D();
	var locationManager : CLLocationManager = CLLocationManager();
	
	var locationUtil : LocationUtility = LocationUtility.init();

	
	/**************************************************************************************************
									View Controller Lifecycle
	**************************************************************************************************/

	override func viewDidLoad() {
		
		super.viewDidLoad();
		self.title = "SJSU Map";
		self.automaticallyAdjustsScrollViewInsets = false;

		locationManager = CLLocationManager.init();
		locationManager.delegate = locationUtil;
		locationUtil.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest

		let selector : Selector = Selector("requestWhenInUseAuthorization");
		if (self.locationManager.respondsToSelector(selector)) {
			
			self.locationManager.requestWhenInUseAuthorization()
		}

		scrollView.contentSize = UIImage(imageLiteral: "map").size;

		NSNotificationCenter.defaultCenter().removeObserver(self);
		let appDidBecomeActiveselector : Selector = Selector("appDidBecomeActive");
		NSNotificationCenter.defaultCenter().addObserver(self, selector: appDidBecomeActiveselector, name: UIApplicationDidBecomeActiveNotification, object: nil);
	}
	
	override func viewWillAppear(animated: Bool) {
		
		for tag in 1...6 {
			
			setButtonAppearance(100+tag);
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		
		if (CLLocationManager.locationServicesEnabled()) {
			
			locationManager.startUpdatingLocation()
		} else {
			
			let alertController = alertControllerWithMessage("Please enable location service from Settings->Privacy->Location Services");
			
			let settingsAction = UIAlertAction(title: "Go to settings", style: .Default, handler: { (_) -> Void in
				
				self.openSettings();
			});
			
			alertController.addAction(settingsAction);
			
			presentViewController(alertController, animated: true, completion: { () -> Void in
				
				self.locationManager.startUpdatingLocation();
			});
		}

		appDidBecomeActive();
	}
	
	override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning();
	}
	
	
	/**************************************************************************************************
											User events
	**************************************************************************************************/
	
	@IBAction func didTouchHighlightButton(sender: AnyObject) {
		
		let touchedButton : UIButton = sender as! UIButton;
		searchResult = NSMutableArray(array: BuildingDetailsGenerator.getBuildingInfoForTag(touchedButton.tag)!);

		let predicate : NSPredicate = NSPredicate(format: "tag == %@", String(touchedButton.tag));
		let filteredArray : NSArray = (searchResult.filteredArrayUsingPredicate(predicate));
		
		if (filteredArray.count != 0) {
			
			selectedBuilding = filteredArray.lastObject as! Building;
			performSegueWithIdentifier(Constants.SHOW_BUILDING_DETAILS_VIEW_SEGUE, sender: self)
		}
	}
	
	
	/**************************************************************************************************
											Navigation
	**************************************************************************************************/
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == Constants.SHOW_BUILDING_DETAILS_VIEW_SEGUE {
			
			let detailsViewController : DetailsViewController = segue.destinationViewController as! DetailsViewController;
			detailsViewController.building = selectedBuilding;
			detailsViewController.currentLocation = currentLocation;
		}
	}

	
	/**************************************************************************************************
										UIScrollViewDelegate
	**************************************************************************************************/
	
	func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {

		ApplicationSettings.sharedSettings.setZoom(scrollView.zoomScale);
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

		ApplicationSettings.sharedSettings.setContentOffset(scrollView.contentOffset);
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		
		return contentView;
	}


	/**************************************************************************************************
										UISearchBarDelegate
	**************************************************************************************************/

	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		
		if ((searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == nil) {
			
			hideHighlightViews();
		}
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

		hideHighlightViews();

		searchResult = NSMutableArray(array: BuildingDetailsGenerator.getBuildingWithName(searchBar.text)!);
		
		displaySearchResult();
	}

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		searchBar.resignFirstResponder();
		searchResult = NSMutableArray(array: BuildingDetailsGenerator.getBuildingWithName(searchBar.text)!);
		
		displaySearchResult();
	}
	
	
	/**************************************************************************************************
										LocationUtilityProtocol
	**************************************************************************************************/
	
	func didUpdateLocation(location : CLLocationCoordinate2D) {
		
		currentLocation = location;
		processLocation();
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

	func setButtonAppearance (tag : Int) {
		
		let button : UIButton = self.view.viewWithTag(tag) as! UIButton;
		
		button.layer.borderWidth = 2.0;
		button.layer.cornerRadius = 5.0;
		button.layer.borderColor = UIColor.clearColor().CGColor;

		button.transform = CGAffineTransformMakeRotation(5.74213);
	}
	
	func hideHighlightViews () {
		
		for tag in 1...6 {
			
			let button : UIButton = self.view.viewWithTag(100+tag) as! UIButton;
			button.layer.borderColor = UIColor.clearColor().CGColor;
		}
	}
	
	func processLocation () {
		
		print(self.contentView.frame)

		let userX = Double(self.contentView.bounds.height) * (fabs(currentLocation.longitude)-fabs(Constants.SJSU_SW.longitude))/(fabs(Constants.SJSU_NE.longitude)-fabs(Constants.SJSU_SW.longitude));
		let userY = Double(self.contentView.bounds.width) - (Double(self.contentView.bounds.width) * (fabs(currentLocation.latitude)-fabs(Constants.SJSU_SW.latitude))/(fabs(Constants.SJSU_NE.latitude)-fabs(Constants.SJSU_SW.latitude)));
		let locationPoint : CGPoint = CGPointMake(CGFloat(userX), CGFloat(userY));

		displayRedCircleAt(locationPoint);
	}
	
	func displaySearchResult () {
		
		if (searchResult.count == 0)  {

			return;
		}
		
		if (searchResult.count == 1) {
			
			if let searchedBuilding = searchResult.lastObject {
				
				processSearchResult(searchedBuilding as! Building, defaultZoom: false);
			}
		} else {
			
			for i in 0...searchResult.count-1 {
				
				let searchedBuilding = searchResult.objectAtIndex(i) as! Building;
				processSearchResult(searchedBuilding, defaultZoom: true);
			}
		}
	}
	
	func processSearchResult (building : Building, defaultZoom : Bool) {
		
		let tag : String = building.tag;
		let intTag : Int? = Int(tag);
		let searched : UIButton = self.view.viewWithTag(intTag!) as! UIButton;
		searched.layer.borderColor = UIColor(colorLiteralRed: 0.0/255.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0).CGColor;
		print("the button's frame to scroll is \(searched.frame)");
		
		if (defaultZoom) {
			
			scrollView.scrollRectToVisible(CGRectZero, animated: true);
			scrollView.zoomScale = 1.0;
		} else {
			
			let scrollRect : CGRect = CGRectMake(searched.frame.origin.x-20, searched.frame.origin.y-20, searched.frame.size.width+40, searched.frame.size.height+40)
			scrollView.zoomToRect(scrollRect, animated: true);
		}
	}
	
	func alertControllerWithMessage(message : String) -> UIAlertController {
		
		let alertController = UIAlertController (title: "Error!", message: message, preferredStyle: .Alert)
		
		let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
		alertController.addAction(dismissAction)
		
		return alertController;
	}
	
	func openSettings () {

		let stringUrl : String = String(format: "%@BundleID", UIApplicationOpenSettingsURLString);
		let settingsUrl = NSURL(string: stringUrl)
		
		UIApplication.sharedApplication().openURL(settingsUrl!)
	}

	func displayRedCircleAt(point : CGPoint) {

		if let tempView = self.contentView.viewWithTag(999) {
			
			tempView.removeFromSuperview();
		}

		let xStart : Int = Int(point.x);
		let yStart : Int = Int(point.y);

		let outerCircleRect : CGRect = CGRectMake(CGFloat(xStart), CGFloat(yStart), 20, 20);
		print(outerCircleRect)
		let outerCircleView : UIView = UIView(frame: outerCircleRect);
		
		outerCircleView.tag = 999;
		outerCircleView.backgroundColor = UIColor.clearColor();
		outerCircleView.layer.borderWidth = 4.0;
		outerCircleView.layer.borderColor = UIColor.blackColor().CGColor;
		outerCircleView.layer.cornerRadius = 10.0;
		self.contentView.addSubview(outerCircleView);

		let innerCircleRect : CGRect = CGRectMake(outerCircleView.frame.size.width/2-5, outerCircleView.frame.size.width/2-5, 10, 10);

		let innerCircleView : UIView = UIView(frame: innerCircleRect);
		innerCircleView.alpha = 0.75;

		innerCircleView.backgroundColor = UIColor.redColor();
		innerCircleView.layer.cornerRadius = 5.0;
		outerCircleView.addSubview(innerCircleView);
	}
	
	func appDidBecomeActive() {
		
		let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
		if (NSString(string: appDelegate.selectedShortcut).length != 0) {
			
			hideHighlightViews();
			searchResult = NSMutableArray(array: BuildingDetailsGenerator.getBuildingWithName(appDelegate.selectedShortcut)!);
			
			displaySearchResult();
		} else {
			
			if (ApplicationSettings.sharedSettings.zoom() != 1.0) {
				
				print("zoom level is \(ApplicationSettings.sharedSettings.zoom())");
				scrollView.zoomScale = ApplicationSettings.sharedSettings.zoom()!;
				scrollView.contentOffset = ApplicationSettings.sharedSettings.contentOffset();
			}
		}
	}
}