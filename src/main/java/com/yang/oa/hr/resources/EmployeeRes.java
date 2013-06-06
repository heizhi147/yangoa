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
import com.yang.oa.commons.PagingBean;
import com.yang.oa.hr.bean.EmpBean;
import com.yang.oa.hr.entity.Employee;
import com.yang.oa.hr.entity.Post;
import com.yang.oa.hr.service.CompyInfoService;

@Controller
@RequestMapping(value = "/employees")
public class EmployeeRes {
	final Logger logger = LoggerFactory.getLogger(OrganizationRes.class);
	@Autowired
	private CompyInfoService compyInfoService;

	@RequestMapping(value = "/page", method = RequestMethod.GET)
	public String getEmployeePage() {
		return "/baseCompyInfo/employee";

	}

	@RequestMapping(method = RequestMethod.GET)
	public @ResponseBody
	List<EmpBean> getEmployeesByOrg(@RequestParam("orgId") String orgId) {
		List<EmpBean> lists = new ArrayList<EmpBean>();
		List<Employee> employees = compyInfoService.getEmployeesByOrg(orgId);
		for (Employee ey : employees) {
			EmpBean empb = changeToEmpBean(ey);
			lists.add(empb);
		}
		return lists;
	}

	@RequestMapping(value = "allEmp", method = RequestMethod.GET)
	public @ResponseBody
	Map<String, Object> getEmployeesByOrg() {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Employee> emps = compyInfoService.selectAllEmp();
		map.put("aaData", emps);
		return map;
	}

	@RequestMapping(value = "/employee/insert", method = RequestMethod.POST)
	public @ResponseBody
	Employee insertEmployee(@RequestBody Employee emp) {
		emp.setUuid(OaUtil.getUUID());
		emp.setPwd("11111111");
		compyInfoService.insertEmployee(emp);
		return emp;

	}

	@RequestMapping(value ="/employee/delete", method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Map<String, String> deleteEmpById(@RequestBody List<EmpBean> empBeans) {
		List<String> lists=new ArrayList<String>();
		for(EmpBean empBean:empBeans){
			lists.add(empBean.getUuid());
		}
		compyInfoService.deleteEmployeeBatch(lists);
		Map<String, String> map = new HashMap<String, String>();
		map.put("message", "删除成功");
		return map;

	}

	@RequestMapping(value = "/employee/{id}", method = RequestMethod.GET)
	public @ResponseBody
	EmpBean getEmpById(@PathVariable("id") String id) {
		Employee emp = compyInfoService.getEmpById(id);
		return changeToEmpBean(emp);
	}

	@RequestMapping(value = "/employee/update", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> updateEmp(@RequestBody EmpBean emp) {
		compyInfoService.updateEmp(changeToEmployee(emp));
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("data", emp);
		map.put("message", "修改成功");
		return map;

	}

	@RequestMapping(value = "/nameCode", method = RequestMethod.GET)
	public @ResponseBody
	Map<String, Object> queryEmployeesNameAndCode(
			@RequestParam("empName") String name,
			@RequestParam("empCode") String code,
			@RequestParam("onePageRows") Integer onePageRows,
			@RequestParam("currentPage") Integer currentPage) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if ("".equals(name)) {
			name = null;
		}
		if ("".equals(code)) {
			code = null;
		}
		PagingBean pageBean = new PagingBean();
		pageBean.setCurrentPage(currentPage);
		pageBean.setOnePageRows(onePageRows);
		int empNum = compyInfoService.selectEmpNumByByNameAndCode(name,code);
		pageBean.setRowsNums(empNum);		
		int pageNums=(int) Math.ceil(empNum /onePageRows);
		pageBean.setPageNums(pageNums);
		if (currentPage == 1) {
			pageBean.setCurrentRows(0);
			pageBean.setHasPreviousPage(false);
			if(currentPage<empNum){
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
		List<Employee> employees = compyInfoService.selectEmpByByNameAndCode(name, code,
				pageBean);
		resultMap.put("queryReult", employees);
		resultMap.put("pageInfo", pageBean);
		return resultMap;
	}

	@RequestMapping(value = "/pageing", method = RequestMethod.GET)
	public @ResponseBody
	List<Employee> queryEmployeesPaging(@RequestBody PagingBean pageBean) {

		int pageSize = pageBean.getOnePageRows();
		int currentPage = pageBean.getCurrentPage();
		if (currentPage == 1) {
			int empNum = compyInfoService.selectEmpNum();
			pageBean.setRowsNums(empNum);
			pageBean.setPageNums(empNum % pageSize);
			pageBean.setCurrentRows(0);
		} else {
			int pageNums = pageBean.getPageNums();
			if (currentPage <= pageNums) {
				int currentRows = (currentPage - 1) * pageSize;
				pageBean.setCurrentRows(currentRows);
			}

		}
		return compyInfoService.selectEmployeesPaging(pageBean);
	}
	
	
	private EmpBean changeToEmpBean(Employee ey) {
		EmpBean empb = new EmpBean();
		empb.setUuid(ey.getUuid());
		empb.setAddress(ey.getAddress());
		empb.setEmail(ey.getEmail());
		empb.setEmpCode(ey.getEmpCode());
		empb.setEmpName(ey.getEmpName());
		empb.setOrgId(ey.getOrgId());
		empb.setPostId(ey.getPostId());
		Post post = compyInfoService.getPostById(ey.getPostId());
		empb.setPostName(post.getPostName());
		empb.setPwd(ey.getPwd());
		empb.setTelNum(ey.getTelNum());
		return empb;
	}

	private Employee changeToEmployee(EmpBean emp) {
		Employee employee = new Employee();
		employee.setUuid(emp.getUuid());
		employee.setAddress(emp.getAddress());
		employee.setEmail(emp.getEmail());
		employee.setEmpCode(emp.getEmpCode());
		employee.setEmpName(emp.getEmpName());
		employee.setOrgId(emp.getOrgId());
		employee.setPostId(emp.getPostId());
		employee.setPwd(emp.getPwd());
		employee.setTelNum(emp.getTelNum());
		return employee;
	}
}
