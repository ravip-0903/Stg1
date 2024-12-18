<?php
/***************************************************************************
*                                                                          *
*   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
*                                                                          *
* This  is  commercial  software,  only  users  who have purchased a valid *
* license  and  accept  to the terms of the  License Agreement can install *
* and use this program.                                                    *
*                                                                          *
****************************************************************************
* PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
* "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
****************************************************************************/


//
// $Id: func.php 12865 2011-07-05 06:57:22Z 2tl $
//

if ( !defined('AREA') ) { die('Access denied'); }


function fn_bestsellerproduct_get_products($params)
{
	if (!empty($params['cid'])) {
		$cids = is_array($params['cid']) ? $params['cid'] : array($params['cid']);
		if (!empty($params['subcats']) && $params['subcats'] == 'Y') {
			$_ids = db_get_fields("SELECT a.category_id FROM ?:categories as a LEFT JOIN ?:categories as b ON b.category_id IN (?n) WHERE a.id_path LIKE CONCAT(b.id_path, '/%')", $cids);
			$cids = fn_array_merge($cids, $_ids, false);
		}
		//$min_deal_percentage = db_get_row("select min_deal_percent from cscart_categories where category_id =".$params['cid']);
		//$min_deal_percentage = $min_deal_percentage['min_deal_percent'];
	}
	//echo '<pre>';print_r($cids);
	$category_ids = implode(',',$cids);
	/*To fetch the products based on deals index*/
	$bspro_query = "SELECT cp.product_id, cp.list_price, cp.amount, cp.promotion_id, cp.special_offer_text, cp.special_offer, cp.price_see_inside, cp.special_offer_badge,cp.deal_inside_badge,cp.freebee_inside, cp.company_id, cp.timestamp, cp.deals_index, cpc.category_id, cpd.product, cpp.price,cps.amount,sum(cpoi.amount) as inv_amount, 
						  round(((cp.list_price-cpp.price)*100)/cp.list_price) as discount 
						  FROM cscart_products cp
						  LEFT JOIN cscart_product_descriptions cpd on (cp.product_id=cpd.product_id) 
						  LEFT JOIN cscart_product_prices cpp on (cp.product_id=cpp.product_id) 
						  LEFT JOIN cscart_products_categories cpc on (cp.product_id=cpc.product_id)
						  LEFT JOIN cscart_categories cc on (cc.category_id=cpc.category_id) and cc.status IN ('A', 'H') 
						  LEFT JOIN cscart_companies ccompanies on (cp.company_id=ccompanies.company_id)
						  INNER JOIN cscart_product_sales cps on cp.product_id=cps.product_id and cpc.category_id=cps.category_id
						  LEFT JOIN cscart_product_options_inventory cpoi on cpoi.product_id=cp.product_id
						  WHERE cp.status = 'A' and cp.amount > 0 and ccompanies.status = 'A'
						  and cpc.category_id in ($category_ids)
						  and round(((cp.list_price-cpp.price)*100)/cp.list_price)>cc.min_deal_percent
						  and cps.amount>0
						  group by cp.product_id having sum(cpoi.amount)>0 or sum(cpoi.amount) is null ORDER BY cps.amount desc,cpp.price desc limit 0,".$params['limit'];
					
	$products = db_get_array($bspro_query);
	
	/*To fetch the products based on discount*/
	
	/*foreach($products_deals_index as $product)
	{
		$products_ids[]=$product['product_id'];
	}
	
	$productid=implode(',',$products_ids);
	
	$hotdeals_query = "SELECT distinct(cp.product_id), cp.list_price, cp.amount, cp.company_id, cp.timestamp, cp.deals_index, cpc.category_id, cpd.product, cpp.price, 
						  round(((cp.list_price-cpp.price)*100)/cp.list_price) as discount 
						  FROM cscart_products cp
						  LEFT JOIN cscart_product_descriptions cpd on (cp.product_id=cpd.product_id) 
						  LEFT JOIN cscart_product_prices cpp on (cp.product_id=cpp.product_id) 
						  LEFT JOIN cscart_products_categories cpc on (cp.product_id=cpc.product_id)
						  LEFT JOIN cscart_categories cc on (cc.category_id=cpc.category_id)
						  LEFT JOIN cscart_companies ccompanies on (cp.company_id=ccompanies.company_id)
						  WHERE cp.status = 'A' and cp.amount > 0 and ccompanies.status = 'A'
						  and cpc.category_id in ($category_ids) and cp.product_id not in ($productid)
						  and round(((cp.list_price-cpp.price)*100)/cp.list_price)>cc.min_deal_percent
						  ORDER BY rand() limit ".($params['limit']/2).",".$params['limit']/2;
	$products_discount = db_get_array($hotdeals_query);
	
	$products = array_merge($products_deals_index,$products_discount);*/
	return $products;
}

?>