require 'json'

module Thirtysix
  class AppRequest
    attr_accessor :objects,
                  :classes,
                  :modules,
                  :floats,
                  :strings,
                  :regexps,
                  :arrays,
                  :hashes,
                  :files,
                  :request_time_in_milliseconds,
                  :controller,
                  :action,
                  :query_parameters,
                  :memory_in_mb

    def build(start_objects, end_objects, env)
      @objects           = (end_objects[:T_OBJECT] || 0)  - (start_objects[:T_OBJECT] || 0)
      @classes           = (end_objects[:T_CLASS] || 0)   - (start_objects[:T_CLASS] || 0)
      @modules           = (end_objects[:T_MODULE] || 0)  - (start_objects[:T_MODULE] || 0)
      @floats            = (end_objects[:T_FLOAT] || 0)   - (start_objects[:T_FLOAT] || 0)
      @strings           = (end_objects[:T_STRING] || 0)  - (start_objects[:T_STRING] || 0)
      @regexps           = (end_objects[:T_REGEXP] || 0)  - (start_objects[:T_REGEXP] || 0)
      @arrays            = (end_objects[:T_ARRAY] || 0)   - (start_objects[:T_ARRAY] || 0)
      @hashes            = (end_objects[:T_HASH] || 0)    - (start_objects[:T_HASH] || 0)
      @files             = (end_objects[:T_FILE] || 0)    - (start_objects[:T_FILE] || 0)
      @controller        = env.fetch("action_dispatch.request.path_parameters", {})[:controller]
      @action            = env.fetch("action_dispatch.request.path_parameters", {})[:action]
      @query_parameters  = env.fetch("action_dispatch.request.query_parameters", nil)
    end

    def to_json
      {
        objects: objects,
        classes: classes,
        modules: modules,
        floats:  floats,
        strings: strings,
        regexps: regexps,
        arrays:  arrays,
        hashes:  hashes,
        files:   files,
        request_time_in_milliseconds: request_time_in_milliseconds,
        controller: controller,
        action: action,
        query_parameters: query_parameters,
        memory_in_mb: memory_in_mb
      }.to_json
    end
  end
end