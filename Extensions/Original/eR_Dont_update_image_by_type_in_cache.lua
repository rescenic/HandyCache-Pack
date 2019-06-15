--[[ <HCExtension>
@name          �� ��������� �������� �� ���� � ���� (RS-img)
@author        DenZzz
@version       1.2 ��� HC v1.00 RC2 (1.0.0.185) � �������� ����
@description   �� ��������� �������� �� ��������� ����� � ���� ��� ������� �� ������
@event         BeforeRequestHeaderSend/Request
</HCExtension> ]]



function Request()

 -- ������ ��� GET-��������
  if hc.method == 'GET' then

   -- ��������, �������� �� ���� � ���� ���������
    img = string.find(hc.cache_file_content_type,'image',1,true) 

      if img~=nil then
       -- ���� ���� � ���� - ��������, �� ����� �� �� ����
        hc.action = 'dont_update-'
        hc.monitor_string = hc.monitor_string..'RS-img '
      end  

  end  -- ����� ����� '������ ��� GET-��������'

end  -- ����� ������� Request
