@echo off
chcp 65001 >nul
echo Updating File from modpack [Buffz & Neftz] JSON...
echo.

:: ==============================================================
:: BUOC KHOI DAU: XOA PLANTPROPS TRONG SENTRY'S QOL
:: ==============================================================
echo [0/3] Deleting PlantProps.json trong Sentry's QOL...
if exist "packs\Sentry's QOL\jsons\objects\PlantProps.json" (
    del /f /q "packs\Sentry's QOL\jsons\objects\PlantProps.json"
    echo Deleted: Da xoa file PlantProps.json trong Sentry's QOL!
) else (
    echo Not Delete: File PlantProps.json in Folder Sentry's QOL! not found
)
echo.

:: ==============================================================
:: PHAN 1: CAP NHAT FILE PLANTPROPS.JSON
:: ==============================================================
echo [1/3] Replacing [Gatling Pea, Mega Gatling Pea] in PlantProps.json...

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
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PlantfoodPeaCount"\s*:\s*100', '"PlantfoodPeaCount": 125'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*25', '"Cooldown": 5'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"ShootInterval"\s*:\s*1.5', '"ShootInterval": 1.35'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*525', '"SunCost": 450'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"ChanceToPlantfood"\s*:\s*0', '"ChanceToPlantfood": 0.05'
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

:: ==============================================================
:: BUOC 2: CAP NHAT TY LE DAN TRONG PROJECTILETYPES.JSON
:: ==============================================================
echo [2/3] Changing Rate for Mega Gatling Pea in ProjectileTypes.json...

>> "%ps_script%" echo $projFiles = Get-ChildItem -Path '.' -Filter '*ProjectileType*.json' -Recurse
>> "%ps_script%" echo foreach ($f in $projFiles) {
>> "%ps_script%" echo     $lines = Get-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo     $inCactus1 = $false; $nextWeight = $null
>> "%ps_script%" echo     for ($i = 0; $i -lt $lines.Count; $i++) {
>> "%ps_script%" echo         if ($lines[$i] -match '"objclass"') { $inCactus1 = $false; $nextWeight = $null }
>> "%ps_script%" echo         if ($lines[$i] -match '"cactus1"') { $inCactus1 = $true }
>> "%ps_script%" echo         if ($inCactus1) {
>> "%ps_script%" echo             if ($lines[$i] -match '"Type"\s*:\s*"pea_flame_yellow"') { $nextWeight = 'yellow' }
>> "%ps_script%" echo             elseif ($lines[$i] -match '"Type"\s*:\s*"pea_flame_blue"') { $nextWeight = 'blue' }
>> "%ps_script%" echo             elseif ($lines[$i] -match '"Type"\s*:\s*"pea"\s*,?\s*$') { $nextWeight = 'pea' }
>> "%ps_script%" echo             if ($lines[$i] -match '"Weight"') {
>> "%ps_script%" echo                 if ($nextWeight -eq 'yellow') { $lines[$i] = $lines[$i] -replace '"Weight"\s*:\s*\d+(\.\d+)?', '"Weight": 15'; $nextWeight = $null }
>> "%ps_script%" echo                 elseif ($nextWeight -eq 'blue') { $lines[$i] = $lines[$i] -replace '"Weight"\s*:\s*\d+(\.\d+)?', '"Weight": 15'; $nextWeight = $null }
>> "%ps_script%" echo                 elseif ($nextWeight -eq 'pea') { $lines[$i] = $lines[$i] -replace '"Weight"\s*:\s*\d+(\.\d+)?', '"Weight": 75'; $nextWeight = $null }
>> "%ps_script%" echo             }
>> "%ps_script%" echo         }
>> "%ps_script%" echo     }
>> "%ps_script%" echo     $lines ^| Set-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo }

:: Thuc thi script PowerShell roi xoa file tam
powershell -ExecutionPolicy Bypass -File "%ps_script%"
del "%ps_script%"

echo Done replacing [Gatling Pea, Mega Gatling Pea] in PlantProps.json and changing rate of Pea in ProjectileTypes.json...
echo.

:: ==============================================================
:: PHAN 3: CAP NHAT FILE PLANT-LEVELS.JSON
:: ==============================================================
echo [3/3] Replacing "TIER *" to "LVL *" in plant-levels.json...
powershell -Command "Get-ChildItem -Path '.' -Filter '*plant-levels*.json' -Recurse | ForEach-Object { $file = $_.FullName; (Get-Content $file -Raw -Encoding UTF8) -replace 'TIER V', 'LVL 5' -replace 'TIER IV', 'LVL 4' -replace 'TIER III', 'LVL 3' -replace 'TIER II', 'LVL 2' -replace 'TIER I', 'LVL 1' | Set-Content $file -Encoding UTF8 }"
echo Hoan thanh cap nhat plant-levels.json!
echo.

echo Done Replacing PVZ 2 GE Mod!
pause