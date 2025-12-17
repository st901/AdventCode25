$TXTinput = Get-Content -Path "$($PSScriptRoot)\input7.txt"
$numRows = $TXTinput.Length
$numCols = $TXTinput[0].Length
write-host "$($numRows)r x $($numCols)c"

$matrix = New-Object 'object[,]' $numRows,$numCols
function zeroMatrix {
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            $matrix[$i,$j] = '.'
        }
    }
}
function populateMatrixTXT{
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            $matrix[$i,$j] = $TXTinput[$i][$j]
        }
    }
}
function printMatrix {
    for ($i = 0; $i -le $numRows;$i++) {
        for ($j = 0; $j -le $numCols;$j++) {
            Write-Host -NoNewline $matrix[$i,$j]
        }
        Write-Host -NoNewline " `n"
    }
}
function firePartOneLazer {
    for ($i = 0; $i -lt ($numRows-1); $i++) {
        for ($j = 0; $j -lt $numCols; $j++) {
            if($matrix[$i,$j] -eq "S"){
                $matrix[($i+1),$j] = "|"
            }
            if($matrix[$i,$j] -eq "|"){
                if($matrix[($i+1),$j] -ne "^"){
                    $matrix[($i+1),$j] = "|"
                }
                else{
                    $matrix[($i+1),($j-1)] = "|"
                    $matrix[($i+1),($j+1)] = "|"
                }
            }
        }
    }
}
$global:splitCount = 0
function countSplits {
    $global:splitCount = 0
    for ($i = 0; $i -lt ($numRows-1); $i++) {
        for ($j = 0; $j -lt $numCols; $j++) {
            if($matrix[$i,$j] -eq "^"){
                if($matrix[($i-1),$j] -eq "|"){
                    $global:splitCount += 1
                }
            }
        }
    }
    write-host "Total Splits : $($global:splitCount)"
}
$global:splitterCount = 0
function countRawSplitters{
    $global:splitterCount = 0
    for ($i = 0; $i -lt ($numRows-1); $i++) {
        for ($j = 0; $j -lt $numCols; $j++) {
            if($matrix[$i,$j] -eq "^"){
                $global:splitterCount += 1
            }
        }
    }
    write-host "Total Splitters : $($global:splitterCount)"
}
function fireLazer ([String] $directions = ""){
    $instruction = 0
    for ($i = 0; $i -lt ($numRows-1); $i++) {
        for ($j = 0; $j -lt $numCols; $j++) {
            if($matrix[$i,$j] -eq "S"){
                $matrix[($i+1),$j] = "|"
            }
            if($matrix[$i,$j] -eq "|"){
                if($matrix[($i+1),$j] -ne "^"){
                    $matrix[($i+1),$j] = "|"
                }
                else{
                    if($instruction -ge $directions.Length){
                        $matrix[($i+1),($j-1)] = "|"
                    }
                    else{
                        if(($directions[$instruction] -eq 'L')){
                            $matrix[($i+1),($j-1)] = "|"
                        }
                        elseif($directions[$instruction] -eq 'R'){
                            $matrix[($i+1),($j+1)] = "|"
                        }
                        $instruction++
                    }
                }
            }
        }
    }
    for ($j = 0; $j -lt $numCols; $j++) {
        if($matrix[-1,$j] -eq "|"){
            return ($j+1)
        }
    }
}

$global:timelineCount = 0
<#
    function theoreticalLazer([String] $directions = $null){
        $instruction = 0
        $solved = New-Object 'object[]' ""
        $solved = $directions
        $x = (($numCols-1)/2)
        for ($i = 0; $i -le $numRows; $i++) {
            #write-host "current : $x : $($matrix[($i),($x)])"
            if($matrix[$i,$x] -eq "^")
            {
                if($instruction -lt $directions.length){
                    if(($directions[$instruction] -eq 'L')){
                        $x -= 1
                    }
                    elseif($directions[$instruction] -eq 'R'){
                        $x += 1
                    }
                    $instruction++
                }
                else{
                    #write-host "Timeline Split! $(([String](($directions)+"R")))"
                    $solved += theoreticalLazer([String](($directions)+"R"))
                    #write-host "Timeline Split! $(([String](($directions)+"L")))"
                    $solved += theoreticalLazer([String](($directions)+"L"))
                    break
                }
            }
            if($i -eq $numRows){
                #write-host "$($directions)"
                $global:timelineCount += 1
                return $solved
            }
        }
    }
#>
function firePartTwoLazer {
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            if($TXTinput[$i][$j] -eq "."){
                $matrix[$i,$j] = 0
            }
            else{
                $matrix[$i,$j] = $TXTinput[$i][$j]
            }
        }
    }
    for ($i = 0; $i -lt ($numRows-1); $i++) {
        for ($j = 0; $j -lt $numCols; $j++) {
            if($matrix[$i,$j] -eq "S"){
                $matrix[($i+1),$j] = (([int64]$matrix[($i+1),$j])+1)
            }
            elseif(($matrix[$i,$j] -gt "0") -and ($matrix[$i,$j] -ne "^")){
                if($matrix[($i+1),$j] -ne "^"){
                    $matrix[($i+1),$j] = (([int64]$matrix[($i+1),$j])+($matrix[$i,$j])) #down 1
                    $matrix[$i,$j] = 0
                }
                else{
                    $matrix[($i+1),($j-1)] = (([int64]$matrix[($i+1),($j-1)])+($matrix[$i,$j])) #down 1 left 1
                    $matrix[($i+1),($j+1)] = (([int64]$matrix[($i+1),($j+1)])+($matrix[$i,$j])) #down 1 right 1
                    #$matrix[$i,$j] = 0
                }
            }
        }
    }
    for ($j = 0; $j -lt $numCols;$j++) {
        if($matrix[-1,$j] -ne "."){
            $global:timelineCount += $matrix[-1,$j]
        }
    }
    write-host "Total Timelines : $($global:timelineCount)"
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            if($matrix[$i,$j] -eq 0){
                $matrix[$i,$j] = ".."
            }
            elseif($matrix[$i,$j] -eq "^"){
                $matrix[$i,$j] = "/\"
            }
            elseif($matrix[$i,$j] -eq "S"){
                $matrix[$i,$j] = "<>"
            }
            elseif($matrix[$i,$j] -le 9){
                $matrix[$i,$j] = "0"+$matrix[$i,$j]
            }

            $matrix[$i,$j] = ""+($matrix[$i,$j])+" "
        }
    }
}


zeroMatrix
populateMatrixTXT
firePartOneLazer
countSplits
#countRawSplitters
firePartTwoLazer
#fireLazer("RRRRRRRRR")
#printMatrix

#theoreticalLazer
#write-host "Total Timelines : $($global:timelineCount)"
# 3135 too low

