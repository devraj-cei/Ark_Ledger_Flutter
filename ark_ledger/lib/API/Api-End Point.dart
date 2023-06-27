class API_EndPoint{
  static const String BASE_URL = 'http://arkledger.techregnum.com/api/';

  static const String LOGIN = 'AppClientUsers/login';
  static const String GET_PROFILE = 'AppClientUsers/getProfile';
  static const String UPDATE_PROFILE = 'AppClientUsers/updateProfile';
  static const String UPLOAD_PROFILE_IMAGE = 'FileUpload/uploadAppClientUsersProfilePicImages';
  static const String CHANGE_PASSWORD = 'AppClientUsers/changePassword';
  static const String FORGET_PASSWORD = 'AppClientUsers/forgetPassword';
  static const String GENERATE_OTP = 'AppClientUsers/generateOTP';

  //Add Credit
  static const String GET_CLIENT_COMPANY_LIST = 'ClientCompanies/getClientCompaniesList';
  static const String GET_CLIENT_ITEM_LIST = 'ClientItems/getClientItemsList';
  static const String SAVE_CREDIT_LEDGER = 'CreditLedger/saveCreditLedger';

  //Ledger
  static const String GET_CREDIT_LEDGER_FOR_CLIENT = 'CreditLedger/getPendingLedgerForClient';
  static const String GET_CREDIT_LEDGER_FOR_CLIENT_COMPANIES = 'CreditLedger/getPendingLedgerForCompanies';
  static const String GET_CREDIT_LEDGER_DETAILS = 'CreditLedger/getCustomerCreditLedger';
  static const String CREATE_INVOICE = 'CreditLedger/createInvoiceForCreditLedger';

  //Invoice
  static const String GET_INVOICE_LIST = 'Invoices/getInvoicesList';
  static const String GET_INVOICE_DETAIL = 'Invoices/getInvoicesDetail';
  static const String SEND_PAYMENT_REMINDER = 'Invoices/sendPaymentReminder';
  static const String UPDATE_PAYMENT_STATUS = 'Invoices/updatePaymentStatus';

  //Offers
  static const String GET_OFFER_LIST = 'offers/getOffersList';
  static const String SAVE_OFFER_LIST = 'offers/saveOffers';
  static const String ENABLE_OFFER = 'offers/enableOffers';
  static const String DISABLE_OFFER = 'offers/disableOffers';
  static const String DELETE_OFFER = 'offers/deleteOffers';
  static const String UPLOAD_OFFER_IMAGE = 'FileUpload/uploadOfferImages';

  //Customers
  static const String GET_CUSTOMER_LIST = 'CustomerClientMapping/getCustomerClientMappingList';
  static const String ENABLE_CUSTOMER = 'CustomerClientMapping/enableCustomerClientMapping';
  static const String DISABLE_CUSTOMER = 'CustomerClientMapping/disableCustomerClientMapping';
    static const String GET_CUSTOMER_DETAILS = 'customers/getCustomersDetails';
  static const String UPDATE_CUSTOMER = 'CustomerClientMapping/editCustomerClientMapping';
  static const String ADD_CUSTOMER = 'CustomerClientMapping/saveCustomerClientMapping';

  //Product Category
  static const String GET_PRODUCT_CATEGORY_LIST = 'ProductCategories/getProductCategoriesList';
  static const String GET_SUB_PRODUCT_CATEGORY_LIST = 'ProductSubcategories/getProductSubCategoriesList';

  //HSN Code
  static const String GET_HSN_CODE = 'appClientHsnSacCode/getAppClienthsnsacList';

  //Products
  static const String GET_PRODUCT_LIST = 'ClientItems/getClientItemsList';
  static const String SAVE_PRODUCT = 'ClientItems/saveClientItems';
  static const String ENABLE_PRODUCT = 'ClientItems/enableClientItems';
  static const String DISABLE_PRODUCT = 'ClientItems/disableClientItems';
  static const String UPLOAD_PRODUCT_IMAGE = 'FileUpload/uploadProductImages';
  static const String DELETE_PRODUCT = 'ClientItems/deleteClientItems';

  //Countr,State,City
  static const String GET_COUNTRY_LIST = "Country/getCountryList";
  static const String GET_STATE_LIST = "State/getStateList";
    static const String GET_CITY_LIST = "City/getCityList";
}