//
//  MBPageControlView.swift
//  MBPageControl
//
//  Created by Viorel Porumbescu on 04/08/2017.
//  Copyright © 2017 Viorel. All rights reserved.
//

import Cocoa


@IBDesignable
class MBPageControlView: NSControl {

    @IBInspectable var distanceBetweenKnobs:CGFloat = 6 {
        didSet {
            self.createPages()
        }
    }

    @IBInspectable var insetKnobHeight:CGFloat = 25 {
        didSet {
            self.createPages()
        }
    }

    // Visual properties for knobs
    @IBInspectable var circleBackgroundColor:NSColor = NSColor(white: 0.92, alpha: 1.0) {
        didSet{
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleBorderWidth:CGFloat   = 0.75 {
        didSet{
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleBorderColor:NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleSelectedColor:NSColor = NSColor(red:0.306, green:0.824, blue:0.341, alpha:1) {
        didSet{
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleSelectedBorderColor:NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleHoverBorderColor:NSColor = NSColor(white: 0.75, alpha: 1.0) {
        didSet{
            self.updateControlProperties()
        }
    }

    @IBInspectable var circleInsetPercent:CGFloat = 10 {
        didSet{
            self.updateControlProperties()
        }
    }

    //Visual properties for View
    @IBInspectable var viewBorderColor:NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet{
            updateLayerProperties()
        }
    }

    @IBInspectable var viewBorderWidth:CGFloat = 0.75 {
        didSet{
            self.updateLayerProperties()
        }
    }

    @IBInspectable var viewBackgroundColor:NSColor = NSColor.white {
        didSet {
            self.updateLayerProperties()
        }
    }

    @IBInspectable var viewCornerRadius:CGFloat = 5 {
        didSet{
            self.updateLayerProperties()
        }
    }

    //Pages
    @IBInspectable var numberOfPages:Int = 5 {
        didSet{
            self.createPages()
        }
    }
    
    @IBInspectable var selectedPage:Int = 0  {
        didSet{
            // if the user will enter an invalil number, we will make sure the  final selection is still valid.
            self.selectedPage = selectedPage % numberOfPages
        }
    }

    @IBInspectable var distributeHorizontaly:Bool = true {
        didSet{
            self.createPages()
        }
    }

    private var _pages:[MBPageControlKnobView] = []
    var indexOfSelectedItem:Int {
        get{
            for item in _pages {
                if item.currentStatus == .selected {
                    selectedPage = item.id
                    return item.id
                }
            }
            return -1
        }
        set {
            selectedPage = newValue
            for item in _pages {
                if item.id == newValue {
                    item.currentStatus = .selected
                } else {
                    item.currentStatus = .inactive
                }
            }
        }
    }

    private var _pageViewSize:NSSize {
        get {
            let inssetPercent = (100 - insetKnobHeight) / 100
            return NSMakeSize(self.bounds.height * inssetPercent, self.bounds.height * inssetPercent)
        }
    }

    private var _isEnabled:Bool = true
    override var isEnabled: Bool {
        set{
            self._isEnabled = newValue
            if newValue {
                self.alphaValue = 1.0
            } else {
                self.alphaValue = 0.7
            }
            self.updateControlProperties()

        }
        get {
            return _isEnabled
        }
    }


    override func prepareForInterfaceBuilder() {
        updateLayerProperties()
        createPages()
        updateControlProperties()
    }

    //MARK: Init
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.updateLayerProperties()
        self.updateControlProperties()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateLayerProperties()
        self.updateControlProperties()
    }

    override func awakeFromNib() {
        self.updateLayerProperties()
        self.updateControlProperties()
        self.createPages()
    }

    //MARK: Draw
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }


    //MARK: functionality
    func aKnobHasBeenSelected(_ sender:MBPageControlKnobView) {
        if self.isEnabled {
            self.selectedPage        = sender.id
            self.indexOfSelectedItem = sender.id
            if self.action != nil {
                NSApp.sendAction(self.action!, to: self.target, from: self)
            } else {
                Swift.print("Are you sure you didn't forget to connect an action to this control?")
            }
        }
    }


    //MARK: Manage ui
    private func createPages() {
        for view in self.subviews {
            view.removeFromSuperview()
        }

        var distance:CGFloat = distanceBetweenKnobs  //default distance between knobs and margins
        let yOrigin          = (self.bounds.height - self._pageViewSize.height) / 2
        var firstX:CGFloat   = 0

        if self.distributeHorizontaly {
            let allWidthControl  = _pageViewSize.width * CGFloat(numberOfPages )
            distance             = (self.bounds.width - allWidthControl) / CGFloat(numberOfPages + 1)
            firstX               = distance
            distance             = distance + _pageViewSize.width
        } else {
            let allWidthControl  = _pageViewSize.width * CGFloat(numberOfPages)  + (distance *  CGFloat(numberOfPages - 1))
            firstX               = (self.bounds.width - allWidthControl) / 2
            distance             = _pageViewSize.width + distance
        }


        for index in 0...self.numberOfPages - 1 {
            let knob = MBPageControlKnobView(frame: NSMakeRect(firstX, yOrigin, _pageViewSize.width, _pageViewSize.height))
            knob.circleBackgroundColor  = self.circleBackgroundColor
            knob.circleSelectedColor    = self.circleSelectedColor
            knob.circleBorderColor      = self.circleBorderColor
            knob.circleBorderWidth      = self.circleBorderWidth
            knob.circleHoverBorderColor = self.circleHoverBorderColor
            knob.circleInsetPercent     = self.circleInsetPercent
            knob.action                 = #selector(aKnobHasBeenSelected(_:))
            knob.target                 = self
            knob.id                     = index
            knob.isEnabled              = self.isEnabled
            knob.currentStatus          = .inactive
            if index == selectedPage {
                knob.currentStatus      = .selected
            }

            self.addSubview(knob)
            _pages.append(knob)
            firstX = firstX + distance
        }
    }

    private func updateControlProperties() {
        for item in _pages {
            item.circleBackgroundColor  = self.circleBackgroundColor
            item.circleSelectedColor    = self.circleSelectedColor
            item.circleBorderColor      = self.circleBorderColor
            item.circleBorderWidth      = self.circleBorderWidth
            item.circleHoverBorderColor = self.circleHoverBorderColor
            item.circleInsetPercent     = self.circleInsetPercent
            item.isEnabled              = self.isEnabled


        }
    }

    private func updateLayerProperties(){
        self.wantsLayer             = true
        self.layer?.backgroundColor = self.viewBackgroundColor.cgColor
        self.layer?.borderColor     = self.viewBorderColor.cgColor
        self.layer?.borderWidth     = self.viewBorderWidth
        self.layer?.cornerRadius    = self.viewCornerRadius
        self.layer?.masksToBounds   = true
    }


}




class MBPageControlKnobView:NSControl {

    enum Status {
        case hover
        case selected
        case inactive
    }



    // Visual properties for knobs
    var circleBackgroundColor:NSColor = NSColor(white: 0.92, alpha: 1.0) {
        didSet{
            self.needsDisplay = true
        }
    }

     var circleBorderWidth:CGFloat   = 0.75 {
        didSet{
            self.needsDisplay = true
        }
    }

     var circleBorderColor:NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            self.needsDisplay = true
        }
    }

     var circleSelectedColor:NSColor = NSColor(red:0.306, green:0.824, blue:0.341, alpha:1) {
        didSet{
            self.needsDisplay = true
        }
    }

     var circleSelectedBorderColor:NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            self.needsDisplay = true
        }
    }

    var circleHoverBorderColor:NSColor = NSColor.red {
        didSet{
            self.needsDisplay = true
        }
    }

    var circleInsetPercent:CGFloat = 10 {
        didSet{
            self.needsDisplay = true
        }
    }


    //properties
    var currentStatus:Status = .inactive  {
        didSet{
            self.needsDisplay = true
        }
    }
    //The id will tell the maincontroll which knob will be selected.
    var id:Int = 0



    var trackingArea:NSTrackingArea!
    override func updateTrackingAreas() {
        if trackingArea != nil {
            self.removeTrackingArea(trackingArea)
        }
        trackingArea               = NSTrackingArea(rect: self.bounds , options: [NSTrackingAreaOptions.mouseEnteredAndExited , NSTrackingAreaOptions.mouseMoved, NSTrackingAreaOptions.activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }



    //MARK: Draw
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let circle = NSBezierPath(ovalIn: dirtyRect.insetBy(dx: circleBorderWidth, dy: circleBorderWidth))
        circleBackgroundColor.set()
        circle.fill()
        circle.lineWidth  = circleBorderWidth

        switch currentStatus {
        case .inactive:
            self.isEnabled ?  circleBorderColor.set() : NSColor.disabledControlTextColor.set()
            circle.stroke()
            break
        case .hover:
            circleHoverBorderColor.set()
            circle.stroke()
            break
        case .selected:
            isEnabled ?  circleSelectedBorderColor.set() : NSColor.disabledControlTextColor.set()
            circle.stroke()

            let selection = NSBezierPath(ovalIn: dirtyRect.insetBy(dx: (dirtyRect.width / 100) * circleInsetPercent, dy: (dirtyRect.width / 100) * circleInsetPercent))
            isEnabled ? circleSelectedColor.set() : NSColor.disabledControlTextColor.set()
            selection.fill()
            break
        }
    }


    override func mouseExited(with event: NSEvent) {
        if !isEnabled {
            return
        }
        if self.currentStatus == .selected {
            return
        }
        self.currentStatus = .inactive
    }

    override func mouseEntered(with event: NSEvent) {
        if !isEnabled {
            return
        }
        if self.currentStatus == .selected {
            return
        }
        self.currentStatus = .hover
    }

    override func mouseDown(with event: NSEvent) {
        if self.action != nil {
            NSApp.sendAction(self.action!, to: self.target, from: self)
        }
//        if self.currentStatus == .selected {
//            self.currentStatus = .inactive
//        } else {
//            self.currentStatus = .selected
//        }
    }



}



