@echo off 
set OutDebugFile=output\jquery.carousellite.js
set OutMinFile=output\jquery.carousellite.min.js
set AllFiles=
set srcFile=..\src\jquery.carousellite.js

@rem Now call Google Closure Compiler to produce a minified version
REM copy /y version-header.js %OutMinFile%

copy %srcFile% %OutDebugFile%

tools\curl --proxy localhost:8080 -d output_info=compiled_code -d output_format=text -d compilation_level=ADVANCED_OPTIMIZATIONS --data-urlencode js_code@%OutDebugFile% "http://closure-compiler.appspot.com/compile" > %OutMinFile%.temp
type %OutMinFile%.temp > %OutMinFile%
del %OutMinFile%.temp


@rem Finalise each file by prefixing with version header and surrounding in function closure
GOTO :END
copy /y version-header.js %OutDebugFile%
echo (function(window,undefined){ >> %OutDebugFile%
type %OutDebugFile%.temp		  >> %OutDebugFile%
echo })(window);                  >> %OutDebugFile%
del %OutDebugFile%.temp

copy /y version-header.js %OutMinFile%
echo (function(window,undefined){ >> %OutMinFile%
type %OutMinFile%.temp		  	  >> %OutMinFile%
echo })(window);                  >> %OutMinFile%
del %OutMinFile%.temp

:END
@PAUSE