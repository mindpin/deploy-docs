deploy-docs
===========

## 准备工作
第一次运行需要做一下工作
```
cp config/env.yml.development config/env.yml
cp config/mongoid.yml.development config/mongoid.yml
```

## 启动服务
```
bundle exec rackup
```

## 进入控制台
```
bundle exec irb -r "./lib/app"
```
