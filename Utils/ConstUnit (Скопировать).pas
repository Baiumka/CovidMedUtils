unit ConstUnit;

interface

type
   TLangArray = array[1..3] of string[10];
const
// ���������� ��������
   AppTitle            = 'AppTitle';
   AppVersion          = ' v 1.001';
   AppSecretWord       = 'AppSecretWord';
   ConLogin            = 'ConLogin';
   ConPass             = 'ConPass';


   Str_Separator       = '~';
   ENDL                = #13#10;

   PopupMenuOwnerDraw  = -1;
// ��������� ������� API_STATE
   esFixed             = Byte(0);
   esInsert            = Byte(1);
   esModify            = Byte(2);
   esDelete            = Byte(3);
// ���������������� ����� ���������
   clError             = Integer($0000FF);
   clInfo              = Integer($FF0000);
   clWarning           = Integer($008000);
   clDebug             = Integer($800080);
// ���������������� ����� �������������
   clRealActive    = Integer($000000);   //clBlack
   clRealInactive  = Integer($FF000013); //clInactiveCaptionText
   clLogicActive   = Integer($0000FF);   //clRed
   clLogicInactive = Integer($000080);   //RGB(128,0,0)
// ������������� �����
   clSnow          = Integer($FAFAFF); //RGB(255,250,250)

// ��������� ��������� � ����������� TAction
{   A  E   V   R    (1000)
    1 0/1 0/1 0/1
    Hidden = not Visble and not Enabled
    Dedault Enabled  = 0
            Visible  = 0
            ReadOnly = 1
            Hidden   = 1
}
  API_ACTION_HIDDEN    = Byte($08);
  API_ACTION_READONLY  = Byte($09);
  API_ACTION_VISIBLE   = Byte($0A);
  API_ACTION_ENABLED   = Byte($0C);
  API_ACTION_ALL       = Byte($0F);

//����������� DataSet-�� ��� TForm � TDataModule
  API_DATASETS_DISABLE = Byte(1);
  API_DATASET_DISABLE  = API_DATASETS_DISABLE;
//
  KS_NONE      = Byte(0);
  KS_ENABLE    = Byte(1);
  KS_VISIBLE   = Byte(2);
  KS_READONLY  = Byte(4);
  KS_ALL       = Byte(7);
