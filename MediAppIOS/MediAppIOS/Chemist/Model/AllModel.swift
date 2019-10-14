//
//  InsertQueryModel.swift
//  MediAppIOS
//
//  Created by abhishek on 28/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation
struct MyData : Codable {
    var status,error : String?
    var stk_book : stk_book
    var offer_book : offer_book
    var scheme_images : scheme_images
    var cart : Cart?
    struct stk_book : Codable {
        var table_name,h_id,v_insert: String?
//
//        enum CodingKeys : String, CodingKey {
//            case v_insert = "v_insert"
//        }
    }

}
struct Cart : Codable {
    var table_name,v_insert : String?
}
struct offer_book : Codable {
    var table_name,offer_string : String?
}

struct scheme_images : Codable {
    var table_name,STATUS,str_images_url : String?
}


struct  avilableStockistModel : Codable {
    
    var status : String?
    var error : String?
    var stockist : [Stockist]?
   // var offer : [StockistOffer]
    
    enum CodingKeys : String , CodingKey {
        case status
        case error
        case stockist = "searchstkbyproduct"
//  case offer = "offerSearchStokiest"
    }
    
}
struct Stockist : Codable {
    var EMPLOYEE_ID : String
    var FST_NAME : String
    var CON_STATUS : String
    var PROD_AVA_COUNT : String
    var GROUP_ROW_ID : String
    var ORG_ID : String
    var stockistlist : [StockistList]?
}

struct  StockistList : Codable {
    var ORG_ID : String
    var FST_NAME : String
    var EMPLOYEE_ID : String
    var ORG_NAME : String
    var CITY : String
    var MANUFACTR_ID : String
    var CON_STATUS : String
    var STATUS : String
    var ID : String
    var SKU_ID : String
    var ROW_ID : String
    var PROD_NAME : String
    var UNITS_AVAILABLE : String
    var ORD_PROD_COUNT : String
    var MRP : String
    var SUM_MRP : String
    var PROD_AVA_COUNT : String
    var QUANTITY : String
    var MSP_PER : String
    var MANUFCTR_ID : String
    var COMPANY_NAME : String
    var GROUP_ROW_ID : String
//    var IMEI : String
    var FLAG : String
    var CATEGORY : String
//    var ZIP_ID : String
    var TAX_ID : String
    var TAX_NAME : String
    var TAX_VALUE : String
    var SCHEME_QUANTITY : String
    var SCHEME_VALUE : String
    var SCHEME_ID : String
    var REEDEM_FLAG,PROD_BUSINESS_TYPE,REDEEM_VALUE,PRODUCT_STATUS,PRODUCT_QUANTITY : String
}
struct  StockistOffer : Codable {
    var table_name : String
  //  var offer_string : String
}

struct setOrderModel : Codable {
    var status : String
    var error : String
    var MESSAGE : String
    
}

struct connection_model : Codable {
    var status : String?
    var error : String?
    var chemistinfo : [ChemInfo]?
}
struct ChemInfo : Codable {
    var STATUS : String
    var EMPLOYEE_ID : String
    var ORG_ID : String
//    var IMEI : String
    var FST_NAME : String
    var NAME : String
    var MOBILE : String
//    var MOBILE_ALT : String
    var EMAIL : String
//    var CITY : String
//    var STATE : String
    var ADDRESS : String
//    var H_ID : String
//    var SESSION_H_ID : String
//    var CON_STATUS : String
//    var ID : String
}


struct WalletModel : Codable {
    var status, error, CF_CREDITED_POINTS, CF_REDEEMED_POINTS : String?
    var CF_DEFERRED_POINTS, CF_EXCHANGE_POINTS: String?
    var redeem_list : [RedeemList]
    var redeem_offer : [RedeemOffer]
    var redeem_option: [RedeemOption]
    var WALLET_IMGES: [WalletImge]
    var selected_option : String?
    var redeem_type_master : [Redeem_Type_Master]
}
struct  Redeem_Type_Master : Codable {
    var TABLE_NAME,GRTM_ID,REEDEM_TYPE,HOW_IT_WORK,GENERAL_TERMS_AND_CONDITION,SCHEME_TERMS_AND_CONDITION : String?
}
struct RedeemOption : Codable {
    var TABLE_NAME,RDM_ID : String?
    var REDEEM_DATA : [RedeemData]
}

struct RedeemData : Codable {
    var REEDEMED_OPTION_MASTER_ID,OPTION_NAME : String?
}
struct RedeemList: Codable {
    var STATUS, PTS_ID, DATE: String?
    var POINT_STATUS,REEDEM_HISTORY_ID: String?
}

struct RedeemOffer: Codable {
    var TABLE_NAME, RDM_ID, POINTS, DESCRIPTION, START_DATE, END_DATE,PRODUCT_REEDEM_FLAG,REEDEM_VALUES: String?
}

struct WalletImge: Codable {
    var TABLE_NAME, GMRPP: String?
    var CREATED_BY: String?
    var CREATED_DATE, RDM_ID: String?
    var URL: String?
    var STATUS, SEQUENCE, POINTS, ALT_DESCRIPTION, GRTM_ID: String?
}


