import "application"

$(function () {
    $(document).on("click", "#my-image", function () {
        $("#file").click();
    })
    $(document).on("change", "#file", function () {

        $("form").submit();
    })
});
