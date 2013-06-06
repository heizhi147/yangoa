package com.yang.oa.hr.resources;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
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
import com.yang.oa.hr.entity.Organization;
import com.yang.oa.hr.entity.Post;
import com.yang.oa.hr.service.CompyInfoService;

@Controller
@RequestMapping(value="/posts")
public class PostRes {
	  final  Logger logger  =  LoggerFactory.getLogger(PostRes. class );
		@Autowired
		private CompyInfoService compyInfoService;
	@RequestMapping(method=RequestMethod.GET)
	public String getpostPage(){
		return "/baseCompyInfo/post";
	}
	@RequestMapping(value="/post/insert" ,method=RequestMethod.POST)
	public @ResponseBody Post insertPost(@RequestBody Post post){
		post.setUuid(OaUtil.getUUID());
		compyInfoService.insertPost(post);
		return post;
		
	}
	@RequestMapping(value="/childpost" ,method=RequestMethod.GET)
	public @ResponseBody List<Post> getPostByParent(@RequestParam("parentid") String parentid){
		return compyInfoService.getPostByparent(parentid);
		
	}
	
	@RequestMapping(value="/post/{id}" ,method=RequestMethod.GET)
	public @ResponseBody Post getPostById(@PathVariable("id") String id){
		return compyInfoService.getPostById(id);
		
	}
	
	@RequestMapping(value="/post/update" ,method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> updatePost(@RequestBody Post post){
		compyInfoService.updatePost(post);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("data", post);
		map.put("message", "修改成功");
		return map;
		
	}
	@RequestMapping(value="/post/delete" ,method=RequestMethod.POST)
	public @ResponseBody Map<String,String> deletePostById(@RequestBody List<Post> posts) throws JlException{
		compyInfoService.deletePostBatch(posts);
		Map<String,String> map=new HashMap<String,String>();
		map.put("message", "删除成功");
		return map;
		
	}
	@RequestMapping(value="/postTree",method=RequestMethod.POST)
	public 	@ResponseBody List<ZtreeModel> getOrgRootTree(@RequestParam("parentid") String parentid){
		List<Post> posts=compyInfoService.getPostByparent(parentid);
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(Post post:posts){
			ZtreeModel tm=new ZtreeModel();
			tm.setId(post.getUuid());
			tm.setName(post.getPostName());
			tm.setpId(post.getParentid());
			tm.setTreeLevel(post.getPostLevel());
			boolean b=compyInfoService.havePostChild(post.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		return treeModels;
	}
	
}
