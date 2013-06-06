package com.yang.oa.hr.resources;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yang.oa.commons.OaUtil;
import com.yang.oa.hr.entity.Role;
import com.yang.oa.hr.service.PowerInfoService;

@Controller
@RequestMapping(value="/roles")
public class RoleRes {
	@Autowired
	private PowerInfoService powerService;
	@RequestMapping(value="/page",method=RequestMethod.GET)
	public String  getRolePage(){
		return "/powerInfo/role";
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public @ResponseBody List<Role>  getRoles(){
		return powerService.getRoles();
	}
	@RequestMapping(value="/role/{id}",method=RequestMethod.GET)
	public @ResponseBody Role getRoleById(@PathVariable("id") String id){	
		return  powerService.getRoleById(id);
	}
	@RequestMapping(value="/role/insert",method=RequestMethod.POST)
	public @ResponseBody Role inserRole(@RequestBody Role role){
		role.setUuid(OaUtil.getUUID());
		powerService.insertRole(role);
		return  role;
	}
	
	@RequestMapping(value="/role/update",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> updateRole(@RequestBody Role role){
		powerService.updateRole(role);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("data", role);
		map.put("message", "修改成功");
		return  map;
	}
	
	@RequestMapping(value="/role/delete",method=RequestMethod.POST)
	public @ResponseBody Map<String,String> deleteRole(@RequestBody List<Role> roles){
		powerService.deleteRoleBatch(roles);
		Map<String,String> map=new HashMap<String,String>();
		map.put("message", "删除成功");
		return map;
	}
}
