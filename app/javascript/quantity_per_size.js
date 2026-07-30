import "application"

function insertQuantityField(checkbox, quantity) {
    let fieldId = `product_product_sizes_attributes_${checkbox.value - 1}_size_id_${checkbox.value}`
    if (document.getElementById(fieldId)) return

    let value = quantity === undefined ? "" : quantity
    let content = `<div><label for="product[stock_quantity][${checkbox.value - 1}]" class="mr-3"><b>Stock Quantity</b></label><input name="product[stock_quantity][${checkbox.value - 1}]" id="${fieldId}" value="${value}"></div>`
    $(checkbox).parent().after(content)
}

function toggleDisplay(e) {

    if (e.target.checked) {

        console.log("checked")
        insertQuantityField(this)
    } else {
        let quantity_input = $("#" + `product_product_sizes_attributes_${this.value - 1}_size_id_${this.value}`)

        quantity_input.parent().remove()
    }
}
function initQuantityPerSize() {

    let existingStock = $("#size-checkbox").data("existing-stock") || {}

    $("#size-checkbox").children().find(".form-check-input").each(function () {
        if (this.checked) {
            insertQuantityField(this, existingStock[this.value])
        }
    })

    $("#size-checkbox").children().find(".form-check-input").off("change.quantityPerSize").on("change.quantityPerSize", toggleDisplay)
    $("#size-checkbox").children('input').off("change.quantityPerSize").on("change.quantityPerSize", toggleDisplay)
}

// Runs immediately for the page currently being evaluated (this module loads
// too late over the network to catch that page's own turbo:load), and again
// on every later turbo:render once cached, since Turbo Drive swaps <body>
// without a full reload and this module's top-level code otherwise only
// ever runs once per browser tab. turbo:render (unlike turbo:load) also
// fires when Turbo re-renders the page in place after a failed form
// submission (e.g. validation errors), so the checkboxes on that page keep
// working too.
initQuantityPerSize()
document.addEventListener("turbo:render", initQuantityPerSize)
