--[[ <HCExtension>
@name          �� ��������� ����� �� ���� � ������� (A-vid)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   �� ��������� ����� �� ���� ����� � ��������� ������ �������
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetContentType(s)
  _,_,x = string.find(s, '[cC]ontent%-[tT]ype: *([^;\r\n]+)')
  if x~=nil then x = string.lower(x) end
  return x
end



function Answer()

 -- ������ ��� GET-��������
  if hc.method == 'GET' then

   -- �������� ��� ����� �� ��������� 'Content-Type'
    local Type = GetContentType(hc.answer_header)
   -- ���� �� � ���� ��������� 'Content-Type' ����� 'video'
    if Type~=nil then vid = string.find(Type,'video',1,true)
    else vid = nil  end

      if vid~=nil then
         -- ���� ����� ���� � ����
          if hc.cache_file_size>=0 then 
           -- �� �� ��������� �����
            hc.action = 'dont_update-'
            hc.monitor_string = hc.monitor_string..'A-vid '
          end  
      end
  end

end  -- ����� ������� Answer
