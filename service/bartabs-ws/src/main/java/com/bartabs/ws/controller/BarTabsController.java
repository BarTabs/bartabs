package com.bartabs.ws.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bartabs.ws.model.Shop;

@Controller
public class BarTabsController {

	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public @ResponseBody Shop getShopInJSON(@RequestParam("name") String name) {

		Shop shop = new Shop();
		shop.setName(name);
		shop.setStaffName("staff");

		Shop shop2 = new Shop();
		shop2.setName("John");
		shop2.setStaffName("Goldberg");

		shop.setShop(shop2);

		return shop;

	}

}