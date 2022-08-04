//
//  RecipesCollectionViewCellViewModel.swift
//  Cooky
//
//  Created by Aslan Murat on 04.08.2022.
//

import Foundation

struct RecipesCollectionViewCellViewModel {
    var credits: Credit?
    var rating: UserRatings?
    var foodName: String
    var cookingDuration: Int?
    var imageURL: String
}
