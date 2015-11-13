//
//  AppDelegate.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/29/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var shortcutItem: UIApplicationShortcutItem?
	var selectedShortcut : String = String();
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		application.statusBarHidden = true;
		
		addApplicationShortcuts(application);

		var performShortcutDelegate = true
		
		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {

			self.shortcutItem = shortcutItem
			
			performShortcutDelegate = false
		}

		return performShortcutDelegate;
	}

	func applicationWillResignActive(application: UIApplication) {

	}

	func applicationDidEnterBackground(application: UIApplication) {

	}

	func applicationWillEnterForeground(application: UIApplication) {

	}

	func applicationDidBecomeActive(application: UIApplication) {

		guard let shortcut = shortcutItem else {

			return;
		}

		handleShortcut(shortcut);
		self.shortcutItem = nil;
	}

	func applicationWillTerminate(application: UIApplication) {

	}

	func handleShortcut( shortcutItem:UIApplicationShortcutItem ) -> Bool {
		
		var succeeded = false;

		if	(shortcutItem.type == Constants.SHORTCUT_MLK		||
			shortcutItem.type == Constants.SHORTCUT_ENGG_BLDG	||
			shortcutItem.type == Constants.SHORTCUT_SUB			||
			shortcutItem.type == Constants.SHORTCUT_BBC) {
				
				self.selectedShortcut = shortcutItem.type;
				let navigationController = self.window?.rootViewController as! Lab3NavigationController;
				
				if (navigationController.viewControllers.count != 0) {
					
					navigationController.popToRootViewControllerAnimated(true);
				}
				
				succeeded = true;
		}
		
		return succeeded;
	}
 
	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		
		completionHandler(handleShortcut(shortcutItem));
	}
	
	func addApplicationShortcuts(application : UIApplication) {
		
		let kingLib : UIApplicationShortcutItem = UIApplicationShortcutItem(type: Constants.SHORTCUT_MLK, localizedTitle: "Search King Library", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil);
		let enggBuilding : UIApplicationShortcutItem = UIApplicationShortcutItem(type: Constants.SHORTCUT_ENGG_BLDG, localizedTitle: "Search Engineering Building", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil);
		let studentUnion : UIApplicationShortcutItem = UIApplicationShortcutItem(type: Constants.SHORTCUT_SUB, localizedTitle: "Search Student Union", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil);
		let bbc : UIApplicationShortcutItem = UIApplicationShortcutItem(type: Constants.SHORTCUT_BBC, localizedTitle: "Search Boccardo Business Center", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil);
		
		let shortcutItems = [kingLib, enggBuilding, studentUnion, bbc];
		
		application.shortcutItems = shortcutItems;
	}
}