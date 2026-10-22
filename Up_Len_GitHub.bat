@echo off
chcp 65001 >nul
title Đẩy Script Lên GitHub - Speed Hub X

echo =======================================================
echo          TỰ ĐỘNG ĐẨY CODE LÊN GITHUB
echo =======================================================
echo.

cd /d "%~dp0"

echo [1/3] Đang kiểm tra thay đổi...
git add .

echo [2/3] Đang lưu commit...
git commit -m "Update Speed Hub X Menu: Fix Slider and UI" 2>nul
if %errorlevel% neq 0 (
    echo Không có thay đổi mới để commit.
)

echo [3/3] Đang đẩy lên GitHub (https://github.com/hiyukilab/ScriptROBLOX)...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo =======================================================
    echo  [THÀNH CÔNG!] Code đã được cập nhật lên GitHub!
    echo =======================================================
    echo.
    echo [Link goc GitHub - Menu All-In-One]:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/Menu_AllInOne.lua"))()
    echo.
    echo [Link rut gon sieu ngan - Menu All-In-One]:
    echo loadstring(game:HttpGet("https://tinyurl.com/speedhubx5"))()
    echo.
    echo [Link goc GitHub - Sample Menu]:
    echo loadstring(game:HttpGet("https://raw.githubusercontent.com/hiyukilab/ScriptROBLOX/main/SampleMenu.lua"))()
    echo.
    echo [Link rut gon sieu ngan - Sample Menu]:
    echo loadstring(game:HttpGet("https://tinyurl.com/24t3o3cx"))()
    echo.
) else (
    echo.
    echo =======================================================
    echo  [LƯU Ý - NẾU LỖI PUSH]
    echo =======================================================
    echo 1. Hãy đảm bảo bạn đã tạo Repo tên 'ScriptROBLOX' trên GitHub:
    echo    👉 https://github.com/new (Đặt tên: ScriptROBLOX, chọn Public)
    echo 2. Đăng nhập tài khoản GitHub khi cửa sổ đăng nhập hiện lên.
    echo.
)

pause
