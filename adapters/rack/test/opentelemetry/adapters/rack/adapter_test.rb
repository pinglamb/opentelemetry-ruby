# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

require_relative '../../../../lib/opentelemetry/adapters/rack/adapter'

describe OpenTelemetry::Adapters::Rack::Adapter do
  let(:adapter_class) { OpenTelemetry::Adapters::Rack::Adapter }
  let(:adapter) { adapter_class.instance }
  let(:config) { {} }

  after do
    # simulate a fresh install:
    adapter.instance_variable_set('@installed', false)
    adapter.install({})
  end

  describe 'config[:retain_middleware_names]' do
    let(:config) { Hash(retain_middleware_names: true) }

    describe 'without config[:application]' do
      it 'raises error' do
        # allow for re-installation with new config:
        adapter.instance_variable_set('@installed', false)

        assert_raises adapter_class::MissingApplicationError do
          adapter.install(config)
        end
      end
    end

    describe 'default' do
      class MyAppClass
        attr_reader :env

        def use(*); end

        def call(env)
          @env = env
          [200, { 'Content-Type' => 'text/plain' }, ['OK']]
        end
      end

      let(:app) { MyAppClass.new }

      describe 'without config' do
        it 'does not set RESPONSE_MIDDLEWARE' do
          app.call({})

          _(app.env['RESPONSE_MIDDLEWARE']).must_be_nil
        end
      end

      describe 'with config[:application]' do
        let(:config) do
          { retain_middleware_names: true,
            application: app }
        end

        it 'retains RESPONSE_MIDDLEWARE after .call' do
          # allow for re-installation with new config:
          adapter.instance_variable_set('@installed', false)

          adapter.install(config)
          app.call({})

          _(app.env['RESPONSE_MIDDLEWARE']).must_equal 'MyAppClass'
        end
      end
    end
  end
end
