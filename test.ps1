$downloadUrl = "https://github.com/AtmoOmen/Dalamud/releases/download/25-05-06-01/latest.7z"
$targetDir = "$env:APPDATA\XIVLauncher\addon\Hooks\dev"
$tempFile = "$env:TEMP\latest.7z"

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile
Expand-Archive -Path $tempFile -DestinationPath $targetDir -Force
Remove-Item -Path $tempFile


git clone https://github.com/ffxivcode/AutoDuty.git
git checkout 95c76c609011c1ad25e689554c155926ee0f2f32
git submodule update --init --recursive .
dotnet build --configuration Release

