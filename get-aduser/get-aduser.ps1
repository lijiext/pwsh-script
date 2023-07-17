$UsernameListPath = ".\users.txt"  # 包含用户名的文本文件路径
$OutputPath = ".\users_info.xlsx"  # 输出Excel文件的路径

# 加载Excel模块
# Install-Module -Name ImportExcel
Import-Module -Name ImportExcel

# 从文本文件中读取用户名列表
$Usernames = Get-Content -Path $UsernameListPath

$UserInfos = foreach ($Username in $Usernames) {
    # 获取用户信息
    $UserInfo = Get-ADUser -Identity $Username -Properties * -ErrorAction SilentlyContinue |
        Select-Object SamAccountName, DisplayName, Description, Enabled, CanonicalName,
            DistinguishedName, AccountExpirationDate, LastLogonDate, Created

    if ($UserInfo) {
        $UserInfo
    } else {
        Write-Host "未找到用户 '$Username' 的信息"
    }
}

if ($UserInfos) {
    # 导出到Excel文件
    $UserInfos | Export-Excel -Path $OutputPath -AutoSize -FreezeTopRow -NoNumberConversion
    Write-Host "用户信息已导出到 $OutputPath"
} else {
    Write-Host "没有用户信息可导出"
}
