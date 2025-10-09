#CLARK FREEPORT ZONE - 35473
#Agoo - 46776
#Speedtest server ID can be found by hovering your mouse in the target speedtest server from ookla's speedtest website
#[35473, 46776]
#You can experiment with the rate limiting of Ookla's app but you'll be blocked from testing for ~1 hour

#allow script to run > choose 'A'
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

cls

$DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip"
$DownloadPath = "C:\temp\SpeedTest.Zip"
$ExtractToPath = "C:\temp\SpeedTest"
$SpeedTestEXEPath = "C:\temp\SpeedTest\speedtest.exe"
$LogPath = "C:\temp\SpeedTestLog.txt"

# Ensure the download and extraction directories exist
if (!(Test-Path -Path "C:\temp")) {
    New-Item -Path "C:\temp" -ItemType Directory
}

if (!(Test-Path -Path $ExtractToPath)) {
    New-Item -Path $ExtractToPath -ItemType Directory
}

# Function to download and unzip the SpeedTest client
function DownloadAndExtractSpeedTest {
    Invoke-WebRequest -Uri $DownloadURL -OutFile $DownloadPath
    
    if (Test-Path $DownloadPath) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        function Unzip {
            param([string]$zipfile, [string]$outpath)
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
        }
        Unzip $DownloadPath $ExtractToPath
    } else {
        Write-Host "Download failed."
    }
}

# Function to run the speed test and write output to log file
function RunTest($ServerID) {
    Write-Host "Testing server ID $ServerID..."
    if (Test-Path $SpeedTestEXEPath) {
        $TestOutput = & $SpeedTestEXEPath --accept-license --server-id $ServerID --format json
        $TestOutput | ConvertFrom-Json | ForEach-Object {
            $Latency = [math]::Round($_.ping.latency)
            $DLSpeed = [math]::Round($_.download.bandwidth * 8 / 1MB, 2)  # Convert from bytes/s to Mbps
            $UPSpeed = [math]::Round($_.upload.bandwidth * 8 / 1MB, 2)    # Convert from bytes/s to Mbps
            "$ServerID`t$Latency`t$DLSpeed`t$UPSpeed"
        } | Out-File -FilePath $LogPath -Encoding utf8 -Append
    } else {
        Write-Host "SpeedTest EXE not found, downloading and extracting..."
        DownloadAndExtractSpeedTest
        if (Test-Path $SpeedTestEXEPath) {
            $TestOutput = & $SpeedTestEXEPath --accept-license --server-id $ServerID --format json
            $TestOutput | ConvertFrom-Json | ForEach-Object {
                $Latency = [math]::Round($_.ping.latency)
                $DLSpeed = [math]::Round($_.download.bandwidth * 8 / 1MB, 2)  # Convert from bytes/s to Mbps
                $UPSpeed = [math]::Round($_.upload.bandwidth * 8 / 1MB, 2)    # Convert from bytes/s to Mbps
                "$ServerID`t$Latency`t$DLSpeed`t$UPSpeed"
            } | Out-File -FilePath $LogPath -Encoding utf8 -Append
        } else {
            Write-Host "Failed to find SpeedTest EXE after download and extraction."
        }
    }
}

# Initialize the log file
if (!(Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType File -Force
} else {
    Clear-Content -Path $LogPath -Force
}

# List of server IDs to test
$ServerIDs = @(
    35473, 46776
)

# Run tests for each server ID
foreach ($ServerID in $ServerIDs) {
    RunTest $ServerID

    # Allow some time for the test to complete and log to be written
    Start-Sleep -Seconds 21
}
