$(function() {
    taskID = $('#task').data("task");

    PrivatePub.subscribe("/tasks/" + taskID, function(data, channel) {
        operation = $.parseJSON(data.operation);
        if(operation.highest == true) {
            $('#company_' + operation.company_id + ' table tbody tr.highest').removeClass('highest');
            $('#company_' + operation.company_id + ' table tbody').append('<tr class="highest"><td>' + operation.invoice_num + '</td><td>' + operation.amount + '</td><td>' + operation.invoice_date + '</td><td>' + operation.operation_date + '</td><td>' + operation.status + '</td></tr>');
            $('#company_' + operation.company_id + ' #highest_num').html(operation.invoice_num);
        }
        else {
            $('#company_' + operation.company_id + ' table tbody').append('<tr><td>' + operation.invoice_num + '</td><td>' + operation.amount + '</td><td>' + operation.invoice_date + '</td><td>' + operation.operation_date + '</td><td>' + operation.status + '</td></tr>');
        }
        opSize = $('#company_' + operation.company_id + ' #size').html();
        $('#company_' + operation.company_id + ' #size').html(parseInt(opSize) + 1);
        if(operation.status == 'accepted') {
            opStatus = $('#company_' + operation.company_id + ' #status').html();
            $('#company_' + operation.company_id + ' #status').html(parseInt(opStatus) + 1);
        }
    });
});