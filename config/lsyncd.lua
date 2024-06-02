settings {
    logfile = "/config/lsyncd.log",
    statusFile = "/config/lsyncd-status.log",
    statusInterval = 20
}

sync {
    default.rsyncssh, -- 同步模式,可选"rsync"(本地)、"rsyncssh"(远程)、"direct"(本地cp)
    source = "/home/source", -- 源目录路径
    host = "root@111.111.111.111",
    targetdir = "/root/source",
    --excludeFrom = "/config/exclude.lst", -- 使用外部文件进行排除
    rsync = {
        archive = true, -- 传输选项,表示递归并保持文件属性
        compress = true, -- 是否压缩传输
        perms = true, -- 保持权限
        _extra = { "--exclude=*.log" } -- 使用 _extra 传递额外的 rsync 选项
    },
    delete = true, -- 同步删除操作
    delay = 5, -- 累积事件延迟同步时间(秒)
    ssh = {
        port = 22
    }
}