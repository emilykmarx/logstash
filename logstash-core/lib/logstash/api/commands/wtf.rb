# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require "logstash/api/commands/base"

module LogStash
  module Api
    module Commands
      class WTF < Commands::Base
        def trace(plugin)
          puts("ZZEM trace")
          # Dispatch to all instances of specified plugin (across all running pipelines)
          service.agent.running_pipelines.map do |pipeline_id, pipeline|
            puts("ZZEM outputs; pipeline_id #{pipeline_id}")
            pipeline.outputs().each() do |output|
              if output.config_name == plugin
                # If plugin doesn't implement wtf_handle_trace, overridden version is called
                # XXX: pass trace msg to plugin's handler (modify sig at same time to return stuff)
                output.wtf_handle_trace
              end
            end
          end

            # XXX get pipeline filters and inputs to dispatch to, from returned value of output trace handler
          service.agent.running_pipelines.map do |pipeline_id, pipeline|
            puts("ZZEM filters; pipeline_id #{pipeline_id}")
            pipeline.filters().each() do |filter|
              puts("ZZEM filter.config_name #{filter.config_name}")
              if filter.config_name == "jdbc_streaming"
                puts("ZZEM calling jdbc trace handler")
                filter.wtf_handle_trace
              end
            end
          end

          # TODO handle trace sent to input (i.e. forwards scoping)

          # Note: response will also include default metadata with a `pipeline` section.
          # Despite this, the API endpoint is per-instance not per-pipeline.
          {
            :success => "true"
          }
        end
      end
    end
  end
end
