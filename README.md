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


### 设计逻辑

  1. creator_id/editor_id不可同时设置为`:required => true`

    这个字段分别在创建/更新两个阶段使用，同时设置为必填，等同于两条腿互绊.

  2. pre_paid_code生成不可以放在model`after :save do |model|`中

    为了保证pre_paid_code的唯一性&简洁性，其中包含model#id.
    真正的pre_paid_code生成是在save后再update.
    如果放在`after :save do`中，并做update，会无限循环下去.


### 技术相关

  1. jquery#bootstrapValidator

    input[type=submit]的name不可以设置为name => [name conflict](!http://bootstrapvalidator.com/getting-started/#name-conflict)

  2. DataMapper#自动更新字段

    [dm-timestamps](!http://datamapper.org/docs/dm_more/timestamps.html)

    ````
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date
    ````

  3. DataMapper#保存失败

    Gemfile

    ````
    gem "dm-validations", "~>1.2.0"
    ````

    model

    ````
    require "dm-validations"
    ````

    controller

    ````
    Order.raise_on_save_failure = false
    order = current_user.orders.new(order_params)
    if not order.save
      puts "Failed to save order: %s" % order.errors.inspect
    end
    ````

# 更新日志

1. 2014/10/26

  1. 调整功能结构，管理权限在/cpanel

2. 2014/10/30
  
  1. DataMapper通用代码，提取放在/lib/utils/data_mapper/model.rb
