module ApplicationHelper
  def variable_length(camel_case_name, language)
    if language === 'python'
      "len(#{variable_name(camel_case_name, language)})"
    elsif ['javascript', 'ruby'].include?(language)
      "#{variable_name(camel_case_name, language)}.length"
    else
      raise "Invalid language #{language}"
    end
  end

  def variable_name(camel_case_name, language)
    if ['python', 'ruby'].include?(language)
      camel_case_name.underscore
    elsif language === 'javascript'
      camel_case_name
    else
      raise "Invalid language #{language}"
    end
  end

  def boolean_value(value, language)
    if language == 'python'
      value ? 'True' : 'False'
    else
      value ? 'true' : 'false'
    end
  end
end
