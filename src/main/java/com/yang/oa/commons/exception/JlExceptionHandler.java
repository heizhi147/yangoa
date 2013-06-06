package com.yang.oa.commons.exception;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;
public class JlExceptionHandler implements HandlerExceptionResolver {
	public ModelAndView resolveException(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception arg3) {
		if(isAjaxRequest(arg0)){
		try {
			if(arg3 instanceof Exception){
			System.out.println("执行方法");
			arg1.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			arg1.getWriter().write(arg3.getMessage());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 return new ModelAndView(); 
		}else{
			ModelAndView mv =new ModelAndView();
			mv.setViewName("home");
			mv.addObject("info", arg3.getMessage());
			return mv;
		}
	}
	
	private boolean isAjaxRequest(HttpServletRequest arg0){
		String requestType=arg0.getHeader("X-Requested-With");
		if(requestType!=null && "XMLHttpRequest".equals(requestType)){
			return true;
		}
		return false;
	}

}