// �������� ����� � ����������
  API_ACTIVE           = 'active';
  API_ACT_N            = 'act_n';
  API_ACT_DT           = 'act_dt';
  API_ADDS             = 'adds';
  API_ADDS_A           = 'adds_a';
  API_ADDS_R           = 'adds_r';
  API_ADDS_U           = 'adds_u';
  API_ALIAS            = 'alias';
  API_ALL              = 'all';
  API_APP              = 'app';
  API_AUTO             = 'auto';
  API_BASE             = 'base';
  API_BUH              = 'buh';
  API_CALC             = 'calc';
  API_CANCELED         = 'canceled';
  API_CAPTION          = 'caption';
  API_CLASS_ID         = 'class_id';
  API_CLASS_NAME       = 'class_name';
  API_CODE             = 'code';
  API_CODES            = 'codes';
  API_COL              = 'col';
  API_DATA             = 'data';
  API_DAYS             = 'days';
  API_DEF_VALUE        = 'def_value';
  API_DELTA            = 'delta';
  API_DEPARTMENT_ID    = 'department_id';
  API_DEPARTMENT_NAME  = 'department_name';
  API_DEPT_ID          = 'dept_id';
  API_DEPT_NAME        = 'dept_name';
  API_DE2_ID           = 'de2_id';
  API_DE2_NAME         = 'de2_name';
  API_DF               = 'df';
  API_DISMISSED        = 'dismissed';
  API_DISPLAY_VALUE    = 'display_value';
  API_DS_PARAM         = 'ds_param';
  API_DT               = 'dt';
  API_DY               = 'dy';
  API_EH               = 'eh';
  API_ENABLE           = 'enable';
  API_ERROR            = 'error';
  API_EXT              = 'ext';
  API_EXTERNAL         = 'external';
  API_FIELDNAME        = 'fieldname';
  API_FILENAME         = 'filename';
  API_FIO              = 'fio';
  API_FIO_A            = 'fio_a';
  API_FIO_R            = 'fio_r';
  API_FIO_U            = 'fio_u';
  API_FMNAME           = 'fmname';
  API_FORMNAME         = 'formname';
  API_FULLNAME         = 'fullname';
  API_JOB              = 'job';
  API_JOB_A            = 'job_a';
  API_JOB_R            = 'job_r';
  API_JOB_U            = 'job_u';
  API_H                = 'h';
  API_H_ID             = 'h_id';
  API_HOURS            = 'hours';
  API_ID               = 'id';
  API_INFO             = 'info';
  API_INN              = 'inn';
  API_IS_NEW           = 'is_new';
  API_IS_PROG          = 'is_prog';
  API_IS_ROLE          = 'is_role';
  API_IS_ROOT          = 'is_root';
  API_IS_USED          = 'is_used';
  API_IS_WORK          = 'is_work';
  API_KEY              = 'key';
  API_KEYWORD          = 'keyword';
  API_KF               = 'kf';
  API_KNU              = 'knu';
  API_KODL             = 'kodl';
  API_KODORD           = 'kodord';
  API_KZT              = 'kzt';
  API_LEVEL            = 'level';
  API_LIST_ID          = 'list_id';
  API_LOCK             = 'lock';
  API_LOGIN            = 'login';
  API_LOGO             = 'logo';
  API_LNG              = 'lng';
  API_MAP              = 'map';
  API_MODE             = 'mode';
  API_NAME             = 'name';
  API_NAME_A           = 'name_a';
  API_NAME_R           = 'name_r';
  API_NAME_U           = 'name_u';
  API_NAMEGR           = 'namegr';
  API_NH               = 'nh';
  API_NK               = 'nk';
  API_NKNU             = 'nknu';
  API_NOT_USED         = 'not_used';
  API_NPR              = 'npr';
  API_NPROF            = 'nprof';
  API_NUMBER           = 'number';
  API_N_BOLN           = 'n_boln';
  API_OKPO             = 'okpo';
  API_OSN_KKOR         = 'osn_kkor';
  API_OTHER_DAYS       = 'other_days';
  API_OTHER_QTY        = 'other_qty';
  API_OWNER_NAME       = 'owner_name';
  API_PARENT           = 'parent';
  API_PASS             = 'pass';
  API_PAY_TYPE_ID      = 'pay_type_id';
  API_PAYER_ID         = 'payer_id';
  API_PAYOR_ID         = 'payor_id';
  API_PAYER_NAME       = 'payer_name';
  API_PAYER_TAX        = 'payer_tax';
  API_PAYOR_NAME       = 'payor_name';
  API_PD               = 'pd';
  API_PD_NAME          = 'pd_name';
  API_PER_CENT         = 'per_cent';
  API_PFZP             = 'pfzp';
  API_PGSUM            = 'pgsum';
  API_PHONE            = 'phone';
  API_POS              = 'pos';
  API_PR               = 'pr';
  API_PR_ZAK           = 'pr_zak';
  API_PRED_DOG         = 'pred_dog';
  API_PRIZ             = 'priz';
  API_PROF             = 'prof';
  API_PROF_NAME        = 'prof_name';
  API_PT5              = 'pt5';
  API_PVSUM            = 'pvsum';
  API_QTY              = 'qty';
  API_QTY7             = 'qty7';
  API_QTY_AVG          = 'qty_avg';
  API_QTY_S            = 'qty_s';
  API_RATE             = 'rate';
  API_RD               = 'rd';
  API_READONLY         = 'readonly';
  API_REASON_ID        = 'reason_id';
  API_REPORT_DS_ID     = 'report_ds_id';
  API_REPORT_ID        = 'report_id';
  API_REPORT_PARAMS_ID = 'report_params_id';
  API_ROOT_ID          = 'root_id';
  API_SB               = 'sb';
  API_SECONDNAME       = 'secondname';
  API_SELLER_ID        = 'seller_id';
  API_SELLER_NAME      = 'seller_name';
  API_SELLER_TAX       = 'seller_tax';
  API_SERVICE_ID       = 'service_id';
  API_SERVICE_NAME     = 'service_name';
  API_SHIP_ID          = 'ship_id';
  API_SHIPPER_ID       = 'shipper_id';
  API_SHIPPER_NAME     = 'shipper_name';
  API_SKNU             = 'sknu';
  API_SOURCE           = 'source';
  API_SNAME            = 'sname';
  API_SQL_SELECT       = 'sql_select';
  API_SQ_NAME          = 'sq_name';
  API_SS               = 'ss';
  API_SSO              = 'sso';
  API_SBO              = 'sbo';
  API_SSP              = 'ssp';
  API_SBP              = 'sbp';
  API_SSD              = 'ssd';
  API_SBD              = 'sbd';
  API_STATE            = 'state';
  API_STRPOS           = 'strpos';
  API_SURNAME          = 'surname';
  API_SWIFT            = 'swift';
  API_TAX_ID           = 'tax_id';
  API_TAX_NUMBER       = 'tax_number';
  API_TEAM             = 'team';
  API_TERM_DOC         = 'term_doc';
  API_TERM_DT          = 'term_dt';
  API_TERM_ID          = 'term_id';
  API_TERM_INFO        = 'term_info';
  API_TERM_TYPE        = 'term_type';
  API_TERM_DOP_S       = 'term_dop_s';
  API_TRNSP_ID         = 'trnsp_id';
  API_TN               = 'tn';
  API_TS               = 'ts';
  API_TS_MPL           = 'ts_mpl';
  API_TS_ZAG           = 'ts_zag';
  API_TYPE             = 'type';
  API_TYPE_ID          = 'type_id';
  API_UNDS             = 'unds';
  API_UNIT_ID          = 'unit_id';
  API_UNK              = 'unk';
  API_USE_LAST         = 'use_last';
  API_USER_FIO         = 'user_fio';
  API_USER_ID          = 'user_id';
  API_VALUE            = 'value';
  API_VAL_ID           = 'val_id';
  API_VAL_NAME         = 'val_name';
  API_VAL_DT           = 'val_dt';
  API_VB               = 'vb';
  API_VF1              = 'vf1';
  API_VF2              = 'vf2';
  API_VF3              = 'vf3';
  API_VF4              = 'vf4';
  API_VNDS             = 'vnds';
  API_VISIBLE          = 'visible';
  API_VSUM             = 'vsum';
  API_WH               = 'WH';
  API_WORK_DAYS        = 'work_days';
  API_WORK_QTY         = 'work_qty';
  API_X2               = 'x2';
  API_YEAR             = 'year';
  API_YEAR_B           = 'year_b';
  API_YEAR_E           = 'year_e';
  API_YEAR_LIST        = 'year_list';
