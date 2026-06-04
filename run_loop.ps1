$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jtlFile = "C:\Tools\apache-jmeter-5.6.3\AX\results_loop_${timestamp}_100u_5loops.jtl"
$logFile = "C:\Users\fakhr\AppData\Local\Temp\axloop_run.log"

Set-Location "C:\Tools\apache-jmeter-5.6.3"
Write-Host "=== AX Loop Test Start ===" -ForegroundColor Cyan
Write-Host "Time      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL       : $jtlFile"
Write-Host ""
Write-Host "Starting AXOtherOperation (background, independent process)..." -ForegroundColor Green
Start-Process -FilePath "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" `
    -ArgumentList "-n -t `"C:\Tools\apache-jmeter-5.6.3\AX\AXOtherOperation.jmx`" -Jport=4445" `
    -WindowStyle Minimized

Write-Host "Waiting 45s before starting AXBidLoop..."
Start-Sleep 45

Write-Host ""
Write-Host "=== AXBidLoop Test START ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Config: 100 threads, ramp 300s, 5 loops"
Write-Host ""

& "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" -n `
    -t "C:\Tools\apache-jmeter-5.6.3\AX\AXBidLoop.jmx" `
    -Jthreads=100 -Jrampup=300 -Jloops=5 `
    -l $jtlFile 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "=== AXBidLoop Test DONE ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL saved: $jtlFile"
