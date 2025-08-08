--[[

MIT License

Copyright (c) 2025 Promeum

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

-- BigMath Library
-- @author Promeum

-- A math module implementation for BigNum.

local BigNum = require(script.Parent.BigNum)

-- Constants
local PI = BigNum.newFraction("3.141592653589793e16", "1e16")
local E = BigNum.newFraction("2.718281828459045e16", "1e16")
local RAD_TO_DEG = BigNum.newFraction("180e16", "3.141592653589793e16")
local DEG_TO_RAD = BigNum.newFraction("3.141592653589793e16", "180e16")

-- BigMath
local BigMath = {}

-- Math Functions

function abs(a)
	return if a:IsNegative() then -a else a
end

function acos(a)
	return toFraction(math.acos(toDecimal(a)))
end

function asin(a)
	return toFraction(math.asin(toDecimal(a)))
end

function atan(a)
	return toFraction(math.atan(toDecimal(a)))
end

function atan2(y, x)
	return toFraction(math.atan2(toDecimal(y), toDecimal(x)))
end

function ceil(a)
	if newtypeof(a) == "Fraction" then
		if not a:IsNegative() then
			return a.Numerator / a.Denominator + sign(a.Numerator)
		else
			return a.Numerator / a.Denominator
		end
	else
		return a
	end
end

function clamp(a, minimum, maximum)
	return max(minimum, min(a, maximum))
end

function cos(a)
	return toFraction(math.cos(toDecimal(a)))
end

function cosh(a)
	return toFraction(math.cosh(toDecimal(a)))
end

function deg(a)
	return toFraction(a) * RAD_TO_DEG
end

function exp(a)
	return toFraction(math.exp(toDecimal(a)))
end

function factorial(n)
	local result = BigNum.new(1)

	for i = toDecimal(n), 1, -1 do
		result *= i
	end

	return result
end

function floor(a)
	if newtypeof(a) == "Fraction" then
		if not a:IsNegative() then
			return a.Numerator / a.Denominator
		else
			return a.Numerator / a.Denominator + sign(a.Numerator)
		end
	else
		return a
	end
end

function fmod(a, b)
	if newtypeof(a) == "BigNum" then
		return (abs(a) % b) * BigNum.new(sign(a))
	else
		return (abs(a) - BigNum.newFraction(floor(abs(a) / b), 1)) * BigNum.newFraction(sign(a), 1)
	end
end

function frexp(a)
	local result = math.frexp(toDecimal(a))
	return toFraction(result[1]), toBigNum(result[2])
end

function ldexp(a, e)
	a = toBigNum(a)
	return toFraction(math.ldexp(toDecimal(a), toDecimal(e)))
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function log(a, b) -- special parameters
	if b then
		return toFraction(math.log(toDecimal(a), toDecimal(b)))
	else
		return toFraction(math.log(toDecimal(a)))
	end
end

function log10(a)
	return toFraction(math.log10(toDecimal(a)))
end

function map(a, inmin, inmax, outmin, outmax)
	local ratio = toFraction(outmax - outmin) / (inmax - inmin)
	return (a - inmin) * ratio + outmin
end

function max(...)
	if #... == 0 then
		return nil
	end

	local array = ...
	local result = array[1]

	for _, v in array do
		if v > result then
			result = v
		end
	end

	return result
end

function min(...)
	if #... == 0 then
		return nil
	end

	local array = ...
	local result = array[1]

	for _, v in array do
		if v < result then
			result = v
		end
	end

	return result
end

function modf(a)
	if newtypeof(a) == "BigNum" then
		return a, BigNum.new(0)
	else
		local aReduced = a:Reduce()
		return aReduced.Numerator, aReduced.Denominator
	end
end

function noise(x, y, z) -- special parameters
	return toFraction(math.noise(toDecimal(x), if y then toDecimal(y) else 0, if z then toDecimal(z) else 0))
end

function pow(a, b)
	return toFraction(math.pow(toDecimal(a), toDecimal(b)))
end

function rad(a)
	return toFraction(a) * DEG_TO_RAD
end

function random(m, n) -- special parameters
	return toFraction(math.random(if m then toDecimal(m) else 0, if n then toDecimal(n) else 1))
end

function randomseed(a)
	math.randomseed(toDecimal(a))
end

function round(a)
	local fraction = toFraction(a)
	return toFractionOrBigNum(math.round(toDecimal(fraction.Numerator) / toDecimal(fraction.Denominator)))
end

function sign(a)
	if a == 0 then
		return 0
	elseif a:IsNegative() then
		return -1
	else
		return 1
	end
end

function sin(a)
	return toFraction(math.sin(toDecimal(a)))
end

function sinh(a)
	return toFraction(math.sinh(toDecimal(a)))
end

function sort(...)
	local array = ...
	local resultArray = {}

	for i, v in array do
		resultArray[i] = toFraction(v)
	end

	table.sort(resultArray)

	return resultArray
end

local ONE_OVER_TWO = BigNum.newFraction(1, 2)

function sqrt(a)
	return pow(a, ONE_OVER_TWO)
end

function tan(a)
	return toFraction(math.tan(toDecimal(a)))
end

function tanh(a)
	return toFraction(math.tanh(toDecimal(a)))
end

-- Supplementary Functions And Et Cetera

function toDecimal(a)
	local type_a = newtypeof(a)

	if type_a == "BigNum" then
		return a:toScientificNotation()
	elseif type_a == "Fraction" then
		return a:toNumber()
	elseif type_a == "number" then
		return a
	else
		return error("bad argument: expected BigNum or Fraction, got " .. type_a)
	end
end

function toFraction(a)
	local type_a = newtypeof(a)

	if type_a == "number" then
		if a ~= a then
			error(`a is nan ({a})`)
			-- return BigNum.newFraction(0, 0)
		elseif math.abs(a) == math.huge then
			error(`a is inf ({a})`)
			-- return BigNum.newFraction(math.sign(a), 0)
		end
		a = tostring(a)
	end

	if type_a == "string" then
		local eLocation = a:find("e")

		if not eLocation then
			local aSplit = a:split(".")
			local powerOfTen = if #aSplit == 2 then aSplit[2]:len() else 0

			return BigNum.newFraction(table.concat(aSplit, ""), 10 ^ powerOfTen):Reduce()
		else
			local eSplit = a:split("e")
			local ePower = tonumber(eSplit[2])
			local aSplit = eSplit[1]:split(".")
			local powerOfTen = (if #aSplit == 2 then aSplit[2]:len() else 0) - ePower

			if math.sign(powerOfTen) == -1 then
				return BigNum.newFraction(a, 1)
			else
				return BigNum.newFraction(table.concat(aSplit, ""), 10 ^ powerOfTen):Reduce()
			end
		end
	elseif type_a == "Fraction" then
		return a:Reduce()
	elseif type_a == "BigNum" then
		return BigNum.newFraction(a, 1)
	else
		return error("bad argument: expected BigNum or Fraction or number, got " .. type_a)
	end
end

function toFractionOrBigNum(a)
	local result = toFraction(a)

	return if result.Denominator == BigNum.new(1) then result.Numerator else result
end

function toBigNum(a)
	local result = toFraction(a)

	return if result.Denominator == BigNum.new(1) then result.Numerator else error("argument could not be converted into BigNum, result: " .. result)
end

function isNaN(a)
	local type_a = newtypeof(a)

	if type_a == "number" then
		return a ~= a
	elseif type_a == "Fraction" then
		return a.Numerator == 0 and a.Denominator == 0
	elseif type_a == "BigNum" then
		return false
	else
		return error("bad argument: expected BigNum or Fraction or number, got " .. type_a)
	end
end

function newtypeof(value)
	if type(value) == "table" then
		if getmetatable(value) == BigNum.Fraction then
			return "Fraction"
		elseif getmetatable(value) == BigNum then
			return "BigNum"
		else
			return typeof(value)
		end
	else
		return typeof(value)
	end
end

-- Wrapper Functions

local function EnsureCompatibility(Func, ParameterCount)
	if not ParameterCount or ParameterCount == 1 then
		return function(a, ...)
			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum, Fraction, number, or string, got " .. newtypeof(a))
			end

			a = toFraction(a)

			return Func(a, ...)
		end
	elseif ParameterCount == 2 then
		return function(a, b)
			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum or Fraction, got " .. newtypeof(a))
			end

			a = toFraction(a)
			
			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(b)) then
				error("bad argument to #1: expected BigNum or Fraction, got " .. newtypeof(b))
			end

			b = toFraction(b)
			
			if #a ~= #b then
				error("You cannot operate on Fractions with BigNums of different sizes: " .. #a .. " and " .. #b)
			end

			return Func(a, b)
		end
	elseif ParameterCount == 3 then
		return function(a, b, c)
			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum or Fraction, got " .. newtypeof(a))
			end

			a = toFraction(a)

			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(b)) then
				error("bad argument to #2: expected BigNum or Fraction, got " .. newtypeof(b))
			end

			b = toFraction(b)

			if not table.find({"Fraction", "BigNum", "number", "string"}, newtypeof(c)) then
				error("bad argument to #3: expected BigNum or Fraction, got " .. newtypeof(c))
			end

			c = toFraction(c)

		if #a ~= #b or #a ~= #c then
				error("You cannot operate on BigNums with different radix: " .. #a .. " and " .. #b .. " and " .. #c)
			end

			return Func(a, b, c)
		end
	else
		error("ParameterCount not in range (1, 3), got " .. ParameterCount)
	end
end

local function EnsureCompatibilityBigNum(Func, ParameterCount)
	if not ParameterCount or ParameterCount == 1 then
		return function(a, ...)
			if not table.find({"BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum, got " .. newtypeof(a))
			end

			a = toFraction(a)

			return Func(a, ...)
		end
	elseif ParameterCount == 2 then
		return function(a, b)
			if not table.find({"BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum, got " .. newtypeof(a))
			end

			a = toFraction(a)

			if not table.find({"BigNum", "number", "string"}, newtypeof(b)) then
				error("bad argument to #2: expected BigNum, got " .. newtypeof(b))
			end

			b = toFraction(b)

			if #a ~= #b then
				error("You cannot operate on BigNums with different radix: " .. #a .. " and " .. #b)
			end

			return Func(a, b)
		end
	elseif ParameterCount == 3 then
		return function(a, b, c)
			if not table.find({"BigNum", "number", "string"}, newtypeof(a)) then
				error("bad argument to #1: expected BigNum, got " .. newtypeof(a))
			end

			a = toFraction(a)

			if not table.find({"BigNum", "number", "string"}, newtypeof(b)) then
				error("bad argument to #2: expected BigNum, got " .. newtypeof(b))
			end

			b = toFraction(b)

			if not table.find({"BigNum", "number", "string"}, newtypeof(c)) then
				error("bad argument to #3: expected BigNum, got " .. newtypeof(c))
			end

			c = toFraction(c)

		if #a ~= #b or #a ~= #c then
				error("You cannot operate on BigNums with different radix: " .. #a .. " and " .. #b .. " and " .. #c)
			end

			return Func(a, b, c)
		end
	else
		error("ParameterCount not in range (1, 3), got " .. ParameterCount)
	end
end

-- Setup BigMath

BigMath.pi = PI
BigMath.e = E

BigMath.abs = EnsureCompatibility(abs)
BigMath.acos = EnsureCompatibility(acos)
BigMath.asin = EnsureCompatibility(asin)
BigMath.atan = EnsureCompatibility(atan)
BigMath.atan2 = EnsureCompatibility(atan2, 2)
BigMath.ceil = EnsureCompatibility(ceil)
BigMath.clamp = EnsureCompatibility(clamp, 3)
BigMath.cos = EnsureCompatibility(cos)
BigMath.cosh = EnsureCompatibility(cosh)
BigMath.deg = EnsureCompatibility(deg)
BigMath.exp = EnsureCompatibility(exp)
BigMath.factorial = EnsureCompatibilityBigNum(factorial)
BigMath.floor = EnsureCompatibility(floor)
BigMath.fmod = EnsureCompatibility(fmod, 2)
BigMath.frexp = EnsureCompatibility(frexp)
BigMath.ldexp = EnsureCompatibility(ldexp, 2)
BigMath.lerp = EnsureCompatibility(lerp, 3)
BigMath.log = EnsureCompatibility(log)
BigMath.log10 = EnsureCompatibility(log10)
BigMath.map = EnsureCompatibility(map)
BigMath.max = EnsureCompatibility(max)
BigMath.min = EnsureCompatibility(min)
BigMath.modf = EnsureCompatibility(modf)
BigMath.noise = EnsureCompatibility(noise)
BigMath.pow = EnsureCompatibility(pow, 2)
BigMath.rad = EnsureCompatibility(rad)
BigMath.random = random
BigMath.randomseed = EnsureCompatibility(randomseed)
BigMath.round = EnsureCompatibility(round)
BigMath.sign = EnsureCompatibility(sign)
BigMath.sin = EnsureCompatibility(sin)
BigMath.sinh = EnsureCompatibility(sinh)
BigMath.sort = EnsureCompatibility(sort)
BigMath.sqrt = EnsureCompatibility(sqrt)
BigMath.tan = EnsureCompatibility(tan)
BigMath.tanh = EnsureCompatibility(tanh)

BigMath.toFraction = toFraction
BigMath.toFractionOrBigNum = toFractionOrBigNum
BigMath.toBigNum = toBigNum
BigMath.toDecimal = EnsureCompatibility(toDecimal, true)

BigMath.isNaN = EnsureCompatibility(isNaN, true)
BigMath.typeof = newtypeof

return BigMath

--[[
the old taylor series trig mechanisms (abandoned; built-in math functions are more efficient)

local TAYLOR_SERIES_ITERATIONS = 9

local SinTaylorSeriesCoefficients = {}
local CosTaylorSeriesCoefficients = {}
local TanTaylorSeriesCoefficients = {
	BigNum.newFraction("1", "1"),
	BigNum.newFraction("1", "3"),
	BigNum.newFraction("2", "15"),
	BigNum.newFraction("17", "315"),
	BigNum.newFraction("62", "2835"),
	BigNum.newFraction("1382", "155925"),
	BigNum.newFraction("21844", "6081075"),
	BigNum.newFraction("929569", "638512875"),
	BigNum.newFraction("6404582", "10854718875"),
	BigNum.newFraction("18888466084", "194896477400625"),
	BigNum.newFraction("113927491862", "2900518163668125"),
	BigNum.newFraction("58870668456604", "3698160658676859375"),
	BigNum.newFraction("8374643517010684", "1298054391195577640625"),
	BigNum.newFraction("689005380505609448", "263505041412702261046875"),
	BigNum.newFraction("129848163681107301953", "122529844256906551386796875"),
	BigNum.newFraction("1736640792209901647222", "4043484860477916195764296875"),
}
local NLogTaylorSeriesCoefficients = {}

for n = 0, TAYLOR_SERIES_ITERATIONS - 1 do
	table.insert(SinTaylorSeriesCoefficients, BigNum.newFraction(((-1) ^ n) * factorial(2 * n + 1), 1))
	table.insert(CosTaylorSeriesCoefficients, BigNum.newFraction(((-1) ^ n) * factorial(2 * n), 1))
	table.insert(NLogTaylorSeriesCoefficients, BigNum.new(((-1) ^ (n - 1)) * n))
end

function proto_sin(x)
	local summation = BigNum.newFraction(0, 1)

	for n = 1, TAYLOR_SERIES_ITERATIONS do
		summation += pow(x, BigNum.newFraction(2 * n, 1)) / SinTaylorSeriesCoefficients[n]
		summation = summation:Reduce()
	end

	return summation
end

function proto_cos(x)
	local summation = BigNum.newFraction(0, 1)

	for n = 0, TAYLOR_SERIES_ITERATIONS - 1 do
		summation += pow(x, BigNum.newFraction(2 * n, 1)) / CosTaylorSeriesCoefficients[n + 1]
	end

	return summation
end

local PI_OVER_2 = PI * BigNum.newFraction(1, 2)
local PI_OVER_4 = PI * BigNum.newFraction(1, 4)
local PI3_OVER_4 = PI * BigNum.newFraction(3, 4)
local PI3_OVER_4_NEGATIVE = PI * BigNum.newFraction(3, 4)

function sin(a)
	if newtypeof(a) == "BigNum" then
		a = BigNum.newFraction(a, 1)
	end

	local x = fmod(a, PI):Reduce()
	
	-- https://www.desmos.com/calculator/tx7bgjwxuf
	if abs(x) < PI_OVER_4 then
		return proto_sin(x)
	elseif sign(x) == 1 then
		if x <= PI3_OVER_4 then
			return proto_cos(x - PI_OVER_2)
		else
			return -proto_sin(x - PI)
		end
	else
		if x >= PI3_OVER_4_NEGATIVE then
			return -proto_cos(x + PI_OVER_2)
		else
			return -proto_sin(x + PI)
		end
	end
end

function cos(a)
	if newtypeof(a) == "BigNum" then
		a = BigNum.newFraction(a, 1)
	end

	local x = fmod(a, PI):Reduce()
	
	-- https://www.desmos.com/calculator/tx7bgjwxuf
	if abs(x) < PI_OVER_4 then
		return proto_cos(x)
	elseif sign(x) == 1 then
		if x <= PI3_OVER_4 then
			return -proto_sin(x - PI_OVER_2)
		else
			return -proto_cos(x - PI)
		end
	else
		if x >= PI3_OVER_4_NEGATIVE then
			return proto_sin(x + PI_OVER_2)
		else
			return -proto_cos(x + PI)
		end
	end
end

function tan(a)
	if newtypeof(a) == "BigNum" then
		a = BigNum.newFraction(a, 1)
	end

	local x = fmod(a, PI_OVER_2):Reduce()

	local summation = BigNum.newFraction(0, 1)

	for n = 0, TAYLOR_SERIES_ITERATIONS - 1 do
		summation += pow(x, BigNum.newFraction(2 * n, 1)) * TanTaylorSeriesCoefficients[n + 1]
	end

	return summation
end

-- No support for logarithms with bases other than e yet
function log(a)
	if newtypeof(a) == "BigNum" then
		assert(a < BigNum.new(1) and a > BigNum.new(0), `a is out of range (0, 1) ({a})`)
	elseif newtypeof(a) == "Fraction" then
		assert(a < BigNum.newFraction(1, 1) and a > BigNum.newFraction(0, 1), `a is out of range (0, 1) ({a})`)
	end
	

	local summation = Constants.ZERO_FRACTION

	for n = 1, TAYLOR_SERIES_ITERATIONS do
		summation += BigNum.newFraction(BigNum.new((a - 1) ^ n), NLogTaylorSeriesCoefficients[n])
	end

	return summation
end

--]]