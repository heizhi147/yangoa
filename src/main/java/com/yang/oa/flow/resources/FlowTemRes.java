package com.yang.oa.flow.resources;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yang.oa.commons.OaStaticValue;
import com.yang.oa.commons.PagingBean;
import com.yang.oa.flow.entity.FlowTem;
import com.yang.oa.flow.service.FlowService;
import com.yang.oa.hr.entity.Employee;

@Controller
@RequestMapping(value = "/flowTems")
public class FlowTemRes {
	
	@Autowired
	private CacheManager ehcacheManager;

	private Cache cache;
	@Autowired
	private FlowService flowService;
	@RequestMapping(value = "/page",method=RequestMethod.GET)
	public String getFlowTemPage(){
		return "/flowInfo/flowTem";
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public @ResponseBody
	Map<String, Object> queryEmployeesNameAndCode(
			@RequestParam("flowTemName") String name,
			@RequestParam("onePageRows") Integer onePageRows,
			@RequestParam("currentPage") Integer currentPage) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if ("".equals(name)) {
			name = null;
		}
		List<FlowTem> flowTems=flowService.selectFlowTemByName(name);
		cache = ehcacheManager.getCache(OaStaticValue.CACHE_NAME);
		Element cacheelement=cache.get("selectFlowByNameResult");
		Element element = new Element("selectFlowByNameResult", flowTems);
		cache.put(element);
		
		PagingBean pageBean = new PagingBean();
		pageBean.setCurrentPage(currentPage);
		pageBean.setOnePageRows(onePageRows);
		int elements = flowTems.size();
		pageBean.setRowsNums(elements);		
		int pageNums=(int) Math.ceil(elements /onePageRows);
		pageBean.setPageNums(pageNums);
		if (currentPage == 1) {
			pageBean.setCurrentRows(0);
			pageBean.setHasPreviousPage(false);
			if(currentPage<elements){
				pageBean.setHasNextPage(true);
			}else{
				pageBean.setHasNextPage(false);
			}
			
		} else {
			pageBean.setHasPreviousPage(true);
			if (currentPage < pageNums) {
				pageBean.setHasNextPage(true);
				int currentRows = (currentPage - 1) * onePageRows;
				pageBean.setCurrentRows(currentRows);
			} else if (currentPage == pageNums) {
				pageBean.setHasNextPage(false);
				int currentRows = (currentPage - 1) * onePageRows;
				pageBean.setCurrentRows(currentRows);
				pageBean.setOnePageRows(pageBean.getRowsNums() - currentRows);
			}

		}
		List<FlowTem> subflowTems =null;
		int skipRowsindex=pageBean.getCurrentRows()+pageBean.getOnePageRows();
		if(skipRowsindex<elements){
			subflowTems =flowTems.subList(pageBean.getCurrentRows(), skipRowsindex);
		}else{
			subflowTems =flowTems.subList(pageBean.getCurrentRows(), elements);
		}
		resultMap.put("queryReult", subflowTems);
		resultMap.put("pageInfo", pageBean);
		return resultMap;
	}
}
