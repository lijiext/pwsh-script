$UsernameListPath = ".\users.txt"  # 包含用户名的文本文件路径
$OutputPath = ".\user_info.csv"  # 输出CSV文件的路径

# 从文本文件中读取用户名列表
$Usernames = Get-Content -Path $UsernameListPath

$UserInfos = foreach ($Username in $Usernames) {
    # 获取用户信息
    $UserInfo = Get-ADUser -Identity $Username -Properties * -ErrorAction SilentlyContinue |
    Select-Object SamAccountName, DisplayName, Description, Enabled, CanonicalName,
    DistinguishedName, AccountExpirationDate, LastLogonDate, Created

    if ($UserInfo) {
        $UserInfo
    }
    else {
        Write-Host "未找到用户 '$Username' 的信息"
    }
}

if ($UserInfos) {
    # 导出到CSV文件
    $UserInfos | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Host "用户信息已导出到 $OutputPath"
}
else {
    Write-Host "没有用户信息可导出"
}