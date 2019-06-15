--[[ <HCExtension>
@name          �� ��������� ����� �� ������� (A-size)
@author        DenZzz
@version       1.3 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   �� ��������� ����, ���� ��� ������ �� ���������
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end

function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *(.-) *\r?\n')
  if x~=nil then x = string.lower(x) end
  return x
end

function GetContentEncoding(s)
  _,_,x = string.find(s, '[cC]ontent%-[eE]ncoding: *(.-) *\r?\n')
  if x~=nil then x = string.lower(x) end
  return x
end



function Answer()

 -- ������ ��� GET-��������
 if hc.method == 'GET' then

  -- �������� ������ ����� �� ��������� 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

  -- ���� � ��������� ���� ������ ����� � �� ������ 1000 ����
  if Len > 1000 then

   -- � ���� ������� ����� � ���� � �� ������� �����        
   if hc.cache_file_size == Len then
    -- �� �������� �������� � ������� � ��������� ���� �� ����
    hc.action = 'dont_update-'
    hc.monitor_string = hc.monitor_string..'A-size '

   -- ���� ������� �� �����:
   else    
    -- �������� ���������� ��������� 'Content-Encoding' 
    local Enc = GetContentEncoding(hc.answer_header)
    -- �������� ��� ����� �� ��������� 'Content-Type'
    local Type = GetContentType(hc.answer_header)
    local Len2 = nil

    -- ��������� ���������� ��������� 'Content-Encoding' � ������� 'Content-Type'
    if Enc == nil and Type ~= nil then
      -- � ���� ��� HTML ��� XML
      if string.find(Type,'text/html',1,true) ~= nil or string.find(Type,'/xml',1,true) ~= nil then
       -- ��������� ����� ����� � ���� � ������ ����������� HC ����
       Len2 = Len + 5 + string.len(Type) + 21 + 4
      end
    end

    -- ���� ����� ������������ ���� ��������� � �������� ����� � ����
    if Len2 ~= nil and hc.cache_file_size == Len2 then
     -- �� �������� �������� � ������� � ��������� ���� �� ����
     hc.action = 'dont_update-'
     hc.monitor_string = hc.monitor_string..'A-size2 '
    end

   end  -- ����� ����� ��������� �������� � �������� �������
  end  -- ����� ����� '������ ������ 1000 ����'
 end  -- ����� ����� '������ ��� GET-��������'

end  -- ����� ������� Answer
