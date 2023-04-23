

# # https://powershellexplained.com/2017-05-27-Powershell-module-building-basics/

# We can call Import-Module on a .ps1, but the convention is to use .psm1 as a module designation. Rename that script to LogModule.psm1.
# https://sid-500.com/2023/01/10/creating-a-powershell-module-with-multiple-functions/

# # https://powershellexplained.com/2017-05-27-Powershell-module-building-basics/

# We can call Import-Module on a .ps1, but the convention is to use .psm1 as a module designation. Rename that script to LogModule.psm1.
# https://sid-500.com/2023/01/10/creating-a-powershell-module-with-multiple-functions/

Function LogModule($txt) {
    Add-Content log.txt $txt
}