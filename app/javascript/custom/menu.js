document.addEventListener("turbo:load", function() {
  console.log("menu.js loaded"); // <-- dòng kiểm tra
  let account = document.querySelector("#account");
  account.addEventListener("click", function(event) {
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
});
