@echo off
chcp 65001 >nul
echo Updating File from modpack [Buffz & Neftz] JSON...
echo.

:: ==============================================================
:: PHAN 1: CAP NHAT FILE PLANTPROPS.JSON
:: ==============================================================
echo [1/2] Replacing [Gatling Pea, Mega Gatling Pea] in PlantProps.json...

:: Tao file script PowerShell tam thoi de xu ly logic an toan
set "ps_script=%temp%\update_plants.ps1"
> "%ps_script%" echo $files = Get-ChildItem -Path '.' -Filter '*PlantProps*.json' -Recurse
>> "%ps_script%" echo foreach ($f in $files) {
>> "%ps_script%" echo     $lines = Get-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo     $inMega = $false
>> "%ps_script%" echo     $inGatling3 = $false
>> "%ps_script%" echo     for ($i = 0; $i -lt $lines.Count; $i++) {
>> "%ps_script%" echo         # Reset bien kiem tra moi khi bat dau mot object moi de tranh bat nham
>> "%ps_script%" echo         if ($lines[$i] -match '"objclass"') { $inMega = $false; $inGatling3 = $false }
>> "%ps_script%" echo         if ($lines[$i] -match '"megagatling"') { $inMega = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"gatling_lvl3"') { $inGatling3 = $true }
>> "%ps_script%" echo         # Xu ly rieng cho megagatling
>> "%ps_script%" echo         if ($inMega) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaType"\s*:\s*"cactus1"', '"PeaType": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaTypePlantfood"\s*:\s*"cactus1"', '"PeaTypePlantfood": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PlantfoodPeaCount"\s*:\s*100', '"PlantfoodPeaCount": 150'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*25', '"Cooldown": 5'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"ShootInterval"\s*:\s*1.5', '"ShootInterval": 1.35'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*525', '"SunCost": 450'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Family"\s*:\s*"None"', '"Family": "Peashooter"'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho gatling_lvl3
>> "%ps_script%" echo         if ($inGatling3) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaType"\s*:\s*"gatlingpea"', '"PeaType": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaTypePlantfood"\s*:\s*"gatlingpea"', '"PeaTypePlantfood": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*20', '"Cooldown": 15'
>> "%ps_script%" echo         }
>> "%ps_script%" echo     }
>> "%ps_script%" echo     $lines ^| Set-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo }

:: Thuc thi script PowerShell roi xoa file tam
powershell -ExecutionPolicy Bypass -File "%ps_script%"
del "%ps_script%"

echo Done replacing [Gatling Pea, Mega Gatling Pea] in PlantProps.json...
echo.

:: ==============================================================
:: PHAN 2: CAP NHAT FILE PLANT-LEVELS.JSON
:: ==============================================================
echo [2/2] Replacing "TIER *" in plant-levels.json...
powershell -Command "Get-ChildItem -Path '.' -Filter '*plant-levels*.json' -Recurse | ForEach-Object { $file = $_.FullName; (Get-Content $file -Raw -Encoding UTF8) -replace 'TIER ', '' | Set-Content $file -Encoding UTF8 }"
echo Done replacing "TIER *" in plant-levels.json!
echo.

echo Done Replacing PVZ 2 GE Mod!
pause