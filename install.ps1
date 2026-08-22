# Bootstrap chezmoi + these dotfiles on native Windows.
#
#   irm https://raw.githubusercontent.com/nixpulvis/dotfiles/master/install.ps1 | iex
#
# Extra args are passed to `chezmoi init`, e.g. to track a branch:
#   .\install.ps1 --branch next
$ErrorActionPreference = 'Stop'

if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    $bin = "$env:USERPROFILE\.local\bin"
    Write-Host "Installing chezmoi to $bin..."
    Invoke-Expression "&{$(Invoke-RestMethod -UseBasicParsing get.chezmoi.io/ps1)} -b '$bin'"
    $env:Path = "$bin;$env:Path"
}

chezmoi init --apply @args nixpulvis
