package com.yang.oa.hr.resources;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yang.oa.commons.ShiroDbRealm.ShiroUser;

@Controller
@RequestMapping(value="/login")
public class LoginController {
	@RequestMapping(method=RequestMethod.GET)
	public String login(){
		return "login";		
	}
	@RequestMapping(method = RequestMethod.POST)
	public String fail(@RequestParam(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM) String userName, Model model){
		model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM, userName);
		return "login";
		
	}
	
	@RequestMapping(value="/info",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Map<String,String> getLoginInfo(){
		Subject currentUser = SecurityUtils.getSubject();
		ShiroUser user=(ShiroUser) currentUser.getPrincipal();
		Map<String,String> map=new HashMap<String,String>();
		map.put("loginName", user.getName());
		return map;
		
	}
	@RequestMapping(value="/logout",method = RequestMethod.GET)
	public String logout(){
		Subject currentUser = SecurityUtils.getSubject();
		currentUser.logout();
	
		return "redirect:/login";
		
	}
	@RequestMapping(value="/unauthorized",method = RequestMethod.GET)
	public String unauthorzed(){
		return "unauthorized";
	}
}
