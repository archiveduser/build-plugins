$ErrorActionPreference = "Stop"

try {
    Write-Output "Script started. Current directory: $(Get-Location)"
    Write-Output "PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Output "Git version: $(git --version)"
    Write-Output ".NET version: $(dotnet --version)"

    # 下载和解压
    $downloadUrl = "https://github.com/AtmoOmen/Dalamud/releases/download/25-05-06-01/latest.7z"
    $targetDir = "$env:APPDATA\XIVLauncher\addon\Hooks\dev"
    $tempFile = "$env:TEMP\latest.7z"

    Write-Output "Creating directory: $targetDir"
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    Write-Output "Downloading from: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

    Write-Output "Extracting to: $targetDir"
    if (-not (Get-Command 7z -ErrorAction SilentlyContinue)) {
        Write-Error "7z is not installed. Cannot extract 7z file."
    }
    7z x $tempFile -o"$targetDir" -y

    Write-Output "Cleaning up temp file"
    Remove-Item -Path $tempFile -ErrorAction SilentlyContinue

    # 验证 Dalamud.dll 存在
    $dalamudDll = Join-Path $targetDir "Dalamud.dll"
    if (-not (Test-Path $dalamudDll)) {
        Write-Error "Dalamud.dll not found in $targetDir"
    }
    Write-Output "Dalamud.dll found at: $dalamudDll"

    # 克隆和构建
    Write-Output "Cloning YesAlready repository"
    git clone https://github.com/PunishXIV/YesAlready.git
    Write-Output "Changing to YesAlready directory"
    Set-Location -Path YesAlready

    Write-Output "Checking out commit"
    git checkout v1.9.1

    Write-Output "Updating submodules"
    git submodule update --init --recursive

    Write-Output "Patching project"

    Write-Output "Restoring NuGet packages"
    dotnet restore --no-cache --force

    Write-Output "Building project"
    dotnet build --configuration Release --no-restore
}
catch {
    Write-Error "Error occurred: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
finally {
    Write-Output "Script completed."
}