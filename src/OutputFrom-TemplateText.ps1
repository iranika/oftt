param (
    [parameter(mandatory)][String]$TemplateFile
    ,[String]$OutputFile = "stdout"
    ,[String]$Pattern = "<(?:(?!<|>).)*>"
)

function Get-RepPatternFromTemplate {
    param (
        [parameter(mandatory)][String]$TemplateFile
    )

    $RepPatternsAll = (Get-Content $TemplateFile | Select-String -AllMatches -Pattern $Pattern).Matches.Value
    $RepPatternsUniqe = @()
    foreach ($_ in $RepPatternsAll){
        
        if ($_ -in $RepPatternsUniqe){
            continue
        }
        $RepPatternsUniqe += $_
    }
    return $RepPatternsUniqe
}


function Get-ReplacedTemplateText {
    param(
        [parameter(mandatory)]$RepItems
        ,[parameter(mandatory)][String]$TemplateFile
    )

    $tmp = Get-Content $TemplateFile -Raw
    foreach($item in $RepItems){
        $tmp = ($tmp -replace $item.pattern, $item.replacement)
    }

    return $tmp
}

##以下、メイン処理
$RepPatterns = Get-RepPatternFromTemplate($TemplateFile)
Write-Host $RepPatterns
$RepItems = @()
Write-Host "各パラメーターの値を入力してください"
foreach($pattern in $RepPatterns){
    $replacement = Read-Host($pattern)
    $RepItems += @{pattern=$pattern; replacement=$replacement}
}
Write-Host "以下の内容でよろしいですか？"
foreach($item in $RepItems){
    Write-Host "$($item.pattern) : $($item.replacement)"
}
if ((Read-Host("y/n")) -ne "y"){
    Write-Host "同意が得られませんでした。処理を終了します"
    return
}

if ($OutputFile -eq "stdout"){
    Get-ReplacedTemplateText $RepItems $TemplateFile | Write-Host
}else{
    Get-ReplacedTemplateText $RepItems $TemplateFile | Out-File -FilePath $OutputFile -Encoding default

}
