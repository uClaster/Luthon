local list = {} 
local format, sub = string.format, string.sub 
local abs = math.abs 

function add_builtin(arr, parent) 
    
    for i, v in pairs(parent) do 
        if type(i) == "string" then 
            arr[i] = v
        end     
    end     
    
    return arr 
    
end     

function check(checkType, t, k, rawMeta) --> nil
    if checkType == "number" then 
        if type(k) == "number" then 
            if rawget(t, k) == nil then error("List index out of range.") end
        end     
    elseif checkType == "numberinsert" then 
        if type(k) == "number" then 
            
            if rawget(t, k-1) == nil and k >= 2 then error("List index out of range.") end 
        end     
    elseif checkType == "slicing" then 
        
        if type(k) ~= "string" then return end
        
        if string.find(k, ":") == nil then return end  
        
        local start, _end = tonumber(sub(k, 0, 1)), tonumber(sub(k, 3, 3)) 
        
        slicedArr = {} 
        
        setmetatable(slicedArr, getmetatable(t))
        
        real_index = 0
        
        for _, v in pairs(t) do 
            if type(_) == "number" then real_index = real_index + 1 end 
            if real_index >= start and real_index <= _end then 
                table.insert(slicedArr, v)
            end     
        end
        
        slicedArr = add_builtin(slicedArr, t)
        
        return slicedArr
        
    end     
end     

function list:new(arr) 
    
    if type(arr) ~= "table" then return error(format("Table expected. got %s", type(arr))) end
    
    arr["clear"], arr["append"], arr["index"] = self.clear, self.append, self.index
    
    local listMeta = {
        
        __index = function(self, k) 
            
            check("number", self, k)
            
            local res = check("slicing", self, k, listMeta)
            
            if res then return res end 
            
            return rawget(self, k)
            
        end,     
        
        __newindex = function(self, k, v) 
            
            check("numberinsert", self, k)
            rawset(self, k, v)
            
        end,     
        
        __call = function(self)
            
            formatted = {} 
            
            for i, v in pairs(self) do
                if type(v) ~= "function" then 
                    table.insert(formatted, v)
                end 
            end   
            
            formatted = table.concat(formatted, ", ")
            
            print(format("[%s]", formatted))
            
        end     
    }
    
    setmetatable(arr, listMeta)
    
    return arr
    
end  

function list.clear(self) 
    
    for k in pairs(self) do 
        if k ~= "function" then 
            self[k] = nil
        end     
    end     
    return self 
end

function list.append(self, value) 
    table.insert(self, value) 
    return self 
end     

function list.index(self, value) 
    for i, v in pairs(self) do 
        if v == value then return i end 
    end    
    return nil 
end     

return list 