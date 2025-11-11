#to allow script execution:
#Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#to revert executionpolicy
#Set-ExecutionPolicy Undefined -Scope CurrentUser

cls

$DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip"
$DownloadPath = "C:\temp\SpeedTest.Zip"
$ExtractToPath = "C:\temp\SpeedTest"
$SpeedTestEXEPath = "C:\temp\SpeedTest\speedtest.exe"
# $LogPath = "C:\temp\SpeedTestLog.txt"

# Ensure the download and extraction directories exist
if (!(Test-Path -Path "C:\temp")) {
    New-Item -Path "C:\temp" -ItemType Directory | Out-Null
}

if (!(Test-Path -Path $ExtractToPath)) {
    New-Item -Path $ExtractToPath -ItemType Directory | Out-Null
}

# Function to download and unzip the SpeedTest client
function DownloadAndExtractSpeedTest {
    Write-Host "Downloading SpeedTest CLI..."
    Invoke-WebRequest -Uri $DownloadURL -OutFile $DownloadPath -UseBasicParsing

    if (Test-Path $DownloadPath) {
        Write-Host "Extracting SpeedTest..."
        Add-Type -AssemblyName System.IO.Compression.FileSystem

        # If the extraction folder already exists, clear it first
        if (Test-Path $ExtractToPath) {
            Remove-Item -Path $ExtractToPath -Recurse -Force
        }
        New-Item -ItemType Directory -Path $ExtractToPath | Out-Null

        [System.IO.Compression.ZipFile]::ExtractToDirectory($DownloadPath, $ExtractToPath)
    } else {
        Write-Host "Download failed."
    }
}

# Function to run the speed test
function RunTest {
    Write-Host "contact PL for concerns"
    if (!(Test-Path $SpeedTestEXEPath)) {
        Write-Host "Executing ^_____^`n"
        DownloadAndExtractSpeedTest
    }

    if (Test-Path $SpeedTestEXEPath) {
        Write-Host "Running SpeedTest..."
        & $SpeedTestEXEPath --accept-license --accept-gdpr
        Write-Host -NoNewline 'Press any key to continue...'
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    } else {
        Write-Host "Failed to find SpeedTest EXE after download and extraction."
    }
}

# Function to delete downloaded and extracted SpeedTest files
function DeleteSpeedTestFiles {
    if (Test-Path $DownloadPath) {
        Write-Host "Deleting downloaded ZIP..."
        Remove-Item -Path $DownloadPath -Force
    } else {
        Write-Host "No ZIP file found to delete."
    }

    if (Test-Path $ExtractToPath) {
        Write-Host "Deleting extracted folder..."
        Remove-Item -Path $ExtractToPath -Recurse -Force
    } else {
        Write-Host "No extracted folder found to delete."
    }
}

# Run the test
RunTest

#Clean up files after running
DeleteSpeedTestFiles
