import "application"

$(function () {


    headerScrollEffect()



    function headerScrollEffect() {
        if ($("#welcome-index").length < 1) {
            return
        }

        window.onscroll = function () { myFunction() };

        var header = document.getElementById("myHeader");

        var sticky = header.offsetTop;

        function myFunction() {
            if (window.pageYOffset > sticky) {
                $('header').css({ 'position': '' });
                header.classList.add("sticky");


            } else {
                header.classList.remove("sticky");
                $('header').css({ 'position': 'absolute' });
            }
        }
    }
});
