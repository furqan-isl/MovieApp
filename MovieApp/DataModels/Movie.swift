//
//  Movie.swift
//  MovieApp
//
//  Created by Furqan on 3/23/17.
//  Copyright © 2017 Furqan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {

    var name: String?
    var releaseDate: String?
    var overview: String?
    var posterUrl: String?

    
    convenience init(json: JSON) {
        self.init()
        
        name = json["title"].string
        releaseDate = json["release_date"].string
        overview = json["overview"].string
        posterUrl = json["poster_path"].string
        
    }
    
}
