--[[ <HCExtension>
@name          �� ��������� ����� �� ���� � ���� (RS-vid)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.185) � �������� ����
@description   �� ��������� ����� �� ��������� ����� � ���� ��� ������� �� ������
@event         BeforeRequestHeaderSend/Request
</HCExtension> ]]



function Request()

 -- ������ ��� GET-��������
  if hc.method == 'GET' then

   -- ��������, �������� �� ���� � ���� �����-������
    vid = string.find(hc.cache_file_content_type,'video',1,true) 

      if vid~=nil then
       -- ���� ���� � ���� - �����, �� ����� ��� �� ����
        hc.action = 'dont_update-'
        hc.monitor_string = hc.monitor_string..'RS-vid '
      end  

  end  -- ����� ����� '������ ��� GET-��������'

end  -- ����� ������� Request
