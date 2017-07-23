//
//  PokeCell.swift
//  pokedex3
//
//  Created by Apostolos Chalkias on 23/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    
    //IBOutlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //Init pokemon class
    var pokemon: Pokemon!
    
    
    //Set rounded corners to cell
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Set radius to layer
        layer.cornerRadius = 5.0
    }
    
    
    func configureCell(_ pokemon: Pokemon){
    
        //Get pokemon instance
        self.pokemon = pokemon
        
        //Update label
        nameLbl.text = pokemon.name.capitalized
        
        //Update image by pokedexId
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
    }
    
    
}
