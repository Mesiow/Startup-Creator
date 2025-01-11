//
//  SCCoreDataManager.swift
//  Startup Creator
//
//  Created by Chris W on 1/6/25.
//

import UIKit
import CoreData

class SCCoreDataManager {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    static func fetchData(with request: NSFetchRequest<Idea> = Idea.fetchRequest()) -> [Idea]{
        //sort data by date (newest entry at the top)
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false);
        let sortDescriptors = [dateSortDescriptor];
        request.sortDescriptors = sortDescriptors
        
        var array: [Idea] = []
        do{
            array = try context.fetch(request)
        }catch{
            print("Error loading favorite rides from core data \(error)");
        }
        return array
    }
    
    static func save() {
        do {
            try context.save();
        }catch {
            print("(Core data) Error saving session \(error)");
        }
    }
    
    //Methods return array with updated data
    static func reloadData() -> [Idea]{
        save()
        let data = fetchData();
        
        return data
    }
    
    static func deleteIdeaFromCollection(in ideas: [Idea], at indexPath: IndexPath) -> [Idea]{
        context.delete(ideas[indexPath.row]); //implicity saves the changes of deletion to core data
        let result = reloadData()
        
        return result
    }
}
