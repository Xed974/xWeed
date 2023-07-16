var currentID = 0

function getColor(value){
    if (value < 20){ return "#f21111" }
    if (value >= 20 && value < 30){ return "#f23711" }
    if (value >= 30 && value < 40){ return "#f25c11" }
    if (value >= 40 && value < 50){ return "#f28211" }
    if (value >= 50 && value < 60){ return "#f2a711" }
    if (value >= 60 && value < 70){ return "#f2cc11" }
    if (value >= 70 && value < 80){ return "#f2f211" }
    if (value >= 80 && value < 90){ return "#cdf211" }
    if (value >= 90 && value < 100){ return "#a7f211" }
    if (value == 100) { return "#82f211" }
}

function updateWater(value){
    document.getElementById("progress2").style.backgroundColor = getColor(value)
    document.getElementById("progress2-bar").style.width = value + "%"
}

function updateHealth(value){
    document.getElementById("progress").style.backgroundColor = getColor(value)
    document.getElementById("progress-bar").style.width = value + "%"
}

function initID(id){
    currentID = id
    document.getElementById("id").innerHTML = "ID: " + id;
}

function updateValue(){
    $.post('https://xWeed/updateWater', JSON.stringify({id : currentID}));
    $('body').css('display', 'none');
    $.post('https://xWeed/NUIFocusOff', JSON.stringify({}));
}

function removePlant(){
    $.post('https://xWeed/removePlant', JSON.stringify({id : currentID}));
    $('body').css('display', 'none');
    $.post('https://xWeed/NUIFocusOff', JSON.stringify({}));
}

function closeInterface(){
    $('body').css('display', 'none');
    $.post('https://xWeed/NUIFocusOff', JSON.stringify({}));
    return
}