# PowerShell 脚本：批量修改所有 .vcxproj 文件
# 使用方法：在 VS2022 开发者 PowerShell 中运行此脚本
# 或者右键此文件 -> "使用 PowerShell 运行"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 定义要添加的包含目录
$includeDirectories = @"
C:\ObjectARX 2007\inc;C:\ObjectARX 2007\inc-win32;`$(SolutionDir)..\AFTDriver\Inc;`$(SolutionDir)..\AFTInterface\inc;`$(SolutionDir)..\APQuantity\Inc;`$(SolutionDir)..\CalcDriver\inc;`$(SolutionDir)..\CalcInterface\inc;`$(SolutionDir)..\DataSource\INC;`$(SolutionDir)..\DBTableDriver\inc;`$(SolutionDir)..\ImpulseDriver\inc;`$(SolutionDir)..\InterfaceMgr\inc;`$(SolutionDir)..\MocCalc\inc;`$(SolutionDir)..\PCFDriver\inc;`$(SolutionDir)..\PCFInterface\inc;`$(SolutionDir)..\Persistent\Inc;`$(SolutionDir)..\PFAResult\inc;`$(SolutionDir)..\UnitSystem\INC;`$(SolutionDir)..\USChart\inc
"@

$resourceIncludeDirectories = @"
`$(SolutionDir)..\AFTDriver\Inc;`$(SolutionDir)..\AFTInterface\inc;`$(SolutionDir)..\APQuantity\Inc;`$(SolutionDir)..\CalcDriver\inc;`$(SolutionDir)..\CalcInterface\inc;`$(SolutionDir)..\DataSource\INC;`$(SolutionDir)..\DBTableDriver\inc;`$(SolutionDir)..\ImpulseDriver\inc;`$(SolutionDir)..\InterfaceMgr\inc;`$(SolutionDir)..\MocCalc\inc;`$(SolutionDir)..\PCFDriver\inc;`$(SolutionDir)..\PCFInterface\inc;`$(SolutionDir)..\Persistent\Inc;`$(SolutionDir)..\PFAResult\inc;`$(SolutionDir)..\UnitSystem\INC;`$(SolutionDir)..\USChart\inc;C:\ObjectARX 2007\inc;C:\ObjectARX 2007\inc-win32
"@

$libraryDirectories = "C:\ObjectARX 2007\lib-win32"

# 查找所有 .vcxproj 文件
$vcxprojFiles = Get-ChildItem -Path $scriptDir -Recurse -Filter "*.vcxproj"

Write-Host "找到 $($vcxprojFiles.Count) 个 .vcxproj 文件" -ForegroundColor Cyan
Write-Host ""

foreach ($file in $vcxprojFiles) {
    Write-Host "处理: $($file.FullName)" -ForegroundColor Yellow
    
    # 读取文件内容
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # 1. 替换 D:\pfalib\Libd 为 $(SolutionDir)..\Libd
    $content = $content -replace 'D:\\pfalib\\Libd\\?', '$(SolutionDir)..\Libd\'
    $content = $content -replace 'D:/pfalib/Libd/?', '$(SolutionDir)../Libd/'
    
    # 2. 替换 D:\pfalib\Lib 为 $(SolutionDir)..\Lib
    $content = $content -replace 'D:\\pfalib\\Lib\\?', '$(SolutionDir)..\Lib\'
    $content = $content -replace 'D:/pfalib/Lib/?', '$(SolutionDir)../Lib/'
    
    # 3. 替换 D:\pfalib 为 $(SolutionDir)..
    $content = $content -replace 'D:\\pfalib\\?', '$(SolutionDir)..\'
    $content = $content -replace 'D:/pfalib/?', '$(SolutionDir)../'
    
    # 加载 XML
    [xml]$xml = $content
    $ns = @{ms = "http://schemas.microsoft.com/developer/msbuild/2003"}
    
    $modified = $false
    
    # 遍历所有 ItemDefinitionGroup（包含 Debug 和 Release 配置）
    foreach ($itemDefGroup in $xml.Project.ItemDefinitionGroup) {
        # 处理 ClCompile（C/C++ 编译器设置）
        $clCompile = $itemDefGroup.ClCompile
        if ($clCompile) {
            # 检查是否已有 AdditionalIncludeDirectories
            $existingIncludes = $clCompile.AdditionalIncludeDirectories
            if ($existingIncludes) {
                # 如果不包含我们的路径，则替换
                if (-not $existingIncludes.Contains('$(SolutionDir)..\AFTDriver\Inc')) {
                    $clCompile.AdditionalIncludeDirectories = $includeDirectories
                    $modified = $true
                }
            } else {
                # 创建新的元素
                $newElem = $xml.CreateElement("AdditionalIncludeDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                $newElem.InnerText = $includeDirectories
                $clCompile.AppendChild($newElem) | Out-Null
                $modified = $true
            }
        }
        
        # 处理 ResourceCompile（资源编译器设置）
        $resourceCompile = $itemDefGroup.ResourceCompile
        if ($resourceCompile) {
            $existingResIncludes = $resourceCompile.AdditionalIncludeDirectories
            if ($existingResIncludes) {
                if (-not $existingResIncludes.Contains('$(SolutionDir)..\AFTDriver\Inc')) {
                    $resourceCompile.AdditionalIncludeDirectories = $resourceIncludeDirectories
                    $modified = $true
                }
            } else {
                $newElem = $xml.CreateElement("AdditionalIncludeDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                $newElem.InnerText = $resourceIncludeDirectories
                $resourceCompile.AppendChild($newElem) | Out-Null
                $modified = $true
            }
        }
        
        # 处理 Link（链接器设置）- 添加库目录
        $link = $itemDefGroup.Link
        if ($link) {
            $existingLibDirs = $link.AdditionalLibraryDirectories
            if ($existingLibDirs) {
                if (-not $existingLibDirs.Contains('ObjectARX')) {
                    $link.AdditionalLibraryDirectories = $existingLibDirs + ";" + $libraryDirectories
                    $modified = $true
                }
            } else {
                $newElem = $xml.CreateElement("AdditionalLibraryDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                $newElem.InnerText = $libraryDirectories
                $link.AppendChild($newElem) | Out-Null
                $modified = $true
            }
        }
        
        # 处理 Lib（库管理器设置，用于静态库）
        $lib = $itemDefGroup.Lib
        if ($lib) {
            $existingLibDirs = $lib.AdditionalLibraryDirectories
            if (-not $existingLibDirs) {
                $newElem = $xml.CreateElement("AdditionalLibraryDirectories", "http://schemas.microsoft.com/developer/msbuild/2003")
                $newElem.InnerText = $libraryDirectories
                $lib.AppendChild($newElem) | Out-Null
                $modified = $true
            }
        }
    }
    
    # 保存修改后的文件
    if ($modified -or ($content -ne $originalContent)) {
        $xml.Save($file.FullName)
        Write-Host "  已修改并保存" -ForegroundColor Green
    } else {
        Write-Host "  无需修改" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "批量处理完成！" -ForegroundColor Green
Write-Host "请重新打开 VS2022 解决方案" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Read-Host "按 Enter 键退出"

