 <div align="center">
<img src="https://github.com/shahshubh/CampusCar/blob/master/assets/icon/logo-cc-new.png"  alt="CampusCar" width="120" >

CampusCar
==========

[![](https://img.shields.io/badge/Made_with-Flutter-blue?style=for-the-badge&logo=flutter)](https://flutter.dev/docs)
[![](https://img.shields.io/badge/Database-Firebase-yellow?style=for-the-badge&logo=firebase)](https://firebase.google.com/docs)
[![](https://img.shields.io/badge/IDE-Visual_Studio_Code-red?style=for-the-badge&logo=visual-studio-code)](https://code.visualstudio.com/ "Visual Studio Code")


</div>

Table of contents
-----------------

* [Introduction](#introduction)
* [Features](#Features)
* [Demo](#Demo)
* [Installation](#installation)
* [Contributing](#contributing)
* [License](#license)


Introduction
-------------


CampusCar provides automated vehicle entry system for any campus/institute or any buildings/socities to automate the process and help maintain records,logs,vehicles... and many more features.

Basically a vehicle number plate recognition app to verify whether the car has access/can enter the campus or not and provide temporary permit to visitors. Also an admin UI to view all logs and manage registered vehicles and more...


Features
---------

* User
    * License Plate Detection from car image.
    * Check for vehicles access inside the campus.
    * Register new vehicles entering the campus with temporary permit (1 day permit).
    * Live vehicles feature. (See vehicles coming at the gate with its details in real time with no user interaction required).

* Admin
    * Authentication.
    * Admin Dashboard with all required statistics and graphs.
    * Keep track of all registered vehicles and their location in/out campus.
    * Update Expiry date of vehicles access in campus.
    * Keep track of logs of all vehicles.
    * Download/Export Logs/Vehicles to excel sheet and pdf.
    * Add new vehicle.
    * Send reminder SMS to user of their access period's expiry.
    * Notify user through SMS on any change in expiry date of their vehicle's access.



Demo
-----

<div align="center">
    <h4 align="center">Home Screen &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Live Vehicles Screen &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Admin Screen</h4>
    <img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master//demo/gif1.gif"/>
    <img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master//demo/gif3.gif"/>
    <img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master//demo/gif2.gif"/>
</div>

<br />

### User Side

<div align="center">

<h4 align="center">Splash Screen &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Home Screen &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Side Drawer</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/1.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/2.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/2.1.jpg"/>

<h4 align="center">Allow Access &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Access Expired &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Vehicle Not Registered</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/3.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/4.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/5.jpg"/>

<h4 align="center">Add New Vehicle &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Registration Success &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Live Vehicle Screen</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/6.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/7.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/8.jpg"/>

</div>


### Admin Side

<div align="center">

<h4 align="center">Login Screen &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Dashboard Screen &nbsp&nbsp&nbsp&nbsp</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/9.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/10.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/11.jpg"/>

<h4 align="center">Side Drawer &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Vehicle Logs &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp All Vehicles</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/12.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/13.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/15.jpg"/>

<h4 align="center">Export as csv/pdf &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Downloaded pdf logs &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Downloaded csv logs</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/14.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/logs1.jpg"/>
<img height=480 width=210 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/logs2.jpg"/>

<h4 align="center">Downloaded pdf allvehicles &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Downloaded csv allvehicles &nbsp&nbsp&nbsp&nbsp</h4>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/vehicles1.jpg"/>
<img height=480 width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/vehicles2.jpg"/>

<h4 align="center">Welcome SMS &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Reminder SMS &nbsp&nbsp&nbsp&nbsp | &nbsp&nbsp&nbsp&nbsp Expiry date update SMS</h4>
<img width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/sms1.jpg"/>
<img width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/sms2.jpg"/>
<img  width=240 style="margin: 10px;" src="https://github.com/shahshubh/CampusCar/blob/master/demo/sms3.jpg"/>


</div>


Installation
-------------

Before starting with installation you would require server for license plate recognition.
For that please follow the steps in the README file here [CampusCar-Server](https://github.com/shahshubh/CampusCar-Server) and then come back.

Once the server is up and running copy the ngrok api url you get after running it and follow below steps.

1. Clone this repository `git clone https://github.com/shahshubh/CampusCar.git`.
2. Change directory `cd CampusCar`.
3. Go to /lib/screens/user/home/home_screen.dart file and on Line 70 change it to
    ```dart
    var endpoint = apiUrl != null ? apiUrl : "your-ngrok-api-url";
    ```
    replace your-ngrok-api-url with the url you copied above + "/upload".
    
    Final url should look something like this _http://{random-string}.ngrok.io/upload_
4. Create a new [firebase project](https://firebase.google.com/)
5. Go to project settings and download **google-services.json** file.
6. Copy this file and paste it inside /CampusCar/android/app/ folder.

<!-- 7. Next create .env file in root folder and add
    ```dart
    ALPR_TOKEN=your-alpr-token
    ```
    You can get your token from [here](https://app.platerecognizer.com/accounts/plan/) -->
7. Run `flutter pub get`.
8. Finally run `flutter run`.


Contributing
-------------
1. Fork it (https://github.com/shahshubh/CampusCar/fork)
2. Create your feature branch (git checkout -b feature/fooBar)
3. Commit your changes (git commit -am 'Add some fooBar')
4. Push to the branch (git push origin feature/fooBar)
5. Create a new Pull Request


License
--------

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/shahshubh/CampusCar/blob/master/LICENSE)


Stargazers
-----------
[![Stargazers repo roster for @shahshubh/CampusCar](https://reporoster.com/stars/shahshubh/CampusCar)](https://github.com/shahshubh/CampusCar/stargazers)




<br/>
<p align="center"><a href="https://github.com/shahshubh/CampusCar#"><img src="https://github.com/shahshubh/CampusCar/blob/master/demo/backToTopButton.png" alt="Back to top" height="29"/></a></p>
