import "application"
import { setFooterHeight } from "footer";

$(function () {
    $(document).on('change', '.select-status', function (e) {
        let order_id = e.target.name.split('[')[0];
        let status_name = e.target.value;
        $.ajax({
            url: "/orders/update_order_status",
            type: "GET",
            dataType: "script",
            data: { "order_id": order_id, "status_name": status_name },
            success: function () {

                setFooterHeight()
            }

        });

    })
})
