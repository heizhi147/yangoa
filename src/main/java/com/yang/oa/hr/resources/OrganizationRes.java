package com.yang.oa.hr.resources;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSON;
import com.yang.oa.commons.OaUtil;
import com.yang.oa.commons.TreeModel;
import com.yang.oa.commons.ZtreeModel;
import com.yang.oa.commons.exception.JlException;
import com.yang.oa.hr.entity.Organization;
import com.yang.oa.hr.service.CompyInfoService;

@Controller
@RequestMapping(value="/orgs")
public class OrganizationRes {
	  final  Logger logger  =  LoggerFactory.getLogger(OrganizationRes. class );
	@Autowired
	private CompyInfoService compyInfoService;

	@RequestMapping(method=RequestMethod.GET)
	public String ogrPage(){
		return "/baseCompyInfo/org";
	}
	@RequestMapping(value="/test", method=RequestMethod.GET)
	public String test(){
		return "/baseCompyInfo/test";
	}
	@RequestMapping(value="/orgList",method=RequestMethod.GET)
	public String orgList(){
		return "/baseCompyInfo/orgListView";
	}
	
	@RequestMapping(value="/rootOrg",method=RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public 	@ResponseBody List<Organization> getRootOrg(){
		return compyInfoService.getOrgInfo();
	}
	@RequestMapping(value="/childOrg/{parentid}",method=RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public 	@ResponseBody List<Organization> getChidOrg(@PathVariable("parentid") String parentid){
		List<Organization> childOrgs=compyInfoService.getOrgInfoByParentid(parentid);
		return childOrgs;
	}
	@RequestMapping(value="/orgRootTree",method=RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public 	@ResponseBody List<ZtreeModel> getOrgRootTree(){
		List<Organization> rootOrgs=compyInfoService.getOrgInfo();
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(Organization org:rootOrgs){
			ZtreeModel tm=new ZtreeModel();
			tm.setId(org.getUuid());
			tm.setName(org.getOrgName());
			tm.setpId(org.getParentid());
			boolean b=compyInfoService.haveOrgChild(org.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		return treeModels;
	}
	@RequestMapping(value="/orgChildTree",method=RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	public 	@ResponseBody List<ZtreeModel> getOrgChildTreeByParentid(@RequestParam String parentid){
		List<Organization> childOrgs=compyInfoService.getOrgInfoByParentid(parentid);
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(Organization org:childOrgs){
			ZtreeModel tm=new ZtreeModel();
			tm.setId(org.getUuid());
			tm.setName(org.getOrgName());
			tm.setpId(org.getParentid());
			boolean b=compyInfoService.haveOrgChild(org.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		return treeModels;
	}
	@RequestMapping(value="/org",method=RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Map<String,Object> getOrgInfoByParent(@RequestParam("parentid") String parentid){
		List<Organization> childOrgs=compyInfoService.getOrgInfoByParentid(parentid);
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(Organization org:childOrgs){
			ZtreeModel tm=new ZtreeModel();
			tm.setId(org.getUuid());
			tm.setName(org.getOrgName());
			tm.setpId(org.getParentid());
			boolean b=compyInfoService.haveOrgChild(org.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("treeData", treeModels);
		map.put("tableData",childOrgs);
		return map;
	}
	@RequestMapping(value="/org/{id}",method=RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Organization getOrgInfoById(@PathVariable("id") String id){
		Organization org=compyInfoService.getOrgByPk(id);	
		return org;
	}
	@RequestMapping(value="/org/create",method=RequestMethod.GET)
	public String createShipForm(Model model){

		return "/baseCompyInfo/orgForm";
	}
	@RequestMapping(value="/org/insert",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> insertOrgInfo(@RequestBody Organization orgInfo){
		orgInfo.setUuid(OaUtil.getUUID());	
		compyInfoService.saveOrgInfo(orgInfo);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("data", orgInfo);
		map.put("message", "保存成功");
		return map;
	}
	@RequestMapping(value="/org/delete",method=RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Map<String,String> deleteOrgById(@RequestBody List<Organization> orgInfos) throws JlException{
		compyInfoService.deleteOrgs(orgInfos);
		Map<String,String> map=new HashMap<String,String>();
		map.put("message", "删除成功");
		return map;
		
	}
	@RequestMapping(value="/org/update",method=RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Map<String,Object> updateOrg(@RequestBody Organization orgInfo){
		compyInfoService.updateOrg(orgInfo);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("data", orgInfo);
		map.put("message", "修改成功");
		return map;
		
	}
	
}
