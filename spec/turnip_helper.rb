require 'rails_helper'
Dir.glob("spec/features/step_definitions/**/*steps.rb") { |f| load f, true }