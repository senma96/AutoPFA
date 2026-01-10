#pragma once

// =====================================================
// StartCADObj - AutoCAD导出功能（已禁用）
// 原因：缺失外部依赖 mobject.h, ACAD.h, UeRegEdit.h
// =====================================================

#ifndef DISABLE_CAD_EXPORT_FEATURE
#include "mobject.h"

class StartCADObj
{
public:
	StartCADObj(void);
public:
	virtual ~StartCADObj(void);

public:
	void StartUpCAD();
	void SetTabIndex( CString tablIndex );
	CString GetTabIndex();

private:
	void GetActiveAcadDoc(BOOL bAcadR14);
	BOOL WriteFileToCAD(CMObject &refDoc, CString strDrawFileName);
	void DeleteSupportPath();
	void AddSupportPath(const CString &strInsPath);
	CString GetArxFilePath(CString strCADVersion);
	char* ConvertUnicodeToAnsi( IN const wchar_t* pwUNICODE );

private:
	CString m_strTabIndex;
	CMObject m_ObjAcadApp;
	CMObject m_ObjAcadDoc;
};

#else
// 禁用时提供空壳类，防止编译错误
class StartCADObj
{
public:
	StartCADObj(void) {}
	virtual ~StartCADObj(void) {}
	void StartUpCAD() {}
	void SetTabIndex( CString ) {}
	CString GetTabIndex() { return _T(""); }
};
#endif
