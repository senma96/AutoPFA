#pragma once

// 简化版 ResourcePathManager - 替代缺失的原始文件
// 原始功能：获取共享数据库路径
// 简化实现：返回当前目录或空字符串

class ResourcePathManager
{
public:
    static ResourcePathManager& Instance()
    {
        static ResourcePathManager instance;
        return instance;
    }

    // 返回共享数据库路径（简化实现）
    CString GetOldSoftShareDbPath()
    {
        // TODO: 修改为实际的数据库路径
        // 例如: return _T("C:\\AutoPFA\\ShareDB\\");
        return _T("");
    }

private:
    ResourcePathManager() {}
    ResourcePathManager(const ResourcePathManager&);
    ResourcePathManager& operator=(const ResourcePathManager&);
};

