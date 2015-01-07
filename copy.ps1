param(
    [switch]$help,
    [int]$first,
    [String]$pattern,
    [switch]$pattern_exclude,
    [String]$dest = ".\$source(copy)",
    [String]$source = ".\",
    [String]$Robo1 = "/MIR",
    [String]$Robo2 = "/copyall",
    [String]$Robo3,
    [String]$Robo4
)

if($help){
    Write-Host "`nSyntax: COPY dest source [first|pattern][pattern_exclude][Robo1-4]`n"
    Write-Host "`nMeaning of Parameters:`n`ndest = Target directory`nsource = source directory`nfirst = the assigned number specifies the amount of items which are displayed (from the beginning of the obtained list)`npattern = a regular expression which enables you to address only a subset of files in source`npattern_exclude = if activated through setting the flag to true it inverts the result of the pattern`nRobo1-4 = specify Robocopy.exe parameter"
    Write-Host "`nStandard values:`n`t`tdest=.\source(copy)`n`t`tsource=.\`n`t`tfirst = ALL`n`t`tpattern = ALL`n`t`tpattern_exclude = false`n`t`tRobo1=\MIR`n`t`tRobo2=\copyal`n`t`tlRobo3-4=null"

    Write-Host "`nPossible patterns(not case sensitive):"
    Write-Host "Begins with --> ^x+"
    Write-Host "Ends with --> xxx$"
    Write-Host "Without _ --> _+ and set pattern_exclude = true`n"
    
}else{
    if(!(Test-Path $source)){
        Write-Host "Wrong source! Check path, please."
        exit
    }

     if(Test-Path $dest){
    Write-Host "Existing directory --> Remove old directory and create new one."
    Remove-Item $dest -Recurse -Force
    mkdir $dest -Force
    }else{
        Write-Host "No existing directory --> Will be created!"
        mkdir $dest -Force

    }
   

    if($first -and !$pattern){
        Write-Host "Select $first first items." 
        $items = Get-ChildItem $source | select -First $first
    }

    if(!$first -and $pattern){
        if($pattern_exclude){
            Write-Host "Use items not matching $pattern."
            $items = Get-ChildItem $source | Where-Object {!($_.Name -match "$pattern")}
        }else{
            Write-Host "Use items matching $pattern."
            $items = Get-ChildItem $source | Where-Object {$_.Name -match "$pattern"}
        }
   
    }
    foreach($i in $items){
        $nameCurrentDir = $i.Name
        $newSource = "$source\$nameCurrentDir"
        $newDest = "$dest\$nameCurrentDir"
        mkdir -Path $newDest
        Robocopy.exe $newSource $newDest $Robo1 $Robo2 $Robo3 $Robo4
    }
}

