require 'spec_helper'

RSpec.describe Thirtysix::AppRequest do 
  let(:before_objects) { {:T_STRING => 400} }
  let(:end_objects)    { {:T_STRING => 500} }
  let(:env)            { {} }

  it "should build from ObjectSpace and the Rack env" do
    app_request = Thirtysix::AppRequest.new
    app_request.build(before_objects, end_objects, env)
    expect(app_request.strings).to eq 100
  end
end