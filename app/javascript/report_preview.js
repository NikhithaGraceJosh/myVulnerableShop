import datepicker from "js-datepicker"

let start;
let end;

function initReportPreview() {
    let $start = $('.start')
    let $end = $('.end')
    if (!$start.length || !$end.length || $start.data('datepickerInitialized')) return

    $start.data('datepickerInitialized', true)

    start = datepicker('.start', {
        id: '#datepicker'
    })
    end = datepicker('.end', {
        id: '#datepicker'
    })
    $(document).on('click', '#generate-preview', report_preview)
    $(document).on('click', '#download-report-later', report_preview)
}

// Runs immediately for the page currently being evaluated (this module loads
// too late over the network to catch that page's own turbo:load), and again
// on every later turbo:load, since Turbo Drive swaps <body> without a full
// reload and this module's top-level code otherwise only ever runs once per
// browser tab.
initReportPreview()
document.addEventListener("turbo:load", initReportPreview)
function report_preview(e) {

    let from = start.getRange().start;
    let to = end.getRange().end;
    let now = false;
    if (e.target.id == "generate-preview") {
        now = true;
    }


    $.ajax({
        url: "/products/report_preview",
        type: "GET",
        data: { "from": from, "to": to, "now": now },
        success: (data) => {
            $('#report-list').html(data.html);
            if (data.length == '0') {
                $('#download-report-now').hide();
            } else {
                update_download_link(from, to);
                $('#download-report-now').show();
            }
        }
    })

}
function update_download_link(from, to) {
    let $link = $('#download-report-now');
    let url = new URL($link.data('base-href'), window.location.origin);
    url.searchParams.set('from', from);
    url.searchParams.set('to', to);
    $link.attr('href', url.pathname + url.search);
}
