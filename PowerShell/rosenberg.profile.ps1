########################################
# Environment variables
########################################

$Env:XDG_DATA_HOME="$home/.local/share"
$Env:XDG_CONFIG_HOME="$home/.config"

########################################
# Source Path on macOS
# Per https://github.com/PowerShell/PowerShell/issues/6027
########################################
if ($IsMacOS -and $env:PATH -notmatch '\b/usr/local/bin\b') { # prevent repeated replacement of $env:PATH
  & { # Use a child scope, so that helper function setenv() doesn't linger.
    function setenv ($variable, $value) { [Environment]::SetEnvironmentVariable($variable, $value)  }
    # `/usr/libexec/path_helper -c` conveniently outputs something like 'setenv PATH "/usr/local/bin:..."',
    # which we can pass to Invoke-Expression, which then calls our transient `setenv()` function.
    Invoke-Expression (/usr/libexec/path_helper -c)  
  }
}

########################################
# Determine dotfiles modules to load
########################################
function Use-Dotfile() { # Expects one argument -- module name
  Param(
    [Parameter(Mandatory=$true)]
    [string]$ModuleName
  )
  if (! (Test-Path -Path $Env:DOTFILESTOLOAD)) {
    throw "Can't find `$DOTFILESTOLOAD file"
  }
  else {
    $dotfilesContent = Get-Content -Path $Env:DOTFILESTOLOAD
    return $dotfilesContent -contains $ModuleName # Needs a complete (but case-insensitive) match, so commented lines won't match
  }
}

########################################
# Source aliases, variables, extensions, etc. for other tools
########################################

. "$Env:DOTFILES/PowerShell/rosenberg.pwshalias.ps1"
if (Use-Dotfile "git") {
  . "$Env:DOTFILES/Git/rosenberg.git.ps1"
}
if (Use-Dotfile "docker") {
  . "$Env:DOTFILES/Docker/rosenberg.docker.ps1"
}
if (Use-Dotfile "dotnet") {
  . "$Env:DOTFILES/Dotnet/rosenberg.dotnet.ps1"
}
if (Use-Dotfile "maven") {
  . "$Env:DOTFILES/Maven/rosenberg.maven.ps1"
}
if (Use-Dotfile "olson") {
  . "$Env:DOTFILES/Olson/rosenberg.olson.ps1"
}

########################################
# Load modules
########################################

# Place code in a standard path for modules
# Or install with: Install-Module module-name -Scope CurrentUser

Import-Module posh-git
Import-Module oh-my-posh

########################################
# Customize the prompt
########################################

# posh-git prompt
function global:PromptWriteErrorInfo() {
  if ($global:GitPromptValues.DollarQuestion) { return }

  if ($global:GitPromptValues.LastExitCode) {
      "`e[31m(" + $global:GitPromptValues.LastExitCode + ") `e[0m"
  }
  else {
      "`e[31m! `e[0m"
  }
}
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 0x00FF00
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$(PromptWriteErrorInfo)'

# global pwsh prompt
Set-PoshPrompt -Theme ys
# $DefaultUser = 'Jeff' # oh-my-posh configuration

# function prompt {
#   $DebugPreference = "SilentlyContinue"
#   $origLastExitCode = $LASTEXITCODE
#   Write-Host "$($ExecutionContext.SessionState.Path.CurrentLocation) " -ForegroundColor Green -NoNewline
#   Write-VcsStatus -
#   Write-Host #Newline
#   $LASTEXITCODE = $origLastExitCode
#   "$('>' * ($nestedPromptLevel + 1)) "
#   & $GitPromptScriptBlock -
#   $DebugPreference = "Continue"
# }