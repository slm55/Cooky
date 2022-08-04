//
//  Recipe.swift
//  Cooky
//
//  Created by Aslan Murat on 21.07.2022.
//

import Foundation

// MARK: - Welcome
struct RecipeResponse: Codable {
    let count: Int
    let results: [Recipe]
}

// MARK: - Result
struct Recipe: Codable {
    let totalTimeMinutes: Int?
    let videoURL: String?
    let userRatings: UserRatings?
    let sections: [Section]?
    let thumbnailURL: String
    let name: String
    let id: Int
    let instructions: [Instruction]?
    let resultDescription: String?
    let credits: [Credit]
    let cookTimeMinutes: Int?
    let nutrition: Nutrition?
    let numServings: Int?
    let createdAt: Int
    let prepTimeMinutes: Int?
    let recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case totalTimeMinutes = "total_time_minutes"
        case videoURL = "video_url"
        case userRatings = "user_ratings"
        case sections
        case thumbnailURL = "thumbnail_url"
        case name
        case id
        case instructions
        case resultDescription = "description"
        case credits
        case cookTimeMinutes = "cook_time_minutes"
        case nutrition
        case numServings = "num_servings"
        case createdAt = "created_at"
        case prepTimeMinutes = "prep_time_minutes"
        case recipes
    }
}


// MARK: - Instruction
struct Instruction: Codable {
    let displayText: String

    enum CodingKeys: String, CodingKey {
        case displayText = "display_text"
    }
}

// MARK: - Nutrition
struct Nutrition: Codable {
    let carbohydrates: Int?
    let protein, fat, calories: Int?

    enum CodingKeys: String, CodingKey {
        case carbohydrates
        case protein, fat, calories
    }
}


// MARK: - Credit
struct Credit: Codable {
    let name: String?
}

// MARK: - Section
struct Section: Codable {
    let components: [Component]?
    let name: String?
}

// MARK: - Component
struct Component: Codable {
    let rawText: String?

    enum CodingKeys: String, CodingKey {
        case rawText = "raw_text"
    }
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let updatedAt: Int
    let name: String
    let createdAt: Int
    let displayPlural: String?
    let id: Int
    let displaySingular: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case name
        case createdAt = "created_at"
        case displayPlural = "display_plural"
        case id
        case displaySingular = "display_singular"
    }
}

// MARK: - UserRatings
struct UserRatings: Codable {
    let score: Double?

    enum CodingKeys: String, CodingKey {
        case score
    }
}

