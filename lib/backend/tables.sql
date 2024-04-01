CREATE TABLE users (
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
    
CREATE TABLE Zone (
            name TEXT,
            zone_id TEXT PRIMARY KEY,
            type TEXT,
            latitude DOUBLE,
            longitude DOUBLE,
            area TEXT,
            population TEXT,
            police_station TEXT,
            town TEXT,
            district TEXT,
            state TEXT,
            pin_code TEXT,
            instance_time TIME DEFAULT CURRENT_TIME
          )

CREATE TABLE Subject (
            subject_id TEXT PRIMARY KEY,
            SubjectName TEXT, 
            SpouseName TEXT,
            ChildName TEXT,
            MaritalStatus TEXT,
            Village TEXT,
            IDType TEXT,
            IDNumber TEXT,
            Mobile TEXT,
            Address TEXT,
            Age INTEGER,
            Sex TEXT,
            Caste TEXT,
            Image TEXT,
            Voice TEXT,
            Religion Text,
            Occupation TEXT,
            Zone_ID TEXT,
            Email TEXT,
            Instance_time TIME DEFAULT CURRENT_TIME,
            upload_time TEXT
          )

CREATE TABLE survey_project (
            name TEXT,
            sid TEXT PRIMARY KEY,
            creation_date DATE  DEFAULT CURRENT_DATE,
            description TEXT,
            template_source TEXT,
            details_source TEXT,
            instance_time TIME DEFAULT CURRENT_TIME,
            upload_time TEXT
          )

CREATE TABLE field_project (
            name TEXT,
            fid TEXT PRIMARY KEY,
            sid TEXT,
            source_type INTEGER,
            attribute_name TEXT,
            attribute_datatype TEXT,
            attribute_unit TEXT,
            attribute_values TEXT,
            required_value INTEGER,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            upload_time TEXT,
            FOREIGN KEY (sid) REFERENCES survey_project(sid)
          )

CREATE TABLE record_log (
            rid TEXT PRIMARY KEY,
            subject_id TEXT,
            survey_datetime DATETIME,
            sid INTEGER,
            record_type INTEGER,
            survey_data TEXT,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            upload_time TEXT,
            FOREIGN KEY (sid) REFERENCES survey_project(sid),
            FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)

          )

CREATE TABLE field_entry (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rid TEXT,
            fid TEXT,
            value TEXT,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            upload_time TEXT,
            FOREIGN KEY (rid) REFERENCES record_log(rid),
            FOREIGN KEY (fid) REFERENCES field_project(fid)
          )

CREATE TABLE service (
            service_id TEXT PRIMARY KEY,
            sname TEXT,
            description TEXT,
            sid TEXT, 
            upload_time TEXT,
            FOREIGN KEY (sid) REFERENCES survey_project(sid)
          )

CREATE TABLE service_enrollment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            service_id TEXT,
            subject_id TEXT,
            sid TEXT,
            start_date TEXT,
            end_date TEXT,
            upload_time TEXT,
            FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
            FOREIGN KEY (sid) REFERENCES survey_project(sid),
            FOREIGN KEY (service_id) REFERENCES service(service_id)
          )
