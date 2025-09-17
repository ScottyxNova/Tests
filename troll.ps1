# Define the registry paths
$regPath = "HKCU:\Control Panel\Desktop"
$photoRegPath = "HKCU:\Software\Microsoft\Windows Photo Viewer\Slideshow\Screensaver"

# Check and create the Photos screensaver registry key if it's missing
if (-not (Test-Path -Path $photoRegPath)) {
    Write-Host "Creating missing registry key for Photos screensaver..."
    New-Item -Path $photoRegPath -Force | Out-Null
}

# 1. Set the screen saver executable to the "Photos" screensaver.
Set-ItemProperty -Path $regPath -Name "SCRNSAVE.exe" -Value "C:\Windows\System32\PhotoScreensaver.scr"

# 2. Set the screensaver timeout to 5 minutes (300 seconds).
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value "60"

# 3. Ensure the screensaver is active.
Set-ItemProperty -Path $regPath -Name "ScreenSaveActive" -Value 1

# 4. Set the source folder for the photos screensaver.
Set-ItemProperty -Path $photoRegPath -Name "ImagesRootPath" -Value "$env:USERPROFILE\Downloads"
