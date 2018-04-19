

### REQUIREMENTS ###


### BUILD ###
iOS 8.2.1 SDK or later
(Swift version 3.02 or later)


### RUNTIME ###
iOS 9.0 or later 
(for older version need to remove all UI elements from UIStackView(via Storyboard) and reinstall them without UIStackView )

This app might be interesting for you if you are looking for implementing CoreData(multiple contexts) / some feature concerning interaction with github.com


### About TestGitHubApi ###

Hi there,

Welcome to app "TestGitHubApi"

![screenshot](https://github.com/PROudoxa/git-first/blob/master/github1.jpg)
![screenshot](https://github.com/PROudoxa/git-first/blob/master/github2.jpg)
![screenshot](https://github.com/PROudoxa/git-first/blob/master/github3.jpg)
![screenshot](https://github.com/PROudoxa/git-first/blob/master/github4.jpg)

This app provides you opportunity for searching repositories for defined github User. Also, you are able to get their detail information and edit some data in your favourite list.
You can save repo to your favourite list. Also you can go to repo's webpage.


### Getting started ###

clone or download the project

this app uses

    pod 'GithubPilot', '~> 1.1'

so, you have to install that pod in order to build the app

in terminal go to project's folder and type:

    pod init

file Podfile has to be created in progect's folder
after that edit the Podfile with Xcode

your Podfile's content should be something like follow one: 
    #-----------
    # Uncomment the next line to define a global platform for your project
    platform :ios, '9.0'

    target 'TestGitHubApi' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for TestGitHubApi
    pod 'GithubPilot', '~> 1.1'

    end
    #-----------

in terminal:
    pod install

if all is ok(green text messages in terminal)
you can try to build a target :)

### Building && Running ###

a) using simulator iOS apps:

open project folder and double click on file

    TestGitHubApi.xcworkspace

in Xcode in scheme section(top left corner) select

    target "TestGitHubApi" -> in "simulators" section select "iPhone 7"(or another simulator)

in Xcode menu go to:

    Product -> Run       (or just hotkey command + R)

the app will be builing and run by Xcode

Let you know more about User's repos!
Have a nice day!


b) using Apple device(iPhone/iPad):

clone or download the project
open project folder
double click to file FunnyRectangles.xcodeproj

in Xcode in scheme section(top left corner) select

    target "TestGitHubApi" -> in "devices" section select one of available devices(dont forget to connect it before)

in Xcode menu go to:

    Product -> Run       (or just hotkey command + R)

the app will be builing and run by Xcode

Let you know more about User's repos!
Have a nice day!


I hope the above is useful to you.
Please feel free to contact me if you need any additional information
