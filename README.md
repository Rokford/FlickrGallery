# FlickrGallery

## Overview
A simple gallery app pulling images from publicly available Flickr feed api.

The user interface is quite raw, using typical iOS patterns.

The app works in both portrait and landscape mode.

## How to run
Clone or download the project, then just open&run in Xcode. 
No additional setup is required.

## How to use
* Pull to refresh the list
* Tap a row to see a bigger picture
* Type a text in the search box to filter the results offline (by tag)
* Tap the 'Sort' button in the right-top corner to show sorting options

## Architecture
* MVVM architecture was used
* UI was designed using storyboard
* There is a dedicated service responsible for downloads

## Technical details
* Images are cached using NSCache
* Images are downloaded asynchronously for visible rows
* Search is done offline (filters the already downloaded results)
* Search results are NOT persisted in Core Data

## Error handling
* The networking errors are propagated up to the main ViewController, and displayed in a popup

## Dependencies
No 3rd party dependencies at the moment. 

Possible additions:
* RxSwift in case of more advanced networking tasks or in case of dynamic online search
* Moya/json mapper to streamline the networking and avoid manually parsing JSONs

## Tests
The app contains both regular and UI tests (currently just a basic one). 
They got their own dedicated targets in the project.
* Regular test are split into ViewModel tests and DownloadService tests
* Download tasks time is measured in tests

## Possible improvements
* Display all the images metadata (would also require a decent UI design to fit it adequatly)
* Add more sorting options 
* Add ServiceLocator pattern for services used (currently just DownloadService)

## Known issues
* "Date Taken" is passed in "yyyy-MM-ddThh:mm:ss-08:00" format, which, when converted to CET, sometimes show future dates. To be investigated...
* Manually refreshing the list turns off the sorting settings

