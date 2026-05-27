# Linux 常用命令速查表

## 一、文件与目录操作

| 命令 | 说明 | 示例 |
|------|------|------|
| `ls` | 列出目录内容 | `ls -la` 显示所有文件（含隐藏）及详细信息 |
| `cd` | 切换目录 | `cd /home` 进入 /home 目录 |
| `pwd` | 显示当前目录路径 | `pwd` |
| `mkdir` | 创建目录 | `mkdir dir1` |
| `rmdir` | 删除空目录 | `rmdir empty_dir` |
| `rm` | 删除文件或目录 | `rm -rf file_or_dir`（慎用） |
| `cp` | 复制文件/目录 | `cp src dest`，`cp -r dir1 dir2` |
| `mv` | 移动或重命名 | `mv old new` |
| `touch` | 创建空文件或更新时间戳 | `touch file.txt` |
| `ln` | 创建链接 | `ln -s target link` 软链接 |
| `file` | 查看文件类型 | `file somefile` |
| `stat` | 显示文件状态信息 | `stat file` |

## 二、文本查看与处理

| 命令 | 说明 | 示例 |
|------|------|------|
| `cat` | 连接并显示文件内容 | `cat file1 file2` |
| `tac` | 倒序显示文件内容 | `tac file` |
| `more` | 分页查看（只能向下） | `more bigfile` |
| `less` | 分页查看（可上下翻页） | `less bigfile` |
| `head` | 显示文件开头若干行 | `head -n 20 file` |
| `tail` | 显示文件末尾若干行 | `tail -f log` 实时追踪 |
| `grep` | 搜索文本 | `grep "pattern" file` |
| `sed` | 流编辑器（替换/删除等） | `sed 's/old/new/g' file` |
| `awk` | 文本处理/报告生成 | `awk '{print $1}' file` |
| `sort` | 排序 | `sort file` |
| `uniq` | 去重（通常先排序） | `sort file \| uniq` |
| `wc` | 统计行、词、字符数 | `wc -l file` |
| `cut` | 提取列 | `cut -d',' -f1 file.csv` |
| `diff` | 比较两个文件 | `diff file1 file2` |

## 三、权限与所有者

| 命令 | 说明 | 示例 |
|------|------|------|
| `chmod` | 修改权限 | `chmod 755 script.sh` |
| `chown` | 修改所有者 | `chown user:group file` |
| `chgrp` | 修改所属组 | `chgrp group file` |
| `umask` | 设置默认权限掩码 | `umask 022` |

## 四、进程管理

| 命令 | 说明 | 示例 |
|------|------|------|
| `ps` | 查看进程 | `ps aux` 或 `ps -ef` |
| `top` | 动态显示进程（实时） | `top`，按 `q` 退出 |
| `htop` | 更友好的 top（需安装） | `htop` |
| `kill` | 终止进程 | `kill -9 PID` |
| `pkill` | 按名称杀进程 | `pkill firefox` |
| `jobs` | 查看后台任务 | `jobs` |
| `bg` | 将任务放到后台运行 | `bg %1` |
| `fg` | 将后台任务调到前台 | `fg %1` |
| `nohup` | 忽略挂断信号运行 | `nohup command &` |
| `nice` / `renice` | 调整进程优先级 | `nice -n 10 command` |

## 五、系统信息与管理

| 命令 | 说明 | 示例 |
|------|------|------|
| `uname` | 显示系统信息 | `uname -a` |
| `whoami` | 当前用户名 | `whoami` |
| `id` | 显示用户 ID 和组 ID | `id` |
| `hostname` | 主机名 | `hostname` |
| `uptime` | 系统运行时间及负载 | `uptime` |
| `dmesg` | 内核日志 | `dmesg \| tail` |
| `free` | 内存使用情况 | `free -h` |
| `df` | 磁盘分区使用 | `df -h` |
| `du` | 目录/文件占用空间 | `du -sh *` |
| `date` | 显示或设置时间 | `date` |
| `cal` | 显示日历 | `cal 2025` |
| `reboot` | 重启 | `sudo reboot` |
| `shutdown` | 关机 | `sudo shutdown -h now` |

## 六、网络相关

| 命令 | 说明 | 示例 |
|------|------|------|
| `ping` | 测试网络连通性 | `ping google.com` |
| `ifconfig` | 查看/配置网络接口（旧） | `ifconfig` |
| `ip` | 更现代的网络配置工具 | `ip addr show` |
| `netstat` | 网络状态、路由表等 | `netstat -tuln` |
| `ss` | 类似 netstat，更快 | `ss -tuln` |
| `curl` | 传输数据（支持 HTTP 等） | `curl https://example.com` |
| `wget` | 下载文件 | `wget http://file.zip` |
| `ssh` | 远程登录 | `ssh user@host` |
| `scp` | 远程复制文件 | `scp local.txt user@host:/path` |
| `rsync` | 高效同步文件 | `rsync -av src/ dest/` |

## 七、压缩与打包

| 命令 | 说明 | 示例 |
|------|------|------|
| `tar` | 打包/解包（常与压缩结合） | `tar -czvf archive.tar.gz dir/`（创建）<br>`tar -xzvf archive.tar.gz`（解压） |
| `gzip` / `gunzip` | 压缩/解压 .gz | `gzip file` |
| `zip` / `unzip` | 处理 .zip 文件 | `zip -r archive.zip dir/`<br>`unzip archive.zip` |

## 八、用户与组管理（需 root/sudo）

| 命令 | 说明 | 示例 |
|------|------|------|
| `useradd` | 添加用户 | `sudo useradd -m username` |
| `passwd` | 修改密码 | `passwd username` |
| `userdel` | 删除用户 | `sudo userdel username` |
| `groupadd` | 添加组 | `sudo groupadd groupname` |
| `usermod` | 修改用户属性 | `sudo usermod -aG sudo username` |

## 九、查找与定位

| 命令 | 说明 | 示例 |
|------|------|------|
| `find` | 按条件查找文件 | `find /home -name "*.txt"` |
| `locate` | 从数据库快速查找（需 updatedb） | `locate passwd` |
| `which` | 查找命令的路径 | `which ls` |
| `whereis` | 查找命令的二进制、源码、手册 | `whereis python` |

## 十、快捷键与帮助

| 快捷键/命令 | 说明 |
|-------------|------|
| `man` | 查看命令手册（如 `man ls`） |
| `info` | 更详细的 GNU 信息页 |
| `whatis` | 简要描述命令 |
| `Tab` | 自动补全命令或路径 |
| `Ctrl + C` | 终止当前进程 |
| `Ctrl + Z` | 挂起当前进程 |
| `Ctrl + D` | 退出终端或发送 EOF |
| `Ctrl + L` | 清屏（同 `clear`） |
| `↑` / `↓` | 历史命令切换 |

---

> 提示：使用 `man <command>` 可查看命令的详细手册。
