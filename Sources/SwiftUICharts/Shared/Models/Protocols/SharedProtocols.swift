//
//  SharedProtocols.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//
 
import SwiftUI


// MARK: Chart Data
/**
 Main protocol for passing data around library.
 
 All Chart Data models ultimately conform to this.
 */
public protocol CTChartData: ObservableObject, Identifiable {
    
    /// A type representing a  data set. -- `CTDataSetProtocol`
    associatedtype Set      : CTDataSetProtocol
    
    /// A type representing a data point. -- `CTChartDataPoint`
    associatedtype DataPoint: CTChartDataPoint
    
    /// A type representing the chart style. -- `CTChartStyle`
    associatedtype CTStyle  : CTChartStyle
    
    /// A type representing opaque View
    associatedtype Touch    : View
    
    var id: ID { get }
    
    /**
     Data model containing datapoints and styling information.
    */
    var dataSets: Set { get set }
    
    /**
     Data model containing the charts Title, Subtitle and the Title for Legend.
    */
    var metadata: ChartMetadata { get set }
    
    /**
     Array of `LegendData` to populate the charts legend.

     This is populated automatically from within each view.
    */
    var legends: [LegendData] { get set }
    
    /**
     Data model pass data from `TouchOverlay` ViewModifier to
     `HeaderBox` or `InfoBox` for display.
    */
    var infoView: InfoViewData<DataPoint> { get set }
    
    /**
     Data model conatining the style data for the chart.
     */
    var chartStyle: CTStyle { get set }
    
    /**
     Customisable `Text` to display when where is not enough data to draw the chart.
    */
    var noDataText: Text { get set }
    
    /**
     Holds data about the charts type.
     
     Allows for internal logic based on the type of chart.
     
     This might get removed in favour of a more protocol based approach.
    */
    var chartType: (chartType: ChartType, dataSetType: DataSetType) { get }
    

    /**
     Returns whether there are two or more data points.
     */
    func isGreaterThanTwo() -> Bool

    // MARK: Touch
    /**
     Takes in the required data to set up all the touch interactions.
     
     Output via `getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch`
     
     - Parameters:
       - touchLocation: Current location of the touch
       - chartSize: The size of the chart view as the parent view.
     */
    func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)
    
    /**
     Takes touch location and return a view based on the chart type and configuration.
     
     Inputs from `setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)`
     
     - Parameters:
       - touchLocation: Current location of the touch
       - chartSize: The size of the chart view as the parent view.
     - Returns: The relevent view for the chart type and options.
     */
    func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch
    
}



// MARK: - Touch Protocol
public protocol TouchProtocol {
    
    /// A type representing a  data set. -- `CTDataSetProtocol`
    associatedtype SetPoint : CTDataSetProtocol
    
    /**
    Gets the nearest data points to the touch location.
    - Parameters:
      - touchLocation: Current location of the touch.
      - chartSize: The size of the chart view as the parent view.
    - Returns: Array of data points.
    */
    func getDataPoint(touchLocation: CGPoint, chartSize: CGRect)
    
    /**
    Gets the location of the data point in the view.
    - Parameters:
      - dataSet: Data set to work with.
      - touchLocation: Current location of the touch.
      - chartSize: The size of the chart view as the parent view.
    - Returns: Array of points with the location on screen of data points.
    */
    func getPointLocation(dataSet: SetPoint, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint?
}


// MARK: - Legend Protocol
/**
 Protocol for dealing with legend data internally.
 */
internal protocol LegendProtocol {
    
    /**
    Sets the order the Legends are layed out in.
     - Returns: Ordered array of Legends.
    */
    func legendOrder() -> [LegendData]
    
    /**
     Configures the legends based on the type of chart.
     */
    func setupLegends()
}




// MARK: - Data Sets
/**
 Main protocol to set conformace for types of Data Sets.
 */
public protocol CTDataSetProtocol: Hashable, Identifiable {
    var id : ID { get }
}

/**
 Protocol for data sets that only require a single set of data .
 */
public protocol CTSingleDataSetProtocol: CTDataSetProtocol {
    /// A type representing a data point. -- `CTChartDataPoint`
    associatedtype DataPoint : CTChartDataPoint
    
    /**
     Array of data points.
     */
    var dataPoints  : [DataPoint] { get set }

}

/**
 Protocol for data sets that require a multiple sets of data .
 */
public protocol CTMultiDataSetProtocol: CTDataSetProtocol {
    /// A type representing a single data set -- `SingleDataSet`
    associatedtype DataSet : CTSingleDataSetProtocol
    
    /**
     Array of single data sets.
     */
    var dataSets : [DataSet] { get set }
}

// MARK: - Data Points
/**
 Protocol to set base configuration for data points.
 */
public protocol CTChartDataPoint: Hashable, Identifiable {
    
    var id               : ID { get }
    
    /**
     Value of the data point
     */
    var value            : Double { get set }
    
    /**
     A label that can be displayed on touch input
    
     It can eight be displayed in a floating box that tracks the users input location
     or placed in the header.
    */
    var pointDescription : String? { get set }
    
    /**
     Date can be used for optionally performing additional calculations.
     */
    var date             : Date? { get set }
    
}

// MARK: - Styles
/**
 Protocol to set the styling data for the chart.
 */
public protocol CTChartStyle {
    
    /**
     Placement of the information box that appears on touch input.
     */
    var infoBoxPlacement        : InfoBoxPlacement { get set }
    
    /**
     Colour of the value part of the touch info.
     */
    var infoBoxValueColour      : Color { get set }
    
    /**
     Colour of the description part of the touch info.
     */
    var infoBoxDescriptionColour : Color { get set }
    
    /**
     Global control of animations.
         
     ```
     Animation.linear(duration: 1)
     ```
     */
    var globalAnimation  : Animation { get set }
}


/**
 A protocol to set colour styling.
 
 Allows for single colour, gradient or gradient with stops control.
 */
public protocol CTColourStyle {
    
    /**
     Selection for the style of colour.
     */
    var colourType: ColourType { get set }
    
    /// Single Colour
    var colour: Color? { get set }
    
    /// Array of colours for gradient
    var colours: [Color]? { get set }
    
    /**
     Array of Gradient Stops.
     
     `GradientStop` is a Hashable version of Gradient.Stop
     */
    var stops: [GradientStop]? { get set }
    
    /// Start point for the gradient
    var startPoint: UnitPoint? { get set }
    
    /// End point for the gradient
    var endPoint: UnitPoint? { get set }
}
