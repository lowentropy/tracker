TRACKER_APIKEY = "";

CmdUtils.CreateCommand({
  
  names: ["track"],
  
  author: {
    name: "Nathan Matthews",
    email: "lowentropy@gmail.com",
    homepage: "http://216brew.com/lowentropy"},
  homepage: "http://tracker.216brew.com/",
  contributors: ["Joseph Holsten <joseph@josephholsten.com>"],
  license: "GPL",
  
  description: "Track personal stats",
  help: "Enter a record to track in natural language: 'amount type @ date'",

  arguments: [{role: 'object', nountype: noun_arb_text, label: 'message'}],
  
  preview: function(pblock, {object}) {
    pblock.innerHTML = CmdUtils.renderTemplate(
      "Send '${message}' to the 216 tracker.", {message: object.text});
  },
  
  execute: function({object}) {
    var message = object.text;
    jQuery.ajax({
      url: "http://tracker.216brew.com/api/quick/" + TRACKER_APIKEY,
      data: {message: message},
      dataType: "text",
      cache: false,
      error: function() { displayMessage("Tracking failed."); },
      success: function() { displayMessage("Message recorded."); }
    });
  }
});
