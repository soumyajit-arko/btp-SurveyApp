# WORK FLOW

Perform a survey with your friends
Check which one do they prefer
How can you analyse the data
The existing solutions architectures

User Login 
-> Store the user data of whoever will be loggin in the device in the table.
Note : First time login should happen with internet connection

After logging in 
-> Get the user info from the server if logging in for the first time
 
```
    users (
        Name TEXT,
        Userid TEXT PRIMARY KEY,
        Password TEXT,
        Age INTEGER,
        Sex TEXT,
        Center_code TEXT,
        User_Type TEXT,
        Address TEXT,
        Mobile TEXT UNIQUE,
        Email TEXT UNIQUE,
        Instance_time TEXT
      )
```
Health Care Worker
--
Download Data

1. Download the survey forms

```
        survey_project (
            name TEXT,
            sid TEXT PRIMARY KEY ,
            creation_date DATE  DEFAULT CURRENT_DATE,
            description TEXT,
            template_source TEXT,
            details_source TEXT,
            instance_time TIME DEFAULT CURRENT_TIME
          )

template_source:[
    {
        "question": "How many times did you come to hospital",
        "type": "Single Choice",
        "unit": "",
        "options": "1,2,3,more than 3 ",
        "required": 0
    },
    {
        "question": "Do you have any of the following problems",
        "type": "Multiple Choice",
        "unit": "",
        "options": "Diabetics,Cancer,Ulcer",
        "required": 0
    },
    {
        "question": "Any previous medical history",
        "type": "Text Answer",
        "unit": "",
        "options": "",
        "required": 0
    },
    {
        "question": "Age when you first found this problem",
        "type": "Integer Answer",
        "unit": "",
        "options": "",
        "required": 0
    }
]



```
2. Download the services list
```
service_enrollment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subject_id INTEGER,
            sid TEXT,
            start_date TEXT,
            end_date TEXT,
            FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
            FOREIGN KEY (sid) REFERENCES survey_project(sid)
          )
```





saMiX

Customised for Ramakrishna Mission Home of Service, Varanasi

multi-centric platform

<!-- Each center has seperate license -->

Cannot be customized
Redundant

Samix Login box
APK version issue

Done :
i button in display beneficiaries to show modal form with image and audio
Hamburger menu - Name,Current network bandwidth, Upload/Download, Logout, version 1.0
Download and upload single buttons only in hamburger menu

Current : 
Upload and download image and audio

Store care giver in record log


