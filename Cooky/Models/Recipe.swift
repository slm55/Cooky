//
//  Recipe.swift
//  Cooky
//
//  Created by Aslan Murat on 21.07.2022.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let count: Int
    let results: [Recipe]
}

// MARK: - Result
struct Recipe: Codable {
    let tipsAndRatingsEnabled: Bool?
    let draftStatus: DraftStatus
    let totalTimeMinutes: Int?
    let videoURL: String?
    let nutritionVisibility: NutritionVisibility?
    let country: Country
    let tags: [Tag]
    let isShoppable: Bool
    let yields: String?
    let userRatings: UserRatings?
    let sections: [Section]?
    let thumbnailURL: String
    let thumbnailAltText: String
    let approvedAt: Int
    let videoID: Int?
    let name: String
    let renditions: [Rendition]
    let seoTitle: String?
    let id: Int
    let show: Show
    let isOneTop: Bool?
    let totalTimeTier: TotalTimeTier?
    let videoAdContent: String?
    let originalVideoURL: String?
    let instructions: [Instruction]?
    let showID: Int
    let resultDescription: String?
    let credits: [Credit]
    let cookTimeMinutes: Int?
    let brand: Brand?
    let slug: String
    let topics: [Topic]?
    let canonicalID: String
    let language: Language
    let servingsNounPlural: String?
    let promotion: Promotion
    let nutrition: Nutrition?
    let numServings: Int?
    let aspectRatio: AspectRatio
    let createdAt: Int
    let keywords: String?
    let servingsNounSingular: String?
    let prepTimeMinutes, brandID: Int?

    enum CodingKeys: String, CodingKey {
        case tipsAndRatingsEnabled = "tips_and_ratings_enabled"
        case draftStatus = "draft_status"
        case totalTimeMinutes = "total_time_minutes"
        case videoURL = "video_url"
        case nutritionVisibility = "nutrition_visibility"
        case country, tags
        case isShoppable = "is_shoppable"
        case yields
        case userRatings = "user_ratings"
        case sections
        case thumbnailURL = "thumbnail_url"
        case thumbnailAltText = "thumbnail_alt_text"
        case approvedAt = "approved_at"
        case videoID = "video_id"
        case name
        case renditions
        case seoTitle = "seo_title"
        case id, show
        case isOneTop = "is_one_top"
        case totalTimeTier = "total_time_tier"
        case videoAdContent = "video_ad_content"
        case originalVideoURL = "original_video_url"
        case instructions
        case showID = "show_id"
        case resultDescription = "description"
        case credits
        case cookTimeMinutes = "cook_time_minutes"
        case brand, slug, topics
        case canonicalID = "canonical_id"
        case language
        case servingsNounPlural = "servings_noun_plural"
        case promotion, nutrition
        case numServings = "num_servings"
        case aspectRatio = "aspect_ratio"
        case createdAt = "created_at"
        case keywords
        case servingsNounSingular = "servings_noun_singular"
        case prepTimeMinutes = "prep_time_minutes"
        case brandID = "brand_id"
    }
}

enum AspectRatio: String, Codable {
    case the11 = "1:1"
    case the169 = "16:9"
}

// MARK: - Brand
struct Brand: Codable {
    let imageURL: String?
    let name: String
    let id: Int?
    let slug: String?
    let type: BrandType?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case name, id, slug, type
    }
}

enum BrandType: String, Codable {
    case brand = "brand"
    case community = "community"
    case typeInternal = "internal"
}

enum Country: String, Codable {
    case us = "US"
    case zz = "ZZ"
}

enum DraftStatus: String, Codable {
    case published = "published"
}

enum Language: String, Codable {
    case eng = "eng"
}

enum Promotion: String, Codable {
    case full = "full"
}

// MARK: - Show
struct Show: Codable {
    let name: ShowName
    let id: Int
}

enum ShowName: String, Codable {
    case bringMe = "Bring Me"
    case goodful = "Goodful"
    case tasty = "Tasty"
    case tasty101 = "Tasty 101"
    case tastyTastyJunior = "Tasty: Tasty Junior"
    case tastyTastyVegetarian = "Tasty: Tasty Vegetarian"
}

enum ThumbnailAltText: String, Codable {
    case empty = ""
    case onePotRecipes = "One-Pot Recipes"
    case summerBreakRecipesForYourKids = "Summer Break Recipes For Your Kids"
}

// MARK: - Instruction
struct Instruction: Codable {
    let temperature: Int?
    let id, position: Int
    let displayText: String
    let startTime: Int
    let appliance: Appliance?
    let endTime: Int

    enum CodingKeys: String, CodingKey {
        case temperature, id, position
        case displayText = "display_text"
        case startTime = "start_time"
        case appliance
        case endTime = "end_time"
    }
}

enum Appliance: String, Codable {
    case foodThermometer = "food_thermometer"
    case oven = "oven"
    case stovetop = "stovetop"
}

// MARK: - Nutrition
struct Nutrition: Codable {
    let sugar, carbohydrates, fiber: Int?
    let protein, fat, calories: Int?

    enum CodingKeys: String, CodingKey {
        case sugar, carbohydrates, fiber
        case protein, fat, calories
    }
}

enum NutritionVisibility: String, Codable {
    case auto = "auto"
    case hidden = "hidden"
}


// MARK: - Credit
struct Credit: Codable {
    let name: String?
    let type: BrandType
}

