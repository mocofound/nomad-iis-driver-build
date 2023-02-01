 Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install git.install --version=2.25.1 -y --no-progress
choco install golang --version=1.15 -y --no-progress
choco install vagrant --version=2.3.4 -y --no-progress
choco install virtualbox --version=7.0.6.20230201 -y --no-progress
choco install make --version=4.3 -y --no-progress
cmd.exe /c "refreshenv"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
ssh-keyscan github.com >> ~/.ssh/known_hosts
#mkdir -p $GOPATH/src/github.com/Roblox
$FolderName="C:\nomad-driver-iis"
if (Test-Path $FolderName) {
}
else
{
    New-Item $FolderName -ItemType Directory
}

cd $FolderName
Invoke-WebRequest 'https://github.com/Roblox/nomad-driver-iis/archive/refs/heads/master.zip' -OutFile .\nomad-driver-iis.zip
Expand-Archive .\nomad-driver-iis.zip .\ -Force
Rename-Item .\nomad-driver-iis-master .\nomad-driver-iis
Remove-Item .\nomad-driver-iis.zip
cd nomad-driver-iis
make build 
