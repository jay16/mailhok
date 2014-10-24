$(document).ready ->
  # Generate a simple captcha
  randomNumber = (min, max) ->
    Math.floor Math.random() * (max - min + 1) + min
  $("#captchaOperation").html [
    randomNumber(1, 100)
    "+"
    randomNumber(1, 200)
    "="
  ].join(" ")
  $("#defaultForm").bootstrapValidator
    message: "填写项不符全要求"
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "user[email]":
        validators:
          notEmpty:
            message: "登陆邮箱为必填项!"
          emailAddress:
            message: "邮箱地址无效"
      "user[password]":
        validators:
          notEmpty:
            message: "登陆密码为必填项"
          identical:
            field: "confirm_password"
            message: "登陆密码与确认密码不一致"
          different:
            field: "user[name]"
            message: "登陆密码不可以与用户名称相同"
      confirm_password:
        validators:
          notEmpty:
            message: "确认密码为必填项"
          identical:
            field: "user[password]"
            message: "确认密码与登陆密码不致"
          different:
            field: "user[name]"
            message: "确认密码不可以与用户名称相同"
      captcha:
        validators:
          callback:
            message: "计算错误"
            callback: (value, validator) ->
              items = $("#captchaOperation").html().split(" ")
              sum = parseInt(items[0]) + parseInt(items[2])
              value is sum
  # Validate the form manually
  $("#validateBtn").click ->
    $("#defaultForm").bootstrapValidator "validate"

  $("#resetBtn").click ->
    $("#defaultForm").data("bootstrapValidator").resetForm true
