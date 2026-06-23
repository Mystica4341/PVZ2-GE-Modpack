@echo off
chcp 65001 >nul
echo Updating File from modpack [Buffz & Neftz] JSON...
echo.

:: ==============================================================
:: BUOC KHOI DAU: XOA PLANTPROPS TRONG SENTRY'S QOL
:: ==============================================================
echo [0/4] Deleting PlantProps.json trong Sentry's QOL...
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
echo [1/4] Replacing [Gatling Pea, Mega Gatling Pea] in PlantProps.json...

:: Tao file script PowerShell tam thoi de xu ly logic an toan
set "ps_script=%temp%\update_plants.ps1"
> "%ps_script%" echo $files = Get-ChildItem -Path '.' -Filter '*PlantProps*.json' -Recurse
>> "%ps_script%" echo foreach ($f in $files) {
>> "%ps_script%" echo     $lines = Get-Content $f.FullName -Encoding UTF8
:: ==============================================================
>> "%ps_script%" echo     # --- BEGIN Delete Nefted plants ---
>> "%ps_script%" echo     $plantsToDelete = @('primalsunflower', 'primalpotatomine', 'primalwalnut', 'primalpeashooter', 'moonflower', 'nightshade', 'shadowshroom', 'grimrose', 'shadowpeashooter', 'darkmatterdragonfruit')
>> "%ps_script%" echo     foreach ($plant in $plantsToDelete) {
>> "%ps_script%" echo         $targetLine = -1
>> "%ps_script%" echo         for ($idx = 0; $idx -lt $lines.Count; $idx++) {
>> "%ps_script%" echo             if ($lines[$idx] -match '"' + $plant + '"') { $targetLine = $idx; break }
>> "%ps_script%" echo         }
>> "%ps_script%" echo         if ($targetLine -ne -1) {
>> "%ps_script%" echo             $startIndex = -1; $endIndex = -1
>> "%ps_script%" echo             for ($j = $targetLine; $j -ge 0; $j--) {
>> "%ps_script%" echo                 if ($lines[$j].Trim() -eq '{') { $startIndex = $j; break }
>> "%ps_script%" echo             }
>> "%ps_script%" echo             if ($startIndex -ne -1) {
>> "%ps_script%" echo                 $braceCount = 0
>> "%ps_script%" echo                 for ($k = $startIndex; $k -lt $lines.Count; $k++) {
>> "%ps_script%" echo                     $openCount = ($lines[$k].ToCharArray() ^| Where-Object { $_ -eq '{' }).Count
>> "%ps_script%" echo                     $closeCount = ($lines[$k].ToCharArray() ^| Where-Object { $_ -eq '}' }).Count
>> "%ps_script%" echo                     $braceCount += $openCount - $closeCount
>> "%ps_script%" echo                     if ($braceCount -eq 0) { $endIndex = $k; break }
>> "%ps_script%" echo                 }
>> "%ps_script%" echo             }
>> "%ps_script%" echo             if ($startIndex -ne -1 -and $endIndex -ne -1) {
>> "%ps_script%" echo                 $newLines = @()
>> "%ps_script%" echo                 for ($m = 0; $m -lt $lines.Count; $m++) {
>> "%ps_script%" echo                     if ($m -lt $startIndex -or $m -gt $endIndex) { $newLines += $lines[$m] }
>> "%ps_script%" echo                 }
>> "%ps_script%" echo                 $lines = $newLines
>> "%ps_script%" echo             }
>> "%ps_script%" echo         }
>> "%ps_script%" echo     }
>> "%ps_script%" echo     # --- END Delete plants ---
:: ==============================================================
:: ==============================================================
>> "%ps_script%" echo     # --- BEGIN Update plants ---
>> "%ps_script%" echo     $inMega = $false
>> "%ps_script%" echo     $inGatling3 = $false
>> "%ps_script%" echo     $inFirePeashooter = $false
>> "%ps_script%" echo     $inPoisonPeashooter = $false
>> "%ps_script%" echo     $inSnapPea = $false
>> "%ps_script%" echo     $inElectricPeashooter = $false
>> "%ps_script%" echo     $inElectricPeashooter2 = $false
>> "%ps_script%" echo     $inElectricPeashooter3 = $false
>> "%ps_script%" echo     $inDuskLobber = $false
>> "%ps_script%" echo     $inDuskLobber2 = $false
>> "%ps_script%" echo     $inDuskLobber3 = $false
>> "%ps_script%" echo     for ($i = 0; $i -lt $lines.Count; $i++) {
>> "%ps_script%" echo         # Reset bien kiem tra moi khi bat dau mot object moi de tranh bat nham
>> "%ps_script%" echo         if ($lines[$i] -match '"objclass"') { $inMega = $false; $inGatling3 = $false; $inFirePeashooter = $false; $inPoisonPeashooter = $false; $inSnapPea = $false; $inElectricPeashooter = $false; $inElectricPeashooter2 = $false; $inElectricPeashooter3 = $false; $inDuskLobber = $false; $inDuskLobber2 = $false; $inDuskLobber3 = $false }
>> "%ps_script%" echo         if ($lines[$i] -match '"megagatling"') { $inMega = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"gatling_lvl3"') { $inGatling3 = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"firepeashooter"') { $inFirePeashooter = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"poisonpeashooter"') { $inPoisonPeashooter = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"snappea"') { $inSnapPea = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"electricpeashooter"') { $inElectricPeashooter = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"electricpeashooter_lvl2"') { $inElectricPeashooter2 = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"electricpeashooter_lvl3"') { $inElectricPeashooter3 = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"dusklobber"') { $inDuskLobber = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"dusklobber_lvl2"') { $inDuskLobber2 = $true }
>> "%ps_script%" echo         if ($lines[$i] -match '"dusklobber_lvl3"') { $inDuskLobber3 = $true }
>> "%ps_script%" echo         # Xu ly rieng cho megagatling
>> "%ps_script%" echo         if ($inMega) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PlantfoodPeaCount"\s*:\s*100', '"PlantfoodPeaCount": 125'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*25', '"Cooldown": 5'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"ShootInterval"\s*:\s*1.5', '"ShootInterval": 1.35'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*525', '"SunCost": 450'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"ChanceToPlantfood"\s*:\s*0(?![.\d])', '"ChanceToPlantfood": 0.05'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho gatling_lvl3
>> "%ps_script%" echo         if ($inGatling3) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaType"\s*:\s*"gatlingpea"', '"PeaType": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"PeaTypePlantfood"\s*:\s*"gatlingpea"', '"PeaTypePlantfood": "pea"'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*20', '"Cooldown": 15'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho firepeashooter
>> "%ps_script%" echo         if ($inFirePeashooter) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*225', '"SunCost": 175'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*7.5', '"Cooldown": 5'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho poisonpeashooter
>> "%ps_script%" echo         if ($inPoisonPeashooter) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*300', '"SunCost": 150'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*15', '"Cooldown": 5'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho snappea
>> "%ps_script%" echo         if ($inSnapPea) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*325', '"SunCost": 200'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho electricpeashooter
>> "%ps_script%" echo         if ($inElectricPeashooter) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*450', '"SunCost": 200'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*20', '"Cooldown": 10'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho electricpeashooter_lvl2
>> "%ps_script%" echo         if ($inElectricPeashooter2) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*375', '"SunCost": 175'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*17.5', '"Cooldown": 12.5'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho electricpeashooter_lvl3
>> "%ps_script%" echo         if ($inElectricPeashooter3) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*575', '"SunCost": 275'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*25', '"Cooldown": 15'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         # Xu ly rieng cho dusk_lobber
>> "%ps_script%" echo         if ($inDuskLobber) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*15', '"Cooldown": 10'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*250', '"SunCost": 150'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         if ($inDuskLobber2) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*225', '"SunCost": 125'
>> "%ps_script%" echo         }
>> "%ps_script%" echo         if ($inDuskLobber3) {
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"SunCost"\s*:\s*325', '"SunCost": 200'
>> "%ps_script%" echo             $lines[$i] = $lines[$i] -replace '"Cooldown"\s*:\s*17.5', '"Cooldown": 13.5'
>> "%ps_script%" echo         }
>> "%ps_script%" echo     }
>> "%ps_script%" echo     # --- END Update plants ---
:: ==============================================================
>> "%ps_script%" echo     $lines ^| Set-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo }

