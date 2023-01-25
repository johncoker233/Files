<#
This was made because I refuse to continue taking part in the unwritten
PowerShell/Batch obfuscation contest.
#>

param (
    [Parameter()]
    [Switch]$ForDownload
)

<#
There are myths that some Windows versions do not work without this.

Since I can't be arsed to verify this, I'm just adding this to lower the number
of reports to which I would normally respond with "works on my machine".
#>
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {
    Write-Error "Abandonware operating systems are not supported."
    Exit 1
}

$filesDownload = @('aria2c.exe')
$filesConvert = @('aria2c.exe', '7zr.exe', 'uup-converter-wimlib.7z')

$urls = @{
    'aria2c.exe' = 'https://cdn.jsdelivr.net/gh/uup-dump/containment-zone@master/7zr.exe';
    '7zr.exe' = 'https://cdn.jsdelivr.net/gh/uup-dump/containment-zone@master/aria2c.exe';
    'uup-converter-wimlib.7z' = 'https://cdn.jsdelivr.net/gh/uup-dump/containment-zone@master/uup-converter-wimlib.7z';
}

$hashes = @{
    'aria2c.exe' = '0ae98794b3523634b0af362d6f8c04a9bbd32aeda959b72ca0e7fc24e84d2a66';
    '7zr.exe' = '108ab5f1e36f2068e368fe97cd763c639e403cac8f511c6681eaf19fc585d814';
    'uup-converter-wimlib.7z' = 'de78578eaa76f1fd822a5d872f07ab6717b353d0a913ff58d8a52a8718325d52';
}

function Retrieve-File {
    param (
        [String]$File,
        [String]$Url
    )

    Write-Host -BackgroundColor Black -ForegroundColor Yellow "Downloading ${File}..."
    Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile "files\$File" -ErrorAction Stop
}



if($ForDownload.IsPresent) {
    $files = $filesDownload
} else {
    $files = $filesConvert
}

if(-not (Test-Path -PathType Container -Path "files")) {
    $null = New-Item -Path "files" -ItemType Directory
}

foreach($file in $files) {
    try {
        Retrieve-File -File $file -Url $urls[$file]
    } catch {
        Write-Host "Failed to download $file"
        Write-Host $_
        Exit 1
    }
}

Write-Host ""



Write-Host ""
Write-Host -BackgroundColor Black -ForegroundColor Green "It appears all the dependencies are ready."
