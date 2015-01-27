module PiggybakPaypal
  class ApplicationController < ActionController::Base
    routes { PiggybakPaypal::Engine.routes }
  end
end
