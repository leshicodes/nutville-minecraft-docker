#  $PSScriptRoot

zip -r backup.zip $PSScriptRoot/../mc -x "$PSScriptRoot/../mc/plugins/*"