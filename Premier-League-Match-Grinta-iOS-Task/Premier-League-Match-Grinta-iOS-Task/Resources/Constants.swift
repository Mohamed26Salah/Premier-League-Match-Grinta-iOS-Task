//
//  Constants.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation

struct Constants {
    struct Links {
        static let baseUrl = ""
        static let apiKey = ""
    }
    struct cellsResuable {
        static let FoodTVC = "FoodTVC"
        static let IngredientsTVC = "IngredientsTVC"
        static let InstructionTVC = "InstructionTVC"
        static let NutritionTVC = "NutritionTVC"
    }
    struct ViewsControllers {
        static let UITabBarVC = "UITabBarVC"
        static let homeViewController = "HomeVC"
        static let FavouritesViewController = "FavouritesVC"
        static let FoodDetailsVC = "FoodDetailsVC"

    }
    struct ImageAssets {
        static let splashScreenImage = "splashScreenImage"
        static let YummyImage = "Yummy"
        static let getStartButton = "getStartedButtonImage"
        static let splashScreenImageBlurred = "splashScreenImageBlurred"
        static let savedImage = "Saved"
        static let UnsavedImage = "UnSaved"
        static let leftArrow = "left-arrow2"
    }
    struct UserDefaults {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

}
