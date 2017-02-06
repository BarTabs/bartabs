package com.bartabs.ws.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bartabs.ws.dao.TestDao;
import com.bartabs.ws.model.Shop;

@Controller
public class BarTabsController {
	@Autowired
	TestDao dao;

	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public @ResponseBody Shop getShopInJSON(@RequestParam("name") String name) {
		return dao.getData();
	}

}