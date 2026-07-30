import "application"
import { setFooterHeight } from "footer";


$(function () {
    $(document).on('change', '.select-size', updateCart)
    $(document).on('change', '.select-quantity', updateCart)
    function updateCart(e) {
        let update_quantity_only = false
        if (e.target.className.includes("select-quantity")) {
            update_quantity_only = true
        }
        let cart_id = parseInt($("#id_" + e.target.name.split('[')[0]).val())
        let size_id = parseInt($('[name="' + e.target.name.split('[')[0] + '[size]"]').val())
        let quantity = parseInt($('[name="' + e.target.name.split('[')[0] + '[quantity]"]').val())

        $.ajax({
            url: "/cart/update_user_cart",
            type: "GET",
            dataType: "script",
            data: { "id": cart_id, "size_id": size_id, "quantity": quantity, "update_quantity_only": update_quantity_only },
            success: function () {

                setFooterHeight()
            },
            error: function () {
                setFooterHeight()
            }

        });

    }
});
