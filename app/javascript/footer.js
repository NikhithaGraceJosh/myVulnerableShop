$(function () {
    setFooterHeight();
})
function setFooterHeight() {

    if (screen.height > ($('html').height() - parseInt($('footer').css('top')))) {

        $('footer').css('top', (screen.height - $('html').height()))
    }
    else {

        let url = window.location.pathname.split("/");
        let action = url[2]
        if (action == "sign_in") {

            $('footer').css({ 'margin-top': '5rem', 'left': 0 })
        } else {

            $('footer').css({ 'top': '5px', 'left': 0 })
        }
    }
}
export { setFooterHeight };
