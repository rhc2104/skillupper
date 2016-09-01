class SubmitController < ApplicationController
  include ActionView::Helpers::TextHelper

  def submit
    content_data = ContentData.get_instance(params[:level])

    language = params[:language].present? ? params[:language] : 'javascript'
    submitted_code = params[:code].to_s
    code = submitted_code

    case language
    when 'javascript'
      compiler_id = 56
      code += "\n"
      code += "var ojInput = #{JSON.generate(content_data.test_values)}; var ojOutput = []; for (var ojIndex in ojInput) {ojOutput.push(#{content_data.function_name(language)}.apply(null, ojInput[ojIndex]));} process.stdout.write(JSON.stringify(ojOutput));"
    when 'python'
      compiler_id = 116
      code +=
"
import json

ojInput = #{JSON.generate(content_data.test_values)}
ojOutput = []
for ojInputValue in ojInput:
  ojOutput.append(#{content_data.function_name(language)}(*ojInputValue))
print(json.dumps(ojOutput))
"
    when 'ruby'
      compiler_id = 17
      code +=
"
require 'json'

oj_input = #{JSON.generate(content_data.test_values)}
oj_output = []
oj_input.each do |oj_input_value|
  oj_output << send('#{content_data.function_name(language)}', *oj_input_value)
end
puts(JSON.generate(oj_output))
"
    else
      raise 'Invalid language'
    end

    current_user.update(programming_language: language)

    submission_id = SphereEngineAPI.send_submission(code, compiler_id)
    if submission_id
      # TODO Better solution? Wait 1.5 seconds because there is a time limit of 1 second for execution
      sleep(1.5)
      output = SphereEngineAPI.get_output(submission_id)

      if output
        success = true
        inputs = content_data.test_values
        expected = content_data.expected_values
        error_message = nil
        begin
          output_values = JSON.parse(output)
        rescue JSON::ParserError
          success = false
          error_message = 'There was an error in running the code. <br/> Did you print any output in your code?  Unfortunately, that is not supported in SkillUpper.'
        end

        unless error_message
          expected.each_with_index do |expected_value, index|
            if expected_value != output_values[index]
              success = false
              error_message =
                'For the test case of: ' + '<br/><code>' + inputs[index].to_json + '</code><br/>' +
                'your code returned: ' + '<br/><code>' + output_values[index].to_json + '</code><br/>' +
                'instead of: ' + '<br/><code>' + expected_value.to_json + '</code>'
              break
            end
          end
        end
        render_response(success, error_message, params[:level], language, submitted_code)
      else
        error_message = SphereEngineAPI.get_compilation_info(submission_id)

        unless error_message
          error_message = SphereEngineAPI.get_error(submission_id)
        end

        unless error_message
          submission_data = SphereEngineAPI.check_submission(submission_id)
          if submission_data.include?('time limit exceeded')
            error_message = 'Time limit exceeded'
          end
        end

        error_message = error_message ? 'Error Message:<br/>' + simple_format(error_message) : 'There was an error in running the code.'
        render_response(false, error_message, params[:level], language, submitted_code)
      end

    else
      render_response(false, 'There was an error in evaluating the submission.  Please try again later.', params[:level], language, submitted_code)
    end
  end

  def render_response(success, error_message, content_name, language, submitted_code)
    # Create user submission, then render response
    UserSubmission.create!(user: current_user, content_name: content_name, language_name: language, submitted_code: submitted_code, succeeded: success)

    render json: {success: success, error_message: error_message}
  end

end
