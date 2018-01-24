#!/bin/bash
#Script untuk menghapus user SSH & OpenVPN

read -p "Nama user SSH yang akan dihapus : " Pengguna

if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna
        echo -e "บัญชีผู้ใช้ถูกลบเรียบร้อย"
else
        echo -e "ผิดพลาด: ไม่มีบัญชีผู้ใช้."
fi