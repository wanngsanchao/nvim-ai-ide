# nvim-ai-ide
```
#nvim的使用需要依赖.config这个配置文件，所以需要把当前项目中的.config这个目录下载本地，然后再镜像拉取完毕之后，把配置映射到容器内部，这个容器默认的会启动ssh服务

#下载镜像
docker pull crpi-9a6lqevuer83t1kj.cn-hangzhou.personal.cr.aliyuncs.com/wsc-namespace/nvim-ide-ai:v1.0.0

#启动开发环境,这里的data的目录是项目目录，可以根据实际情况进行挂载
docker run -d --name dev-env   -p 5555:22   -v /root/projects:/data   -v /root/nvim-ide/.config/nvim:/root/.config/nvim crpi-9a6lqevuer83t1kj.cn-hangzhou.personal.cr.aliyuncs.com/wsc-namespace/nvim-ide-ai:v1.0.0 

```
