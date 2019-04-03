# kong-dockerfile
生产环境中kong的镜像脚本和配置

### 扩展功能
1. 镜像中添加了logratate。
2. 添加custom template。

### 目录介绍

主要是生产环境部署时需要用到的文件。

| 文件名               | 介绍                                            |
| ------------------:| -------------------------------------------------------|
| `conf/kong.conf` | 自定义kong日志                      |
| `conf/nginx.template` | 自定义custom模板，目前只修改了access日志log_format字段  |
| `logratate/nginx`  | access日志自动切割的任务配置                 |
| `plugin`   | kong 的自定义插件                              |
| `Dockerfile` | 添加了logratate和custom template          |
