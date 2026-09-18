Get-ChildItem -File -Filter "*.txt" | Rename-Item -NewName { $_.BaseName + ".lua" }
