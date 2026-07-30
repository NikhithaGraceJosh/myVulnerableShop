import { setFooterHeight } from "footer";

$(function () {
    let total_pages = 10;
    let pagenum = 1;
    let flag = true;
    $(window).on("scroll", function () {
        var $document = $(document);
        var $window = $(this);

        if ($document.scrollTop() >= $document.height() - $window.height() - 200 && flag && $("#product-list").length) {
            let page_url = new URL(location.href)
            pagenum += 1;
            if (pagenum <= total_pages) {
                $('.product-list-content:last').after(`<div class='loader text-center w-100 p-3' style="background-color:lightgrey"><div style="font-size:12px;color:white">Loading more products</div><image src="/assets/loader-14cbf625172f09a97d9daad6edcabd4d9ac4849ff40415b99fb6aa563a1e56ab.gif"></div`)

                let gender = page_url.searchParams.get("gender")
                let type = page_url.searchParams.get("type")
                let search = page_url.searchParams.get("search")
                let page_size = page_url.searchParams.get("page_size")

                flag = false;
                $.ajax({
                    url: "/products/filter",
                    type: "GET",
                    data: { gender, type, search, pagenum, page_size },
                    success: (data) => {

                        $('.loader').remove();
                        console.log(data)

                        if (data.success) {
                            total_pages = data.total_pages;

                            if (pagenum <= total_pages) {
                                $("#product-list").append(data.html);
                                setFooterHeight();
                            }
                            else {
                                $("#product-list").append(`<div style="font-size:12px;color:grey" class="text-center">End</div>`);
                                setFooterHeight();
                            }
                        }
                        flag = true;

                    },
                    error: (data) => {

                    }

                })

            }
        }
    })
})
