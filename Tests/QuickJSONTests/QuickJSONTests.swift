import XCTest
@testable import QuickJSON
import Logging

struct MyCodingKey:CodingKey {
	var stringValue:String
	init?(stringValue:String) {
		self.stringValue = stringValue
	}
	var intValue:Int? {
		return nil
	}
	init?(intValue:Int) {
		return nil
	}
}

final class QuickJSONTests: XCTestCase {
	struct TestModel: Codable {
		let id: Int
		let name: String
	}
	struct UnkeyedInKeyedObj: Codable {
        let id: String
        let arr: [String]
    }
	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testDecoderWithValidData() {
		// Given
		let jsonData = """
		{
			"id": 1,
			"name": "Test Name"
		}
		""".data(using: .utf8)!
		
		// When
		do {
			let result = try QuickJSON.decode(TestModel.self, from: Array(jsonData), size:jsonData.count)
			
			// Then
			XCTAssertEqual(result.id, 1)
			XCTAssertEqual(result.name, "Test Name")
		} catch {
			XCTFail("Decoding failed with error: \(error)")
		}
	}

	func testDecodeAllKeys() {
		var randomNumbers = Set<UInt64>()
		for _ in 0..<5 {
			randomNumbers.insert(UInt64.random(in: 0..<UInt64.max))
		}
		let jsonData = Set(randomNumbers.compactMap({ "#\($0)" }))
		var buildData = [String:String]()
		for dat in jsonData {
			buildData[dat] = "testing"
		}

		do {
			let encodedDat = try QuickJSON.encode(buildData)
			let getKeys = try QuickJSON.decode(bytes:encodedDat) { decoder in
				let keyedContainer = try decoder.container(keyedBy: MyCodingKey.self)
				return Set(keyedContainer.allKeys.compactMap( { $0.stringValue } ))
			}
			XCTAssertEqual(jsonData, getKeys)
		} catch {
			XCTFail("Decoding failed with error: \(error)")
		}
	}

	func testDecoderWithInvalidData() {
		// Given
		let jsonData = """
		{
			"id": "one",
			"name": "Test Name"
		}
		""".data(using: .utf8)!
		
		// When
		do {
			let _ = try QuickJSON.decode(TestModel.self, from: Array(jsonData), size:jsonData.count)
			
			// Then
			XCTFail("Decoding should not be successful for invalid data")
		} catch {
			// Decoding is expected to throw an error for invalid data. Test succeeds in this case.
		}
	}	

	
    func testEncoderWithValidData() {
        // Given
        let testData = TestModel(id: 1, name: "Test Name")
        
        // When
        do {
            let result = try QuickJSON.encode(testData)
            let resultString = String(bytes: result, encoding: .utf8)

            // Then
            XCTAssertEqual(resultString, "{\"id\":1,\"name\":\"Test Name\"}")
        } catch {
            XCTFail("Encoding failed with error: \(error)")
        }
	}

	func testArrayEncodingAndDecoding() {
		// Given
		let jsonArrayData = """
			[
				{"id": 1, "name": "Test Name 1"},
				{"id": 2, "name": "Test Name 2"},
				{"id": 3, "name": "Test Name 3"}
			]
		""".data(using: .utf8)!

		// When
		do {
			let result = try QuickJSON.decode([TestModel].self, from: Array(jsonArrayData), size:jsonArrayData.count)

			// Then
			XCTAssertEqual(result.count, 3)
			XCTAssertEqual(result[0].id, 1)
			XCTAssertEqual(result[0].name, "Test Name 1")
			XCTAssertEqual(result[1].id, 2)
			XCTAssertEqual(result[1].name, "Test Name 2")
			XCTAssertEqual(result[2].id, 3)
			XCTAssertEqual(result[2].name, "Test Name 3")
		} catch {
			XCTFail("Decoding failed with error: \(error)")
		}

		// When
		do {
			let result = try QuickJSON.encode([TestModel(id: 4, name: "Test Name 4"), TestModel(id: 5, name: "Test Name 5")])
			let resultString = String(bytes: result, encoding: .utf8)

			// Then
			XCTAssertEqual(resultString, "[{\"id\":4,\"name\":\"Test Name 4\"},{\"id\":5,\"name\":\"Test Name 5\"}]")
		} catch {
			XCTFail("Encoding failed with error: \(error)")
		}
	}

	 func testEncodingAndDecodingWithKeyedContainerHoldingUnkeyedContainer() {
        let testData = UnkeyedInKeyedObj(id: "123", arr: ["A", "B", "C"])
        
        do {
            let encodedData = try QuickJSON.encode(testData)
            let decodedData = try QuickJSON.decode(UnkeyedInKeyedObj.self, from: Array(encodedData), size:encodedData.count)
            
            XCTAssertEqual(decodedData.id, testData.id)
            XCTAssertEqual(decodedData.arr, testData.arr)
        } catch {
            XCTFail("Encoding and decoding with keyed container holding unkeyed container failed with error: \(error)")
        }
    }
}
