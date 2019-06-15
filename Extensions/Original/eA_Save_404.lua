--[[ <HCExtension>
@name          ��������� ������ ������ 404 (A-404s)
@author        DenZzz
@version       1.1 ��� HC v1.00 RC2 (1.0.0.175) � �������� ����
@description   ��������� ������ ������ � ����� '404 Not Found'
@rule          /favicon\.ico$
@rule          ^http://www\.computer-museum\.ru/
@event         AnswerHeaderReceived/Answer
</HCExtension> ]]


function GetAnswerCode(s)
  _,_,x = string.find(s, 'HTTP/1%.%d +(%d+)')
  if x==nil then return -1 else return tonumber(x) end
end


function Answer()

 -- �������� ��� ������ �� ���������
  answ_code = GetAnswerCode(hc.answer_header)

 -- ���� ��� ������ 404
  if answ_code==404 then
     hc.action = 'save-'
     hc.monitor_string = hc.monitor_string..'A-404s '
     hc.answer_header,_ = string.gsub(hc.answer_header, '^HTTP/1%.%d +404', 'HTTP/1.1 200', 1)
  end

end  -- ����� ������� Answer
