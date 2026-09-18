BWOPostData = BWOPostData or {}

BWOPostData.GetBox = function(id)
    local ret = BWOPostData.box[id]
    ret.id = id
    ret.x, ret.y = id:match("([^%-]+)%-([^%-]+)")
    ret.x = tonumber(ret.x)
    ret.y = tonumber(ret.y)
    return ret
end

BWOPostData.GetRandomBox = function()
    local keys = {}
    for id, box in pairs(BWOPostData.box) do
        table.insert(keys, id)
    end
    local boxId = keys[ZombRand(#keys) + 1]
    
    local ret = BWOPostData.box[boxId]
    ret.id = boxId
    ret.x, ret.y = boxId:match("([^%-]+)%-([^%-]+)")
    ret.x = tonumber(ret.x)
    ret.y = tonumber(ret.y)
    return ret
end

BWOPostData.box = BWOPostData.box or {}

-- westpoint

BWOPostData.box["10956-6646"] = {areaId = "", address = "2 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["10965-6651"] = {areaId = "", address = "1 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["10956-6668"] = {areaId = "", address = "4 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["10992-6746"] = {areaId = "", address = "5 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["10956-6714"] = {areaId = "", address = "8 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["10988-6755"] = {areaId = "", address = "10 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11020-6746"] = {areaId = "", address = "7 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11049-6746"] = {areaId = "", address = "9 OAK ST, WEST POINT KY 40177"}

BWOPostData.box["11142-6746"] = {areaId = "", address = "13 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11144-6746"] = {areaId = "", address = "15 OAK ST, WEST POINT KY 40177"}

BWOPostData.box["11307-6746"] = {areaId = "", address = "17 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11309-6746"] = {areaId = "", address = "19 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11393-6746"] = {areaId = "", address = "23 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11410-6746"] = {areaId = "", address = "25 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11435-6746"] = {areaId = "", address = "27 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11575-6746"] = {areaId = "", address = "35 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11605-6746"] = {areaId = "", address = "37 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11655-6768"] = {areaId = "", address = "39 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11679-6768"] = {areaId = "", address = "41 OAK ST, WEST POINT KY 40177"}

BWOPostData.box["11731-6768"] = {areaId = "", address = "43 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11730-6777"] = {areaId = "", address = "44 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11769-6768"] = {areaId = "", address = "45 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11792-6768"] = {areaId = "", address = "47 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11825-6768"] = {areaId = "", address = "49 OAK ST, WEST POINT KY 40177"}

BWOPostData.box["11956-6768"] = {areaId = "", address = "51 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11975-6768"] = {areaId = "", address = "53 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["11994-6768"] = {areaId = "", address = "55 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["12035-6768"] = {areaId = "", address = "57 OAK ST, WEST POINT KY 40177"}
BWOPostData.box["12059-6768"] = {areaId = "", address = "59 OAK ST, WEST POINT KY 40177"}

BWOPostData.box["11239-6717"] = {areaId = "", address = "1 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11244-6710"] = {areaId = "", address = "2 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11218-6717"] = {areaId = "", address = "3 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11214-6710"] = {areaId = "", address = "4 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11196-6717"] = {areaId = "", address = "5 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11194-6710"] = {areaId = "", address = "6 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11178-6715"] = {areaId = "", address = "8 MILLER DR, WEST POINT KY 40177"}
BWOPostData.box["11175-6736"] = {areaId = "", address = "10 MILLER DR, WEST POINT KY 40177"}


BWOPostData.box["11266-6734"] = {areaId = "", address = "2 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11266-6714"] = {areaId = "", address = "4 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11292-6686"] = {areaId = "", address = "5 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11302-6686"] = {areaId = "", address = "7 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11322-6686"] = {areaId = "", address = "9 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11348-6686"] = {areaId = "", address = "11 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11417-6686"] = {areaId = "", address = "17 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11419-6696"] = {areaId = "", address = "18 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11441-6686"] = {areaId = "", address = "19 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11470-6717"] = {areaId = "", address = "20 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11479-6712"] = {areaId = "", address = "21 OHIO DR, WEST POINT KY 40177"}
BWOPostData.box["11479-6728"] = {areaId = "", address = "23 OHIO DR, WEST POINT KY 40177"}


BWOPostData.box["11238-6766"] = {areaId = "", address = "1 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11232-6771"] = {areaId = "", address = "2 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11238-6789"] = {areaId = "", address = "3 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11232-6796"] = {areaId = "", address = "4 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11238-6821"] = {areaId = "", address = "5 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11232-6811"] = {areaId = "", address = "6 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11238-6822"] = {areaId = "", address = "7 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11232-6852"] = {areaId = "", address = "8 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11238-6864"] = {areaId = "", address = "9 SALT ST, WEST POINT KY 40177"}
BWOPostData.box["11232-6853"] = {areaId = "", address = "10 SALT ST, WEST POINT KY 40177"}

BWOPostData.box["11291-6852"] = {areaId = "", address = "2 GOGGINS ST, WEST POINT KY 40177"}
BWOPostData.box["11292-6852"] = {areaId = "", address = "4 GOGGINS ST, WEST POINT KY 40177"}
BWOPostData.box["11333-6852"] = {areaId = "", address = "6 GOGGINS ST, WEST POINT KY 40177"}
BWOPostData.box["11348-6852"] = {areaId = "", address = "8 GOGGINS ST, WEST POINT KY 40177"}
BWOPostData.box["11374-6852"] = {areaId = "", address = "10 GOGGINS ST, WEST POINT KY 40177"}

BWOPostData.box["11441-6828"] = {areaId = "", address = "2 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11462-6828"] = {areaId = "", address = "4 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11489-6818"] = {areaId = "", address = "5 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11489-6828"] = {areaId = "", address = "6 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11500-6818"] = {areaId = "", address = "7 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11511-6828"] = {areaId = "", address = "8 YOUNG ST, WEST POINT KY 40177"}
BWOPostData.box["11528-6828"] = {areaId = "", address = "10 YOUNG ST, WEST POINT KY 40177"}

BWOPostData.box["11152-6895"] = {areaId = "", address = "1 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11163-6895"] = {areaId = "", address = "3 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11291-6894"] = {areaId = "", address = "5 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11292-6894"] = {areaId = "", address = "7 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11320-6905"] = {areaId = "", address = "8 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11332-6894"] = {areaId = "", address = "9 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11347-6894"] = {areaId = "", address = "11 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11373-6894"] = {areaId = "", address = "13 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11416-6905"] = {areaId = "", address = "14 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11426-6894"] = {areaId = "", address = "15 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11433-6905"] = {areaId = "", address = "16 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11437-6894"] = {areaId = "", address = "17 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11460-6905"] = {areaId = "", address = "18 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11464-6894"] = {areaId = "", address = "19 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11480-6905"] = {areaId = "", address = "20 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11490-6894"] = {areaId = "", address = "21 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11505-6905"] = {areaId = "", address = "22 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11505-6894"] = {areaId = "", address = "23 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11536-6905"] = {areaId = "", address = "24 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11581-6894"] = {areaId = "", address = "25 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11566-6905"] = {areaId = "", address = "26 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11607-6894"] = {areaId = "", address = "27 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11587-6905"] = {areaId = "", address = "28 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11629-6894"] = {areaId = "", address = "29 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11606-6905"] = {areaId = "", address = "30 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11656-6894"] = {areaId = "", address = "31 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11647-6905"] = {areaId = "", address = "32 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11663-6894"] = {areaId = "", address = "33 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11664-6905"] = {areaId = "", address = "34 MAIN ST, WEST POINT KY 40177"}
BWOPostData.box["11683-6905"] = {areaId = "", address = "36 MAIN ST, WEST POINT KY 40177"}


