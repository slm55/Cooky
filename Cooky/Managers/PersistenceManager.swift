//
//  FavoriteRecipesManager.swift
//  Cooky
//
//  Created by Aslan Murat on 01.08.2022.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private(set) var favoriteRecipes = [Recipe]()
    
    private init(){
        getFavoriteRecipes()
    }
    
    func getFavoriteRecipes(){
        if let data = UserDefaults.standard.object(forKey: "favoriteRecipes"){
            if let dataFR = try? JSONDecoder().decode([Recipe].self, from: data as! Data) {
                favoriteRecipes = dataFR
            }
        }
    }
    
    func addFavoriteRecipe(recipe: Recipe) {
        favoriteRecipes.append(recipe)
    }
    
    func deleteFavoriteRecipe(recipe: Recipe) {
        if let indexOfRecipe = favoriteRecipes.firstIndex(where: {$0.id == recipe.id}) {
            favoriteRecipes.remove(at: indexOfRecipe)
        }
    }
    
    func saveFavoriteRecipes(){
        if let data = try? JSONEncoder().encode(favoriteRecipes) {
            UserDefaults.standard.set(data, forKey: "favoriteRecipes")
        }
    }
    
    func isFavoriteRecipe(recipe: Recipe) -> Bool {
        return favoriteRecipes.contains(where: {$0.id == recipe.id})
    }
}
