var is_open = 0;

function set(variable,value,value2) {
    if (variable == "weapon") {
        $('.base_weapon__logo').remove();
        $('.hud__gta').append('<img class="base_weapon__logo" width="100" height="100" src="http://mta/cr_hudui/components/weapon/' + value + '.png"/>');
    } else if (variable == "hpbar" || variable == "armorbar" || variable == "hp" || variable == "armor") {
        $('.list__' + variable).width(value);
    } else if (variable == "destroy") {
        $('.list__' + value).remove();
    } else if (variable == "create") {
        if (value == "armorbar") {
            $('.hud__gta').append('<div class="list__armorbar"><div class="list__armor"></div></div>');
        } else if (value == "injury") {
            $('.hud__static').append('<img class="list__injury" src="http://mta/cr_hudui/components/injury.png"/>');
        }
    } else if (variable == "info") {
        if (value == "close") {
            $('.list__panel').remove(); 
            $('.list__panel-head').remove(); 
            $('.list__panel-body').remove(); 
        } else {
            $('.hud__gta').append('<div class="list__panel"><div class="list__panel-head">' + value + '</div><div class="list__panel-body">' + value2 + '</div></div>');
        }
    } else if (variable == "moneycolor") {
        $('.list__money').css('color', value);
    } else if (variable == "speedo") {
        if (value == "on") {
            $('#speedometer').show();
        } else {
            $('#speedometer').hide();
        }
    } else {   
        $('.list__' + variable).html(value);
    }
}


$(document).ready(function() {
    mta.triggerEvent('hud.browserReady');
    startTime();
    // Speedo:
    $('#speedometer').hide();
    $('.list__speedtext').remove();
    $('.list__speed').remove();
    $('.list__fueltext').remove();
    $('.list__fuel').remove();
});


function startTime() {
    var localDate = new Date();

    var year = checkTime(localDate.getUTCFullYear());
    var month = checkTime(localDate.getUTCMonth() + 1);
    var day = checkTime(localDate.getUTCDate());
    var hours = checkTime(localDate.getHours());
    var minutes = checkTime(localDate.getMinutes());
    var seconds = checkTime(localDate.getSeconds());
    $('.list__realtime').html(day + "/" + month + "/" + year);
    $('.list__time').html(hours + ":" + minutes);
    var timer = setTimeout(startTime, 1000);
}

function checkTime(time) {
    if (time < 10)
        time = "0" + time;

    return time;
}

function mtaevent(eventname) {
    mta.triggerEvent(eventname);
};  

function error(message) {
	toastr.error(message);
}

function info(message) {
	toastr.success(message);
}