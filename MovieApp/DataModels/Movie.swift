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
    var posterPath: String?
    var posterUrl: String?

    
    convenience init(json: JSON) {
        self.init()
        
        name = json["title"].string
        releaseDate = json["release_date"].string
        overview = json["overview"].string
        posterPath = json["poster_path"].string
        
        //http://image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg
        if posterPath != nil && posterPath != "" {
            posterUrl = "http://image.tmdb.org/t/p/w92" + posterPath!
        }
        
    }
    
}
