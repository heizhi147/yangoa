package com.yang.oa.hr.resources;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yang.oa.commons.OaUtil;
import com.yang.oa.commons.ZtreeModel;
import com.yang.oa.commons.exception.JlException;
import com.yang.oa.hr.entity.Post;
import com.yang.oa.hr.entity.SysResource;
import com.yang.oa.hr.service.PowerInfoService;

@Controller
@RequestMapping(value="/reses")
public class SysRes {
	@Autowired
	private PowerInfoService powerService;
	@RequestMapping(value="/page", method=RequestMethod.GET)
	public String getPowerPage(){
		return "/powerInfo/res";
	}
	@RequestMapping(value="/res", method=RequestMethod.GET)
	public @ResponseBody List<SysResource> getResByParent(@RequestParam("parentid") String parentid){
		return powerService.getResByParent(parentid);
	}
	@RequestMapping(value="/res/{id}", method=RequestMethod.GET)
	public @ResponseBody SysResource getResById(@PathVariable("id") String id){
		return powerService.getResById(id);
	}
	
	@RequestMapping(value="/res/insert" ,method=RequestMethod.POST)
	public @ResponseBody SysResource insertPost(@RequestBody SysResource sysRes){
		sysRes.setUuid(OaUtil.getUUID());
		powerService.insertRes(sysRes);
		return sysRes;
	}
	@RequestMapping(value="/res/delete", method=RequestMethod.POST)
	public @ResponseBody Map<String,String> deleteResById(@RequestBody List<SysResource> sysRes) throws JlException{
		powerService.deleteResBatch(sysRes);
		Map<String,String> map=new HashMap<String,String>();
		map.put("message", "删除成功");
		return map;
	}
	@RequestMapping(value="/res/update", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> updateRes(@RequestBody SysResource sysRes){
		powerService.updateRes(sysRes);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("data", sysRes);
		map.put("message", "修改成功");
		return map;
	}
	@RequestMapping(value="/resTree", method=RequestMethod.POST)
	public @ResponseBody List<ZtreeModel> getResTreeData(@RequestParam("parentid") String parentid){

		List<SysResource> reses=powerService.getResByParent(parentid);
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(SysResource res:reses){
			ZtreeModel tm=new ZtreeModel();
			tm.setId(res.getUuid());
			tm.setName(res.getResName());
			tm.setpId(res.getParentid());
			boolean b=powerService.hasChildRes(res.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		return treeModels;
	
	}
}
