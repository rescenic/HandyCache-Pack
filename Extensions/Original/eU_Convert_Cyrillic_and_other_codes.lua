--[[<HCExtension>
@name              �������������� URL: ���� �������� ���� %Dx%xx � %�� � �������� ������� (�-Conv)
@author            DenZzz
@version           0.4
@min_HC_version    1.0.0.228
@description       ����������� ���� �������� ���� %Dx%xx (UTF8) � %�� (Win1251) � �������� ������� ��� ������������� �� � ������ ������
@rule              %[A-F2-7]
@event             Init/Init
@event             URLToFileNameConverting/Converting
</HCExtension>]]


-- ������� ������� ��������

function Init()
 hc_static.CodeTable = {
  { Char = '�', UTF8 = [[%D0%90]], Win1251 = [[%C0]] },
  { Char = '�', UTF8 = [[%D0%91]], Win1251 = [[%C1]] },
  { Char = '�', UTF8 = [[%D0%90]], Win1251 = [[%C0]] },
  { Char = '�', UTF8 = [[%D0%91]], Win1251 = [[%C1]] },
  { Char = '�', UTF8 = [[%D0%92]], Win1251 = [[%C2]] },
  { Char = '�', UTF8 = [[%D0%93]], Win1251 = [[%C3]] },
  { Char = '�', UTF8 = [[%D0%94]], Win1251 = [[%C4]] },
  { Char = '�', UTF8 = [[%D0%95]], Win1251 = [[%C5]] },
  { Char = '�', UTF8 = [[%D0%96]], Win1251 = [[%C6]] },
  { Char = '�', UTF8 = [[%D0%97]], Win1251 = [[%C7]] },
  { Char = '�', UTF8 = [[%D0%98]], Win1251 = [[%C8]] },
  { Char = '�', UTF8 = [[%D0%99]], Win1251 = [[%C9]] },
  { Char = '�', UTF8 = [[%D0%9A]], Win1251 = [[%CA]] },
  { Char = '�', UTF8 = [[%D0%9B]], Win1251 = [[%CB]] },
  { Char = '�', UTF8 = [[%D0%9C]], Win1251 = [[%CC]] },
  { Char = '�', UTF8 = [[%D0%9D]], Win1251 = [[%CD]] },
  { Char = '�', UTF8 = [[%D0%9E]], Win1251 = [[%CE]] },
  { Char = '�', UTF8 = [[%D0%9F]], Win1251 = [[%CF]] },
  { Char = '�', UTF8 = [[%D0%A0]], Win1251 = [[%D0]] },
  { Char = '�', UTF8 = [[%D0%A1]], Win1251 = [[%D1]] },
  { Char = '�', UTF8 = [[%D0%A2]], Win1251 = [[%D2]] },
  { Char = '�', UTF8 = [[%D0%A3]], Win1251 = [[%D3]] },
  { Char = '�', UTF8 = [[%D0%A4]], Win1251 = [[%D4]] },
  { Char = '�', UTF8 = [[%D0%A5]], Win1251 = [[%D5]] },
  { Char = '�', UTF8 = [[%D0%A6]], Win1251 = [[%D6]] },
  { Char = '�', UTF8 = [[%D0%A7]], Win1251 = [[%D7]] },
  { Char = '�', UTF8 = [[%D0%A8]], Win1251 = [[%D8]] },
  { Char = '�', UTF8 = [[%D0%A9]], Win1251 = [[%D9]] },
  { Char = '�', UTF8 = [[%D0%AA]], Win1251 = [[%DA]] },
  { Char = '�', UTF8 = [[%D0%AB]], Win1251 = [[%DB]] },
  { Char = '�', UTF8 = [[%D0%AC]], Win1251 = [[%DC]] },
  { Char = '�', UTF8 = [[%D0%AD]], Win1251 = [[%DD]] },
  { Char = '�', UTF8 = [[%D0%AE]], Win1251 = [[%DE]] },
  { Char = '�', UTF8 = [[%D0%AF]], Win1251 = [[%DF]] },
  { Char = '�', UTF8 = [[%D0%B0]], Win1251 = [[%E0]] },
  { Char = '�', UTF8 = [[%D0%B1]], Win1251 = [[%E1]] },
  { Char = '�', UTF8 = [[%D0%B2]], Win1251 = [[%E2]] },
  { Char = '�', UTF8 = [[%D0%B3]], Win1251 = [[%E3]] },
  { Char = '�', UTF8 = [[%D0%B4]], Win1251 = [[%E4]] },
  { Char = '�', UTF8 = [[%D0%B5]], Win1251 = [[%E5]] },
  { Char = '�', UTF8 = [[%D0%B6]], Win1251 = [[%E6]] },
  { Char = '�', UTF8 = [[%D0%B7]], Win1251 = [[%E7]] },
  { Char = '�', UTF8 = [[%D0%B8]], Win1251 = [[%E8]] },
  { Char = '�', UTF8 = [[%D0%B9]], Win1251 = [[%E9]] },
  { Char = '�', UTF8 = [[%D0%BA]], Win1251 = [[%EA]] },
  { Char = '�', UTF8 = [[%D0%BB]], Win1251 = [[%EB]] },
  { Char = '�', UTF8 = [[%D0%BC]], Win1251 = [[%EC]] },
  { Char = '�', UTF8 = [[%D0%BD]], Win1251 = [[%ED]] },
  { Char = '�', UTF8 = [[%D0%BE]], Win1251 = [[%EE]] },
  { Char = '�', UTF8 = [[%D0%BF]], Win1251 = [[%EF]] },
  { Char = '�', UTF8 = [[%D1%80]], Win1251 = [[%F0]] },
  { Char = '�', UTF8 = [[%D1%81]], Win1251 = [[%F1]] },
  { Char = '�', UTF8 = [[%D1%82]], Win1251 = [[%F2]] },
  { Char = '�', UTF8 = [[%D1%83]], Win1251 = [[%F3]] },
  { Char = '�', UTF8 = [[%D1%84]], Win1251 = [[%F4]] },
  { Char = '�', UTF8 = [[%D1%85]], Win1251 = [[%F5]] },
  { Char = '�', UTF8 = [[%D1%86]], Win1251 = [[%F6]] },
  { Char = '�', UTF8 = [[%D1%87]], Win1251 = [[%F7]] },
  { Char = '�', UTF8 = [[%D1%88]], Win1251 = [[%F8]] },
  { Char = '�', UTF8 = [[%D1%89]], Win1251 = [[%F9]] },
  { Char = '�', UTF8 = [[%D1%8A]], Win1251 = [[%FA]] },
  { Char = '�', UTF8 = [[%D1%8B]], Win1251 = [[%FB]] },
  { Char = '�', UTF8 = [[%D1%8C]], Win1251 = [[%FC]] },
  { Char = '�', UTF8 = [[%D1%8D]], Win1251 = [[%FD]] },
  { Char = '�', UTF8 = [[%D1%8E]], Win1251 = [[%FE]] },
  { Char = '�', UTF8 = [[%D1%8F]], Win1251 = [[%FF]] },
  { Char = '�', UTF8 = [[%D0%81]], Win1251 = [[%A8]] },
  { Char = '�', UTF8 = [[%D1%91]], Win1251 = [[%B8]] }  }

 hc_static.CodeTableSpec = {
  { Char = '%', Code = [[%(25)+]]},
  { Char = '$', Code = [[%24]] },
  { Char = '&', Code = [[%26]] },
  { Char = "'", Code = [[%27]] },
  { Char = '(', Code = [[%28]] },
  { Char = ')', Code = [[%29]] },
  { Char = '+', Code = [[%2B]] },
  { Char = ',', Code = [[%2C]] },
  { Char = '-', Code = [[%2D]] },
  { Char = ';', Code = [[%3B]] },
  { Char = '=', Code = [[%3D]] },
  { Char = '@', Code = [[%40]] },
  { Char = '[', Code = [[%5B]] },
  { Char = ']', Code = [[%5D]] },
  { Char = '_', Code = [[%5F]] },
  { Char = '{', Code = [[%7B]] },
  { Char = '}', Code = [[%7D]] }  }

