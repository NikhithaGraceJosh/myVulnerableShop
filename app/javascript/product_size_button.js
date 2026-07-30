import "application"

let hidden_data_var;
$(function () {

    $(document).on('click', '.product-size-button', sizeFunction)

    function sizeFunction() {

        $(".product-size-button").css({
            'border': '1px solid #1a6461',
            'background-color': 'white', 'color': 'black'
        })
        let button_id = $(this).attr('id')
        hidden_data_var = $(this).data('value')
        let product_id = window.location.pathname.split("/")[2]
        $.ajax({
            url: "/products/get_quantity",
            type: "GET",
            dataType: "json",
            data: { "size_id": hidden_data_var, "product_id": product_id },
            success: function (data) {
                console.log(data)
                let available_quantity_message = ""
                if (data == 0) {
                    available_quantity_message = "Out Of Stock!"
                } else if (data == 1) {
                    available_quantity_message = "Only 1 left! Hurry!"
                } else if (data < 6) {
                    available_quantity_message = "Only " + data + " pieces left!"
                }

                $("#avail-quantity").html(available_quantity_message)


            }
        })
        console.log(hidden_data_var)
        $("#size_id").val(hidden_data_var)
        $("#" + button_id).css({ 'border': '1px solid #1a6461', 'background-color': '#1a6461', 'color': 'white' });
    }
});
