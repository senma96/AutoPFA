@echo off
chcp 65001 >nul
echo ========================================
echo 修复库文件名称映射
echo ========================================

REM 设置 Libd 目录路径（根据你的实际路径修改）
set LIBD_DIR=C:\Users\code\PFA\AutoPFA_clone\Libd
set LIBD_DIR2=C:\Users\code\PFA\AutoPFA_clone\AutoPFA\Libd

echo.
echo 检查并创建目录...
if not exist "%LIBD_DIR%" mkdir "%LIBD_DIR%"

echo.
echo 从 AutoPFA\Libd 复制到 Libd...

REM 复制所有 lib 文件到根目录的 Libd
if exist "%LIBD_DIR2%\*.lib" copy /Y "%LIBD_DIR2%\*.lib" "%LIBD_DIR%\" >nul 2>&1
if exist "%LIBD_DIR2%\*.dll" copy /Y "%LIBD_DIR2%\*.dll" "%LIBD_DIR%\" >nul 2>&1
if exist "%LIBD_DIR2%\*.exp" copy /Y "%LIBD_DIR2%\*.exp" "%LIBD_DIR%\" >nul 2>&1

echo.
echo 创建库文件名映射...

cd /d "%LIBD_DIR%"

REM APQuantity 映射
if exist "APQuantity.lib" (
    if not exist "APQuantityd.lib" copy /Y "APQuantity.lib" "APQuantityd.lib" >nul
    if not exist "APQuantity10d.lib" copy /Y "APQuantity.lib" "APQuantity10d.lib" >nul
    if not exist "APQuantity10.lib" copy /Y "APQuantity.lib" "APQuantity10.lib" >nul
    echo   APQuantity.lib -^> APQuantityd.lib, APQuantity10d.lib
)
if exist "APQuantityd.lib" (
    if not exist "APQuantity10d.lib" copy /Y "APQuantityd.lib" "APQuantity10d.lib" >nul
    echo   APQuantityd.lib -^> APQuantity10d.lib
)

REM AFTDriver 映射
if exist "AFTDriver.lib" (
    if not exist "AFTDriverd.lib" copy /Y "AFTDriver.lib" "AFTDriverd.lib" >nul
    echo   AFTDriver.lib -^> AFTDriverd.lib
)
if exist "AFTDriverd.lib" (
    if not exist "AFTDriver.lib" copy /Y "AFTDriverd.lib" "AFTDriver.lib" >nul
    echo   AFTDriverd.lib exists
)

REM AFTInterface 映射
if exist "AFTInterface.lib" (
    if not exist "AFTInterfaced.lib" copy /Y "AFTInterface.lib" "AFTInterfaced.lib" >nul
    echo   AFTInterface.lib -^> AFTInterfaced.lib
)
if exist "AFTInterfaced.lib" (
    if not exist "AFTInterface.lib" copy /Y "AFTInterfaced.lib" "AFTInterface.lib" >nul
    echo   AFTInterfaced.lib exists
)

REM UnitSystem 映射
if exist "UnitSystem.lib" (
    if not exist "UnitSystemd.lib" copy /Y "UnitSystem.lib" "UnitSystemd.lib" >nul
    echo   UnitSystem.lib -^> UnitSystemd.lib
)
if exist "UnitSystemd.lib" (
    if not exist "UnitSystem.lib" copy /Y "UnitSystemd.lib" "UnitSystem.lib" >nul
    echo   UnitSystemd.lib exists
)

REM Persistent 映射
if exist "Persistent.lib" (
    if not exist "Persistentd.lib" copy /Y "Persistent.lib" "Persistentd.lib" >nul
    echo   Persistent.lib -^> Persistentd.lib
)
if exist "Persistentd.lib" (
    if not exist "Persistent.lib" copy /Y "Persistentd.lib" "Persistent.lib" >nul
    echo   Persistentd.lib exists
)

REM DataSource 映射
if exist "DataSource.lib" (
    if not exist "DataSourced.lib" copy /Y "DataSource.lib" "DataSourced.lib" >nul
    echo   DataSource.lib -^> DataSourced.lib
)

REM CalcInterface 映射
if exist "CalcInterface.lib" (
    if not exist "CalcInterfaced.lib" copy /Y "CalcInterface.lib" "CalcInterfaced.lib" >nul
    echo   CalcInterface.lib -^> CalcInterfaced.lib
)

REM PCFInterface 映射
if exist "PCFInterface.lib" (
    if not exist "PCFInterfaced.lib" copy /Y "PCFInterface.lib" "PCFInterfaced.lib" >nul
    echo   PCFInterface.lib -^> PCFInterfaced.lib
)

REM InterfaceMgr 映射
if exist "InterfaceMgr.lib" (
    if not exist "InterfaceMgrd.lib" copy /Y "InterfaceMgr.lib" "InterfaceMgrd.lib" >nul
    echo   InterfaceMgr.lib -^> InterfaceMgrd.lib
)

REM PFAResult 映射
if exist "PFAResult.lib" (
    if not exist "PFAResultd.lib" copy /Y "PFAResult.lib" "PFAResultd.lib" >nul
    echo   PFAResult.lib -^> PFAResultd.lib
)

REM CalcDriver 映射
if exist "CalcDriver.lib" (
    if not exist "CalcDriverd.lib" copy /Y "CalcDriver.lib" "CalcDriverd.lib" >nul
    echo   CalcDriver.lib -^> CalcDriverd.lib
)

REM ImpulseDriver 映射
if exist "ImpulseDriver.lib" (
    if not exist "ImpulseDriverd.lib" copy /Y "ImpulseDriver.lib" "ImpulseDriverd.lib" >nul
    echo   ImpulseDriver.lib -^> ImpulseDriverd.lib
)

REM PCFDriver 映射
if exist "PCFDriver.lib" (
    if not exist "PCFDriverd.lib" copy /Y "PCFDriver.lib" "PCFDriverd.lib" >nul
    echo   PCFDriver.lib -^> PCFDriverd.lib
)

REM DBTableDriver 映射
if exist "DBTableDriver.lib" (
    if not exist "DBTableDriverd.lib" copy /Y "DBTableDriver.lib" "DBTableDriverd.lib" >nul
    echo   DBTableDriver.lib -^> DBTableDriverd.lib
)

REM MocCalc/MOCCacl 映射
if exist "MOCCacl.lib" (
    if not exist "MOCCacld.lib" copy /Y "MOCCacl.lib" "MOCCacld.lib" >nul
    if not exist "MocCalc.lib" copy /Y "MOCCacl.lib" "MocCalc.lib" >nul
    if not exist "MocCalcd.lib" copy /Y "MOCCacl.lib" "MocCalcd.lib" >nul
    echo   MOCCacl.lib -^> MOCCacld.lib, MocCalc.lib
)

REM USChart 映射
if exist "USChart.lib" (
    if not exist "USChartd.lib" copy /Y "USChart.lib" "USChartd.lib" >nul
    echo   USChart.lib -^> USChartd.lib
)

echo.
echo ========================================
echo 完成！
echo ========================================
echo.
echo 现有库文件:
dir /b *.lib 2>nul
echo.
pause

