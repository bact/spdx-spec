// Insert <wbr> (word break opportunity) at camelCase boundaries in the
// RelationshipType page across all table columns (name, From, To, Description,
// Relationship class). Only camelCase text is affected; plain prose is unchanged.
document.addEventListener('DOMContentLoaded', function () {
  if (!window.location.pathname.includes('RelationshipType')) return;

  document.querySelectorAll('td').forEach(function (cell) {
    insertCamelCaseBreaks(cell);
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
