import "application"

$(function () {
    $(document).on("ajax:error", "#new-address-form", function (evt) {

        errors = evt.originalEvent.detail[0].error
        for (message of errors)
            $('#errors').append(`<li>${message}</li>`)
    })
})
