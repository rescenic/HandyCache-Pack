--[[ <HCExtension>
@name            Opera Turbo Agent
@author          DenZzz
@version         0.5
@min_HC_version  1.0.0.228
@description     ����� ��� ������ Opera Turbo ����� HandyCache
@rule            ^http://\w*-turbo[^.]*\.opera-mini\.net:80/
@event           Init/Init
@event           Options/Options
@event           BeforeViewInMonitor/BeforeView
@event           BeforeRequestHeaderSend/RequestSend
@event           AnswerHeaderReceived/AnswerReceived
@event           BeforeAnswerHeaderSend/AnswerSend
@event           URLToFileNameConverting/Converting
</HCExtension> ]]

---------------------------------------------------------------------------------------------------------------------

function BeforeView()
	if not OTA_Request_URL then OTA_Request_URL = {} end
	local X_Opera_Info = re.find(hc.request_header, [[^X-Opera-Info: ID=\d+]])
	local Opera_ID = re.find(X_Opera_Info, [[ID=(\d+)]], 1)
	Opera_Turbo_Host = re.find(hc.url, [[^http://\K[^/]+]])
	--X_Opera_Host = re.find(hc.request_header, [[^X-Opera-Host: [^\r\n]+]])
	OTA_Request_URL[Opera_ID] = hc.url

	hc.monitor_text_color = 0 + 90*256 + 0*256*256  -- ���� ����� �����-������� (R+G+B)
	local referer = re.find(hc.monitor_parent_url, [[^http://\K(?!\w*-turbo[^.]*\.opera-mini\.net:80/)[^\r\n]+]])
	if referer then
		hc.monitor_parent_url = 'http://'..Opera_Turbo_Host..'/'..referer		-- ����������� ����� � �������� HC
	end
end

---------------------------------------------------------------------------------------------------------------------

function RequestSend()
	-- ������ �� ������� ������������ ��� ������ ����� ������������ (�������������) ������, ������� �� ����� keep-alive (� �������� ��� ���� ����� ������� 502)
	if hc_static.OTA_Options['Disconnect_Old_Connections'].On then
		if os.time() - (Last_request_time or os.time()) > 3 then
			hc.client_disconnect()		-- ���� ���������� � ��������, ���� ��� ����������� ������ 3 ������
			hc.monitor_string = hc.monitor_string..'OTA: Disconnect Time-Out'
			--hc.put_to_log('\r\n===== ���������� � �������� ��������� ����������� ��-�� ������� �������!')
		end
		Last_request_time = os.time()
	end

	-- ���������� ��������� ��������
	hc.repeat_options('no_answer', 0, 0)
	hc.repeat_options('request', 0, 0)

	-- ������ � ����� ������������� (��������������) ������
	if hc_static.OTA_Options['No_Cache_on_Parent_Proxy'].On then
		if not re.match(hc.request_header, [[^Pragma: ]]) then
			hc.request_header = re.replace(hc.request_header, [[\r\n\K(?=\r\n)]], 'Pragma: no-cache\r\n')		-- ��������� �������������� ������ �� ����� ����� �� ������ ����
		end
	end

	-- ��� �������� ����� �������� ��� ������ �������� � ������ ��������
	if hc_static.OTA_Options['Download_Pictures_from_Original_Servers'].On then
		if re.match(hc.url, [[^http://.*\.(bmp|gif|i[mp]g|ico|jpe?g|png|tiff?)(\?|$)]]) and hc.method=='GET' then
			hc.update_url_info(hc.url)
			local request_url = re.find(hc.request_header, [[\AGET +\K[^\r\n]+(?= +HTTP/)]])
			if re.find(request_url, [[^/]]) then
				local Host = re.find(hc.request_header, [[^Host: *\K[^\r\n]+]])
				if Host then request_url = 'http://'..Host..request_url end
			end
			local direct_url = re.replace(request_url, [[http://\K\w*-turbo[^.]*\.opera-mini\.net:80/]])
			local direct_host = re.find(direct_url, [[http://\K[^/]+]])
			hc.request_header = re.replace(hc.request_header, [[\AGET \K[^\r\n]+(?= HTTP/)]], direct_url)
			hc.request_header = re.replace(hc.request_header, [[^Host: \K[^\r\n]+]], direct_host)
			hc.repeat_options('request', nil, nil)
			hc.monitor_string = hc.monitor_string..'OTA: Direct '
			--hc.put_to_log('\r\n===== ����� ������� �������� �������� � ������� �������. ������ URL:  ', direct_url)
		end
	end
--	hc.request_header = re.replace(hc.request_header, [=[^X-Opera-Info: ID=\d+, \Kp=[34]]=], 'p=0')   -- �������� ��� ������ � ������� �����
end

---------------------------------------------------------------------------------------------------------------------

function AnswerReceived()
	if not OTA_Server_ID then OTA_Server_ID = {} end
	OTA_Server_ID[hc.monitor_index] = re.find(hc.answer_header, [[^X-Opera-Info: ID=(\d+)]], 1)   -- ID � �������������� ������ �������� �������
	--hc.put_to_log('\r\n===== ��������� ���  ', hc.url, '  ������� � �������:\r\n', hc.answer_header)
end

---------------------------------------------------------------------------------------------------------------------

function AnswerSend()
	--hc.put_to_log('\r\n===== ����� ����������� BeforeAnswerHeaderSend ���  ', hc.url)
	local X_Opera_Info = re.find(hc.request_header, [[^X-Opera-Info: ID=\d+]])

	if not re.match(hc.answer_header, [[^X-Opera-Info:]]) then
		hc.answer_header = re.replace(hc.answer_header, [[\r\n\K(?=\r\n)]], X_Opera_Info..'\r\n')		-- ������������ ��������� ��� �����-������
	end
	local Opera_ID = re.find(hc.answer_header, [[^X-Opera-Info: ID=(\d+)]], 1)

	if not re.match(hc.answer_header, X_Opera_Info) then  -- ���� ID � ������� � �������� ������ �� ���������
		hc.monitor_string = hc.monitor_string..'OTA: Other ID '
		if not OTA_Server_ID or not OTA_Server_ID[hc.monitor_index] or (OTA_Server_ID and OTA_Server_ID[hc.monitor_index] and OTA_Server_ID[hc.monitor_index] ~= Opera_ID) or re.match(hc.answer_header, [[^X-Cache: HIT]]) then
			-- ���� ����� ����������� ��� HC  ���  ���� � �������� ������� ������ ����� 304 (��� 200 + A-size) � HC ����� ���� �� RAM-���� �� ������� �����������  ���  ���� ����� ������� ������������� ������ �� ������ ����, �� ������ ID.
			hc.answer_header = re.replace(hc.answer_header, [[^X-Opera-Info: ID=\d+]], X_Opera_Info)		-- ����� ID ��� ������ � ������� ������ ���������� �� ���� HC ��� �� ���� ������������� ������
			hc.monitor_string = hc.monitor_string..'- changed '
			--hc.put_to_log('\r\n===== ID � ��������� ������ ��� ������� ���  ', hc.url)
		end
	end

	--hc.put_to_log('\r\n===== ��������� ���  ', hc.url, '  ��������� � ����� � �������� �������:\r\n', hc.answer_header)

	if re.match(hc.answer_header, [[\AHTTP/1\.\d 502]]) then
		hc.client_disconnect()		-- ���� ���������� � ��������, ����� ������ �� �������� �� ��������� ������� (���������������� ��� HC ������ 1.0.0.196 � ����)
		hc.monitor_string = hc.monitor_string..'OTA: Disconnect 502 '
		--hc.put_to_log('\r\n===== ���������� � �������� ��������� ����������� ��-�� ������ 502 ���  ', hc.url)
	end

	-- ������ � ������������� ��� ������ ����� ������������ (�������������) ������ 1.0, ������� �� ������ keep-alive � �������� (� �������� ��� ���� ����� ������� 502)
	if hc_static.OTA_Options['Switch_Off_Pipelining_for_1_0_Proxy'].On then
		--if re.match(hc.answer_header, [[^Via:[^\r\n]*1\.0]]) then
			hc.answer_header = re.replace(hc.answer_header, [[\AHTTP/1\.1]], 'HTTP/1.0')
			hc.answer_header = re.replace(hc.answer_header, [[^Connection: \K(?!close)[^\r\n]+]], 'close')
		--end
	end
end

---------------------------------------------------------------------------------------------------------------------

function Converting()
	--hc.put_to_log('\r\n===== ������ ���������� URLToFileNameConverting ���  ', hc.url, '\r\n===== ������ ������ � �������� HC: ', hc.monitor_index)
	if not conv_url then conv_url = {} end
	conv_url[hc.monitor_index] = nil
	local work_url = nil
	local Opera_ID = re.find(hc.answer_header, [[^X-Opera-Info: ID=(\d+)]], 1)
	if Opera_ID and OTA_Request_URL and OTA_Request_URL[Opera_ID] and OTA_Request_URL[Opera_ID] ~= hc.url then
		work_url = OTA_Request_URL[Opera_ID]
		hc.monitor_string = hc.monitor_string..'OTA: File name changed '
	end
	work_url = re.replace((work_url or hc.url), [[^http://\K\w*-turbo[^.]*\.opera-mini\.net:80/]])
	if work_url ~= hc.url then
		hc.preform_cache_file_name(hc.prepare_url(work_url))
		conv_url[hc.monitor_index] = work_url
		--hc.put_to_log('\r\n===== ���������� URLToFileNameConverting ���������  ', hc.url, '\r\n===== ����� ����:  ', work_url)
	end
end


---------------------------------------------------------------------------------------------------------------------

function Init()
	hc_static.OTA_Options = {}
	hc_static.OTA_Options['Disconnect_Old_Connections'] = {
		Rus_name = '��������� ������ ���������� � ��������� ��� ������ ����� ������������ (�������������) ������, ������� �� ����� ������������ Keep-Alive ����������',
		Rus_hint = '�������� � ������ �������� ���������� ������� "502 Bad Gateway" � �������� HC',
		On = false,
		Position = 1	}
	hc_static.OTA_Options['Switch_Off_Pipelining_for_1_0_Proxy'] = {
		Rus_name = '��������� �������� ������������ Pipelining � Keep-Alive (HC ����� �������� �� ��������� HTTP/1.0 � ��������� ����������)',
		Rus_hint = '�������� � ������ �������� ���������� ������� "Client disconnected" ������ � �������� HC � ���������� �������� �������',
		On = false,
		Position = 2	}
	hc_static.OTA_Options['No_Cache_on_Parent_Proxy'] = {
		Rus_name = '��������� ������������� (��������������) ������ �������� ������������ ����� �� ������ ����',
		Rus_hint = '�������� � ������ �������� ������ (��������) � �������� ���������� ������� "401 Unauthorized"',
		On = false,
		Position = 3	}
	hc_static.OTA_Options['Download_Pictures_from_Original_Servers'] = {
		Rus_name = '��������� ����� �������� ��� ������ �������� � ������ �������� ������',
		Rus_hint = '�������� ��� �������� ����� �������� �������� ��� ������',
		On = false,
		Position = 4	}

	local f = io.open(re.replace(hc.script_name, [[(.*\.).*]], [[\1ini]]), 'r')
	if f then
		local t = {}
		while true do
			local s = f:read("*line")
			if s then table.insert(t, s) else break end
		end
		f:close()
		for i=1, #t do
			local option = re.find(t[i], [[(\w+)=]], 1)
			local value = re.find(t[i], [[=(\w+)]], 1)
			if option and hc_static.OTA_Options[option] and value == 'true' then
				hc_static.OTA_Options[option].On = true
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------

function Options()
	require "vcl"
	if Form then
		Form:Free()
		Form=nil
	end

	local hei = 130 + 40*(#hc_static.OTA_Options + 1)

	Form = VCL.Form('Form')
	OkButton = VCL.Button(Form, "OkButton")
	CancelButton = VCL.Button(Form, "CancelButton")
	Form._ = {Caption='��������� Opera Turbo Agent', Width=700, ClientHeight=hei+OkButton.Height+10, Position='poOwnerFormCenter'}
	OkButton._ = {Caption = "���������", Width=100, Left=100, Top= Form.ClientHeight-OkButton.Height-10, OnClick = "onOkButtonClick"}
	CancelButton._ = {Caption = "��������", Width=100, Left=480, Top=OkButton.Top, OnClick = "onCancelButtonClick"}

	cb = {}
	for k,v in pairs(hc_static.OTA_Options) do
		cb[k] = VCL.CheckBox(Form, 'cb'..k)
		cb[k]._= {Caption=v.Rus_name, Hint=v.Rus_hint, ShowHint=true, WordWrap=true, Top=10+35*(v.Position-1), Left=30, Height=35, Width=620, Checked=v.On}
	end

	Form:ShowModal()
	Form:Free()
	Form=nil
end


function onOkButtonClick(Sender)
	for k,v in pairs(hc_static.OTA_Options) do
		v.On = cb[k].Checked
	end
	Form:Close()
	SaveOptions()
end


function onCancelButtonClick(Sender)
	Form:Close()
end


function SaveOptions()
	local f = assert(io.open(re.replace(hc.script_name, [[(.*\.).*]], [[\1ini]]), 'w'))
	if not f then return end
	for k,v in pairs(hc_static.OTA_Options) do
		if v.On == true then
			f:write(k .. '=true\n')
		else
			f:write(k .. '=false\n')
		end
	end
	f:close()
end