// �������� ������� ��� �����
  API_CLASS_REPORT_PARAMS = 'REPORT_PARAMS_TYPE';
  API_CLASS_AVERAGE       = 'AVERAGE_TYPE';
  API_CLASS_LEAVE         = 'LEAVE_TYPE';
  API_CLASS_DAY_OFF       = 'DAY_OFF_TYPE';
// �������� ����� ���������� ������
  API_TYPE_INTEGER     = 1001;
  API_TYPE_DOUBLE      = 1002;
  API_TYPE_STRING      = 1003;
  API_TYPE_DATE        = 1004;
  API_TYPE_EMPLOYEE    = 1005;
  API_TYPE_DEPARTMENT  = 1006;

// �������� ���������
  MSG_CDS_EMPTY        = '����� ������ ����, ��������� ��������� ���������!';
  MSG_WRONG_INPUT_YEAR = '����������� ������ ���!';
  MSG_CHANGE_SAVED     = '��������� ������� ���������!';
  MSG_CDS_IS_ACTIVE    = '����� ������ ��������� ��������!';
  MSG_FUNC_NOT_DEFINE  = '������� "%s" �� ����������!';
  MSG_ITEM_CAN_NOT_DEL = '������� �� ����� ���� ������!'#13#10'�������� ����������� ��������!';
  MSG_ROW_CANNOT_DEL   = '������ �� ����� ���� �������!';
  MSG_SAVE_CHANGE      = '���������� ��������� ��������� ���������!';
  MSG_FILL_TN          = '�������� ������� � ����������!';
  MSG_NOT_FIND_TN      = '��������� �� ��� ������!';
  MSG_NOT_FIND_PD      = '������������� �� ���� ������!';
  MSG_NOT_FIND_PROF    = '��������� �� ���� �������!';
  MSG_NOT_ENTER_TN     = '��������� �� ��� ������!';
  MSG_NOT_ENTER_PD     = '������������� �� ���� �������!';
  MSG_FILL_DATE        = '��������� ����!';
  MSG_FILL_MODE        = '�������� �����!';
  MSG_FILL_EDIT        = '��������� ���� ������!';
  MSG_CALC_FINISHED    = '������ ��������';
  MSG_NOT_EDIT_LOCK    = '��������� ������� ������������ ������������� ���������!';
  MSG_SELECT_CANCEL    = '����� ������� ��� �������!';
  MSG_ERROR_DS_CREATE  = '������ ��� �������� ������ ������!';
  MSG_DS_NOT_FIND      = '�� ��� ������ ����� ������ %s(������ %s)!';
  MSG_DS_NOT_ACTIVE    = '����� ������ %s(������ %s) �� ������!';
  MSG_REQUIRED_FIELD   = '�� ��������� ������������ ���� %s';
  MSG_NO_DAY           = '� ������ ��� ������ ��� %d';
  MSG_FILL_REQUIRED    = '��������� ������������ ����!';
  MSG_BIG_TIME         = '����� �� ����� ���� ������ %f �����!';
  MSG_BAD_SQ           = '������ ��������� ���������� �������� ��� ������������������ "%s"';
  MSG_NO_SQ            = '������ �� ������� ������������������ ��� ������ ������ "%s"';
  MSG_NOT_FIND_NDSTYPE = '������ �� ������� �������������� �� ������ � ����� %d';

  MSG_API_ADD          = '����������';
  MSG_API_EDIT         = '�����������';
  MSG_API_DEL          = '��������';
  MSG_API_MOVE         = '�����������';

  MSG_API_DISMISSE     = '����������';

  MSG_API_NO_TN        = '<<���������>>';
  MSG_API_NO_PD        = '<<�������������>>';
  MSG_API_NO_JB        = '<<���������>>';
  MSG_API_AUTO_CREATE  = '���������������';
  MSG_API_GLOBAL       = '����� ������ ������';

  MSG_NOT_FOUND_REPORT = '�� ��� ������ ������ ������� %s!';
  MSG_NOT_LOAD_REPORTS = '�� ������� ��������� ������� �������!';
  MSG_NOT_EDIT_REPORT  = '������ ������ %s �� �������������!';
  MSG_NDS_IS_WRONG     = '������� ����� ��� �� ���� � ��������� ��������� 5 ���(������)!';
