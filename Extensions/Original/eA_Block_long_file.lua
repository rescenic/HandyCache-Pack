--[[ <HCExtension>
@name          ����������� �������� ������� ������ (A-long)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   ��������� �������� ������, ������� ������ ��������� ����������� �������
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]



function GetContentLength(s)
  _,_,x = string.find(s, '[cC]ontent%-[lL]ength: *(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end



function Answer()

 -- �������� ������ ����� �� ��������� 'Content-Length' 
  local Len = GetContentLength(hc.answer_header)

   -- ���� ������ ����� ���� � ��������� � �� ������ 1000000 ����
    if Len > 1000000 then
     -- � �������� HC ��� �� ��������� ��� ��������� '���������', �� ����������� ��������
      if hc.action=='' or hc.action==nil or hc.action=='save' or hc.action=='save-' then
        hc.action = 'stop-'
        hc.monitor_string = hc.monitor_string..'A-long '
      end
    end

end  -- ����� ������� Answer
