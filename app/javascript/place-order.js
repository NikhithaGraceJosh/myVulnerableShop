import "application"

$(function () {
    $(document).on('click', '#place-order', function () {
        $('#qloader').show();
        $('#cart-show').css({ 'opacity': '0.3' })
    })
})