// ��������� ������������
  DLG_INDEX_YEAR_ADD   = '�������� ����� ���'+ENDL+'� ��������� �����?';
  DLG_INDEX_YEAR_DEL   = '������� ������ ���'+ENDL+'�� ���������� ������?';
  DLG_INDEX_MAKE_BASE  = '������� ���������� �����'+ENDL+'������� ��� ����������?';
  DLG_INDEX_FIRST_YEAR = '������� ����� ��� ����� ������.';
  DLG_SAVE_CHANGE      = '��������� ��������� ���������?';
  DLG_CANCEL_CHANGE    = '�������� ��������� ���������?';
  DLG_DELETE_ROW       = '������� ��������� ������ ������?';
  DLG_DELETE_HAND_ROWS = '������� ��������� ������� ������?';
  DLG_DEACTIVE_ROW     = '������� ���������� ��������� ������ ������?';
  DLG_LOGIN_FAULT      = '�������� � ��������!'+ENDL+'��� ��� ������ �����������!'+ENDL+'����������� �����?';
  DLG_DELETE_ITEM      = '������� ��������� �������?';
  DLG_MOVE_ITEM        = '����������� ��������� �������?';
  DLG_DISMISSE         = '������� ���������� ����������?';
  DLG_DISMISSE_DATE    = '������� ���� ����������?';
  DLG_DELETE_EMPLOYEE  = '������� ����������?';
  DLG_KEY_FIND         = '������� ������ ������?';
  DLG_TN_MUST_RECALC   = '����� ���������� ����������'+ENDL+
                         '����������� ���������� �� ��������'+ENDL+
                         '�� ������ ���������';
  DLG_MAY_EXIT         = '��������� ������ ����������?';
  DLG_NO_FILE          = '���� %s �� ������!';
  DLG_INPUT_PASS       = '������� ������!';
  DLG_NO_EDIT_ROLE     = '�������������� ������� ���������!'#13#10'������� � �������!';
  DLG_MAKE_REAL        = '������������� ��������������� ����?';
  DLG_INPUT_BILL_DATE  = '������� ����� ���� �����?';
  DLG_TAX_IS_AUTO_CREATE = '��������� ��������� ������� �� ������ ���������!';
  DLG_TAX_IS_NOT_EDIT  = '��������� ��������� �� �������������� (������� �� ������ ���������)!';

