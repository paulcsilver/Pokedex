//
//  Pokemon.swift
//  Pokedex
//
//  Created by Paul Silver on 12/31/16.
//  Copyright © 2016 paulcsilver. All rights reserved.
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
    private var _nextEvolutionName: String!
    private var _nextEvolutionPokedexId: Int!
    private var _nextEvolutionLevel: Int!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var id: Int {
        return _pokedexId
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
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionPokedexId: Int {
        if _nextEvolutionPokedexId == nil {
            _nextEvolutionPokedexId = -1
        }
        
        return _nextEvolutionPokedexId
    }
    
    var nextEvolutionLevel: Int {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = -1
        }
        
        return _nextEvolutionLevel
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    init(name: String, id: Int) {
        _name = name
        _pokedexId = id
        
        _pokemonURL = "\(POKEMON_API_HOSTNAME)\(POKEMON_API_PATH)\(_pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        // Request the details for the Poke from the API host
        Alamofire.request(_pokemonURL!).responseJSON { response in
            // Extract the JSON as a Dictionary, and the extract each individual component
            // to populate the attributes on our Pokemon class
            if let pokemonDict = response.result.value as? Dictionary<String, AnyObject> {
                // Weight
                if let weight = pokemonDict["weight"] as? String {
                    self._weight = weight
                }
                
                // Height
                if let height = pokemonDict["height"] as? String {
                    self._height = height
                }
                
                // Attack
                if let attack = pokemonDict["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                // Defense
                if let defense = pokemonDict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                // Type
                if let types = pokemonDict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for i in 1..<types.count {
                            if let name = types[i]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                // Description
                if let descriptions = pokemonDict["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0 {
                    var pokemonDescription = ""
                    
                    for descriptionDict in descriptions {
                        if let path = descriptionDict["resource_uri"] {
                            let url = POKEMON_API_HOSTNAME + path
                            Alamofire.request(url).responseJSON { response in
                                if let resourceDict = response.result.value as? Dictionary<String, AnyObject> {
                                    if let description = resourceDict["description"] as? String {
                                        pokemonDescription += (description + " ")
                                    }
                                }
                                
                                if descriptionDict == descriptions.last! {
                                    self._description = pokemonDescription
                                    completed()
                                }
                            }
                        }
                    }
                } else {
                    self._description = "No description available."
                }
                
                // Evolutions - the dictionary has the level and the name, the resource_uri has the id
                if let evolutions = pokemonDict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    // NextEvolutionName
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            // NextEvolutionId
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let stripped_uri = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextPokedexId = stripped_uri.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionPokedexId = Int(nextPokedexId)!
                            } else {
                                self._nextEvolutionPokedexId = -1
                            }
                            // NextEvolutionLevel
                            if let level = evolutions[0]["level"] as? Int {
                                self._nextEvolutionLevel = level
                            } else {
                                self._nextEvolutionLevel = -1
                            }
                        }
                    } else {
                        self._nextEvolutionName = "N/A"
                    }
                }
            }
            
            completed()
        }
    }
    
}
