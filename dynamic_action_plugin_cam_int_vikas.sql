prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1810418193191039
,p_default_application_id=>113
,p_default_owner=>'ADMIN'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/cam_int_vikas
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(13672039227262334819)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'CAM.INT.VIKAS'
,p_display_name=>'Cam_Integration'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION F_RENDER (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT AS',
'    VR_RESULT         APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'BEGIN',
'    IF apex_application.g_debug THEN',
'      apex_plugin_util.debug_dynamic_action',
'        ( p_plugin         => p_plugin',
'        , p_dynamic_action => p_dynamic_action);',
'    END IF;     ',
'   APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''CamIntegration'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''vikas''',
'    );',
' VR_RESULT.JAVASCRIPT_FUNCTION   := ''',
'    function () {CamIntegration(this, ''||APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE )||',
'                                         APEX_JAVASCRIPT.ADD_VALUE( P_DYNAMIC_ACTION.ATTRIBUTE_02, TRUE )  ||',
'                                         APEX_JAVASCRIPT.ADD_VALUE( P_DYNAMIC_ACTION.ATTRIBUTE_03, FALSE ) ||''',
'                                );',
'                      }'';',
'    RETURN VR_RESULT;    ',
'    ',
'END;',
'',
'',
'',
'',
'FUNCTION CAM_AJAX (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT IS',
'    VR_RESULT         APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'    l_plsql_code P_DYNAMIC_ACTION.attribute_01%TYPE := P_DYNAMIC_ACTION.attribute_01;',
'BEGIN',
'    apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql_code);',
'    RETURN null;',
'END;',
'',
''))
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'CAM_AJAX'
,p_standard_attributes=>'REGION'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>91
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13672390861511358226)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'PLSQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>false
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_collection_name VARCHAR2(100);',
'  l_clob            CLOB;',
'  l_blob            BLOB;',
'  l_filename        VARCHAR2(100);',
'  l_mime_type       VARCHAR2(100);',
'  l_token           VARCHAR2(32000);',
'  --',
'BEGIN',
'   -- get defaults',
'  l_filename  := ''snap_'' ||',
'                 to_char(SYSDATE,',
'                         ''YYYYMMDDHH24MISS'') || ''.png'';',
'  l_mime_type := ''image/png'';',
'  -- build CLOB from f01 30k Array',
'  dbms_lob.createtemporary(l_clob,',
'                           FALSE,',
'                           dbms_lob.session);',
'',
'  FOR i IN 1 .. apex_application.g_f01.count LOOP',
'    l_token := wwv_flow.g_f01(i);',
'  ',
'    IF length(l_token) > 0 THEN',
'      dbms_lob.writeappend(l_clob,',
'                           length(l_token),',
'                           l_token);',
'    END IF;',
'  END LOOP;',
'  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);',
'  l_collection_name := ''PHOTOS'';',
'  -- check if exist',
'  IF NOT',
'      apex_collection.collection_exists(p_collection_name => l_collection_name) THEN',
'    apex_collection.create_collection(l_collection_name);',
'  END IF;',
'  IF dbms_lob.getlength(lob_loc => l_blob) IS NOT NULL THEN',
'    apex_collection.add_member(p_collection_name => l_collection_name,',
'                               p_c001            => l_filename, -- filename',
'                               p_c002            => l_mime_type, -- mime_type',
'                               p_d001            => SYSDATE, -- date created',
'                               p_blob001         => l_blob); -- BLOB img content',
'  END IF;',
' ',
' exception when others then ',
'  raise_application_error(-20001,DBMS_UTILITY.format_error_backtrace);',
'END;'))
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select photos.seq_id, dbms_lob.getlength(photos.blob001)image,',
'       photos.seq_id as view_photo',
'from apex_collections photos',
'where photos.collection_name = ''PHOTOS'''))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31299972955971659745)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(253084885642668015)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Button Label'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Save'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20436C6F62746F417272617928652C742C61297B6C6F6F70436F756E743D4D6174682E666C6F6F7228652E6C656E6774682F74292B313B666F7228766172206E3D303B6E3C6C6F6F70436F756E743B6E2B2B29612E7075736828652E';
wwv_flow_api.g_varchar2_table(2) := '736C69636528742A6E2C742A286E2B312929293B72657475726E20617D66756E6374696F6E20436F6E76657274546F4261736536342865297B72657475726E20652E73756273747228652E696E6465784F6628222C22292B31297D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(3) := '5361766532436F6C6C656374696F6E28652C742C612C6E297B766172206F3D5B5D3B6F3D436C6F62746F417272617928436F6E76657274546F4261736536342874292C3365342C6F292C617065782E7365727665722E706C7567696E28652C7B70616765';
wwv_flow_api.g_varchar2_table(4) := '4974656D733A612C6630313A6F7D2C7B64617461547970653A2268746D6C222C737563636573733A66756E6374696F6E2865297B617065782E7375626D697428297D7D297D66756E6374696F6E2043616D496E746567726174696F6E28652C742C612C6E';
wwv_flow_api.g_varchar2_table(5) := '297B636F6E7374206F3D5B2428652E6166666563746564456C656D656E7473295D3B242E65616368286F2C2866756E6374696F6E28652C6F297B76617220693D6F5B305D2E69643B2428222E696D6167652D636170747572652D6865616422292E6C656E';
wwv_flow_api.g_varchar2_table(6) := '6774683E303F2428222E696D6167652D636170747572652D6865616422292E72656D6F766528293A24282866756E6374696F6E28297B76617220653D2428273C646976207374796C653D22746578742D616C69676E3A63656E7465723B2220636C617373';
wwv_flow_api.g_varchar2_table(7) := '3D22696D6167652D636170747572652D68656164223E203C766964656F2069643D22766964656F222077696474683D2236343022206865696768743D2234383022206175746F706C61793E3C2F766964656F3E203C63616E7661732069643D2263616E76';
wwv_flow_api.g_varchar2_table(8) := '6173222077696474683D2236343022206865696768743D2234383022207374796C653D22646973706C61793A6E6F6E653B223E3C2F63616E7661733E3C627574746F6E20747970653D22627574746F6E222069643D22736176652D696D6167652D636170';
wwv_flow_api.g_varchar2_table(9) := '747572652220636C6173733D22742D427574746F6E20742D427574746F6E2D2D7072696D617279223E272B6E2B223C2F627574746F6E3E203C2F6469763E22293B24282223222B69292E617070656E642865293B766172206F2C723D646F63756D656E74';
wwv_flow_api.g_varchar2_table(10) := '2E676574456C656D656E74427949642822766964656F22292C633D646F63756D656E742E676574456C656D656E7442794964282263616E76617322292C733D632E676574436F6E746578742822326422292C643D28646F63756D656E742E676574456C65';
wwv_flow_api.g_varchar2_table(11) := '6D656E74427949642822777776466C6F77466F726D22292C66756E6374696F6E2865297B636F6E736F6C652E6572726F722822766964656F2063617074757265206572726F723A20222C652E636F6465297D293B6E6176696761746F722E6D6564696144';
wwv_flow_api.g_varchar2_table(12) := '65766963657326266E6176696761746F722E6D65646961446576696365732E676574557365724D656469613F6E6176696761746F722E6D65646961446576696365732E676574557365724D65646961287B766964656F3A21307D292E7468656E28286675';
wwv_flow_api.g_varchar2_table(13) := '6E6374696F6E2865297B6F3D652C722E7372634F626A6563743D652C722E706C617928297D29293A6E6176696761746F722E676574557365724D656469613F6E6176696761746F722E676574557365724D65646961287B766964656F3A21307D2C286675';
wwv_flow_api.g_varchar2_table(14) := '6E6374696F6E2865297B6F3D652C722E7372633D652C722E706C617928297D292C64293A6E6176696761746F722E7765626B6974476574557365724D656469613F6E6176696761746F722E7765626B6974476574557365724D65646961287B766964656F';
wwv_flow_api.g_varchar2_table(15) := '3A21307D2C2866756E6374696F6E2865297B6F3D652C722E7372634F626A6563743D652C722E706C617928297D292C64293A6E6176696761746F722E6D6F7A476574557365724D6564696126266E6176696761746F722E6D6F7A476574557365724D6564';
wwv_flow_api.g_varchar2_table(16) := '6961287B766964656F3A21307D2C2866756E6374696F6E2865297B6F3D652C722E7372634F626A6563743D652C722E706C617928297D292C64292C242822627574746F6E23736176652D696D6167652D6361707475726522292E636C69636B2828617379';
wwv_flow_api.g_varchar2_table(17) := '6E632066756E6374696F6E28297B732E64726177496D61676528722C302C302C3634302C343830292C722E7374796C652E646973706C61793D226E6F6E65222C632E7374796C652E646973706C61793D22696E6C696E652D626C6F636B222C6F2E676574';
wwv_flow_api.g_varchar2_table(18) := '547261636B7328295B305D2E73746F7028293B76617220652C6E3D632E746F4461746155524C28293B653D617065782E7574696C2E73686F775370696E6E65722824282223222B6929292C6177616974205361766532436F6C6C656374696F6E28742C6E';
wwv_flow_api.g_varchar2_table(19) := '2C612C69292C652E72656D6F766528297D29297D29297D29297D0A2F2F2320736F757263654D617070696E6755524C3D43616D496E746567726174696F6E2E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(231063776168088208)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_file_name=>'CamIntegration.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B2243616D496E746567726174696F6E2E6A73225D2C226E616D6573223A5B22436C6F62746F4172726179222C22705F636C6F62222C22705F73697A65222C22705F6172726179222C226C6F6F';
wwv_flow_api.g_varchar2_table(2) := '70436F756E74222C224D617468222C22666C6F6F72222C226C656E677468222C2269222C2270757368222C22736C696365222C22436F6E76657274546F426173653634222C22705F64617461555249222C22737562737472222C22696E6465784F66222C';
wwv_flow_api.g_varchar2_table(3) := '225361766532436F6C6C656374696F6E222C2270416A617831222C22705F496D67222C22705F69746D222C22705F6974656D31222C226630314172726179222C2261706578222C22736572766572222C22706C7567696E222C22706167654974656D7322';
wwv_flow_api.g_varchar2_table(4) := '2C22663031222C226461746154797065222C2273756363657373222C227375626D6974222C2243616D496E746567726174696F6E222C22705F726567696F6E222C22705F616A6578222C22705F69746D4964222C22705F62746E5F6C61626C65222C2261';
wwv_flow_api.g_varchar2_table(5) := '7272222C2224222C226166666563746564456C656D656E7473222C2265616368222C226974656D222C226964222C2272656D6F7665222C226469765F72676E222C22617070656E64222C22766964656F53747265616D222C22766964656F222C22646F63';
wwv_flow_api.g_varchar2_table(6) := '756D656E74222C22676574456C656D656E7442794964222C2263616E766173222C22636F6E74657874222C22676574436F6E74657874222C226572724261636B222C226572726F72222C22636F6E736F6C65222C22636F6465222C226E6176696761746F';
wwv_flow_api.g_varchar2_table(7) := '72222C226D6564696144657669636573222C22676574557365724D65646961222C227468656E222C2273747265616D222C227372634F626A656374222C22706C6179222C22737263222C227765626B6974476574557365724D65646961222C226D6F7A47';
wwv_flow_api.g_varchar2_table(8) := '6574557365724D65646961222C22636C69636B222C226173796E63222C2264726177496D616765222C227374796C65222C22646973706C6179222C22676574547261636B73222C2273746F70222C226C5370696E6E657224222C2276496D67222C22746F';
wwv_flow_api.g_varchar2_table(9) := '4461746155524C222C227574696C222C2273686F775370696E6E6572225D2C226D617070696E6773223A22414141412C53414153412C59414159432C45414151432C45414151432C4741436E43432C55414159432C4B41414B432C4D41414D4C2C454141';
wwv_flow_api.g_varchar2_table(10) := '4F4D2C4F4141534C2C474141552C4541436E432C4941414B2C494141494D2C454141492C45414147412C454141494A2C55414157492C49414376424C2C454141514D2C4B41414B522C4541414F532C4D41414D522C454141534D2C454141474E2C474141';
wwv_flow_api.g_varchar2_table(11) := '554D2C454141492C4B414535442C4F41414F4C2C45414774422C53414153512C674241416742432C474145562C4F414461412C45414155432C4F41414F442C45414155452C514141512C4B41414F2C47414972452C53414153432C674241416942432C45';
wwv_flow_api.g_varchar2_table(12) := '414151432C4541414F432C4541414D432C4741456A432C49414349432C454141572C47414366412C4541415570422C59414647572C6742414167424D2C474145432C4941414F472C4741437243432C4B41414B432C4F41414F432C4F41414F502C454141';
wwv_flow_api.g_varchar2_table(13) := '512C4341437243512C554141574E2C4541434F4F2C4941414B4C2C474143562C434141534D2C534141552C4F414564432C514141532C53414153542C47414356472C4B41414B4F2C59414D6C432C53414153432C6541416742432C45414153432C454141';
wwv_flow_api.g_varchar2_table(14) := '4F432C45414151432C47414370432C4D41414D432C4541414D2C43414143432C454141454C2C454141534D2C6D4241457842442C45414145452C4B41414B482C4741414B2C5341415331422C4541414738422C47414368422C494141496E422C45414155';
wwv_flow_api.g_varchar2_table(15) := '6D422C4541414B2C47414147432C4741476A424A2C454141452C75424141754235422C4F4141532C4541492F4234422C454141452C7542414175424B2C5341476A434C2C474141452C5741454D2C494141494D2C454141554E2C454141452C7952414179';
wwv_flow_api.g_varchar2_table(16) := '52462C454141592C6F4241437254452C454141452C4941414D68422C4741415375422C4F41414F442C47414778422C49414349452C45414441432C45414151432C53414153432C654141652C5341456843432C45414153462C53414153432C654141652C';
wwv_flow_api.g_varchar2_table(17) := '5541436A43452C45414155442C4541414F452C574141572C4D4130423542432C4741784269424C2C53414153432C654141652C654177422F422C534141534B2C47414366432C51414151442C4D41414D2C774241417942412C4541414D452C5141476A44';
wwv_flow_api.g_varchar2_table(18) := '432C55414155432C6341416742442C55414155432C61414161432C6141433743462C55414155432C61414161432C614141612C43414335425A2C4F41414F2C4941435A612C4D41414B2C53414153432C47414354662C45414163652C45414364642C4541';
wwv_flow_api.g_varchar2_table(19) := '414D652C55414159442C4541436C42642C4541414D67422C554145584E2C55414155452C61414362462C55414155452C614141612C434143665A2C4F41414F2C4941435A2C53414153632C4741434A662C45414163652C45414364642C4541414D69422C';
wwv_flow_api.g_varchar2_table(20) := '4941414D482C4541435A642C4541414D67422C53414358562C47414341492C55414155512C6D42414362522C55414155512C6D4241416D422C43414372426C422C4F41414F2C4941435A2C53414153632C4741434A662C45414163652C45414364642C45';
wwv_flow_api.g_varchar2_table(21) := '41414D652C55414159442C4541436C42642C4541414D67422C53414358562C47414341492C55414155532C6942414362542C55414155532C6742414167422C4341436C426E422C4F41414F2C4941435A2C53414153632C4741434A662C45414163652C45';
wwv_flow_api.g_varchar2_table(22) := '414364642C4541414D652C55414159442C4541436C42642C4541414D67422C53414358562C47414B58662C454141452C36424141364236422C4F41414F432C6942414539426A422C454141516B422C5541415574422C4541414F2C454141472C45414147';
wwv_flow_api.g_varchar2_table(23) := '2C4941414B2C4B41437043412C4541414D75422C4D41414D432C514141552C4F4143744272422C4541414F6F422C4D41414D432C514141552C65414376427A422C4541415930422C594141592C47414147432C4F41436E442C49414346432C4541444D43';
wwv_flow_api.g_varchar2_table(24) := '2C4541414D7A422C4541414F30422C5941457642462C454141596C442C4B41414B71442C4B41414B432C5941416178432C454141472C4941414D68422C55414368434A2C67424141674267422C4541415179432C4541414B78432C45414151622C474143';
wwv_flow_api.g_varchar2_table(25) := '6E446F442C454141552F42222C2266696C65223A2243616D496E746567726174696F6E2E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(231064137759088211)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_file_name=>'CamIntegration.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20436C6F62746F417272617928705F636C6F622C20705F73697A652C20705F6172726179297B0D0A09206C6F6F70436F756E74203D204D6174682E666C6F6F7228705F636C6F622E6C656E677468202F20705F73697A6529202B2031';
wwv_flow_api.g_varchar2_table(2) := '3B0D0A20202020202020202020202020202020666F7220287661722069203D20303B2069203C206C6F6F70436F756E743B20692B2B29207B0D0A202020202020202020202020202020202020202020202020705F61727261792E7075736828705F636C6F';
wwv_flow_api.g_varchar2_table(3) := '622E736C69636528705F73697A65202A20692C20705F73697A65202A202869202B20312929293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020202020202072657475726E20705F61727261793B0D0A7D0D0A0D0A2066';
wwv_flow_api.g_varchar2_table(4) := '756E6374696F6E20436F6E76657274546F42617365363428705F6461746155524929207B0D0A2020202020202020202020202020202076617220626173653634203D20705F646174615552492E73756273747228705F646174615552492E696E6465784F';
wwv_flow_api.g_varchar2_table(5) := '6628272C2729202B2031293B0D0A2020202020202020202020202020202072657475726E206261736536343B0D0A20202020202020207D0D0A0D0A202066756E6374696F6E205361766532436F6C6C656374696F6E202870416A6178312C20705F496D67';
wwv_flow_api.g_varchar2_table(6) := '2C20705F69746D2C705F6974656D3129207B0D0A0920202020202020200D0A2020202020202020202020202020202076617220626173653634203D20436F6E76657274546F42617365363428705F496D67293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(7) := '20766172206630314172726179203D205B5D3B0D0A202020202020202020202020202020206630314172726179203D436C6F62746F4172726179286261736536342C2033303030302C206630314172726179293B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(8) := '2020617065782E7365727665722E706C7567696E2870416A6178312C207B0D0A090909090920706167654974656D733A20705F69746D2C09090909092020200D0A2020202020202020202020202020202020202020202020206630313A20663031417272';
wwv_flow_api.g_varchar2_table(9) := '61790D0A202020202020202020202020202020207D2C207B202020202020202064617461547970653A202768746D6C27202020202020202020202020202009090909092C0D0A2020202020202020202020202020202020202020202020202F2F20535543';
wwv_flow_api.g_varchar2_table(10) := '4553532066756E6374696F6E0D0A202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E28705F69746D29207B0D0A20202020202020202020202020202020202020202020202020202020202020206170';
wwv_flow_api.g_varchar2_table(11) := '65782E7375626D697428293B202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200D0A2020202020202020202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(12) := '0D0A0D0A202020202020202020202020202020207D293B0D0A20202020202020207D0D0A0D0A20202066756E6374696F6E2043616D496E746567726174696F6E2028705F726567696F6E2C705F616A65782C705F69746D49642C705F62746E5F6C61626C';
wwv_flow_api.g_varchar2_table(13) := '6529207B0D0A20202020202020202020202020202020636F6E737420617272203D205B2428705F726567696F6E2E6166666563746564456C656D656E7473295D3B0D0A202020202020202020202020202020200D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '20242E65616368286172722C2066756E6374696F6E28692C206974656D29207B0D0A20202020202020202020202020202020202020202020202076617220705F6974656D31203D206974656D5B305D2E69643B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '20202020202020200D0A2020202020202020202020202020202020202020202020200D0A20202020202020202020202020202020202020202020202069662028202428272E696D6167652D636170747572652D6865616427292E6C656E677468203E2030';
wwv_flow_api.g_varchar2_table(16) := '2029207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F546F20444F200D0A20202020202020202020202020202020202020202020202020202020202020202F2F2043616D657261206E6565647320746F2073';
wwv_flow_api.g_varchar2_table(17) := '746F700D0A20202020202020202020202020202020202020202020202020202020202020200D0A20202020202020202020202020202020202020202020202020202020202020202428272E696D6167652D636170747572652D6865616427292E72656D6F';
wwv_flow_api.g_varchar2_table(18) := '766528293B0D0A2020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020656C73650D0A202020202020202020202020202020202020202020202020242866756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(19) := '207B09090D0A090909090909090D0A2020202020202020202020202020202020202020202020202020202020202020766172206469765F72676E203D202428273C646976207374796C653D22746578742D616C69676E3A63656E7465723B2220636C6173';
wwv_flow_api.g_varchar2_table(20) := '733D22696D6167652D636170747572652D68656164223E203C766964656F2069643D22766964656F222077696474683D2236343022206865696768743D2234383022206175746F706C61793E3C2F766964656F3E203C63616E7661732069643D2263616E';
wwv_flow_api.g_varchar2_table(21) := '766173222077696474683D2236343022206865696768743D2234383022207374796C653D22646973706C61793A6E6F6E653B223E3C2F63616E7661733E3C627574746F6E20747970653D22627574746F6E222069643D22736176652D696D6167652D6361';
wwv_flow_api.g_varchar2_table(22) := '70747572652220636C6173733D22742D427574746F6E20742D427574746F6E2D2D7072696D617279223E272B705F62746E5F6C61626C652B273C2F627574746F6E3E203C2F6469763E27293B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '202020202020202020202428222322202B20705F6974656D31292E617070656E64286469765F72676E293B0D0A0D0A20202020202020202020202020202020202020202020202020202020202020200D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '2020202020202020202020202076617220766964656F203D20646F63756D656E742E676574456C656D656E74427949642827766964656F27293B0D0A20202020202020202020202020202020202020202020202020202020202020207661722076696465';
wwv_flow_api.g_varchar2_table(25) := '6F53747265616D3B0D0A20202020202020202020202020202020202020202020202020202020202020207661722063616E766173203D20646F63756D656E742E676574456C656D656E7442794964282763616E76617327293B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '202020202020202020202020202020202020202020202076617220636F6E74657874203D2063616E7661732E676574436F6E746578742827326427293B0D0A20202020202020202020202020202020202020202020202020202020202020207661722073';
wwv_flow_api.g_varchar2_table(27) := '70696E6E65723B0D0A2020202020202020202020202020202020202020202020202020202020202020766172207370696E546172676574456C656D203D20646F63756D656E742E676574456C656D656E74427949642827777776466C6F77466F726D2729';
wwv_flow_api.g_varchar2_table(28) := '3B0D0A2020202020202020202020202020202020202020202020202020202020202020766172207370696E4F7074696F6E73203D207B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206C696E65';
wwv_flow_api.g_varchar2_table(29) := '733A2031332C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206C656E6774683A2032382C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(30) := '2077696474683A2031342C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207261646975733A2034322C0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(31) := '2020202020207363616C653A20312C0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F726E6572733A20312C0D0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '20202020202020202020636F6C6F723A202723303030272C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206F7061636974793A20302E32352C0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '20202020202020202020202020202020202020202020726F746174653A20302C0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020646972656374696F6E3A20312C0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '202020202020202020202020202020202020202020202020202020202073706565643A20312C0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020747261696C3A2036302C0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(35) := '20202020202020202020202020202020202020202020202020202020202020206670733A2032302C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207A496E6465783A203265392C0D0A20202020';
wwv_flow_api.g_varchar2_table(36) := '202020202020202020202020202020202020202020202020202020202020202020202020636C6173734E616D653A20277370696E6E6572272C0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(37) := '6F703A2027353025272C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206C6566743A2027353025272C0D0A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(38) := '202020202020736861646F773A2066616C73652C0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206877616363656C3A2066616C73652C0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(39) := '20202020202020202020202020202020202020706F736974696F6E3A20276162736F6C757465270D0A20202020202020202020202020202020202020202020202020202020202020207D3B0D0A0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '2020202020202020202020766172206572724261636B203D2066756E6374696F6E286572726F7229207B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F6E736F6C652E6572726F72282776';
wwv_flow_api.g_varchar2_table(41) := '6964656F2063617074757265206572726F723A20272C206572726F722E636F6465293B0D0A20202020202020202020202020202020202020202020202020202020202020207D3B0D0A0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '20202020202020696620286E6176696761746F722E6D6564696144657669636573202626206E6176696761746F722E6D65646961446576696365732E676574557365724D6564696129207B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '20202020202020202020202020202020206E6176696761746F722E6D65646961446576696365732E676574557365724D65646961287B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '20202020766964656F3A20747275650D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207D292E7468656E2866756E6374696F6E2873747265616D29207B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '202020202020202020202020202020202020202020202020202020202020202020766964656F53747265616D203D2073747265616D3B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '20202020766964656F2E7372634F626A656374203D2073747265616D3B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F2E706C617928293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(47) := '202020202020202020202020202020202020202020202020202020202020202020207D293B0D0A20202020202020202020202020202020202020202020202020202020202020207D20656C736520696620286E6176696761746F722E676574557365724D';
wwv_flow_api.g_varchar2_table(48) := '6564696129207B202F2F205374616E646172640D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206E6176696761746F722E676574557365724D65646961287B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(49) := '2020202020202020202020202020202020202020202020202020202020202020202020766964656F3A20747275650D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207D2C2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(50) := '73747265616D29207B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F53747265616D203D2073747265616D3B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '202020202020202020202020202020202020202020202020202020202020766964656F2E737263203D2073747265616D3B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202076';
wwv_flow_api.g_varchar2_table(52) := '6964656F2E706C617928293B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207D2C206572724261636B293B0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '7D20656C736520696620286E6176696761746F722E7765626B6974476574557365724D6564696129207B202F2F205765624B69742D70726566697865640D0A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '2020206E6176696761746F722E7765626B6974476574557365724D65646961287B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F3A20747275650D0A20202020';
wwv_flow_api.g_varchar2_table(55) := '2020202020202020202020202020202020202020202020202020202020202020202020207D2C2066756E6374696F6E2873747265616D29207B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(56) := '20202020202020766964656F53747265616D203D2073747265616D3B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F2E7372634F626A656374203D2073747265';
wwv_flow_api.g_varchar2_table(57) := '616D3B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F2E706C617928293B0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(58) := '20202020202020207D2C206572724261636B293B0D0A20202020202020202020202020202020202020202020202020202020202020207D20656C736520696620286E6176696761746F722E6D6F7A476574557365724D6564696129207B202F2F204D6F7A';
wwv_flow_api.g_varchar2_table(59) := '696C6C612D70726566697865640D0A202020202020202020202020202020202020202020202020202020202020202020202020202020206E6176696761746F722E6D6F7A476574557365724D65646961287B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '2020202020202020202020202020202020202020202020202020202020202020766964656F3A20747275650D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207D2C2066756E6374696F6E28737472';
wwv_flow_api.g_varchar2_table(61) := '65616D29207B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F53747265616D203D2073747265616D3B0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '202020202020202020202020202020202020202020202020202020766964656F2E7372634F626A656374203D2073747265616D3B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '2020766964656F2E706C617928293B0D0A202020202020202020202020202020202020202020202020202020202020202020202020202020207D2C206572724261636B293B0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '2020207D0D0A0D0A20202020202020202020202020202020202020202020202020202020202020202F2F0D0A20202020202020202020202020202020202020202020202020202020202020202F2F207361766520696D616765200D0A2020202020202020';
wwv_flow_api.g_varchar2_table(65) := '202020202020202020202020202020202020202020202020242827627574746F6E23736176652D696D6167652D6361707475726527292E636C69636B28206173796E632066756E6374696F6E2829207B0D0A0909090909090909090D0A20202020202020';
wwv_flow_api.g_varchar2_table(66) := '202020202020202020202020202020202020202020202020202020202020202020636F6E746578742E64726177496D61676528766964656F2C20302C20302C203634302C20343830293B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(67) := '20202020202020202020202020202020766964656F2E7374796C652E646973706C6179203D20276E6F6E65273B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202063616E7661732E7374796C652E';
wwv_flow_api.g_varchar2_table(68) := '646973706C6179203D2027696E6C696E652D626C6F636B273B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020766964656F53747265616D2E676574547261636B7328295B305D2E73746F702829';
wwv_flow_api.g_varchar2_table(69) := '3B0D0A090909090920202020202020202020207661722076496D67203D63616E7661732E746F4461746155524C28293B0D0A09090909090909202020766172206C5370696E6E6572243B0D0A090909090909092020206C5370696E6E657224203D206170';
wwv_flow_api.g_varchar2_table(70) := '65782E7574696C2E73686F775370696E6E65722820242820272327202B20705F6974656D31202920293B0D0A090909090920202020202020202020206177616974205361766532436F6C6C656374696F6E28705F616A65782C2076496D672C705F69746D';
wwv_flow_api.g_varchar2_table(71) := '49642C705F6974656D31293B0D0A09090909090909096C5370696E6E6572242E72656D6F766528293B0D0A20202020202020202020202020202020202020202020202020202020202020207D293B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(72) := '202020207D293B0D0A0D0A202020202020202020202020202020207D293B0D0A20202020202020207D0D0A0D0A0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13675276747851063124)
,p_plugin_id=>wwv_flow_api.id(13672039227262334819)
,p_file_name=>'CamIntegration.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done