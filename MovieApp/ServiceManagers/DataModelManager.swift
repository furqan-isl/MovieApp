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
    
    var suggestionsList: [String]!
    
    func loadModelData() {
        
        if let suggestions = UserDefaults.standard.object(forKey: Constants.UserDefaults.SUGGESTIONS_KEY) as? [String] {
            suggestionsList = suggestions
        } else {
            suggestionsList = [String]()
        }
        
//        let suggestions = UserDefaults.standard.stringArray(forKey: Constants.UserDefaults.SUGGESTIONS_KEY)
////        let suggestions = UserDefaults.standard.value(forKey: Constants.UserDefaults.SUGGESTIONS_KEY)
//        if suggestions != nil  {
//            if (suggestions?.count)! > 0 {
//                suggestionsList = Array(suggestions!)
//            }
//        }
    }
    
    


}
