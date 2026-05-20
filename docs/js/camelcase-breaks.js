// Insert <wbr> (word break opportunity) at camelCase boundaries in the
// RelationshipType page, limited to the From, To, and Relationship class
// columns (0-based indices 1, 2, 4) to avoid unnecessary work elsewhere.
document.addEventListener('DOMContentLoaded', function () {
  if (!window.location.pathname.includes('RelationshipType')) return;

  // Column layout: 0=name, 1=From, 2=To, 3=Description, 4=Relationship class
  var targetCols = [1, 2, 4];

  document.querySelectorAll('tr').forEach(function (row) {
    row.querySelectorAll('td').forEach(function (cell, index) {
      if (targetCols.indexOf(index) !== -1) {
        insertCamelCaseBreaks(cell);
      }
    });
  });
});

function insertCamelCaseBreaks(node) {
  Array.from(node.childNodes).forEach(function (child) {
    if (child.nodeType === Node.TEXT_NODE) {
      var text = child.textContent;
      if (!/[a-z][A-Z]/.test(text)) return;

      var frag = document.createDocumentFragment();
      var last = 0;
      // Match every lowercase→uppercase transition and insert a <wbr> between them
      text.replace(/([a-z])([A-Z])/g, function (match, lower, upper, offset) {
        frag.appendChild(document.createTextNode(text.slice(last, offset + 1)));
        frag.appendChild(document.createElement('wbr'));
        last = offset + 1;
      });
      frag.appendChild(document.createTextNode(text.slice(last)));
      child.parentNode.replaceChild(frag, child);
    } else if (child.nodeType === Node.ELEMENT_NODE) {
      insertCamelCaseBreaks(child);
    }
  });
}
