//
//  POErrorAlertLog.m
//  pyOsiriX
//

/*
 Copyright (c) 2016, The Institute of Cancer Research and The Royal Marsden.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the copyright holder nor the names of its contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "POErrorAlertLog.h"

@implementation POErrorAlertLog

+ (NSInteger)alertWithMessageText:(NSString *)message :(NSString *)firstButton :(NSString *)secondButton :(NSString *)thirdButton :(NSString *)informativeTextWithFormat, ...
{
	NSAlert *alert = [[NSAlert alloc] init];
	if (message)
		[alert setMessageText:message];
	if (firstButton)
		[alert addButtonWithTitle:firstButton];
	if (secondButton)
		[alert addButtonWithTitle:secondButton];
	if (thirdButton)
		[alert addButtonWithTitle:thirdButton];
	if (informativeTextWithFormat)
	{
		va_list args;
		va_start(args, informativeTextWithFormat);
		NSString *infText = [[NSString alloc] initWithFormat:informativeTextWithFormat arguments:args];
		[alert setInformativeText:infText];
		[infText release];
		va_end(args);
	}
	[alert setAlertStyle:NSWarningAlertStyle];
	
	NSInteger response = (NSInteger)[alert runModal];
	[alert release];
	return response;
}

+ (PyObject *) newErrorAlertLog
{
    POErrorAlertLog *new = [[POErrorAlertLog alloc] init];
    PyObject *log =  [pyLog pythonObjectWithInstance:new];
    [new release];
    return log; //log is now the keeper of this object.  When Py_DECREF'd it will be deleted.
}

- (void) alertError
{
	[POErrorAlertLog alertWithMessageText:@"Python Error" :@"OK" :nil :nil :stringBin];
    [stringBin release];
    stringBin = nil;
}

- (void) logAppendString:(NSString *)str
{
    if (!stringBin) {
        stringBin = [[NSMutableString alloc] init];
    }
    if ([str isEqualToString:@"\n"])
        [self alertError];
    else
        [stringBin appendString:str];
}

@end
