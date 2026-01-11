# AutoPFA 编译配置指南

## 📋 项目简介

**优易管网流体分析软件 AutoPFA 8.0** - 管网流体分析软件，用于管道系统的流体动力学分析。

---

## 🔧 环境要求

| 项目 | 版本/要求 |
|------|----------|
| **IDE** | Visual Studio 2022 |
| **平台工具集** | v145 |
| **Windows SDK** | Windows 10.0 SDK |
| **配置** | Debug / Win32 |
| **外部依赖** | AutoCAD ObjectARX 2007 SDK |

---

## 📁 目录结构

```
AutoPFA_clone/
├── AFTDriver/          # AFT驱动模块
├── AFTInterface/       # AFT接口模块
├── APQuantity/         # 单位数量模块
├── AutoPFA/            # 主程序（解决方案在此目录）
├── CalcDriver/         # 计算驱动模块
├── CalcInterface/      # 计算接口模块
├── DataSource/         # 数据源模块
├── DBTableDriver/      # 数据库表驱动
├── ImpulseDriver/      # 脉冲驱动模块
├── InterfaceMgr/       # 接口管理器
├── MocCalc/            # MOC计算模块
├── PCFDriver/          # PCF驱动模块
├── PCFInterface/       # PCF接口模块
├── Persistent/         # 持久化模块
├── PFAResult/          # 结果模块
├── UnitSystem/         # 单位系统模块
├── USChart/            # 图表模块
├── Libd/               # Debug输出目录（DLL、LIB、EXE）
├── Lib/                # Release输出目录
├── 编译必须文件/        # 运行时必需的配置文件
└── 开发文档/           # 开发文档
```

---

## 🚀 编译步骤

### 第一步：安装 ObjectARX 2007 SDK

1. 下载 AutoCAD ObjectARX 2007 SDK
2. 安装到 `C:\ObjectARX 2007\`
3. 确保以下目录存在：
   - `C:\ObjectARX 2007\inc\`
   - `C:\ObjectARX 2007\inc-win32\`
   - `C:\ObjectARX 2007\lib-win32\`

### 第二步：打开解决方案

1. 用 VS2022 打开 `AutoPFA\AutoPFA.sln`
2. 如果提示升级项目，选择"确定"

### 第三步：配置所有子项目

对**每个子项目**执行以下配置：

#### 3.1 设置附加包含目录

**配置属性** → **C/C++** → **常规** → **附加包含目录**：

```
C:\ObjectARX 2007\inc;C:\ObjectARX 2007\inc-win32;$(SolutionDir)..\AFTDriver\Inc;$(SolutionDir)..\AFTInterface\inc;$(SolutionDir)..\APQuantity\Inc;$(SolutionDir)..\CalcDriver\inc;$(SolutionDir)..\CalcInterface\inc;$(SolutionDir)..\DataSource\INC;$(SolutionDir)..\DBTableDriver\inc;$(SolutionDir)..\ImpulseDriver\inc;$(SolutionDir)..\InterfaceMgr\inc;$(SolutionDir)..\MocCalc\inc;$(SolutionDir)..\PCFDriver\inc;$(SolutionDir)..\PCFInterface\inc;$(SolutionDir)..\Persistent\Inc;$(SolutionDir)..\PFAResult\inc;$(SolutionDir)..\UnitSystem\INC;$(SolutionDir)..\USChart\inc
```

#### 3.2 设置资源编译器包含目录（如有.rc文件）

**配置属性** → **资源** → **常规** → **附加包含目录**：

（同上）

#### 3.3 设置附加库目录

**配置属性** → **链接器** → **常规** → **附加库目录**：

```
C:\Users\code\PFA\AutoPFA_clone\Libd;C:\ObjectARX 2007\lib-win32
```

> 💡 也可使用：`$(SolutionDir)..\Libd;C:\ObjectARX 2007\lib-win32`

#### 3.4 设置输出目录

**配置属性** → **常规**：

| 设置 | Debug值 |
|------|---------|
| 输出目录 | `$(SolutionDir)..\Libd\` |
| 中间目录 | `$(Configuration)\` |
| 目标文件名 | `$(ProjectName)d` |

#### 3.5 设置链接器输出

**配置属性** → **链接器** → **常规** → **输出文件**：

```
$(SolutionDir)..\Libd\$(TargetName)$(TargetExt)
```

### 第四步：配置 AutoPFA 主项目

#### 4.1 附加依赖项

**链接器** → **输入** → **附加依赖项**：

```
Persistentd.lib;APQuantity10d.lib;USChartd.lib;MOCCacld.lib;CalcDriverd.lib;PFAResultd.lib;UnitSystemd.lib;DBTableDriverd.lib;InterfaceMgrd.lib;AFTInterfaced.lib;CalcInterfaced.lib;ImpulseDriverd.lib;HTMLHELP.LIB;AFTDriverd.lib;DataSource.lib;%(AdditionalDependencies)
```

> ⚠️ 已移除不存在的外部库：`APGlobalShare10d.lib`, `GetPropertyofMaterial10d.lib`, `DataFormatDlgd.lib`

#### 4.2 禁用 SAFESEH

**链接器** → **高级** → **映像具有安全异常处理程序**：设为 **否 (/SAFESEH:NO)**

### 第五步：按顺序编译

**必须按以下顺序单独编译**（右键项目 → 生成）：

```
第一批（基础库）：
1. APQuantity
2. UnitSystem
3. Persistent
4. DataSource
5. AFTDriver

