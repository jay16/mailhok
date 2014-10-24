$ ->
  $("#package_form").bootstrapValidator
    message: "填写内容不符合要求"
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      "package[name]":
        validators:
          notEmpty:
            message: "套餐名称是必填项"
      "package[price]":
        validators:
          notEmpty:
            message: "价格是必填项"
      "package[num]":
        validators:
          notEmpty:
            message: "数量是必填项"
      "package[unit]":
        validators:
          notEmpty:
            message: "单位是必填项"

  
  # Validate the form manually
  #$("#submit").click ->
  #  $("#package_form").bootstrapValidator "validate"

  #$("#reset").click ->
  #  $("#package_form").data("bootstrapValidator").resetForm true
