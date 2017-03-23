//
//  DataModelManager.swift
//  MovieApp
//
//  Created by Furqan on 3/23/17.
//  Copyright © 2017 Furqan. All rights reserved.
//

import UIKit

class DataModelManager: NSObject {
    
    // Singleton shared object
    static let shared = DataModelManager()
    
    private override init() {  //This prevents others from using the default '()' initializer for this Singleton class
        super.init()
        //Initialization
    }


}
