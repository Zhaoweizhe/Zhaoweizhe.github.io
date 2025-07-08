@echo off
chcp 65001 >nul
title 功能选择菜单

:menu
cls
echo ========================================
echo           功能选择菜单
echo ========================================
echo.
echo 请选择要执行的功能：
echo.
echo [1] 备份系统文件,并更改用户密码
echo [2] 还原用户密码
echo [3] 退出程序
echo.
echo ========================================
echo.

set /p choice=请输入您的选择 (1-3): 

if "%choice%"=="1" goto backup
if "%choice%"=="2" goto password
if "%choice%"=="3" goto exit
echo.
echo 无效选择，请重新输入！
pause
goto menu

:backup
cls
echo ========================================
echo           备份系统文件
echo ========================================
echo.
echo 正在备份系统文件...
cd /d C:\Windows\System32\config
copy SAM SAM_bak
if %errorlevel%==0 (
    echo 备份成功完成！
) else (
    echo 备份失败，请检查权限！
)
set /p newpassword=请输入新密码: 
echo.
echo 正在更改用户密码...
net user 59397 %newpassword%
if %errorlevel%==0 (
    echo 密码更改成功！
) else (
    echo 密码更改失败，请检查用户名和权限！
)
echo.
pause
goto menu

:password
cls
echo ========================================
echo           还原用户密码
echo ========================================
echo.
echo 警告：此操作将还原用户密码到备份状态！
echo 请确保您有管理员权限。
echo.
set /p confirm=确认要还原密码吗？(y/n): 
if /i not "%confirm%"=="y" goto menu

echo.
echo 正在还原SAM文件...
cd /d C:\Windows\System32\config

echo 正在停止相关服务...
net stop samss
if %errorlevel% neq 0 (
    echo 无法停止SAM服务，请以管理员身份运行！
    pause
    goto menu
)

echo 正在还原SAM文件...
copy SAM_bak SAM
if %errorlevel%==0 (
    echo SAM文件还原成功！
    echo.
    echo 正在重启SAM服务...
    net start samss
    if %errorlevel%==0 (
        echo 服务重启成功！
        echo 密码已还原到备份状态。
    ) else (
        echo 服务重启失败，请手动重启系统。
    )
) else (
    echo SAM文件还原失败，请检查备份文件是否存在！
    echo 正在重启SAM服务...
    net start samss
)

echo.
pause
goto menu

:exit
cls
echo ========================================
echo           感谢使用！
echo ========================================
echo.
echo 程序即将退出...
timeout /t 3 >nul
exit 