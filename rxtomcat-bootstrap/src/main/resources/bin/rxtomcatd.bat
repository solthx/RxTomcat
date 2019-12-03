@echo off

rem Copyright 2019 dunwoo.com - 顿悟源码
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

setlocal

rem 检查是否设置 JAVM_HOME or JRE_HOME，已经是否存在 java.exe 可执行命令
if not "%JRE_HOME%" == "" goto gotJreHome
if not "%JAVA_HOME%" == "" goto gotJavaHome
echo Neither the JAVA_HOME nor the JRE_HOME environment variable is defined
echo At least one of these environment variable is needed to run this program
goto end

rem 没找到 JRE 目录, 使用 JAVA_HOME 作为 JRE_HOME
:gotJavaHome
set "JRE_HOME=%JAVA_HOME%"

rem 检查是否存在 java.exe
:gotJreHome
if not exist "%JRE_HOME%\bin\java.exe" goto noJreHome
goto okJava

rem 至少需要一个 JRE
:noJreHome
echo The JRE_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

:okJava
set _RUNJAVA="%JRE_HOME%\bin\java.exe"

rem 设置程序执行的家目录
cd ..
set "RXTOMCAT_BASE=%cd%"

rem 检查是否存在启动脚本
if exist "%RXTOMCAT_BASE%\bin\rxtomcatd.bat" goto okHome
echo The RXTOMCAT_BASE environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

rem 设置 classpath 和 jvm 参数
:okHome

set "TMPDIR=%RXTOMCAT_BASE%\work"

set "CLASSPATH=%RXTOMCAT_BASE%\bin\bootstrap.jar"

set "MAIN_CALSS=com.dunwoo.tomcat.startup.Bootstrap"

set "LOGGING_CONFIG=%RXTOMCAT_BASE%\bin\logback.xml"

set "JAVA_OPTS=-server -Xms512M -Xmx512M"

rem 运行信息
echo Using RXTOMCAT_BASE:   "%RXTOMCAT_BASE%"
echo Using TMPDIR:          "%TMPDIR%"
echo Using JRE_HOME:        "%JRE_HOME%"
echo Using JAVA_HOME:       "%JAVA_HOME%"
echo Using CLASSPATH:       "%CLASSPATH%"
echo RxTomcat Starting ...

goto doStart

:doStart
%_RUNJAVA% %JAVA_OPTS% -classpath "%CLASSPATH%" -Dlogback.configurationFile="%LOGGING_CONFIG%" -Drxtomcat.base="%RXTOMCAT_BASE%" -Djava.io.tmpdir="%TMPDIR%" %MAIN_CALSS%

pause
goto end

:end

pause