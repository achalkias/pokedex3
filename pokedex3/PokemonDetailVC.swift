//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Apostolos Chalkias on 23/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var heightLbL: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    //Init a variable of type Pokemon
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the name and pokedex id
        nameLbl.text = pokemon.name.capitalized
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        //Set images
        setImages()
        
        
        //Download data
        pokemon.downloadPokemonDetail {
            
            
            
            self.updateUI()
        }
    }
    
    func setImages() {
    
        //  Get the right image
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        
        //Set the images to imageviews
        mainImg.image = img
        currentEvoImg.image = img
    }

 
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        //Close controller
        dismiss(animated: true, completion: nil)
    }

    
    func updateUI() {
        //Set the labels
        attackLbl.text = pokemon.attack
        defenceLbl.text = pokemon.defense
        heightLbL.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            
            //Pokemon dont have evolutions
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        
        }
        
        
        
        
    }
}
