//
//  ViewController.swift
//  pokedex3
//
//  Created by Apostolos Chalkias on 23/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    
    //IBOutlets
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Array of type Pokemon
    var pokemon = [Pokemon]()
    //Array of type pokemon to save filtered data
    var filteredPokemon = [Pokemon]()
    
    //Init an audio player
    var musicPlayer: AVAudioPlayer!
    
    //Init a boolean to determine whether or not is on search mode or not
    var inSearchMode = false
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //Assing collectoinView delegate and dataSource
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        //Change the search bar return key to say done
        searchBar.returnKeyType = UIReturnKeyType.done
        
        //Parse the pokemon list from csv
        parsePokemonCsv()
        
        //Set the audio
        initAudio()
        
        
    }
    
    
    func initAudio(){
        //Get the path of the music file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        //Try to get the music file
        do {
            
            //Set audio player
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)

            //Prepare music player for play the audio file
            musicPlayer.prepareToPlay()
            
            //Set the number of loops to -1 so it will loop continuesly
            musicPlayer.numberOfLoops = -1
            
            //Play the audio file
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    func parsePokemonCsv(){
    
        //Get the path of the file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //Try parse the csv
        do {
             let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            //Loop through the rows to get the data
            for row in rows {
               
                //Get pokeId
                let pokeId = Int(row["id"]!)!
                
                //Get pokeName
                let name = row["identifier"]!
                
                //Create a pokemon object
                let poke = Pokemon(name: name, pokedexId: pokeId)
            
                //Append object to the pokemon array
                pokemon.append(poke)
                
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create cells. Using resuable cell to load only the displayed cells
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath)
            as? PokeCell{
            
            //Create an object of Pokemon type
            let poke: Pokemon!
            
            
            //Check whether or not is inSearchMode to return the right array index
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                
                //Pass the object to PokeCell
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                
                //Pass the object to PokeCell
                cell.configureCell(poke)
            }
          
            
            //Return cell
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Create an object of type Pokemon
        var poke: Pokemon!
        
        //Check serach mode to set the right object
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else{
             poke = pokemon[indexPath.row]
        }
        
        //Perform a segue and send the poke object
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        //Check if is in serach mode or not to return the right array count
        if inSearchMode{ return filteredPokemon.count} else {return pokemon.count}
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        //If the music plays pause the music
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            
            //Set some alpha to the button
            sender.alpha = 0.2
            
        } else {
            musicPlayer.play()
            
            //Remove alpha from the button
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Close keyboard
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Check if the search bar text is nill
        
        if searchBar.text == nil || searchBar.text == ""{
   
            //Set search mode to false
            inSearchMode = false
            
            
            //Repopulate the collection view data
            collection.reloadData()
            
            //Close keyboard
            view.endEditing(true)
            
        } else {
            
            //Set search mode to true
            inSearchMode = true
            
            //Check if the search bar text is equal to any of the pokemon array name 
            
            //Lower case the text 
            let lower = searchBar.text!.lowercased()
            
            //Set the filtered pokemon list to the original pokemon list but filtered
            //$0 means each object in pokemon array
            //So for each name value check if the search bar text contained inside of the value
            //If the value contans the lower then put it in filtered list
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            
            //Repopulate the collection view data
            collection.reloadData()
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "PokemonDetailVC" {
            //Crate a variable of the destinacion view controller
            if let detailsVC = segue.destination as? PokemonDetailVC {
                //Get the sender object
                if let poke = sender as? Pokemon {
                    
                    //set the poke object to pokemon variable in PokemonDetailVC controller
                    detailsVC.pokemon = poke
                    
                }
                
            }
        }
        
    }
    
    
}

