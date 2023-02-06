# nomad-iis-driver-build
This repo contains code for building and installing the nomad-iis-driver plugin for HashiCorp Nomad.  The [Nomad IIS Task Driver](https://github.com/Roblox/nomad-driver-iis) was created by Roblox.

## Files
* ***build-nomad-driver-iis.ps1*** - Uses chocolatey, golang, and make to build win_iis.exe.

* ***install-nomad-windows-powershell.ps1*** - Uses sc.exe to create windows services for Nomad and Consul.  Win_iis.exe is placed into Nomad's plugin directory.  Nomad can now schedule jobs to this client.

* ***plugin/win_iis.exe*** - I built and shared this exe so that I could find it later.  Use at your own risk. 

### Compiled on the following Windows Server 2019 AMI in Feb 2023.
```
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
```