第二批：
6. AFTInterface
7. PFAResult
8. CalcInterface
9. PCFInterface

第三批：
10. InterfaceMgr
11. ImpulseDriver
12. CalcDriver
13. PCFDriver
14. DBTableDriver
15. MocCalc
16. USChart

最后：
17. AutoPFA
```

### 第六步：复制运行时文件

将以下文件复制到 `Libd\` 目录：

1. **配置文件**（从 `编译必须文件\` 目录）：
   - `QuantityConfig.txt` （必须！单位配置）
   - `outputref.txt`
   - `FourQuadrantData.txt`
   - `AutoPFA.txt`

2. **ObjectARX DLL**（从 `C:\ObjectARX 2007\` 目录）：
   - `AcGe17.dll`
   - 其他 `Ac*.dll` 文件

---

## ⚠️ 常见问题解决

### 问题1：找不到头文件

**错误**：`Cannot open include file: 'xxx.h'`

**解决**：检查 **附加包含目录** 是否正确设置

### 问题2：找不到库文件

**错误**：`LNK1104: 无法打开文件 "xxxd.lib"`

**解决**：
1. 检查 **附加库目录** 是否包含 `Libd` 路径
2. 确认依赖项目已编译成功
3. 检查 `Libd` 文件夹中是否有该文件

### 问题3：SAFESEH 错误

**错误**：`LNK1281: 无法生成 SAFESEH 映像`

**解决**：**链接器** → **高级** → **映像具有安全异常处理程序** → **否**

### 问题4：输出路径错误

**错误**：`MSB3191: 无法创建目录 "D:\pfalib\Libd"`

**解决**：修改 **输出目录** 为 `$(SolutionDir)..\Libd\`

### 问题5：单位加载失败

**错误**：程序启动时提示"单位加载失败"

**解决**：将 `编译必须文件\QuantityConfig.txt` 复制到 exe 所在目录

### 问题6：缺少 DLL

**错误**：`无法启动此程序，因为计算机中丢失 xxx.dll`

**解决**：将所有编译生成的 DLL 和 ObjectARX 的 DLL 复制到 exe 目录

---

## 📝 禁用的功能

由于缺少外部依赖库，以下功能已在代码中禁用：

| 功能 | 原因 | 相关宏定义 |
|------|------|-----------|
| CAD导出 | 缺少 ObjectARX SDK 完整文件 | `DISABLE_CAD_EXPORT_FEATURE` |
| 数据格式导出 | 缺少 DataFormatDll.lib | `DISABLE_DATA_FORMAT_DLL` |
| 材料属性查询 | 缺少 GetPropertyofMaterial.lib | 代码注释 |

相关代码修改：
- `AutoPFA/AutoPFADoc.cpp`
- `AutoPFA/StartCADObj.h`
- `AutoPFA/StartCADObj.cpp`
- `AutoPFA/dlgpipemodel.cpp`

---

## 📂 Libd 目录应包含的文件

编译成功后，`Libd` 目录应包含：

### DLL 文件
- AFTDriverd.dll
- AFTInterfaced.dll
- APQuantityd.dll
- CalcDriverd.dll
- CalcInterfaced.dll
- DataSource.dll
- DBTableDriverd.dll
- ImpulseDriverd.dll
- InterfaceMgrd.dll
- MOCCacld.dll
- PCFDriverd.dll
- PCFInterfaced.dll
- Persistentd.dll
- PFAResultd.dll
- UnitSystemd.dll
- USChartd.dll

### LIB 文件
- 对应的 .lib 文件

### 配置文件
- QuantityConfig.txt
- outputref.txt
- FourQuadrantData.txt
- AutoPFA.txt

### 可执行文件
- AutoPFAd.exe

### ObjectARX DLL（如需要）
- AcGe17.dll
- 其他 Ac*.dll

---

## 🔄 Git 同步

```bash
# 设置 Git（解决中文文件名问题）
git config core.precomposeunicode false

# 拉取代码
git pull origin master

# 提交更改
git add -A
git commit -m "提交说明"
git push origin master
```

---

## 📞 联系方式

如有问题，请联系项目维护者。

---

**最后更新**：2026年1月11日

