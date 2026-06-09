# Start hugo server on port 1314 in the background
$hugoProcess = Start-Process hugo -ArgumentList "server", "--port", "1314" -PassThru -NoNewWindow

# Wait for the server to start (typically 3 seconds is plenty)
Start-Sleep -Seconds 3

# Run headless Chrome to print the profile page to PDF
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$outputPdf = Join-Path (Get-Location) "static\Shubham-DevOps-CV.pdf"

Write-Host "Generating PDF to $outputPdf..."
Start-Process -FilePath $chromePath -ArgumentList "--headless=new", "--disable-gpu", "--print-to-pdf=$outputPdf", "--no-pdf-header-footer", "--no-sandbox", "http://localhost:1314/profile/" -Wait

# Stop the hugo process
Stop-Process -Id $hugoProcess.Id -Force
Write-Host "PDF CV generated successfully at static\Shubham-DevOps-CV.pdf!"