// MARK: - Rendition
struct Rendition: Codable {
    let maximumBitRate: Int?
    let height: Int
    let container: Container
    let duration: Int
    let minimumBitRate, bitRate: Int?
    let contentType: ContentType
    let aspect: Aspect
    let width: Int
    let name: RenditionName
    let posterURL: String
    let fileSize: Int?
    let url: String

    enum CodingKeys: String, CodingKey {
        case maximumBitRate = "maximum_bit_rate"
        case height, container, duration
        case minimumBitRate = "minimum_bit_rate"
        case bitRate = "bit_rate"
        case contentType = "content_type"
        case aspect, width, name
        case posterURL = "poster_url"
        case fileSize = "file_size"
        case url
    }
}

enum Aspect: String, Codable {
    case landscape = "landscape"
    case square = "square"
}

enum Container: String, Codable {
    case mp4 = "mp4"
    case ts = "ts"
}

enum ContentType: String, Codable {
    case applicationVndAppleMpegurl = "application/vnd.apple.mpegurl"
    case videoMp4 = "video/mp4"
}

enum RenditionName: String, Codable {
    case low = "low"
    case mp41280X720 = "mp4_1280x720"
    case mp4320X180 = "mp4_320x180"
    case mp4320X320 = "mp4_320x320"
    case mp4480X480 = "mp4_480x480"
    case mp4640X360 = "mp4_640x360"
    case mp4640X640 = "mp4_640x640"
    case mp4720X404 = "mp4_720x404"
    case mp4720X720 = "mp4_720x720"
}

// MARK: - Section
struct Section: Codable {
    let components: [Component]?
    let name: String?
    let position: Int
}

// MARK: - Component
struct Component: Codable {
    let measurements: [Measurement]?
    let rawText, extraComment: String
    let ingredient: Ingredient
    let id, position: Int

    enum CodingKeys: String, CodingKey {
        case measurements
        case rawText = "raw_text"
        case extraComment = "extra_comment"
        case ingredient, id, position
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

// MARK: - Measurement
struct Measurement: Codable {
    let unit: Unit
    let quantity: String
    let id: Int
}

// MARK: - Unit
struct Unit: Codable {
    let abbreviation: String
    let system: String
    let name: String
    let displayPlural: String
    let displaySingular: String

    enum CodingKeys: String, CodingKey {
        case abbreviation, system, name
        case displayPlural = "display_plural"
        case displaySingular = "display_singular"
    }
}

enum Abbreviation: String, Codable {
    case ball = "ball"
    case c = "c"
    case can = "can"
    case clove = "clove"
    case cup = "cup"
    case drop = "drop"
    case empty = ""
    case g = "g"
    case head = "head"
    case l = "L"
    case lb = "lb"
    case leaf = "leaf"
    case mL = "mL"
    case oz = "oz"
    case packet = "packet"
    case pt = "pt"
    case scoop = "scoop"
    case slice = "slice"
    case stick = "stick"
    case tablespoon = "tablespoon"
    case tbsp = "tbsp"
    case teaspoon = "teaspoon"
    case tsp = "tsp"
}

enum DisplayPlural: String, Codable {
    case balls = "balls"
    case cans = "cans"
    case cloves = "cloves"
    case cups = "cups"
    case drops = "drops"
    case empty = ""
    case g = "g"
    case heads = "heads"
    case l = "L"
    case lb = "lb"
    case leaves = "leaves"
    case mL = "mL"
    case oz = "oz"
    case packets = "packets"
    case pt = "pt"
    case scoops = "scoops"
    case slices = "slices"
    case sticks = "sticks"
    case tablespoons = "tablespoons"
    case teaspoons = "teaspoons"
}

enum UnitName: String, Codable {
    case ball = "ball"
    case can = "can"
    case clove = "clove"
    case cup = "cup"
    case drop = "drop"
    case empty = ""
    case gram = "gram"
    case head = "head"
    case leaf = "leaf"
    case liter = "liter"
    case milliliter = "milliliter"
    case ounce = "ounce"
    case packet = "packet"
    case pint = "pint"
    case pound = "pound"
    case scoop = "scoop"
    case slice = "slice"
    case stick = "stick"
    case tablespoon = "tablespoon"
    case teaspoon = "teaspoon"
}

enum System: String, Codable {
    case imperial = "imperial"
    case metric = "metric"
    case none = "none"
}

// MARK: - Tag
struct Tag: Codable {
    let name: String
    let id: Int
    let displayName: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case displayName = "display_name"
        case type
    }
}

enum TagType: String, Codable {
    case appliance = "appliance"
    case businessTags = "business_tags"
    case cookingStyle = "cooking_style"
    case cuisine = "cuisine"
    case dietary = "dietary"
    case difficulty = "difficulty"
    case equipment = "equipment"
    case featurePage = "feature_page"
    case healthy = "healthy"
    case holiday = "holiday"
    case meal = "meal"
    case occasion = "occasion"
    case seasonal = "seasonal"
}

// MARK: - Topic
struct Topic: Codable {
    let name, slug: String
}

// MARK: - TotalTimeTier
struct TotalTimeTier: Codable {
    let tier, displayTier: String

    enum CodingKeys: String, CodingKey {
        case tier
        case displayTier = "display_tier"
    }
}

// MARK: - UserRatings
struct UserRatings: Codable {
    let countPositive: Int
    let score: Double?
    let countNegative: Int

    enum CodingKeys: String, CodingKey {
        case countPositive = "count_positive"
        case score
        case countNegative = "count_negative"
    }
}

enum VideoAdContent: String, Codable {
    case none = "none"
    case undetermined = "undetermined"
}

// MARK: - Encode/decode helpers


class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

