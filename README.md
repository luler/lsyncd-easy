# 实时文件同步工具

基于lsyncd服务镜像构建的实时文件同步工具，旨在进一步简化配置，快速搭建

# 安装

第一步：

- 需要备份的目标服务器上执行ssh-copy-id登录备份服务器,登录账号自定义，具有对应目录操作权限即可。注意：如果目标服务器还没有设置公私钥，执行ssh-keygen命令，一直按回车即可
```
ssh-copy-id root@111.111.111.111
```

第二步：

- 登录的目的是获取到登录授权配置，一般保存在~/.ssh目录下，登录之后复制~/.ssh到项目的配置目录

```
cp -r ~/.ssh ./config/
```

第三步：

- 配置config/lsyncd.lua，一般只需要配置sync下的host、targetdir参数，其他参数不需要特别设置的话则保留默认即可

``` 
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
```

第四步，修改docker-compose.yml的目录映射，配置你需要同步的目录，然后启动即可

```
version: '3'
services:
  lsyncd:
    build: .
    volumes:
      # 把主机的./source目录换成需要的同步的目录即可
      - ./source:/home/source
    restart: always
```

启动，注意每次修改配置都需要重新构建镜像的，所以一律执行下面命令即可

``` 
docker-compose up -d --build
```

后续可通过下面命令查看同步日志情况

``` 
docker-compose logs
```

# 参考文档

- https://lsyncd.github.io/lsyncd/manual/config/file/
- https://hub.docker.com/r/theorangeone/lsyncd