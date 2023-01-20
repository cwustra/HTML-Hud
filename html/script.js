var genislik = window.screen.width;
var yukseklik = window.screen.height; 


function changeHP(value) {
 
    if(genislik >= 1920 && yukseklik >= 1080)
    {
        var data = 144 / 100 * value;
    }
    else
    {
        var data = 144 / 100 * value;
    }

    document.getElementById("health").setAttribute("style", "width: " + data + "px;");
}

function changeArmor(value) {
   
    if(genislik >= 1920 && yukseklik >= 1080)
    {
        var data = 144 / 100 * value;
    }
    else
    {
        var data = 144 / 100 * value;
    }

    document.getElementById("armor").setAttribute("style", "width: " + data + "px;");
}




function setFuel(fuel) {
  setProgressFuel(fuel,'.progress-fuel');
  if (fuel <= 20)
    $('.progress-fuel').addClass('orangeStroke');
  else if (fuel <= 10) {
    $('.progress-fuel').removeClass('orangeStroke');
    $('.progress-fuel').addClass('redStroke');
  }
}

function setProgressFuel(percent, element){
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}

// Speed
function setProgressSpeed(value, element){
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value*100/220;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

}
