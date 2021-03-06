--
-- 日志
-- 2017/10/18
-- Author LOLO
--

local print = print
local xpcall = xpcall
local tostring = tostring
local traceback = debug.traceback
local concat = table.concat


---@class Logger
local Logger = {}

local ed = EventDispatcher.New()
Logger._ed = ed




--- 添加一条错误日志（存入 LogInfo 列表）
--- 如果想添加一条包含调用堆栈信息的错误日志，请使用 error() 函数抛出错误
---@param message string @ 日志内容
---@return void
function Logger.AddErrorLog(msg)
    print(msg)
end


--=---------------------------[ error traceback ]---------------------------=--

local logError = Logger.AddErrorLog
--- 错误内容和堆栈捕获
---@param msg string
---@return void
function Logger.ErrorTraceback(msg)
    local err = {
        "[LUA ERROR] ",
        tostring(msg),
        traceback("", 2)
    }
    logError(concat(err, ""))
end


local isJIT = isJIT
local traceback = Logger.ErrorTraceback
--- 调用 fn，并捕获出现的错误（ try ... catch ）
---@param fn fun() @ 传入的函数
---@param caller any @ self 对象，默认为 nil
---@return flag, msg
function Logger.TryCall(fn, caller)
    if isJIT then
        return xpcall(fn, traceback, caller)
    else
        if caller ~= nil then
            return xpcall(function()
                fn(caller)
            end, traceback)
        else
            return xpcall(fn, traceback)
        end
    end
end

--=-------------------------------------------------------------------------=--







return Logger