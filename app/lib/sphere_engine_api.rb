require 'net/http'
require 'uri'
require 'json'

class SphereEngineAPI
  API_PREFIX = "https://#{ENV['SPHERE_ENGINE_API_SUBDOMAIN']}.compilers.sphere-engine.com/api/v4"

  TOKEN = ENV['SPHERE_ENGINE_API_TOKEN']

  def self.send_submission(code, compiler_id)
    # send request
    uri = URI.parse("#{API_PREFIX}/submissions?access_token=#{TOKEN}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    submission_data = {compilerId: compiler_id, source: code, timeLimit: 1}

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(submission_data)

    body = execute_api_request(http, request)
    if body
      body = JSON.parse(body)
      return body['id']
    end
  end

  def self.check_submission(submission_id)
    uri = URI.parse("#{API_PREFIX}/submissions/#{submission_id}?access_token=#{TOKEN}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    body = execute_api_request(http, request)

    return body
  end

  def self.get_compilation_info(submission_id)
    uri = URI.parse("#{API_PREFIX}/submissions/#{submission_id}/cmpinfo?access_token=#{TOKEN}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    body = execute_api_request(http, request)

    return body
  end

  def self.get_error(submission_id)
    uri = URI.parse("#{API_PREFIX}/submissions/#{submission_id}/error?access_token=#{TOKEN}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    body = execute_api_request(http, request)

    return body
  end

  def self.get_output(submission_id)
    uri = URI.parse("#{API_PREFIX}/submissions/#{submission_id}/output?access_token=#{TOKEN}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    body = execute_api_request(http, request)

    return body
  end

  def self.execute_api_request(http, request)
    begin
      response = http.request(request)

      if [Net::HTTPCreated, Net::HTTPOK].include?(response.class)
        return response.body
      end

      # process errors, TODO better
      case response
        when Net::HTTPUnauthorized
          STDERR.puts "Invalid access token"
        when Net::HTTPPaymentRequired
          STDERR.puts "Unable to create submission"
        when Net::HTTPBadRequest
          body = JSON.parse(response.body)
          puts "Error code: " + body["error_code"].to_s + ", details available in the message: " + body["message"].to_s
      end
    rescue => e
      STDERR.puts e
      STDERR.puts "Connection error"
    end
  end

end
