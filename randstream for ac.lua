ScriptInfo = {
	id = "xxuurruuii.randstream",
	title = "随机交互生成器",
	desc = "这是一个随机交互生成器。它会在给定的时间范围内在7个位置随机生成交互。",
	author = "xxuurruuii",
	version = "1.0",
	compatibility = "Arcade-Chan>=3.3.3",
	arguments = {
		{
			type = "number", -- 支持number/string/boolean
			name = "BPM",
			required = true
		},
		{
			type = "number",
			name = "起始时间",
			required = true
		},
		{
			type = "number",
			name = "结束时间",
			required = true
		},
		{
			type = "number",
			name = "节拍划分",
			required = false,
			default = 16
		},
		{
			type = "number",
			name = "出张程度(1-3)",
			required = false,
			default = 1
		},
		{
			type = "number",
			name = "起手(1左2右0不指定)",
			required = false,
			default = 0
		},
		{
			type = "boolean",
			name = "叠键",
			required = false,
			default = false
		}
	}
}

function check(l,r,fanshou,MaxFanshou,Stack)
	if (Stack==false) and (l==r) then return -100 end
	if l-r>=3 then return -100 end
	x=0
	if (l-r)%2==0 then
		if l<=r then x=0
		else
			x=3
			if fanshou<0 then x=-3 end
		end
	else
		if r%2==1 then
			if l<r then x=1 else x=2 end
		else
			if l<r then x=-1 else x=-2 end
		end
	end
	if (x-fanshou>2) or (x-fanshou<-2) then return -100 end
	if (x>MaxFanshou) or (x<-MaxFanshou) then return -100 end
	if (fanshou>=2 or fanshou<=-2) and (x>=2 or x<=-2) and (Math.RandInt(1,3)==1) then return -100 end
    return x
end

function DrawTap(k,Timing)
    local chart = ChartInstance
	if k%2==1 then
        note=ScriptTap.Create(Timing, Math.Floor(k/2)+1)
		chart:AddTap(note)
	else
        arc=ScriptArc.Create(Timing,Timing+1,0,(k-2)/4,(k-2)/4,1,1,"s","true")
        -- note=ScriptArcTap.Create(arc,Timing)
        -- chart:AddArc(arc)
		arc:AddArcTap(Timing)
		chart:AddArc(arc)
	end
end

function ScriptMain(...)
	local args = {...}
    local Bpm = args[1]
    local BaseTiming = args[2]
    local EndTiming = args[3]
    local Divide = args[4] or 16
    local MaxFanshou = args[5] or 1
    local qishou = args[6] or 0
    local Stack = args[7] or false

    if MaxFanshou<1 or MaxFanshou>3 then return "出张程度不合法" end
	n=0.5+(EndTiming-BaseTiming)/(60/Bpm*1000*4/Divide)+1
	n=n-n%1
	if qishou==0 then
		qishou=Math.RandInt(0,2)
	elseif qishou==1 then
		qishou=0
	else 
		qishou=1
	end
	repeat
		l,r=Math.RandInt(1,8),Math.RandInt(1,8)
	until l-r>1 or r-l>1
	if l>r then l,r=r,l end
	fanshou=check(l,r,0,MaxFanshou,Stack)
	trycount=0
	for i=0,n-1 do
		if i%2==qishou then
			DrawTap(l,Math.Floor(BaseTiming+i*60/Bpm*1000*4/Divide))
			repeat
				l=Math.RandInt(1,8)
				temp=check(l,r,fanshou,MaxFanshou,Stack)
				trycount=trycount+1
			until temp~=-100 or trycount>10000
			fanshou=temp
		else
			DrawTap(r,Math.Floor(BaseTiming+i*60/Bpm*1000*4/Divide))
			repeat
				r=Math.RandInt(1,8)
				temp=check(l,r,fanshou,MaxFanshou,Stack)
				trycount=trycount+1
			until temp~=-100 or trycount>10000
			fanshou=temp
		end
		if trycount>10002 then return "Error" end
	end
	return "1"
end