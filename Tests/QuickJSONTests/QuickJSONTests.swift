import XCTest
@testable import QuickJSON

final class QuickJSONTests: XCTestCase {
	var decoder: QuickJSON.Decoder!
	var encoder: QuickJSON.Encoder!
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
		decoder = QuickJSON.Decoder()
		encoder = QuickJSON.Encoder()
	}

	override func tearDown() {
		decoder = nil
		encoder = nil
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
			let result = try decoder.decode(TestModel.self, from: Array(jsonData))
			
			// Then
			XCTAssertEqual(result.id, 1)
			XCTAssertEqual(result.name, "Test Name")
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
			let _ = try decoder.decode(TestModel.self, from: Array(jsonData))
			
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
            let result = try encoder.encode(testData)
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
			let result = try decoder.decode([TestModel].self, from: Array(jsonArrayData))

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
			let result = try encoder.encode([TestModel(id: 4, name: "Test Name 4"), TestModel(id: 5, name: "Test Name 5")])
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
            let encodedData = try encoder.encode(testData)
            let decodedData = try decoder.decode(UnkeyedInKeyedObj.self, from: Array(encodedData))
            
            XCTAssertEqual(decodedData.id, testData.id)
            XCTAssertEqual(decodedData.arr, testData.arr)
        } catch {
            XCTFail("Encoding and decoding with keyed container holding unkeyed container failed with error: \(error)")
        }
    }
}
