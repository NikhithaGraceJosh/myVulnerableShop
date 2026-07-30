import "application"

$(function () {
    $(document).on("click", ".wishlisted", addToWishlist("far fa-heart", "not-wishlisted"))
    $(document).on("click", ".not-wishlisted", addToWishlist("fa fa-heart", "wishlisted"))
})
function addToWishlist(icon, status) {

    return () => {

        $(".heart-icon").remove();
        $(".wishlist-wrapper").append(`<i class="heart-icon ${icon} ${status}"></i>`)
        let product_id = window.location.href.split("/").pop();
        if (status == "wishlisted") {
            $.ajax({
                url: "/wishlists",
                type: "POST",
                data: { product_id },
                success: (data) => {
                    alert("Added to wishlist")
                }
            })
        } else {
            $.ajax({
                url: "/wishlists/" + product_id,
                type: "DELETE",
                success: (data) => {
                    alert("Removed from wishlist")
                }
            })
        }
    }
}

