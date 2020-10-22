
local old_path = package.path
package.path = _CM_DIR .. '?.lua'
require('cm_common')
package.path = old_path

hc.put_to_log('Content Master destroy started...')

local users = loadstring(hc.get_global('CM_USERS'))()

users.ALL.AutoUpdate = hc.get_global('CM_AUTO_UPDATE')
users.ALL.StatUpdatePeriod = hc.get_global('CM_AUTO_STAT')

_CM_WRITE_FILE(hc.script_name:match('.*%.') .. 'ini', 'wb', _CM_SAVE_TABLE(users))

-- ����������� ������ ���������� ����������
hc.remove_global('CM_WORKERS')	-- ����������� �������� ���������� ���� (html, js, css, raw, url)

local js_parsers = hc.get_global_table_item('CM_PARSERS', 'JS')
if js_parsers then
	for _,v in pairs(js_parsers) do	-- ������ ������������������ � ���� JS-��������
		if v:sub(1, 1)=='*' then re.unregister_regex(v) end
	end
end
hc.remove_global('CM_PARSERS')	-- ������ �������� (html, js)

local function unregister_rules(rules)
	if type(rules)=='table' then
		for _,v in pairs(rules) do unregister_rules(v) end
	elseif type(rules)=='string' and rules:sub(1, 1)=='*' then
		re.unregister_regex(rules)
	end
end
unregister_rules(hc.get_global('CM_RULES'))	-- ������� ������������������ � ���� �� ��������
hc.remove_global('CM_RULES')	-- �������, ��������������� �� ����� ������������ � ���� ��������

hc.remove_global('CM_RULES_SOURCE')	-- ������ � �������, ������ ����� � ������ ������ � ���� ����� ��� ������� �������
hc.remove_global('CM_RULES_ADDITIONS')	-- �������������� ������ (�����, ������ ������ � �.�.) ��� ��������� ������

hc.remove_global('CM_OPTIONS')	-- ��������� ��������� ��:
--	SystemCoding				: �����		- ������ �������, �� ������� ������� ��. ��������: https://msdn.microsoft.com/en-us/library/windows/desktop/dd317756(v=vs.85).aspx
--	LanguageID					: �����		- ���� ��. ��� ��������� ������� ���� �� �� hc.language_id. ��������: https://support.microsoft.com/en-us/kb/221435
--	LAST_OPTIONS_CHANGE_TIME	: �����		- ����� ���������� ��������� �������� ��
--	ExtensionName				: ������	- ������������ ���������� (������������ ��� �������������� ����������� ��)
--	Version						: ������	- ����� ������ ��
--	ctypes						: �������	- ������ ������������ ���������� ����� �������� ���������� ����� (html, js)
--	HaveDifferentUsers			: boolean	- ����, ������������ ������� ������������� � ������� �����������

hc.remove_global('CM_USERS')	-- ������ ������������� � ��������� � ������� ���������� ��� ���� ����� ��������, ��������, ������ ��������
hc.remove_global('CM_URL_CACHE')	-- ��� ������������ �������� �� URL
hc.remove_global('CM_AUTO_UPDATE')
hc.remove_global('CM_AUTO_STAT')
hc.remove_global('CM_DOMS')	-- DOM �������, ����������� ��� ���������� ������������� ������ (���� �� ���������� �������!!!)
hc.remove_global('CM_COMMON')	-- ���������� ����� �������
hc.remove_global('CM_LANGUAGES')
hc.remove_global('CM_ADMUNCHER_FILES')
hc.remove_global('CM_SITE_SPECIFIC_CSS')
hc.remove_global('CM_SITE_SPECIFIC_JS')
hc.remove_global('CM_ABP_SITE_SPECIFIC_CSS')

local rtmp = hc.get_global('CM_ABP_GENERIC_BLOCK_REGEX') or {}
for k,v in pairs(rtmp) do
	re.unregister_regex(v)
end
hc.remove_global('CM_ABP_GENERIC_BLOCK_REGEX')
local rtmp = hc.get_global('CM_ABP_GENERIC_HIDE_REGEX') or {}
for k,v in pairs(rtmp) do
	re.unregister_regex(v)
end
hc.remove_global('CM_ABP_GENERIC_HIDE_REGEX')


_CM_SAVE_HITS()	-- ���� ������ ������������ ������ ��������
hc.remove_global('CM_HITS')
hc.remove_global('CM_LAST_HITS_SAVE_TIME')	-- ����� ���������� �������������� ����� ������������ ������

hc.remove_global('CM_REMOVE_INTERACTIVE_MODE_BY_USERS')
hc.remove_global('CM_ORIGINAL_RULES')	-- ��� ����� ������, �������� �� ������� (��� ������ � ��� ������������ �������)
hc.remove_global('CM_UPDATE_COUNTER')	-- ������� �������� ����������

hc.remove_global('CM_HTML_ENGINE_INITIALIZED')	-- ���� ��������������� ����� ������������� HTML-������ ��� ������� ������������. ����������� ������� JS ����������� ��� ��������� ������� HTML. ������ ��� �� ����� ������� ����� ��������� helper_ss.js. � ���� ������ ������ �����



hc.put_to_log('Content Master destroyed')
