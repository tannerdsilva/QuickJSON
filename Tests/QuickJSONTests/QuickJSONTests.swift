import Testing
import Foundation

@testable import QuickJSON


@Suite("QuickJSONTests")
struct QuickJSONTests {
	@Test("kuCoinTests")
	func kuCoinTests() throws {
		let urlpath = URL(filePath:"/Users/tannerdsilva/Desktop/exchange_service_prices.json")!
		let data = try! Data(contentsOf:urlpath)
		struct ResponseBody:Decodable {
			struct DataContainer:Decodable {
				struct CurrencyItem:Decodable {
					let symbol:String
					let last:String?
					let volValue:String?
				}
				let ticker:[CurrencyItem]
			}
		
			let code:String
			let data:DataContainer
			func toMap() -> [String:PriceVolume] {
				var buildMap = [String:PriceVolume]()
				for curPair in self.data.ticker {
					if let hasLast = curPair.last, let hasVolValue = curPair.volValue {
						if let price = Double(hasLast), let volume = Double(hasVolValue) {
							let pv = PriceVolume(p:price, v:volume)
							buildMap[curPair.symbol] = pv
						} else {
							print("Failed to parse price or volume for \(curPair.symbol) with last:\(String(describing:curPair.last)) and volValue:\(String(describing:curPair.volValue))")
						}
					}
				}
				return buildMap
			}
		}
		let response = try QuickJSON.decode(ResponseBody.self, bytes:data, size:data.count, flags:QuickJSON.Decoding.Flags())
		#expect(response.toMap().count > 0, "Response map should have more than 0 items, got \(response.toMap().count)")
	}
}

public struct PriceVolume:Sendable, Equatable, CustomDebugStringConvertible {
	public var p:Double
	public var v:Double
	public init(p:Double, v:Double) {
		self.p = p
		self.v = v
	}
	public func inverted() -> PriceVolume {
		return PriceVolume(p:(1 / p), v:((1 / p) * v))
	}
	public var debugDescription:String {
		return "PriceVolume(p:\(p), v:\(v))"
	}
}
