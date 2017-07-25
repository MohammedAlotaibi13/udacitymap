

import Foundation
import UIKit

class StudentArray {
    
    class var sharedInstance: StudentArray {
        
        struct Static {
            static var instance : StudentArray = StudentArray()
            
        }
        
        return Static.instance
        
    }
    
    var myArray : [Studentinformation] = [Studentinformation]()
    
    static func StudentInformationArray(_ result: [[String:AnyObject]]) -> [Studentinformation]{
        
        var studentinformations = [Studentinformation]()
        for result in result {
            
            studentinformations.append(Studentinformation(dicionary: result))
        }
        return studentinformations
    }
    
}
