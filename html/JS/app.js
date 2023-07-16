(function(){
    window.onData = function(data){
        if (data.action == "show") {
            updateWater(data.water)
            updateHealth(data.health)
            initID(data.id)
            $('body').css('display', 'block');
        }

        if (data.action == "hide"){
            $('body').css('display', 'none');
        }
    }
    window.onload = function(e){ window.addEventListener('message', function(event){ onData(event.data) }); }
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $('body').css('display', 'none');
            $.post('https://xWeed/NUIFocusOff', JSON.stringify({}));
            return
        }
    };
})()