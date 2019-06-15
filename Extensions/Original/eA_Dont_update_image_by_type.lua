--[[ <HCExtension>
@name          �� ��������� �������� �� ���� � ������� (A-img)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   �� ��������� �������� �� ���� ����� � ��������� ������ �������
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


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

 -- ������ ��� GET-��������
  if hc.method == 'GET' then

   -- �������� ��� ����� �� ��������� 'Content-Type'
    local Type = GetContentType(hc.answer_header)
   -- ���� �� � ���� ��������� 'Content-Type' ����� 'image'
    if Type~=nil then img = string.find(Type,'image',1,true)
    else img = nil  end
   -- �������� ������ ����� �� ��������� 'Content-Length' 
    local Len = GetContentLength(hc.answer_header)

      if img~=nil then
         -- ���� �������� ���� � ���� � �� ������ �� ������� �� �������� ��� ������ 1000 ���� (�� ������ � 1 �����)
          if hc.cache_file_size>=0 and (Len == -1 or Len > 1000) then
           -- �� �� ��������� ��������
            hc.action = 'dont_update-'
            hc.monitor_string = hc.monitor_string..'A-img '
          end  
      end
  end

end  -- ����� ������� Answer
