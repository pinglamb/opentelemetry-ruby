# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: hello_service.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("hello_service.proto", :syntax => :proto3) do
    add_message "api.HelloRequest" do
      optional :greeting, :string, 1
    end
    add_message "api.HelloResponse" do
      optional :reply, :string, 1
    end
  end
end

module Api
  HelloRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("api.HelloRequest").msgclass
  HelloResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("api.HelloResponse").msgclass
end