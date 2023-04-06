# trust local PS scripts
Set-ExecutionPolicy RemoteSigned

# trust PowerShell Gallery
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name Microsoft.Graph
Install-Module -Name ExchangeOnlineManagement -RequiredVersion 3.1.0
