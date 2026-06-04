$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jtlFile = "C:\Tools\apache-jmeter-5.6.3\AX\results_endurance_${timestamp}_100u_30min.jtl"
$logFile = "C:\Users\fakhr\AppData\Local\Temp\axendurance_run.log"

Set-Location "C:\Tools\apache-jmeter-5.6.3"
Write-Host "=== AX Endurance Test Start ===" -ForegroundColor Cyan
Write-Host "Time      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL       : $jtlFile"
Write-Host ""
Write-Host "Starting AXOtherOperation (background, 35 menit)..." -ForegroundColor Green
Start-Process -FilePath "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" `
    -ArgumentList "-n -t `"C:\Tools\apache-jmeter-5.6.3\AX\AXOtherOperation.jmx`" -Jport=4445" `
    -WindowStyle Minimized

Write-Host "Waiting 45s before starting AXEndurance..."
Start-Sleep 45

Write-Host ""
Write-Host "=== AXEndurance Test START ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Config: 100 threads, ramp 300s, duration 30 menit"
Write-Host ""

& "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" -n `
    -t "C:\Tools\apache-jmeter-5.6.3\AX\AXEndurance.jmx" `
    -l $jtlFile 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "=== AXEndurance Test DONE ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL saved: $jtlFile"
