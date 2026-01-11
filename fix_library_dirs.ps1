# PowerShell 脚本：批量修改所有 .vcxproj 文件的附加库目录
# 使用方法：右键此文件 -> "使用 PowerShell 运行"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 定义正确的库目录（两个目录都包含，确保能找到）
$libraryDirectories = "`$(SolutionDir)..\Libd;`$(SolutionDir)Libd;C:\ObjectARX 2007\lib-win32"

# 查找所有 .vcxproj 文件
$vcxprojFiles = Get-ChildItem -Path $scriptDir -Recurse -Filter "*.vcxproj"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "批量修改附加库目录" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "目标库目录: $libraryDirectories" -ForegroundColor Yellow
Write-Host ""
Write-Host "找到 $($vcxprojFiles.Count) 个 .vcxproj 文件" -ForegroundColor Cyan
Write-Host ""

foreach ($file in $vcxprojFiles) {
    Write-Host "处理: $($file.Name)" -ForegroundColor Yellow
    
    # 读取文件内容
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # 加载 XML
    [xml]$xml = $content
    
    $modified = $false
    
    # 遍历所有 ItemDefinitionGroup（包含 Debug 和 Release 配置）
    foreach ($itemDefGroup in $xml.Project.ItemDefinitionGroup) {
        
        # 处理 Link（链接器设置）
        $link = $itemDefGroup.Link
        if ($link) {
            $existingLibDirs = $link.AdditionalLibraryDirectories
            
            # 检查是否需要更新
            $needsUpdate = $true
            if ($existingLibDirs -and $existingLibDirs.Contains('$(SolutionDir)..\Libd')) {
                $needsUpdate = $false
            }
            
            if ($needsUpdate) {
                if ($existingLibDirs) {
                    # 已有设置，添加我们的路径
                    if (-not $existingLibDirs.Contains('$(SolutionDir)..\Libd')) {
                        $link.AdditionalLibraryDirectories = $libraryDirectories + ";" + $existingLibDirs
                        $modified = $true
                    }
                } else {
                    # 创建新的元素
                    $newElem = $xml.CreateElement("AdditionalLibraryDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                    $newElem.InnerText = $libraryDirectories
                    $link.AppendChild($newElem) | Out-Null
                    $modified = $true
                }
            }
        }
        
        # 处理 Lib（库管理器设置，用于静态库项目）
        $lib = $itemDefGroup.Lib
        if ($lib) {
            $existingLibDirs = $lib.AdditionalLibraryDirectories
            
            if (-not $existingLibDirs -or -not $existingLibDirs.Contains('$(SolutionDir)..\Libd')) {
                if ($existingLibDirs) {
                    $lib.AdditionalLibraryDirectories = $libraryDirectories + ";" + $existingLibDirs
                } else {
                    $newElem = $xml.CreateElement("AdditionalLibraryDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                    $newElem.InnerText = $libraryDirectories
                    $lib.AppendChild($newElem) | Out-Null
                }
                $modified = $true
            }
        }
    }
    
    # 保存修改后的文件
    if ($modified) {
        $xml.Save($file.FullName)
        Write-Host "  已修改" -ForegroundColor Green
    } else {
        Write-Host "  无需修改" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "完成！请重新打开 VS2022 解决方案" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Read-Host "按 Enter 键退出"

