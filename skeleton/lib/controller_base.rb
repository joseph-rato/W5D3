require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req 
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response 
  
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "get your sh*t together son" if @already_built_response 
    @res['location'] = url
    @res.status = 302
    @already_built_response = true
    @session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # debugger
    raise "get your sh*t together son" if @already_built_response 
    @res['Content-Type'] = content_type
    @res.write content
    @already_built_response = true
    # debugger
    @session.store_session(@res) 
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    dir_path = File.dirname(__FILE__)
    debugger
    template_path = File.join(dir_path,"../views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template_code = File.read(template_path)
    render_content(ERB.new(template_code).result(binding), 'text/html')                                
    
  
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req) 
    
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

