# MemeMe 2.0

MemeMe 2.0 is a project for iOS Developer Nanodegree program at Udacity

[![Swift Version](https://img.shields.io/badge/Swift-5.3-brightgreen)](https://swift.org) [![Xcode Version](https://img.shields.io/badge/Xcode-12.1-success.svg)](https://swift.org) [![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://swift.org)

## Overview

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.


## Features
- A navigation structure that creates an intuitive flow through the app
- Build tables with datasources and delegates
- Create custom table view cells
- Implement user interfaces with tab views and collection views

## How to use the app
1. When the user first launches the app the Sent Memes View will appear. 
2. When the user taps the + button in the top right corner the app should push the Meme Editor View.
3. In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. 
4. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.
5. After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor.
6. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.
7. When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme.
8. Selecting a meme from the table or collection presents the Meme Detail View.
9. In the Meme Detail View, when the user clicks on the 'Edit' button, the Meme Editor view appear and allow the user to edit an already existing meme.
10.A "swipe to delete” function to the table view that allow the users to delete a meme.


## Tools

- Xcode 12.1
- Swift
 
## Compatibility

 - iOS 7+

## Installation

Download and unzip ```MemeMe-2.0```

## To Do
- Allow the user to crop the image.

