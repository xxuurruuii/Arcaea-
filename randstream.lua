 -- 该脚本在 Lua♭ for Arcade-One 环境下运行。

ToolsProviders = {"RandJiaoHu"} -- 使用 ToolsProviders 申明所有该脚本内的外置工具
ToolsNames = {"随机交互生成器"} -- 与 ToolsProviders 一一对应，为工具的用户友好名称
RandJiaoHu_Params = {"BPM","起始时间","结束时间","节拍划分","出张程度(1-3)","起手(1左2右0不指定)","叠键"}
RandJiaoHu_ParamsValue = {"100","0","0","16","1","0","False"}

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
	if (fanshou>=2 or fanshou<=-2) and (x>=2 or x<=-2) and (Flat.rand(1,3)==1) then return -100 end
    return x
end

function DrawTap(k,Timing)
	if k%2==1 then
		note=NewArcEvent(EventType.Tap)
		note.Timing=Timing
		note.track=Math.Floor(k/2)+1
		AddArcEvent(note)
	else
		arc=NewArcEvent(EventType.Arc)
		arc.Timing=Timing
		arc.EndTiming=Timing+1
		arc.XStart=(k-2)/4
		arc.XEnd=(k-2)/4
		arc.YStart=1
		arc.YEnd=1
		arc.LineType=ArcLineType.S
		arc.IsVoid=true
		note=NewArcEvent(EventType.ArcTap)
		note.Timing=Timing
		AddArcEvent(arc)
		AddArcTap(arc,note)
	end
end

function RandJiaoHu(Bpm,BaseTiming,EndTiming,Divide,MaxFanshou,qishou,Stack)
	Bpm=Flat.ToFloat(Bpm) -- 将 string 转换为 float
	BaseTiming = Flat.ToFloat(BaseTiming)
	EndTiming = Flat.ToFloat(EndTiming)
	Divide = Flat.ToFloat(Divide)
	MaxFanshou = Flat.ToFloat(MaxFanshou)
	qishou = Flat.ToFloat(qishou)
	if MaxFanshou<1 or MaxFanshou>3 then return "出张程度不合法" end
	if Stack=="False" then
		Stack=false
	else
		Stack=true
	end
	n=0.5+(EndTiming-BaseTiming)/(60/Bpm*1000*4/Divide)+1
	n=n-n%1
	if qishou==0 then
		qishou=Flat.Rand(0,2)
	elseif qishou==1 then
		qishou=0
	else 
		qishou=1
	end
	repeat
		l,r=Flat.Rand(1,8),Flat.Rand(1,8)
	until l-r>1 or r-l>1
	if l>r then l,r=r,l end
	fanshou=check(l,r,0,MaxFanshou,Stack)
	trycount=0
	for i=0,n-1 do
		if i%2==qishou then
			DrawTap(l,Math.Floor(BaseTiming+i*60/Bpm*1000*4/Divide))
			repeat
				l=Flat.Rand(1,8)
				temp=check(l,r,fanshou,MaxFanshou,Stack)
				trycount=trycount+1
			until temp~=-100 or trycount>10000
			fanshou=temp
		else
			DrawTap(r,Math.Floor(BaseTiming+i*60/Bpm*1000*4/Divide))
			repeat
				r=Flat.Rand(1,8)
				temp=check(l,r,fanshou,MaxFanshou,Stack)
				trycount=trycount+1
			until temp~=-100 or trycount>10000
			fanshou=temp
		end
		if trycount>10002 then return "Error" end
	end
	return "1"
	--[[
	for i,j in pairs(note) do
		s=s..i
	end
	return s
	--]]
end
