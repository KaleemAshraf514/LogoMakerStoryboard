# LogoMakerStoryboard

An iOS Logo Maker application built with **Swift, UIKit and Storyboard**.

## Current Features

- Home screen with template categories and subcategories
- Logo, Flyer, Poster, Business Card and Invitation browsing
- Dynamic template aspect ratios by category
- Search
- Favourites persisted locally
- Side menu and premium UI
- Local bundled template catalogue
- Reusable image loading and collection-view cells
- Category artwork with asset-catalog and bundle fallbacks

## Project Structure

- `LogoMakerStoryboard.xcodeproj` — Xcode project
- `LogoMakerStoryboard/LogoMakerStoryboard 4/` — application target
- `LogoMakerUIKit/Home/` — Home, search and gallery screens
- `LogoMakerUIKit/Services/` — template and favourites services
- `LogoMakerUIKit/Resources/` — bundled template data
- `Assets.xcassets` — application/category assets
- `Base.lproj/Main.storyboard` — main storyboard

## Requirements

- Xcode
- iOS SDK supported by the project
- Swift

## Running

1. Clone the repository.
2. Open `LogoMakerStoryboard.xcodeproj` in Xcode.
3. Select your development team/signing configuration if running on a physical device.
4. Choose a simulator or connected iPhone.
5. Build and run.

## Notes

The template editor/canvas is still under development. The current project focuses on template discovery, category browsing, search, favourites and supporting UI.

## Repository Hygiene

User-specific Xcode state, DerivedData, build products and macOS metadata are intentionally excluded from version control.
