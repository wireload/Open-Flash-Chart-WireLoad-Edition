//*******************************************************************************
//	Copyright (c) 2006 Patterson Consulting, Inc
//	All rights reserved.
//
// 	Redistribution and use in source and binary forms, with or without
// 	modification, are permitted provided that the following conditions are met:
//
// 		* Redistributions of source code must retain all references to Patterson
// 		  Consulting, Danny Patterson, com.dannypatterson and dannypatterson.com.
//		* Redistributions of source code must retain the above copyright
//		  notice, this list of conditions and the following disclaimer.
//		* Redistributions in binary form must reproduce the above copyright
//		  notice, this list of conditions and the following disclaimer in the
//		  documentation and/or other materials provided with the distribution.
//		* Neither the name of the Patterson Consulting nor the names of its
//		  contributors may be used to endorse or promote products derived from
//		  this software without specific prior written permission.
//
// 	THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
// 	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// 	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// 	DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
// 	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// 	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// 	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// 	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// 	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// 	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//*******************************************************************************


package com.dannypatterson.logging {
	
	import flash.external.ExternalInterface;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;
	
	/**
	 * This class serves as a custom target for Firebug's console.
	 * It works with the logging framework in Flex.
	 * 
	 * @author Danny Patterson
	 * @version 0.1.0 2008-04-08
	 */
	public class FirebugTarget extends LineFormattedTarget {
		
		public function FirebugTarget() {
			super();
		}
	    
	    /**
	     * This is called by the logger and is where we delegate the message to
	     * the corresponding Firebug function based on the log level.
	     * 
	     * @see mx.logging.targets.LineFormattedTarget#logEvent
	     */ 
	    override public function logEvent(event:LogEvent):void {
	    	super.logEvent(event)
	    	if(ExternalInterface.available) {
	    		switch(event.level) {
	    			case LogEventLevel.DEBUG:
	    				ExternalInterface.call("console.debug", event.message);
	    				break;
	    			case LogEventLevel.ERROR:
	    			case LogEventLevel.FATAL:
	    				ExternalInterface.call("console.error", event.message);
	    				break;
	    			case LogEventLevel.INFO:
	    				ExternalInterface.call("console.info", event.message);
	    				break;
	    			case LogEventLevel.WARN:
	    				ExternalInterface.call("console.warn", event.message);
	    				break;
	    			default:
	    				ExternalInterface.call("console.log", event.message);
	    		}
			}
	    }
		
	}
}