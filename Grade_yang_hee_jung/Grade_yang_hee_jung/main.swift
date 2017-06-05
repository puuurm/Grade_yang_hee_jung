//
//  main.swift
//  Grade_yang_hee_jung
//
//  Created by yangpc on 2017. 6. 2..
//  Copyright © 2017년 yangpc. All rights reserved.
//

import Foundation

public struct Student: Comparable{
    let name: String
    let average: Double
    
    public static func == (lhs: Student, rhs: Student) -> Bool {
        return (lhs.name == rhs.name) && (lhs.name == rhs.name)
    }
    
    public static func < (lhs: Student, rhs: Student) -> Bool {
        if lhs.name != rhs.name {
            return lhs.name < rhs.name
        } else if lhs.name != rhs.name {
            return lhs.name < rhs.name
        } else {
            return false
        }
    }
    
}

public extension Double { /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let result = Darwin.round(self * divisor) / divisor
        return result
    }
}

public func loadJson() -> [Student]? {
    let file: String = "students.json"
    let dir = FileManager.default.homeDirectoryForCurrentUser
    let path = dir.appendingPathComponent(file)
    if let data = try? Data(contentsOf: path, options: .alwaysMapped) {
        do {
            guard let json: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] else {
                return nil
            }
            return parseJsonToObject(json: json)
        } catch { print(error) }
    } else {
        print("No file")
    }
    return nil
}

public func parseJsonToObject(json: [NSDictionary]) -> [Student]? {
    var studentArr: [Student] = [Student]()
    for students in json {
        guard let studentName: String = students.value(forKey: "name") as? String,
            let grades: [String: Double] = students.value(forKey: "grade") as? [String: Double] else {
                return nil
        }
        var sumOfScore: Double = 0.0
        let numOfSubject: Double = Double(grades.count)
        for (_, score) in grades {
            sumOfScore += score
        }
        studentArr.append(Student(name: studentName, average: sumOfScore/numOfSubject))
    }
    return studentArr
}

func makeContents(List: [Student]) -> String {
    let title: String = "성적결과표\n\n"
    var total: String = "전체 평균 : "
    var per: String = "개인별 학점\n"
    var complete: String = "수료생\n"
    
    let numOfStudents: Double = Double(List.count)
    
    let sortedStudentList: [Student] = (List.sorted())
    let completeList: [String] = sortedStudentList.filter{ $0.average >= 70 }.map({ (list: Student) -> String in return list.name })
    var totalScore: Double = 0.0
    
    for obj in sortedStudentList {
        let name = obj.name
        
        totalScore += obj.average
        per.append(name + "\t   : ")
        switch obj.average {
        case 90...100:
            per.append("A\n")
        case 80..<90:
            per.append("B\n")
        case 70..<80:
            per.append("C\n")
        case 60..<70:
            per.append("D\n")
        default:
            per.append("F\n")
        }
    }
    per.append("\n")
    var totalAverage: Double = totalScore / numOfStudents
    let roundedTotalAverage: Double = (totalAverage).roundToPlaces(places: 2)
    total.append("\(roundedTotalAverage)\n \n")
    var count: Int = 0
    for student in completeList {
        count += 1
        if(count == completeList.count) {
            complete.append(student)
        } else {
            complete.append(student + ", ")
        }
    }
    let contents: String = title + total + per + complete
    return contents
}

func writeResultToText(studentList: [Student]) -> Void {
    let file = "result.txt" //this is the file. we will write to and read from it
    let dir = FileManager.default.homeDirectoryForCurrentUser
    let path = dir.appendingPathComponent(file)
    let contents: String = makeContents(List: studentList)
    
    //writing
    do {
        try contents.write(to: path, atomically: false, encoding: String.Encoding.utf8)
    }
    catch { print(error) }
    
}

func run() -> Void {
    guard let parseToObject = loadJson() else {
        return
    }
    writeResultToText(studentList: parseToObject)
}

run()

