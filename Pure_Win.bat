@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 3f

cd /d "%~dp0"
set "path=%~dp0Bin;!path!"

title ��׿�Զ�����ű� by ViNew
echo =================================================
echo   ................................
echo   ..._.._..__..__._..____.._.._...
echo   ../.)(.\(..)(..(.\(..__)/.)(.\..
echo   ..\.\/./.)(./..../.)._).\./\./..
echo   ...\__/.(__)\_)__)(____)(_/\_)..
echo   ................................
echo.
echo   һ���Զ�����׿ϵͳ��
echo   * �Զ�ʶ��׿ϵͳAPP������
echo   * ������֧�����л��͸���ROM��
echo   * �Զ���װadb������
echo   * ����root,���ؽ�BL����
echo   * OTA���º󾫼���Ȼ��Ч��������ִ�нű���
echo   * �������޸�purelist.txt�����б�
echo   * ɾ��APP���߾��������ˣ�˫�弴�ɻָ���
echo.
echo =================================================

set "UseAdb=1"
echo.
pause
echo =================================================
echo   ��黷��
echo.

:CHECK_ENV

if "!UseAdb!"=="1" (
	for /f "tokens=*" %%t in ('adb get-state') do set "adbState=%%t"
	echo.
	echo   Adb״̬: !adbState!
	if not "!adbState!"=="device" (
		echo.
		echo   ���԰�װadb����
		call "InstallUsbDriver.cmd"

		adb kill-server
		ping -n 2 127.0.0.1 >nul
		
		for /f "tokens=*" %%t in ('adb get-state') do set "adbState=%%t"
		echo.
		echo   Adb״̬: !adbState!
		if not "!adbState!"=="device" (
			echo.
			echo   �޷�����adb����ȷ����
			echo.
			echo   * ���ֻ�����USB��
			echo.
			pause
			goto :CHECK_ENV
		)
	)
)

echo.
echo =================================================
echo   ����Ŀ¼
echo.

if "!UseAdb!"=="1" (
	FastCopy /cmd=delete /no_ui "output" "Bin/FastCopy.log" "Bin/FastCopy2.ini"
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   ��ȡ������APP����
	echo.

	if not exist "output" md "output"
		cd "output"
		adb shell pm list packages -3 >> otherapp.txt
		if errorlevel 1 echo   ��ȡ������APP����ʧ�� & pause & exit /b
		cd "%~dp0"
	)
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   ��ȡ����APP����
	echo.
		cd "output"
		adb shell pm list packages -s -f >> systemapp.txt
		cd "%~dp0"
		for /f "delims=""" %%i in ('type "purelist.txt"') do (
	 	type "output\systemapp.txt"|findstr /i "%%i" >> output\pureapp.tmp
		)
		cd "output"
		cd.>pureapp.txt
		for /f "delims=" %%i in (pureapp.tmp) do (
		find /i "%%i" pureapp.txt||echo %%i>>pureapp.txt
		)
		FastCopy /cmd=delete /no_ui "pureapp.tmp"
		if errorlevel 1 echo   ��ȡ����APP����ʧ�� & pause & exit /b
		cd "%~dp0"	
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   ���ɾ���ű�
	echo.
		pause
		cd "output"
		for /f "delims=" %%i in ("pureapp.txt") do (
		if %%~zi lss 2 (
		echo.
		echo   �����б��в�����δ������APP
		echo.
		echo   �밴������˳�
		pause >nul
		exit /b
		)
		)
		type otherapp.txt pureapp.txt >> PureOS.bat
		if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
   			sed_x86 -i 's/.*=/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' PureOS.bat
			sed_x86 -i 's/package:/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' PureOS.bat
		) else (
    		sed_x64 -i "s/.*=/adb\ shell\ pm\ uninstall\ --user\ 0\ /g" PureOS.bat
			sed_x64 -i "s/package:/adb\ shell\ pm\ uninstall\ --user\ 0\ /g" PureOS.bat
		)
		if errorlevel 1 echo   ���ɾ���ű�ʧ�� & pause & exit /b
		cls
		cd "%~dp0"
)

if not exist "output\PureOS.bat" (
	echo.
	echo   �Ҳ�������ű����޷�������
	echo.
	echo   �밴������˳�
	pause >nul
	exit /b
)

echo.
echo =================================================
echo   ִ�о���ű�
echo.
		cd "output"
		call PureOS.bat
		if errorlevel 1 echo   ִ�о���ű�ʧ�� & pause & exit /b
		cd "%~dp0"


echo.
echo =================================================
echo   ����Ŀ¼
echo.

if "!UseAdb!"=="1" (
	FastCopy /cmd=delete /no_ui "output" "Bin/FastCopy.log" "Bin/FastCopy2.ini"
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   �������
	echo.
	echo   ��ӭ�����ҵĲ��� https://vinew.cc
	echo.
	pause
) 

goto :EOF
endlocal
pause