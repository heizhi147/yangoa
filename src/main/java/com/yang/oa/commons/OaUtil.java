package com.yang.oa.commons;

import java.util.UUID;

public class OaUtil {
	 public static final synchronized String getUUID() {
	        return UUID.randomUUID().toString().replace("-", "");
	    }
}