end


-- �������������� ����� � �������� �������

function Converting()

 if not conv_url then conv_url = {} end
 local work_url = conv_url[hc.monitor_index] or hc.url

 if re.match(work_url, [=[%[2-7]]=]) then
  for i = 1, #hc_static.CodeTableSpec do
   work_url = re.replace(work_url, hc_static.CodeTableSpec[i].Code, hc_static.CodeTableSpec[i].Char, true)
  end
 end

 if re.match(work_url, [=[%D[01]%[89AB]]=]) then
  for i = 1, #hc_static.CodeTable do
   work_url = re.replace(work_url, hc_static.CodeTable[i].UTF8, hc_static.CodeTable[i].Char, true)
  end
 end

 if re.match(work_url, [=[%[A-F]]=]) then
  for i = 1, #hc_static.CodeTable do
   work_url = re.replace(work_url, hc_static.CodeTable[i].Win1251, hc_static.CodeTable[i].Char, true)
  end
 end

 if work_url ~= (conv_url[hc.monitor_index] or hc.url) then
  hc.preform_cache_file_name(hc.prepare_url(work_url))
  --hc.put_to_log(hc.prepare_url(work_url))
  hc.monitor_string = hc.monitor_string .. '�-Conv'
 end
 conv_url[hc.monitor_index] = nil
end
