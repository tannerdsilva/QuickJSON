import Testing
import Foundation

@testable import QuickJSON


@Suite("QuickJSONTests")
struct QuickJSONTests {
	@Test("kuCoinTests")
	func kuCoinTests() throws {
		let urlpath = URL(filePath:"/Users/tannersilva/Desktop/kucoin.json")!
		let data = try! Data(contentsOf:urlpath)
		struct ResponseBody:Decodable {
			struct DataContainer:Decodable {
				struct CurrencyItem:Decodable {
					let symbol:String
					let last:String
					let volValue:String
				}
				let ticker:[CurrencyItem]
			}
		
			let code:String
			let data:DataContainer
			func toMap() -> [String:PriceVolume] {
				var buildMap = [String:PriceVolume]()
				for curPair in self.data.ticker {
					if let vol24h = Double(curPair.volValue), let lastPrice = Double(curPair.last) {
						buildMap[curPair.symbol] = PriceVolume(p:lastPrice, v:vol24h)
					}
				}
				return buildMap
			}
		}
		let response = try QuickJSON.decode(ResponseBody.self, bytes:data, size:data.count, flags:QuickJSON.Decoding.Flags())
		fatalError("\(response.data.ticker.count)")
		let map = response.toMap()
		fatalError("\(map.count)")
		#expect(map.count > 0, "map should have at least one entry")
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
