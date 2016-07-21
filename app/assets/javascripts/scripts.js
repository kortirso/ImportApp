$(function() {
    PrivatePub.subscribe("/tasks", function(data, channel) {
        operations = $.parseJSON(data.operations);
        ID = parseInt(operations.task_id);
        $('#task_' + ID + ' .success').html(parseInt(operations.success));
        $('#task_' + ID + ' .failed').html(parseInt(operations.failure));
        $('#task_' + ID + ' .loaded').html(parseInt(operations.success) + parseInt(operations.failure));
    });

    PrivatePub.subscribe("/tasks/complete", function(data, channel) {
        task = $.parseJSON(data.task);
        ID = parseInt(task.id);
        $('#task_' + ID + ' .progress').html('Loading complete');
    });
});