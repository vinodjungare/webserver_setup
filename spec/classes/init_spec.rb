require 'spec_helper'
describe 'webserver_setup' do

  context 'with defaults for all parameters' do
    it { should contain_class('webserver_setup') }
  end
end