:: ==============================================================
:: PHAN 2: CAP NHAT TY LE DAN TRONG PROJECTILETYPES.JSON
:: ==============================================================
echo [2/4] Changing Rate for Mega Gatling Pea in ProjectileTypes.json...

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

:: ==============================================================
:: PHAN 3: DIEU CHINH THUOC TINH OBTAINWORLD TRONG PLANTFEATURES.JSON
:: ==============================================================
echo [3/4] Changing OBTAINWORLD in PlantFeature.json...

>> "%ps_script%" echo $featFiles = Get-ChildItem -Path '.' -Filter '*PlantFeature*.json' -Recurse
>> "%ps_script%" echo foreach ($f in $featFiles) {
>> "%ps_script%" echo     $lines = Get-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo     # ------------------------------------------------------------------
>> "%ps_script%" echo     # BAN CO THE THEM NHIEU CAY DE DOI WORLD VAO MAU CO DAU PHAY:
>> "%ps_script%" echo     # Vi du: @('dusklobber', 'moonflower', 'nightshade', 'shadowshroom', 'grimrose', 'shadowpeashooter')
>> "%ps_script%" echo     # ------------------------------------------------------------------
>> "%ps_script%" echo     $plantsToMove = @('dusklobber', 'dusklobber_lvl2', 'dusklobber_lvl3', 'moonflower', 'nightshade', 'shadowshroom', 'grimrose', 'shadowpeashooter')
>> "%ps_script%" echo     foreach ($plant in $plantsToMove) {
>> "%ps_script%" echo         $targetLine = -1
>> "%ps_script%" echo         for ($idx = 0; $idx -lt $lines.Count; $idx++) {
>> "%ps_script%" echo             if ($lines[$idx] -match '"CODENAME"\s*:\s*"' + $plant + '"') { $targetLine = $idx; break }
>> "%ps_script%" echo         }
>> "%ps_script%" echo         if ($targetLine -ne -1) {
>> "%ps_script%" echo             $startIndex = -1; $endIndex = -1
>> "%ps_script%" echo             for ($j = $targetLine; $j -ge 0; $j--) {
>> "%ps_script%" echo                 if ($lines[$j].Trim().StartsWith('{')) { $startIndex = $j; break }
>> "%ps_script%" echo             }
>> "%ps_script%" echo             if ($startIndex -ne -1) {
>> "%ps_script%" echo                 $braceCount = 0
>> "%ps_script%" echo                 for ($k = $startIndex; $k -lt $lines.Count; $k++) {
>> "%ps_script%" echo                     $openCount = ($lines[$k].ToCharArray() ^| Where-Object { $_ -eq '{' }).Count
>> "%ps_script%" echo                     $closeCount = ($lines[$k].ToCharArray() ^| Where-Object { $_ -eq '}' }).Count
>> "%ps_script%" echo                     $braceCount += $openCount - $closeCount
>> "%ps_script%" echo                     if ($braceCount -eq 0) { $endIndex = $k; break }
>> "%ps_script%" echo                 }
>> "%ps_script%" echo             }
>> "%ps_script%" echo             if ($startIndex -ne -1 -and $endIndex -ne -1) {
>> "%ps_script%" echo                 for ($m = $startIndex; $m -le $endIndex; $m++) {
>> "%ps_script%" echo                     if ($lines[$m] -match '"OBTAINWORLD"\s*:\s*"frontyard"') {
>> "%ps_script%" echo                         $lines[$m] = $lines[$m] -replace '"OBTAINWORLD"\s*:\s*"frontyard"', '"OBTAINWORLD": "modern"'
>> "%ps_script%" echo                     }
>> "%ps_script%" echo                 }
>> "%ps_script%" echo             }
>> "%ps_script%" echo         }
>> "%ps_script%" echo     }
>> "%ps_script%" echo     $lines ^| Set-Content $f.FullName -Encoding UTF8
>> "%ps_script%" echo }

:: Thuc thi chuong trinh PowerShell tong hop
powershell -ExecutionPolicy Bypass -File "%ps_script%"
del "%ps_script%"

:: ==============================================================
:: PHAN 4: CAP NHAT FILE PLANT-LEVELS.JSON
:: ==============================================================
echo [4/4] Replacing "TIER *" to "LVL *" in plant-levels.json...
powershell -Command "Get-ChildItem -Path '.' -Filter '*plant-levels*.json' -Recurse | ForEach-Object { $file = $_.FullName; (Get-Content $file -Raw -Encoding UTF8) -replace 'TIER V', 'LVL 5' -replace 'TIER IV', 'LVL 4' -replace 'TIER III', 'LVL 3' -replace 'TIER II', 'LVL 2' -replace 'TIER I', 'LVL 1' | Set-Content $file -Encoding UTF8 }"
echo Done update PlantProps.json!
echo Done update ProjectileTypes.json!
echo Done update PlantFeatures.json!
echo Done update plant-levels.json!
echo.

echo Done Replacing PVZ 2 GE Mod!
pause