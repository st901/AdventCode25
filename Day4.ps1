$TXTinput = Get-Content -Path "$($PSScriptRoot)\input4.txt"
$numRawRows = $TXTinput.Length
$numRawCols = $TXTinput[0].Length
$numRows = $numRawRows + 2
$numCols = $numRawCols + 2
write-host "$($numRows) x $($numCols)"

$matrix = New-Object 'object[,]' $numRows,$numCols
function zeroMatrix {
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            $matrix[$i,$j] = '.'
        }
    }
}

# Populate Matrix
function populateMatrixTXT{
    for ($i = 1; $i -le $numRawRows;$i++) {
        for ($j = 1; $j -le $numRawCols;$j++) {
            $matrix[$i,$j] = $TXTinput[($i-1)][($j-1)]
        }
    }
}

# Calculate Surrounding Free Spaces
function freeSpaceCalc {
    for ($i = 0; $i -lt $numRows;$i++) {
        for ($j = 0; $j -lt $numCols;$j++) {
            $count = 0
            if ($matrix[$i,$j] -ne '.') {
                # NW
                if ($matrix[($i-1),($j-1)] -ne '.') {
                    $count++
                }
                # N
                if ($matrix[($i-1),($j)] -ne '.') {
                    $count++
                }
                # NE
                if ($matrix[($i-1),($j+1)] -ne '.') {
                    $count++
                }
                # W
                if ($matrix[($i),($j-1)] -ne '.') {
                    $count++
                }
                # E
                if ($matrix[($i),($j+1)] -ne '.') {
                    $count++
                }
                # SW
                if ($matrix[($i+1),($j-1)] -ne '.') {
                    $count++
                }
                # S
                if ($matrix[($i+1),($j)] -ne '.') {
                    $count++
                }
                # SE
                if ($matrix[($i+1),($j+1)] -ne '.') {
                    $count++
                }
                $matrix[$i,$j] = 8-$count
            }
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
function printRawMatrix {
    for ($i = 1; $i -le $numRawRows;$i++) {
        for ($j = 1; $j -le $numRawCols;$j++) {
            Write-Host -NoNewline $matrix[$i,$j]
        }
        Write-Host -NoNewline " `n"
    }
}

function partOne {
    zeroMatrix
    populateMatrixTXT
    freeSpaceCalc
    $answer = 0
    for ($i = 1; $i -le $numRawRows;$i++) {
        for ($j = 1; $j -le $numRawCols;$j++) {
            if(($matrix[$i,$j] -gt 4) -and ($matrix[$i,$j] -ne '.')){
                $answer += 1
                Write-Host -NoNewline 'x'
            }
            elseif($matrix[$i,$j] -ne '.'){
                Write-Host -NoNewline '@'
            }
            else{
                Write-Host -NoNewline '.'
            }
        }
        Write-Host -NoNewline " `n"
    }
    Write-Host "TOTAL w/ 4 Free Spaces around : $($answer)"
}

$global:totalRemoved = 0
$global:totalRounds = 0

function removeValues{
    $removed = 0
    for ($i = 1; $i -le $numRawRows;$i++) {
        for ($j = 1; $j -le $numRawCols;$j++) {
            if(($matrix[$i,$j] -gt 4) -and ($matrix[$i,$j] -ne '.')){
                $global:totalRemoved += 1
                $removed += 1
                $matrix[$i,$j] = '.'
            }
        }
    }
    if ($removed -ne 0) {
        $global:totalRounds += 1
        Write-Host "Round $($global:totalRounds) : $($removed)"
    }
    freeSpaceCalc
}

function partTwo {
    zeroMatrix
    populateMatrixTXT
    freeSpaceCalc
    $global:totalRemoved = 0
    $global:totalRounds = 0
    $done = $false
    while ($done -eq $false) {
        $temp = $global:totalRemoved
        removeValues
        if ($temp -eq $global:totalRemoved) {
            $done = $true
        }
    }
    #Print Final Output
    for ($i = 1; $i -le $numRawRows;$i++) {
        for ($j = 1; $j -le $numRawCols;$j++) {
            if(($matrix[$i,$j] -gt 4) -and ($matrix[$i,$j] -ne '.')){
                Write-Host -NoNewline 'x'
            }
            elseif($matrix[$i,$j] -ne '.'){
                Write-Host -NoNewline $matrix[$i,$j]
            }
            else{
                Write-Host -NoNewline '.'
            }
        }
        Write-Host -NoNewline " `n"
    }
    Write-Host "TOTAL Removed after $($global:totalRounds) Rounds : $($global:totalRemoved)"
}

#partOne
partTwo