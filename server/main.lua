-- Comando ejemplo: /lunarcoin give <identificador> <cantidad>
--                  /lunarcoin give char1:XXXXX 10
--                  /lunarcoin remove char1:XXXXX 10
ESX.RegisterCommand({'lunarcoin', 'lc'}, {'admin', 'moderador', 'soporte'}, function(xPlayer, args)
    local sourceIdentifier  = xPlayer.identifier
    local sourceName        = xPlayer.getName()
    type                    = args[1]
    id                      = args[2]
    quantity                = tonumber(args[3])
    local xPlayer           = ESX.GetPlayerFromId(id)
    
    if type == 'give' then
        xPlayer.addAccountMoney('coins', quantity)

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message-coin"><b>^0💰 Lunar Coins añadidas: </b>{0}</div>',
            args = { quantity }
        })
    elseif type == 'remove' then
        tokens = xPlayer.getAccount('coins')

        if tokens["money"] >= quantity then
            xPlayer.removeAccountMoney('coins', quantity)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-remove"><b>^0💰 Lunar Coins removidas: </b>{0}</div>',
                args = { quantity }
            })
        else
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-remove"><b>^0💰 Lunar Coins: </b>Este usuario no tiene Lunar Coins suficientes para remover.</div>',
            })
        end
    elseif type == 'clear' then
        xPlayer.setAccountMoney('coins', 0)

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message-reset"><b>^0💰 Lunar Coins Reiniciadas</b></div>',
        })
    end

    function CoinSendToDiscord(weebhook, msg)
        local discord = weebhook
        local name = GetPlayerName(1)
        if discord~=nil then
            PerformHttpRequest(discord, function(a,b,c)end, "POST", json.encode({embeds={{title="*Kx Logs*",description=msg,color=7046867,}}}), {["Content-Type"]="application/json"})
        end
    end

    CoinSendToDiscord("https://discord.com/api/webhooks/1010336472873848943/59VJQqmKH-uraRnbPjRpXpgbiOaqhnaLPwP-OXlj2JBsuwz4Fljllb14gaB-krnKmIEe", "***[Lunar_tokens] Coins***\nAdmin: **"..sourceName.."["..sourceIdentifier.."]".."**\nJugador:** "..xPlayer.getName().."["..xPlayer.identifier.."]".."**\nCoins:** "..quantity.."**")
end, true)