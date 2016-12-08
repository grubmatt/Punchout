//
//  CoreDataStack.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import Foundation
import CoreData

// again, making public so playground can access these
public class CoreDataStack {
    
    public let model:NSManagedObjectModel
    public let persistentStoreCoordinator:NSPersistentStoreCoordinator
    public let context:NSManagedObjectContext
    
    public init() {
        // initialize our contact entity
        let scoreEntity = NSEntityDescription()
        scoreEntity.name = "Score"
        scoreEntity.managedObjectClassName = NSStringFromClass(Score)
        
        // create the attributes for the entity (just id and name for now)
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .Integer64AttributeType
        idAttribute.optional = false
        idAttribute.indexed = true
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .StringAttributeType
        nameAttribute.optional = false
        nameAttribute.indexed = false
        
        let userScoreAttribute = NSAttributeDescription()
        userScoreAttribute.name = "userScore"
        userScoreAttribute.attributeType = .StringAttributeType
        userScoreAttribute.optional = false
        userScoreAttribute.indexed = false
        
        let opponentScoreAttribute = NSAttributeDescription()
        opponentScoreAttribute.name = "opponentScore"
        opponentScoreAttribute.attributeType = .StringAttributeType
        opponentScoreAttribute.optional = false
        opponentScoreAttribute.indexed = false
        
        // add the properties to the entity
        scoreEntity.properties = [idAttribute, nameAttribute, userScoreAttribute, opponentScoreAttribute]
        
        // add the entities to the model
        model = NSManagedObjectModel()
        model.entities = [scoreEntity]
        
        // setup the persistent store coordinator
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        }
        catch {
            print("error creating persistentstorecoordinator: \(error)")
        }
        
        // set up managed object context
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
    }
    
    // a simple function to save the context only if it has changes
    public func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