struct OfferSubmit : Codable {
    var status,error : String
}

struct voucherSubmit : Codable {
    var status,error,msg : String
}

struct StockistApprovedModel : Codable {
    var status , error : String
    var stockistApprovedOrders : [StockistApprovedOrders]
}

struct StockistApprovedOrders : Codable {
    var TABLE_NAME, ORDER_ID, ORDER_DATE, SALES_INVOICE_NO, ORG_ID, ADDRESS : String
    
}

struct StokistPendingModel : Codable {
    var status , error : String
    var stockistPendingOrdersFromChm : [StockistPendingOrder]
}

struct  StockistPendingOrder : Codable {
    var TABLE_NAME, ORDER_ID, S_ORG_ID, ORDER_DATE, ORG_ID, Mark_as_Delivered, SHOP_NAME, SESSION_H_ID : String
}

struct StockistDeclinedModel : Codable {
    var status , error : String
    var stockistDeclinedOrdersFromChm : [StockistDeclineOrder]
}
struct StockistDeclineOrder : Codable{
    var TABLE_NAME, ORDER_ID, SHOP_NAME, S_ORG_ID, ORDER_DATE, SALES_INVOICE_NO, ORG_ID, Mark_as_Delivered : String?
}

struct PostponeDetailModel : Codable {
    var status, error : String?
    var postpone_order_details : [StockistDeclineOrder]?
}

struct ApprovedDetailModel : Codable {
    var status, error : String?
    var org_approved_order_details : [ApprovedData]?
}

struct PendingDetailModel : Codable {
    var status, error : String?
    var pending_order_details : [ApprovedData]?
}

struct PostponeDetailData : Codable {
    var status,error : String?
    
}

struct DeclineDetailModel : Codable {
    var status, error : String?
    var declined_order_details : [ApprovedData]?
}


struct ApprovedData : Codable {
    var TABLE_NAME,ORG_ID,NAME,ORDER_ID,FST_NAME,SHOP_NAME,ORDL,SKU_ID,ORDER_QUANTITY,APPROVED_QUANTITY,POSTPONE_QUANTITY,UNIT_PRICE,PRICE,ADJUSTMENT,SUB_TOTAL,TOTAL_PRICE,PRODUCT_NAME,SALES_INVOICE_NO,DISCOUNT,SCHEME,SCHEME_ID,SCHEME_DESCRIPTION,OFFER_AMOUNT,LAST_MODIFIED,C_ORG_ID,GST_NUMBER,ADDRESS,FREE_SKU_QUANTITY,REDEEM_POINTS : String?
    
}

struct SalesPerson : Codable {
    var status,error : String?
    var Mr_List : [Mr_List]?
}
struct Mr_List : Codable {
    var  MEMPLOYEE_ID,EMPLOYEE_NAME,EMAIL : String?
}

struct DeleveredOrderData : Codable {
    var status,error : String
    var stockistDeliveredOrdersFromChm : [stockistDeliveredOrdersFromChm]?
}

struct  stockistDeliveredOrdersFromChm : Codable {
    var ORG_ID,EMPLOYEE_ID,DELIVERED_DATE,SHOP_NAME,STK_NAME,DELIVERY_PERSON_NAME,ORDER_ID,SALES_INVOICE_NO,SESSION_ID,ERROR,STATUS : String?
}

struct  org_delivered_order : Codable {
    var TABLE_NAME,ORDER_ID,S_ORG_ID,ORDER_DATE,DELIVERY_PERSON_ID,SALES_INVOICE_NO,Mark_as_Delivered,ORDER_STATUS : String?
}

struct DeliverdOrderDiscription : Codable {
    var stockistDeliveredOrderDetail : [stockistDeliveredOrderDetail]?
}

struct stockistDeliveredOrderDetail : Codable {
    var table_name,ORDER_ID,SALES_INVOICE_NO,GROSS_AMOUNT,DELIVERY_PERSON_ID,DELIVERY_PERSON_NAME,CHEM_ORG_ID,STK_ORG_ID,FST_NAME,SHOP_NAME,ORDER_DATE,OFFER_AMOUNT : String?
    var ord_disc : [Order_disciption]?
    enum CodingKeys : String, CodingKey {
        case ord_disc = "org_delivered_order"
    }
}

struct  Order_disciption : Codable {
    var GROSS_AMOUNT,SALES_INVOICE_NO,SKU_ID,ORDER_ID,ORDER_QUANTITY,DISCOUNT_AMOUNT,APPROVED_QUANTITY,PRODUCT_NAME,PRICE,ORDER_DATE,ITEM_PRICE : String?
}


struct Editing : Codable {
    var status,field_name,field_value : String?
}

struct OTPData : Codable {
    var status,message : String?
}


//schemImageModel
struct SchemImageModel : Codable {
    
    var schemUrl,schemProductId,big_url,schem_flag : String?
    
}

struct UpdateInfoModel : Codable {
    var db_version,app_version,updated : String?
}

