--[[ <HCExtension>
@name          ��������� ��� ����������� ������ 403 � 404 (A-40X)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   ��������� ��� ��������� ������ 403 � 404
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetAnswerCode(s)
  _,_,x = string.find(s, 'HTTP/1%.%d +(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end

function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *([^;\r\n]+)')
  if x~=nil then x = string.lower(x) end
  return x
end

function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end



function Answer()

 -- �������� ��� ������ �� ���������
  local answ_code = GetAnswerCode(hc.answer_header)
 -- �������� ��� ����� �� ��������� 'Content-Type'
  local Type = GetContentType(hc.answer_header)
 -- ���� �� � ���� ��������� 'Content-Type' ����� 'image'
  if Type~=nil then img = string.find(Type,'image',1,true)
  else img = nil  end
 -- �������� ������ ����� �� ��������� 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

 -- ���� ��� ������ 403 ��� 404
  if answ_code==403 or answ_code==404 then

   -- � ���� ��� '��������', �� ��������� �� � ����
    if img~=nil then
       hc.action = 'save-'
       hc.monitor_string = hc.monitor_string..'A-40Xs '
   -- ���� ��� �� '��������'
    else    
     -- � ���� � ��������� ��� ������� ����� ��� �� ������ 1000 ���� (�� ������ � 1 �����), �� ����������� ��������
      if Len == -1 or Len > 1000 then
       hc.action = 'stop-'
       hc.monitor_string = hc.monitor_string..'A-40X '
      end
    end

  end

end  -- ����� ������� Answer

