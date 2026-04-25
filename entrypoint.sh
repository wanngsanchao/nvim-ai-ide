#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: wsc
# mail: 1874417000@qq.com
# Created Time: 2026-03-18 01:12:10
#########################################################################
# entrypoint.sh

# 启动 SSHD 的前台模式
echo "Starting SSH daemon..."
exec /usr/sbin/sshd -D -e

