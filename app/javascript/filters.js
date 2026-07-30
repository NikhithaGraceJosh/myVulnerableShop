import "application"
import { setFooterHeight } from "footer";

$(function () {
    $(document).on('focusout', '#min-price-filter', filterFunction)
    $(document).on('focusout', '#max-price-filter', filterFunction)
    $(document).on('change', '.filter-check', filterFunction)
    $(document).on('click', '#clear-filter', filterFunction)
    $(document).on('click', '.gender-check', filterFunction)

    function filterFunction(e) {
        $("#qloader").show();
        $("#product-list-content").css({ 'opacity': '0.3' })
        let page_size;
        let max_price;
        let min_price;
        let gender;
        let type;
        let search;
        let filter_categories = [];
        let filters = "";
        if (e.target.id != 'clear-filter') {
            max_price = $("#max-price-filter").val();
            if (max_price != "") {
                filters += " - Max: " + max_price;
            }
            min_price = $("#min-price-filter").val();
            if (min_price != "") {
                filters += " - Min: " + min_price;
            }
            $.each($("input[class='filter-check']:checked"), function () {
                filter_categories.push($(this).val());
                filters += " - " + $(this).val().charAt(0).toUpperCase() + $(this).val().substr(1).toLowerCase()
            });
            $('#filter-list').html(filters)
        } else {
            //clear all fields
            $('#filter-list').html("")
            $("#max-price-filter").val("");
            $("#min-price-filter").val("");
            $('input:checkbox').prop('checked', false);
            $('.gender-check').prop('checked', false);
        }
        let page_url = new URL(location.href)
        gender = page_url.searchParams.get("gender")
        type = page_url.searchParams.get("type")
        search = page_url.searchParams.get("search")
        page_size = page_url.searchParams.get("page_size") || 8

        console.log("MIN:" + min_price)
        console.log("MAX" + max_price)
        console.log("gender" + gender)
        if ($(".gender-check").is(':checked')) {
            gender = $("input[class='gender-check']:checked").val()
        }
        console.log("gender" + gender)

        $.ajax({
            url: "/products/filter",
            type: "GET",
            data: { "min_price": min_price, "max_price": max_price, "filter_categories": JSON.stringify(filter_categories), "gender": gender, "type": type, "search": search, page_size, pagenum: 1 },
            success: (data) => {
                $("#qloader").hide('slow');
                $("#product-list-content").css({ 'opacity': '1' })
                console.log(data)
                if (data.success == true) {
                    $("#product-list").html(data.html);
                    setFooterHeight();
                }


            },
            error: (data) => {
            }
        })
    }
})
