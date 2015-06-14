//
//  Constants.swift
//  CoreDataCRUD
//  Written by Steven R.
//

struct Constants {
    
    struct CellIds {
        static let EventTableCell = "eventItemCell"
    }
    
    struct SegueIds {
        static let showEventItem = "showEventItemSegue"
        static let editEventItem = "editEventItemSegue"
    }
    
    struct CoreDataEntities {
        static let EventEntiy = "Event"
    }
    struct UserDefaults {
        static let RunCount = "runCount"
    }
    
    //Name of the Event entity
    static let eventNamespace = "Event"
    
    //Enum for Event Entity member fields
    enum EventAttributes : String {
        case
        eventId    = "eventId",
        title      = "title",
        date       = "date",
        venue      = "venue",
        city       = "city",
        country    = "country",
        attendees  = "attendees",
        fb_url      = "fb_url",
        ticket_url = "ticket_url"
        
        static let getAll = [
            eventId,
            title,
            date,
            venue,
            city,
            country,
            attendees,
            fb_url,
            ticket_url
        ]
    }

}