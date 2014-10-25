# [MailHok](http://mailhok.cn/)

## 启动服务

````
bundle install
bundle exec thin start
````

## 路由配置 

````
````

# 功能说明 

## 坑汇总
  1. jquery#bootstrapValidator
    input[type=submit]的name不可以设置为name => [name conflict](!http://bootstrapvalidator.com/getting-started/#name-conflict)

# 更新日志

1. 2014/10/24

  1. 调整功能结构，管理权限在/cpanel
  2. rspec测试完成controller/view
