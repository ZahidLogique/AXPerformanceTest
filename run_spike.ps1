$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jtlFile = "C:\Tools\apache-jmeter-5.6.3\AX\results_spike_${timestamp}_100u_60s.jtl"
$logFile = "C:\Users\fakhr\AppData\Local\Temp\axspike_run.log"

Set-Location "C:\Tools\apache-jmeter-5.6.3"
Write-Host "=== AX Spike Test Start ===" -ForegroundColor Cyan
Write-Host "Time      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL       : $jtlFile"
Write-Host ""
Write-Host "Starting AXOtherOperation (background, independent process)..." -ForegroundColor Green
Start-Process -FilePath "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" `
    -ArgumentList "-n -t `"C:\Tools\apache-jmeter-5.6.3\AX\AXSpike.jmx`" -Jport=4445" `
    -WindowStyle Minimized

Write-Host "Waiting 45s before starting AXSpike..."
Start-Sleep 45

Write-Host ""
Write-Host "=== AXSpike Test START ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Config: 100 threads, ramp 60s (BURST), 1 loop"
Write-Host ""

& "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" -n `
    -t "C:\Tools\apache-jmeter-5.6.3\AX\AXSpike.jmx" `
    -Jthreads=100 -Jrampup=60 -Jloops=1 `
    -l $jtlFile 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "=== AXSpike Test DONE ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL saved: $jtlFile"
