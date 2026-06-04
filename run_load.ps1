$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jtlFile = "C:\Tools\apache-jmeter-5.6.3\AX\results_load_${timestamp}_120u.jtl"
$logFile = "C:\Users\fakhr\AppData\Local\Temp\axload_run.log"

Set-Location "C:\Tools\apache-jmeter-5.6.3"
Write-Host "=== AX Load Test Start ===" -ForegroundColor Cyan
Write-Host "Time      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL       : $jtlFile"
Write-Host ""
Write-Host "Starting AXOtherOperation (background, independent process)..." -ForegroundColor Green
Start-Process -FilePath "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" `
    -ArgumentList "-n -t `"C:\Tools\apache-jmeter-5.6.3\AX\AXOtherOperation.jmx`" -Jport=4445" `
    -WindowStyle Minimized

Write-Host "Waiting 45s before starting AXBidding..."
Start-Sleep 45

Write-Host ""
Write-Host "=== AXBidding Load Test START ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Config: 120 threads, ramp 300s, 1 loop"
Write-Host ""

& "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" -n `
    -t "C:\Tools\apache-jmeter-5.6.3\AX\AXBidding.jmx" `
    -Jthreads=120 -Jrampup=300 -Jloops=1 `
    -l $jtlFile 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "=== AXBidding Load Test DONE ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL saved: $jtlFile"
