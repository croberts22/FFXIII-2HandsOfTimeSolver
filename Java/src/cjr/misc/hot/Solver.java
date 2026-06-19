package cjr.misc.hot;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Solver {

	static int[] numbers;
	static boolean solved = false;
	static String final_solution = "";
	static final boolean DEBUG = false;
	
	public static void configure(){
		//string representation of input
		String s_list = "";
		
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		
		System.out.print("List the numbers, separating each one with a comma (ex: \"1, 2, 3, 2\"): ");
		try {
			s_list = br.readLine();
		} catch (IOException e){
			System.out.println("IOException error: could not read");
			e.printStackTrace();
			return;
		}

		numbers = parse_string(s_list);
		//TODO: Exception handling here
		if(numbers == null){
			return;
		}
		
		for(int i = 0; i < numbers.length && !solved; i++){
			int[] copy = Arrays.copyOf(numbers, numbers.length);
			System.out.println("\n------------------------------------------------------");
			System.out.println("Starting at node " + i + " (value = " + numbers[i] + "):");
			System.out.println("------------------------------------------------------");
			solve(i, copy, copy.length, "", 1);
			if(!solved) System.out.println("\nNo solutions found for initial node " + i + " (value = " + numbers[i] + "):");
		}
		
		if(solved){
			System.out.println("--------------------------------");
			System.out.print("Final Result:\n" + final_solution);
			System.out.println("--------------------------------");
		}
		else{
			System.out.println("------------------");
			System.out.println("No solution found.");
			System.out.println("------------------");
		}
		
		
	}
	
	public static int[] parse_string(String s){
		String str_no_whitespace = s.replaceAll("\\s", "");
		String[] string_result = str_no_whitespace.split(",");
		int[] result = new int[string_result.length];
		for(int i = 0; i < string_result.length; i++){
			result[i] = Integer.parseInt(string_result[i]);
		}
		
		return result;
	}
	
	public static void solve(int position, int[] number_array, int remaining, String solution, int depth){
		
		//If the number we're currently looking at is gone, back up.
		if(number_array[position] == -1){
			System.out.println("Dead end! Backing up...");
			return;
		}
		
		//instantiate variables.
		int move_value = number_array[position];
		int new_position;
		number_array[position] = -1; //-1 signifies that it is used.
		
		//this is for use for the left hand side of recursion, since the right hand side will modify the mutable array.
		int[] original_array = Arrays.copyOf(number_array, number_array.length);
		
		solution += "Position: " + position + ", Value: " + move_value+"\n";
		
		remaining--;
		
		//if no more numbers remain, then this means we have solved the puzzle.
		if(remaining == 0){
			//unnecessary, but for sanity checking.
			for(int i = 0; i < number_array.length; i++){
				if(number_array[i] != -1)
					return;
			}
			
			//Puzzle has been solved; set solved to true and send solution to static variable.
			solved = true;
			final_solution = solution;
			
			return;
		}
		else{
			//check right and left sides for out of bounds condition.
			//we wrap the value around the array (think circular).
			
			String depth_string = createDepth(depth);
			
			//left hand side
			if(position - move_value < 0){
				new_position = (position - move_value) + number_array.length;
			}
			else{
				new_position = position - move_value;
			}
			System.out.println(depth_string + "Current Position: " + position + ", Value: " + move_value);
			if(DEBUG) System.out.println("Current solution: \n" + solution);
			System.out.println(depth_string + "(Left) Moving to position " + new_position + " from position " + position + ".");
			solve(new_position, number_array, remaining, solution, depth+1);
			if(solved) return;
			
			//right hand side
			if(move_value + position > (number_array.length - 1)){
				new_position = (move_value + position) - number_array.length;
			}
			else{
				new_position = position + move_value;
			}
			System.out.println(depth_string + "Current Position: " + position + ", Value: " + move_value);
			if(DEBUG) System.out.println("Current solution: \n" + solution);
			System.out.println(depth_string + "(Right) Moving to position " + new_position + " from position " + position + ".");
			solve(new_position, original_array, remaining, solution, depth+1);
			if(solved) return;

		}
	}

	private static String createDepth(int depth) {
		String result = "";
		for(int i = 0; i < depth; i++){
			result += "-";
		}
		return result;
	}
}
