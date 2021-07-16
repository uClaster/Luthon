
local exception = {} 

local handle = {}

function exception:except(callback) 
    
    if not handle["success"] then callback(handle["error"]) end
    
end     

function exception:try(callback) 
    
    local success, err = pcall(callback)
    
    handle["success"] = success 
    handle["error"] = err
    
    return {
        except = self.except
    }
    
end     

return exception