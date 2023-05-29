import XCTest
@testable import QuickJSON

final class QuickJSONTests: XCTestCase {
	var decoder: QuickJSON.Decoder!
	var encoder: QuickJSON.Encoder!
	struct TestModel: Codable {
		let id: Int
		let name: String
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
            let resultString = String(cString: result)

            // Then
            XCTAssertEqual(resultString, "{\"id\":1,\"name\":\"Test Name\"}")
        } catch {
            XCTFail("Encoding failed with error: \(error)")
        }
	}


}
