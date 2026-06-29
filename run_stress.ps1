param(
    [int]$threads = 150,
    [int]$rampup  = 60,
    [int]$loops   = 1
)

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jtlFile = "C:\Tools\apache-jmeter-5.6.3\AX\results_stress_${timestamp}_${threads}u_${rampup}s.jtl"
$logFile = "C:\Users\fakhr\AppData\Local\Temp\axstress_run.log"

Set-Location "C:\Tools\apache-jmeter-5.6.3"
Write-Host "=== AX Stress Test ===" -ForegroundColor Cyan
Write-Host "Time      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Config    : $threads threads | ramp ${rampup}s | ${loops} loop"
Write-Host "JTL       : $jtlFile"
Write-Host ""
Write-Host "Starting AXOtherOperation (background)..." -ForegroundColor Green
Start-Process -FilePath "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" `
    -ArgumentList "-n -t `"C:\Tools\apache-jmeter-5.6.3\AX\AXOtherOperation.jmx`" -Jport=4445" `
    -WindowStyle Minimized

Write-Host "Waiting 45s before starting..."
Start-Sleep 45

Write-Host ""
Write-Host "=== AXStress START ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host ""

& "C:\Tools\apache-jmeter-5.6.3\bin\jmeter.bat" -n `
    -t "C:\Tools\apache-jmeter-5.6.3\AX\AXStress.jmx" `
    -Jthreads=$threads -Jrampup=$rampup -Jloops=$loops `
    -l $jtlFile 2>&1 | Tee-Object -FilePath $logFile

Write-Host ""
Write-Host "=== AXStress DONE ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "JTL saved: $jtlFile"
