var table = $('table')[0];
var rowGroups = {};
//loop through the rows excluding the first row (the header row)
while(table.rows.length > 1){
    var row = table.rows[1];
    var id = $(row.cells[0]).text();
    if(!rowGroups[id]) rowGroups[id] = [];
    if(rowGroups[id].length > 0){
        row.className = 'subrow';
        $(row).slideUp();
    }
    rowGroups[id].push(row);
    table.deleteRow(1);
}
//loop through the row groups to build the new table content
for(var id in rowGroups){
    var group = rowGroups[id];
    for(var j = 0; j < group.length; j++){
        var row = group[j];
        if(group.length > 1 && j == 0) {
            //add + button
            var lastCell = row.cells[row.cells.length - 1];
            $("<span class='collapsed'>").appendTo(lastCell).click(plusClick);
        }
        table.tBodies[0].appendChild(row);
    }
}
//function handling button click
function plusClick(e){
    var collapsed = $(this).hasClass('collapsed');
    var fontSize = collapsed ? 14 : 0;
    $(this).closest('tr').nextUntil(':not(.subrow)').slideToggle(400)
           .css('font-size', fontSize);
    $(this).toggleClass('collapsed');
}
