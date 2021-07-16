local luthon = require("./luthon/init")
local list = luthon.list 
local exception = luthon.exception 

local myList = list:new({"hi", "sequence", "gnome"}) 

local dorman = myList["1:2"] 

print(dorman()) -- [hi, sequence]

exception:try(function()
    print(myList[4])
end):except(function(err)
    print("suppressed error: "..err)
end) -- catched 

print("hahsja") 