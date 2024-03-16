# WORK FLOW

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
