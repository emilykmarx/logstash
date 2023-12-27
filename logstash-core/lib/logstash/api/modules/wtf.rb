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

require "logstash/api/modules/base"
require "logstash/api/errors"
require "logstash/api/commands/base"

module LogStash
  module Api
    module Modules
      class WTF < ::LogStash::Api::Modules::Base
        def wtf
          factory.build(:wtf)
        end

        TRACE_PATH = "/trace"

        get TRACE_PATH do
          begin
            # XXX: parse plugin name from msg stored by ES instead of taking as param (since this should be invisible to ES)
            respond_with(wtf.trace(params["plugin"]))
          rescue ArgumentError => e # TODO change error type?
            response = respond_with({"error" => e.message})
            status(400)
            response
          end
        end
      end
    end
  end
end
