//
//  sampleScript.swift
//  ScriptManager for Mac
//
//  Created by Jason Jeon on 3/12/22.
//

import Cocoa
import Combine
import Carbon
class SampleScript
{
var script: NSAppleScript = {
    let script = NSAppleScript(source: """
        
        on displayMessage(message)
            
            tell application "System Events"
              
                tell appearance preferences
              
                    set dark mode to not dark mode

                end tell

            end tell
        end displayMessage
        """
    )!
    let success = script.compileAndReturnError(nil)
    assert(success)
    return script
}()
}
