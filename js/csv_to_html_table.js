var CsvToHtmlTable = CsvToHtmlTable || {};

CsvToHtmlTable = {
    init: function (options) {
        options = options || {};
        var csv_path = options.csv_path || "";
        var el = options.element || "table-container";
        var allow_download = options.allow_download || false;
        var csv_options = options.csv_options || {};
        var datatables_options = options.datatables_options || {};
        var custom_formatting = options.custom_formatting || [];
        var customTemplates = {};
        $.each(custom_formatting, function (i, v) {
            var colIdx = v[0];
            var func = v[1];
            customTemplates[colIdx] = func;
        });

        var $table = $("<table class='table table-striped table-condensed find-duplicates' id='" + el + "-table'></table>");
        var $containerElement = $("#" + el);
        $containerElement.empty().append($table);

        $.when($.get(csv_path)).then(
            function (data) {
//console.log(JSON.stringify(Papa.parse(data)));
                var csvData = $.csv.toArrays(data, csv_options);
                var $tableHead = $("<thead></thead>");
                var csvHeaderRow = csvData[0];
                var $tableHeadRow = $("<tr><th><input type=\"checkbox\" name=\"select_all\" id=\"example-select-all\"></th></tr>");
                for (var headerIdx = 0; headerIdx < csvHeaderRow.length; headerIdx++) {
                      if (csvHeaderRow[headerIdx].includes("Type")){
                        $tableHeadRow.append($("<th class=\"duplifer-highlightdups\"></th>").text(csvHeaderRow[headerIdx]));
                } else
                	$tableHeadRow.append($("<th align='left'></th>").text(csvHeaderRow[headerIdx]));
                }

                $tableHead.append($tableHeadRow);

                $table.append($tableHead);
                var $tableBody = $("<tbody></tbody>");

                for (var rowIdx = 1; rowIdx < csvData.length; rowIdx++) {
                    var $tableBodyRow = $("<tr onclick=\"selectColor(this)\"><td><input type=\"checkbox\" id=\"checkbox-" + rowIdx + "\"></td></tr>");
                    for (var colIdx = 0; colIdx < csvData[rowIdx].length; colIdx++) {
			var linkRef = csvData[rowIdx][0];
                        var $tableBodyRowTd = $("<td style=\"cursor:pointer\" onclick=\"location.href='" + linkRef + ".html'\">link</td>");
                        var cellTemplateFunc = customTemplates[colIdx];
                        if (cellTemplateFunc) {
                            $tableBodyRowTd.html(cellTemplateFunc(csvData[rowIdx][colIdx]));
                        } else {
                            $tableBodyRowTd.text(csvData[rowIdx][colIdx]);
                        }
                        $tableBodyRow.append($tableBodyRowTd);
                        $tableBody.append($tableBodyRow);
                    }
                }
                $table.append($tableBody);

		$(document).ready(function () {
		    $(".find-duplicates").duplifer();
		    $("table").simpleCheckboxTable();
		});

var checkboxValues = JSON.parse(localStorage.getItem('checkboxValues')) || {};
var $checkboxes = $("#table-container-table :checkbox");
$("#table-container-table :checkbox").on("change", function(){
  console.log("The checkbox with the ID '" + this.id + "' changed");
  $checkboxes.on("change", function(){
  $checkboxes.each(function(){
    checkboxValues[this.id] = this.checked;
  });
  localStorage.setItem("checkboxValues", JSON.stringify(checkboxValues));
});
});
$.each(checkboxValues, function(key, value) {
  $("#" + key).prop('checked', value);
  if(value){
  $("#" + key).closest('tr').toggleClass('active');
  }
});

$(document).ready(function(){
  var show_btn=$('.show-modal');
  var show_btn=$('.show-modal');
  //$("#testmodal").modal('show');
  $("#just_load_please").on("click", function(e) {
    e.preventDefault();
    $("#loadMe").modal({
      backdrop: "static", //remove ability to close modal with click
      keyboard: false, //remove option to close with keyboard
      show: true //Display loader!
    });
    setTimeout(function() {
      $("#loadMe").modal("hide");
    }, 5500);
   }); 
    show_btn.click(function(){
      $("#testmodal").modal('show');
  })
});


$(function() {
        $('#element').on('click', function( e ) {
            Custombox.open({
                target: '#testmodal-1',
                effect: 'fadein'
            });
            e.preventDefault();
        });
    });

                $table.DataTable(datatables_options);

                if (allow_download) {

                    $containerElement.append("<hr><p><a class='btn btn-info' href='" + csv_path + "'><i class='glyphicon glyphicon-download'></i> Download as CSV</a></p>");
                }
            });
    }
};
