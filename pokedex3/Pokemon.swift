//
//  Pokemon.swift
//  pokedex3
//
//  Created by Apostolos Chalkias on 23/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
    //Getters
    
    var nextEvolutionLevel: String {
        
        if _nextEvolutionLevel == nil {
            
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName == nil {
            
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String {
        
        if _description == nil {
            
            _description = ""
        }
        return _description
    }
    
    var type: String {
        
        if _type == nil {
            
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        
        if _defense == nil {
            
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        
        if _height == nil {
            
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        
        if _weight == nil {
            
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        
        if _attack == nil {
            
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        
        if _nextEvolutionTxt == nil {
            
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    
    
    
    
    
    var name:String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId:Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    
    //Initializer
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        print(self._pokemonURL)
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //Get the dictionary
            if let dict = response.result.value as? Dictionary<String,AnyObject>{
                
                //Get weight
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                //Get height
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                //Get attack
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                //Get diffence
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                //Get the type
                //Check if exists and if the count is not 0
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0{
                    
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    
                    //Check the count of types
                    if types.count > 1 {
                        //Loop through types and set the values
                        for x in 1..<types.count {
                            //Set the other names
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                    
                    
                    
                } else {
                    self._type = ""
                }
                
                //Get the descriptions
                //Check that there is at least one
                if let descrArr = dict["descriptions"] as? [Dictionary<String,String>], descrArr.count > 0 {
                
                    //Get the url for the description
                    if let url = descrArr[0]["resource_uri"] {
                        
                        let descrUrl = "\(URL_BASE)\(url)"
                    
                        //Request the data from the description url
                        Alamofire.request(descrUrl).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                            
                                //Get the description
                                if let description = descDict["description"] as? String{
                                
                                    
                                    //Replace all the POKMON with Pokemon
                                    let newDescr  = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    
                                    //Set the description 
                                    self._description = newDescr
                                }
                                
                            }
                            completed()
                            
                        })
                    
                    }
                
                } else{
                    self._description = ""
                }
                
                //Get the evolutions
                if let evolutions = dict["evolutions"] as?  [Dictionary<String,AnyObject>], evolutions.count > 0  {
                
                    //Get the name of the next evolution
                    if let nextEvo = evolutions[0]["to"] as? String {
                    
                        //Exclude megas
                        if nextEvo.range(of: "mega") == nil {
                            
                         self._nextEvolutionName = nextEvo
                        
                            //Get the nextEvolution id
                            if let uri = evolutions[0]["resource_uri"] as? String {
                            
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                
                                //Get the level
                                if let lvlExists = evolutions[0]["level"] {
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                } else{
                                    self._nextEvolutionLevel = ""
                                }
                                
                            }
                            
                        }
                        
                    
                    }
                
                }
                
                
            }
            
            //Complete the request
            completed()
            
            
            
            
            
            
        }
        
    }
    
}
