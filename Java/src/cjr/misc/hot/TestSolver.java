package cjr.misc.hot;

import junit.framework.Assert;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import junit.textui.TestRunner;

public final class TestSolver extends TestCase {
	
	public void testParseString1() {
		final int[] expected_result = {1, 2, 3};
		String s = "1, 2, 3";
		int[] result = Solver.parse_string(s);
		Assert.assertTrue(result.length == expected_result.length);
		Assert.assertTrue(result[0] == expected_result[0]);
		Assert.assertTrue(result[1] == expected_result[1]);
		Assert.assertTrue(result[2] == expected_result[2]);
	}
	
	public void testParseString2() {
		final int[] expected_result = {3, 5, 1};
		String s = "3      ,5,                     1";
		int[] result = Solver.parse_string(s);
		Assert.assertTrue(result.length == expected_result.length);
		Assert.assertTrue(result[0] == expected_result[0]);
		Assert.assertTrue(result[1] == expected_result[1]);
		Assert.assertTrue(result[2] == expected_result[2]);
	}

}
