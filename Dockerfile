FROM mcr.microsoft.com/windows/servercore:1903

LABEL maintainer="mattchris9@hotmail.com"

SHELL ["powershell", "-command"]

RUN Set-ExecutionPolicy Unrestricted
#RUN . { Invoke-WebRequest -useb http://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; get-boxstarter -Force; $Boxstarter.RebootOk=$true; $Boxstarter.NoPassword=$true; $Boxstarter.AutoLogin=$true; Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/fireeye/flare-vm/master/install.ps1
#ADD install.ps1 C:/ 
#RUN ["Set-BoxstarterConfig", "-NugetSources", "https://www.myget.org/F/flare/api/v2/"]
RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force
#RUN choco config set cacheLocation ${Env:TEMP}
#RUN try { Set-MpPreference -DisableRealtimeMonitoring $true; Invoke-Expression "cinst -y disabledefender-winconfig "; } catch {}
#RUN choco config set cacheLocation ${Env:TEMP}
RUN choco sources add --name=flare --source=https://www.myget.org/F/flare/api/v2 --priority 1
RUN choco upgrade -y vcredist-all.flare
#RUN Enable-MicrosoftUpdate; cinst -y powershell; Disable-MicrosoftUpdate

ADD flarevm.installer.flare C:/

RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force; $Boxstarter.RebootOk=$false; $Boxstarter.NoPassword=$false; $Boxstarter.AutoLogin=$true; Set-BoxstarterConfig -NugetSources "https://www.myget.org/F/flare/api/v2;https://chocolatey.org/api/v2"; Install-BoxstarterPackage -PackageName flarevm.installer.flare; exit 0
