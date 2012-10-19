# -*- encoding : utf-8 -*-
module Untied
  module Consumer
    class Railtie < Rails::Railtie
      rake_tasks do
        load "untied-consumer/tasks/untied_rails.tasks"
      end
    end
  end
end
