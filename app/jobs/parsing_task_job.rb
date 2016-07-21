class ParsingTaskJob < ActiveJob::Base
    include Parser
    queue_as :default

    def perform(task)
        task_parser = Parser::TaskParser.new(task.file, task.id)
        task_parser.parse_file
        task.update(success: task_parser.success, failure: task_parser.total - task_parser.success)
        PrivatePub.publish_to "/tasks/complete", task: { id: task.id }.to_json
    end
end