//
//  CityManager.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation
import CoreData

//Singleton - an object that has a single instance in the life span of the application

//1. final - a class can NOT be inherited
final class CityManager {
    
    //2. static - shared instance variable for anyone that wants to use the class
    static let shared = CityManager()
    
    //3. private init - so no one else can instantiate another instance
    private init() {}
    
    //escaping gives the closure a separate life span than the function it resides in
    func getCities(completion: @escaping ([City]) -> Void) {
        
        //Multithreading - GCD (Grand Central Dispatch)
        
        //Qualities of Service - Pritory of Queue - 5 QOS: 1. UserInteractive, 2. UserInitiated, 3. default, 4. utility, 5.background
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else {
                completion([])
                return
            }
            
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                var cities = [City]()
                
                for dict in jsonResponse {
                    if let city = City(dict: dict) {
                        cities.append(city)
                    }
                }
                
                completion(cities)
                
            } catch {
                print("Couldn't Serialize JSON: \(error.localizedDescription)")
                completion([])
                return
            }
            
        }
    }
    
    /* Core Data Stack
     1. NSManagedObject - Entity - Must be created in the context
     2. NSManagedObjectContext - handles the saving, deletion, and modiciation of entities - Is on main thread
     3. NSPersistentCoordinator - handles how the context is saved
     4. NSPersistentStore - Where the entities are saved - store for persistence
    */
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //lazy - late init - doesn't actually initialize the object until it is called
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "City2City")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
        return container
    }()
    
    
    //MARK: Save
    func save(_ city: City) {
        //check if city exists
        check(city)
        
        //init new CoreCity
        let entity = NSEntityDescription.entity(forEntityName: "CoreCity", in: context)!
        let coreCity = CoreCity(entity: entity, insertInto: context)
        
        //KVC - Key Value Coding - accessing a objects properties by a string
        coreCity.setValue(city.name, forKey: "name")
        coreCity.setValue(city.state, forKey: "state")
        coreCity.setValue(city.population, forKey: "population")
        coreCity.setValue(city.coordinates.latitude, forKey: "lat")
        coreCity.setValue(city.coordinates.longitude, forKey: "long")
        
        //MUST Save context - or it will NOT persist
        saveContext()
        
        print("Saved City To CoreData: \(city.name)")
    }
    
    //MARK: Load
    func load() -> [CoreCity] {
        
        //fetch request - perform query for CoreData
        let fetchRequest = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        
        var cities = [CoreCity]()
        
        do {
            //make a request in the context with the fetch request
            cities = try context.fetch(fetchRequest)
            cities.reverse() //reverse array order
        } catch {
            print("Couldn't Fetch CoreCity: \(error.localizedDescription)")
        }
        
        print("Loaded CoreCities: \(cities.count)")
        return cities
    }
    
    //MARK: Delete
    func delete(_ coreCity: CoreCity) {
        context.delete(coreCity)
        print("Deleted CoreCity: \(coreCity.name!), \(coreCity.state!)")
        saveContext()
    }
    
    //MARK: Check - delete duplicates and limit saved cities to 10
    func check(_ city: City) {
        
        let coreCities = load()
        
        for core in coreCities {
            
            if city.name == core.name! && city.state == core.state! {
                delete(core)
                return
            }
        }
        
        if coreCities.count > 9 {
            delete(coreCities.last!)
        }
        
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
}