// ��������� ��� TLabel
  LBL_NO_PARENT        = '<<��� ��������!>>';
  LBL_NO_DATE          = '<<��� ����>>';
  LBL_NEW_ITEM         = '<<����� ������>>';
// ������� ��� ��������
  FLT_CDS_NOT_STATE    = '['+API_STATE+'] <> %d';
  FLT_CDS_IS_STATE     = '['+API_STATE+'] = %d';
// �����������
  RFR_ALL = 0;

  DEF_LNG = 2;

  LNG_SNAME = 0; 
  LNG_UA = 1;
  LNG_RU = 2;
  LNG_EN = 3;

  LNGs : TLangArray = ('����������', '�������', '����������');
//
  API_IN_REESTR  = 2;
  API_OUT_REESTR = 1;

  API_ADD_HAND    = 0;
  API_ADD_BALANCE = 1;
  API_ADD_BILL    = 2;
//
  MAP_NULL      = '#NULL#';
  MAP_TABLENAME = '#TABLENAME#';
  MAP_DATE      = '#DATE#';

  MAP_DATATYPE_INTEGER = '#I#';
  MAP_DATATYPE_STRING  = '#S#';
  MAP_DATATYPE_LOND    = '#L#';
  MAP_DATATYPE_DATE    = '#D#';
  MAP_DATATYPE_FLOAT   = '#F#';
  MAP_DATATYPE_TIME    = '#T#';
// ������ ������� � ��������
//resourcestring
  QR_EMPTY                     = 'SELECT 1';
  QR_EMPTY_MESSAGE             = 'select null::timestamp as time, null::varchar as message, null::integer as fontcolor, null::integer as type'+#13#10+
                                 'where 1=2';
  QR_DEF_LANG                  = 'select 2';
  FCN_GET_NEXT_VALUE  = 'select nextval(:sq_name)';
  FNC_USER_INFO       = 'select * from *******.p_get_user_info(:login, :pass)';
  FNC_GET_ACCESS      = 'select * from *******.p_get_real_access(:user_id)';
  FNC_INSERT_CONTROL  = 'select *******.p_insert_control(:user_id, :fmname, :formname, :name, :caption, :fullname)';
  FNC_USERS_LIST = 'select p.*' + #13#10 +
                   'from *******.p_get_user_list() p' + #13#10 +
                   'order by p.fio';
  FNC_REPORTS_LIST = 'select 0 id where :keyword = '''' and 1=2';
                     //'select p.* from ******.p_reports_list(:keyword) p';
  QR_REPORTS_MODIFY = 'update ******.reports r' + #13#10 +
                      'set data = :data' + #13#10 +
                      'where r.id = :id';
  {QR_REPORT_SETTINGS = 'select *' + #13#10 +
                       'from *.report_settings';}
  QR_REPORT_SETTINGS = 'select null::integer id, null::varchar key, null::varchar keyword' + #13#10 +
                       'where 1=2';

  QR_GET_CALCDATE = 'select current_date dt';
                    //'select dt' + #13#10 +
                    //'from ******.wconfig';


implementation

end.
