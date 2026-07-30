import "application"

$(function () {
    $(document).on('change', '#gender-select', function (e) {
        let gender = $('#gender-select').val()
        $.ajax({
            url: "/products/product_type_for_gender",
            type: "GET",
            dataType: 'json',
            data: { "gender": gender },
            success: (data) => {
                $('#product-type-select').empty()
                data.forEach(function (product_type) {
                    $('#product-type-select').append("<option value='" + product_type.id + "'>" + product_type.name + "</option>")
                });
            }
        })
    })
})
