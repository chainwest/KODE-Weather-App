//
//  CLLocationCoordinate2D+ConvertCoordinate.swift

import Foundation
import MapKit

extension CLLocationCoordinate2D {
  var convertCoordinate: String? {
    var latSeconds = Int(self.latitude * 3600)
    let latDegrees = latSeconds / 3600
    latSeconds = abs(latSeconds % 3600)
    let latMinutes = latSeconds / 60
    latSeconds %= 60
    var longSeconds = Int(self.longitude * 3600)
    let longDegrees = longSeconds / 3600
    longSeconds = abs(longSeconds % 3600)
    let longMinutes = longSeconds / 60
    longSeconds %= 60
    return String(format: "%d°%d'%d\"%@ %d°%d'%d\"%@",
                  abs(latDegrees),
                  latMinutes,
                  latSeconds, latDegrees >= 0 ? "N" : "S",
                  abs(longDegrees),
                  longMinutes,
                  longSeconds,
                  longDegrees >= 0 ? "E" : "W" )
  }
}
