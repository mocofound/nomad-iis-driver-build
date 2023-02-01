#Prereq/TODO - update 2x Consul Token Values
sc.exe stop "Nomad"
sc.exe stop "Consul"
start-sleep -Seconds 2
sc.exe delete "Nomad"
sc.exe delete "Consul"

$FolderName = "C:\nomad\"
if (Test-Path $FolderName) {
}
else
{
    New-Item $FolderName -ItemType Directory
    New-Item "$FolderName\data" -ItemType Directory
    New-Item "$FolderName\plugin" -ItemType Directory
    New-Item "$FolderName\logs" -ItemType Directory
}
#Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3/nomad_1.4.3_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 

Expand-Archive "$FolderName\nomad.zip" -DestinationPath "$FolderName\" -Force
$ConfigPath = "$FolderName\nomad_windows_client_config.hcl"
$ConfigPath2 = "$FolderName\nomad_windows_client_config2.hcl"
$formatText = @"
# Increase log verbosity
log_level = "DEBUG"
log_file = "C:\\nomad\\logs\\nomad.log"
data_dir  = "C:\\nomad\\data"
plugin_dir = "C:\\nomad\\plugin"
plugin "win_iis" {
  config {
    enabled = true
    stats_interval = "5s"
  }
}
bind_addr = "0.0.0.0"
datacenter = "dc1"

# Enable the client
client {
  enabled = true
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

acl {
  enabled = true
}

consul {
  address = "127.0.0.1:8500"
  #token = "CONSUL_TOKEN"
  token = "5679b6b0-9e81-11ed-a8fc-0242ac1"
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}
"@ > $ConfigPath
Get-Content $ConfigPath | out-file -encoding ASCII $ConfigPath2
sc.exe create "Nomad" binPath="$FolderName\nomad.exe agent -config=$ConfigPath2" start= auto
sc.exe start "Nomad"

$ConsulFolderName = "C:\consul\"
if (Test-Path $ConsulFolderName) {
}
else
{
    New-Item $ConsulFolderName -ItemType Directory
    New-Item "$ConsulFolderName\data" -ItemType Directory
}


#Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
Invoke-WebRequest -Uri "https://releases.hashicorp.com/consul/1.14.4/consul_1.14.4_windows_amd64.zip" -OutFile "$ConsulFolderName\consul.zip"
Expand-Archive "$ConsulFolderName\consul.zip" -DestinationPath "$ConsulFolderName\" -Force
$ConsulConfigPath = "$ConsulFolderName\consul_windows_client_config.hcl"
$ConsulConfigPath2 = "$ConsulFolderName\consul_windows_client_config2.hcl"
#Powershell Here-string  $(Get-Date) ${myDate}
#advertise_addr = $(Get-NetIPAddress | Where-Object -FilterScript { $_.PrefixOrigin -eq "Dhcp"  })
$formatText = @"
ui = true
log_level = "INFO"
data_dir = "C:\\consul\\data"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
#advertise_addr = "IP_ADDRESS"
#retry_join = ["RETRY_JOIN"]
advertise_addr = "172.31.24.70"
retry_join = ["provider=aws tag_key=ConsulAutoJoin tag_value=auto-join"]
#retry_join = ["172.31.53.33"]

acl {
    enabled = true
    default_policy = "deny"
    down_policy = "extend-cache"
    tokens {
       agent  = "5679b6b0-9e81-11ed-a8fc-0242a"
  }
}

connect {
  enabled = true
}
ports {
  grpc = 8502
}

"@ > $ConsulConfigPath
Get-Content $ConsulConfigPath | out-file -encoding ASCII $ConsulConfigPath2
sc.exe create "Consul" binPath="$ConsulFolderName\consul.exe agent -config-file=$ConsulConfigPath2" start= auto
#C:\consul\consul.exe C:\consul\consul_windows_client_config2.hcl
sc.exe start "Consul" 
