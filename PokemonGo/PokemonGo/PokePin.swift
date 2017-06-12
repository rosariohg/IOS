//
//  PokePin.swift
//  PokemonGo
//
//  Created by Rosario Huanca Gonza on 6/8/17.
//  Copyright © 2017 Rosario Huanca Gonza. All rights reserved.
//

import UIKit
import MapKit

class PokePin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon:Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

