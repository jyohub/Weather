# WeatherWidget

## Situation

- [x] B. Design and implement an app as a long term project
You are a tech-lead of an iOS team with 5 members. The team is going to develop a new iOS
app. It is supposed to be a long term project to develop and maintain the app within the team.
Before starting the development with the team members, you are going to design the app and
implement fundamental functionalities as the tech lead.

## Requirements

- iOS 14.0+
- Xcode 13.2.1

## Technologies used

- UIKit
- SwiftUI
- WidgetKit
- Combine

## To Run the project

- Select the Weather.xcodeproj from the project folder to open the project in Xcode. 
- After the project is open, run the project to open the App.

## Specification Implemented

- Show 3 widget options for users
- Get location permission from users
- Error handling for users who deny the permission of the popup
    - Assign users location automatically based on their location info
        - Sunny
        - Cloudy
        - Sun behind cloud
        - Raining
        - Snow
- Allow users to set their own image from their gallery
- Connect https://openweathermap.org/api with this app to get current weather
- Show the current weather in widget
- Widget info should be updated per 1 minute to show correct current weather

## Architecture and implementation details

The architecture used for this implementation is MVVM(Model-View-ViewModel).
View Model contains the business logic and is the single source of truth.
View Model acts like a processor which takes input from the view, does some processing, and returns the output. 
The outputs are what the view is binding to so that it reflects the state of the model.
The View just reflects the state of the model which is accessed through the View Model.
The View accesses the model through the View Model. 
The View has a direct reference to the View Model. But, the View Model is agnostic of the View. 
And, the model is agnostic of the View Model or the View.
Protocols are used to help with Unit testing and loose coupling between the objects.
UIKit is used for the App to display the widget setting screen for better control using Collection View.
The collection view cells reuse the widget created in SwiftUI for the cells.
Unit Tests are done for the service and view model. The code coverage can be improved for the error cases as well. 
Utils and extension classes are created as needed.
Error Handling is done to display the error to the user. But, for sone scenarios like location denied, it is better to give an option to user to set the location manually.

## To do 

Currently, app group is not enabled, as it needed an apple developer account, so the implementation to share the photo between the App an the widget is not there.
There may be some other way to enable app group, to test on simulator, but have not explored it in this implementation.
If app group is enabled in capabilities, then the photo can be displayed in the background for the widget as well.

For the initial implementation there are no third party libraries used. 
It is better to use libraries when needed later. 
Some of the libraries that can be considered in Future are: Swinject for Dependency Injection, Kingfisher, etc..,

## Experience

Overall, I really enjoyed doing this assignment.
The experience of having a good design and specification was really encouraging. 
Though, it looked simple, there are many things to consider as we have to think both the app and the widget implementation and sharing the code between them and make it generic and maintainable. 
Will keep on improving my implementation for improving unit test coverage and all edge cases.
Thank you so much for the opportunity.
