(function(){
    const noop = () => undefined;
    const eventHandlers = {
        ['XWEED_EVENT_NUI_SHOW']: (eventPayload) => {
            updateWater(eventPayload.water)
            updateHealth(eventPayload.health)
            initID(eventPayload.id)
            $('body').css('display', 'block');
        },
        ['XWEED_EVENT_NUI_HIDE']: () => {
            $('body').css('display', 'none');
        }
    };

    window.onData = function(data){ (eventHandlers[data.action] ? eventHandlers[data.action](data.payload) : noop()); }
    window.onload = function(e){ window.addEventListener('message', function(event){ onData(event.data) }); }
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $('body').css('display', 'none');
            $.post('https://xWeed/NUIFocusOff', JSON.stringify({}));
            return
        }
    };
})()