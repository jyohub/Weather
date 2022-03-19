//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by jyohub on 2022/03/12.
//

import XCTest
@testable import Weather

class WeatherServiceTests: XCTestCase {

    var sut: WeatherServiceProtocol!
    
    override func setUp() {
        super.setUp()
        sut = WeatherService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testSuccessfulWeatherResponse() throws {
        _ = URLSession(mockResponder: WeatherDataSuccesfulResponder.self)
        let publisher = sut.fetchWeatherData(latitude: -122.08, longitude: 37.39)
        let weather = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(weather.count, 1)
        XCTAssertEqual(weather[0].place, "Mountain View")
        XCTAssertEqual(weather[0].country, "US")
        XCTAssertEqual(weather[0].icon, "01d")
        XCTAssertEqual(weather[0].description, "clear sky")
        XCTAssertEqual(weather[0].temperature, 282.55)
        XCTAssertEqual(weather[0].time, Date.init(timeIntervalSinceReferenceDate: 1560350645))
    }

}

class WeatherDataSuccesfulResponder: MockURLResponder {
    
    static func respond(to request: URLRequest) throws -> Data {
        return try mockDataWith(fileName: "weatherSuccessResponse")
    }
    
    static func mockDataWith(fileName : String) throws -> Data {
        let bundle = Bundle(for: WeatherDataSuccesfulResponder.self)
        guard let pathString = bundle.path(forResource: fileName, ofType: "json") else {
            print("\(fileName).json not found")
            return Data()
        }
        let encoding = String.Encoding.utf8.rawValue
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: encoding) else {
            print("Unable to convert \(fileName).json to String")
            return Data()
        }
        print("The JSON string is: \(jsonString)")
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            print("Unable to convert \(fileName).json to NSData")
            return Data()
        }
        return jsonData
    }
}


