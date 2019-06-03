$ProfileDir = $MyInvocation.MyCommand.Path -replace "WindowsPowerShell\\.*$", "WindowsPowerShell"
$ModuleDir = "$ProfileDir\Modules\oftt"
function OutputFrom-TemplateText {
    <#
    .SYNOPSIS
    テンプレートテキストにパラメータを差し込んで出力します。

    .DESCRIPTION
    テンプレートテキストにパラメータを差し込んで出力します。

    .EXAMPLE
    OutputFrom-TemplateText TemplateFile.txt OutputFile.txt
    TemplateFile.txtにパラメータを差し込んで、OutputFile.txtに出力します。

    .EXAMPLE
    OutputFrom-TemplateText TemplateFile.txt
    TemplateFile.txtにパラメータを差し込んで、Write-Hostに出力します。

    .NOTES

    .LINK        
    #>
    param (
        [parameter(mandatory)][String]$TemplateFile # テンプレートファイル
        ,[String]$OutputFile = "stdout" # 出力先(指定がない場合はWrite-Host)
    )

    &"$ModuleDir\src\OutputFrom-TemplateText.ps1" $TemplateFile $OutputFile
}

Export-ModuleMember -Function OutputFrom-TemplateText