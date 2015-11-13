//
//  BuildingDetailsGenerator.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/31/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit

class BuildingDetailsGenerator: NSObject {

	static let buildings = BuildingDetailsGenerator.getAllBuildingsInformation();
	
	static func getAllBuildingsInformation() -> NSArray? {
		
		let buildings = NSMutableArray();
		
		let kingLib : Building = Building();
		kingLib.name = "King Library";
		kingLib.address = "Dr. Martin Luther King, Jr. Library, 150 East San Fernando Street, San Jose, CA 95112";
		kingLib.searchStrings = "MLK Martin Luther King Library";
		kingLib.imageName = "MLK.png";
		kingLib.tag = "101";
		buildings.addObject(kingLib);
		
		let yuHall : Building = Building();
		yuHall.name = "Yoshihiro Uchida Hall";
		yuHall.address = "Yoshihiro Uchida Hall, San Jose, CA 95112";
		yuHall.searchStrings = "YUH Yoshihiro Uchida Hall";
		yuHall.imageName = "YUH.png";
		yuHall.tag = "102";
		buildings.addObject(yuHall);

		let spg : Building = Building();
		spg.name = "SJSU South Garage";
		spg.address = "San Jose State University South Garage, 330 South 7th Street, San Jose, CA 95112";
		spg.searchStrings = "SPG SJSU South Garage Parking";
		spg.imageName = "SPG.png";
		spg.tag = "103";
		buildings.addObject(spg);
		
		let engg : Building = Building();
		engg.name = "SJSU Engineering Building";
		engg.address = "San José State University Charles W. Davidson College of Engineering, 1 Washington Square, San Jose, CA 95112";
		engg.searchStrings = "SJSU Engineering Building engg charles davidson college eb";
		engg.imageName = "EnggBldg.png";
		engg.tag = "104";
		buildings.addObject(engg);

		let su : Building = Building();
		su.name = "Student Union";
		su.address = "Student Union Building, San Jose, CA 95112";
		su.searchStrings = "student union su building";
		su.imageName = "SU.png";
		su.tag = "105";
		buildings.addObject(su);

		let bbc : Building = Building();
		bbc.name = "Boccardo Business Complex";
		bbc.address = "Boccardo Business Complex, San Jose, CA 95112";
		bbc.searchStrings = "bbc boccardo business complex";
		bbc.imageName = "BBC.png";
		bbc.tag = "106";
		buildings.addObject(bbc);

		return buildings;
	}
	
	static func getBuildingWithName(buildingName: String!) -> NSMutableArray? {
		
		let predicate : NSPredicate = NSPredicate(format: "searchStrings contains[c] %@", buildingName);
		
		let filteredArray : NSArray = (buildings?.filteredArrayUsingPredicate(predicate))!;
		
		if (filteredArray.count != 0) {
			
			return filteredArray.mutableCopy() as? NSMutableArray;
		} else {
			
			return NSMutableArray();
		}
	}
	
	static func getBuildingInfoForTag(tag: Int) -> NSMutableArray? {
		
		let predicate : NSPredicate = NSPredicate(format: "tag == %@", String(tag));
		
		let filteredArray : NSArray = (buildings?.filteredArrayUsingPredicate(predicate))!;
		
		if (filteredArray.count != 0) {
			
			return filteredArray.mutableCopy() as? NSMutableArray;
		} else {
			
			return NSMutableArray();
		}
	}
}