require 'spec_helper'
describe 'otrs' do

  context 'with defaults for all parameters' do
    it { should contain_class('otrs') }
  end
end
