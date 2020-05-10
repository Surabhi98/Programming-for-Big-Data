import java.io.IOException;
import java.util.List;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Reducer;

//SURABHI AGARWAL : 17203535
// A program to compute the significance of patents using MapReduce jobs

public class Question2_MapReduce {

    //The first Mapper class which emits key value pairs
    public static class Mapper1 extends Mapper < Object , Text , Text, Text >{
        public void map ( Object key , Text value , Context context) throws IOException,InterruptedException {
            
            // read the input line by line and separate it into tokens
            String[] tokenizer = value.toString().trim().split("\\s+"); 

            // store each of the tokens into a string 
            String fromNode = tokenizer[0];
            String toNode = tokenizer[1];

            // add a minus in front of toNode to make it negative 
            String negative_tonode = "-";
            for(int i = 0; i < toNode.length(); i++){
                negative_tonode += toNode.charAt(i);
            }

            // output two key-value pairs as per question's requirements
            // (toNode, fromNode) 
            context.write(new Text(toNode), new Text(fromNode));
            // (fromNode, -toNode)
            context.write(new Text(fromNode), new Text(negative_tonode));
        }
    }

    // The first Reducer class which takes in input from the first mapper
    // and emits the key along with the string of values associated with it

    public static class Reducer1 extends Reducer < Text, Text , Text, Text > {

        public void reduce ( Text key , Iterable < Text > values , Context context) throws IOException,InterruptedException {

            // create a new empty string that will store all the value for the given key 
            String output = ""; 

            // storing all values into a single string separated by a comma
            for ( Text current_value : values ) {
                output += val.toString() + ",";
            }

            // removing last comma
            output = output.substring(0, output.length()-1);

            // emit the key along with the string of values associated with it 
            context.write(new Text(key), new Text(output));
        }
    }

    // The second Mapper class which takes in input from the first Reducer
    // and emits absolute value for the negative key and the list of 
    // values associated with it
    public static class Mapper2 extends Mapper < Object , Text , Text, Text > {
        public void map ( Object key , Text value , Context context) throws IOException,InterruptedException {

            // split into tokens the given list of vaues separated by a comma
            String[] tokenizer = value.toString().trim().split(",");


            String resulting_values = ""; //new list of values stored in "list"

            
            for(String current_value : tokenizer) {

                // if there is a negative value in the list of values 
                // associated with the given key - make that negative value 
                // the key with all other values + the key added to the list of values
                if(current_value.charAt(0).equals("-")) {
                    resulting_values += String.valueOf(key);

                    for (String curr_val : tokens){
                        if( !(curr_val.charAt(0).equals("-")) ) {
                            resulting_values += curr_val + ",";
                        }
                    }

                    // remove last comma from 'result' string 
                    String current_value_abs = current_value.substring(1, current_value.length());

                    // emit absolute value for the negative key and the associated 
                    // list of values with it
                    context.write(new Text(current_value_abs), new Text(resulting_values));
                }
            }
        }
    }

    // The second Reducer class which takes in input from the second Mapper and 
    // emits the final result in the form of key value pairs.
    public static class Reducer2 extends Reducer < Text, Text , Text, IntWritable > {
        public void reduce(Text key, Iterable <Text> values, Context context) throws IOException,InterruptedException {

            // stores the frequency of citations for each key 
            int frequency = 0; 

            // calculates the frequency of citations for the given key
            // by counting the number of values (citations) in the list associated with that key
            for(Text current_value:values) {
                frequency = frequency + 1;
            }

            // output the final result, that is a key-value pair 
            context.write (new Text(key), new IntWritable(frequency));
        }
    }

    // The main class sets up the configuration for both jobs
    public static void main(String[] args) throws Exception{

        // create a new configuration 
        Configuration config = new Configuration();

        // create a new job
        Job job1 = Job.getInstance(config, "Job 1 started:");
        
        // setting up job1
        job1.setJarByClass(Question2_MapReduce.class);
        job1.setMapperClass(Mapper1.class);
        job1.setReducerClass(Reducer1.class);
        job1.setMapOutputKeyClass(Text.class);
        job1.setMapOutputValueClass(Text.class);
        FileInputFormat.addInputPath(job1, new Path(args[0]));
        FileOutputFormat.setOutputPath(job1, new Path(args[1]));

        // wait for job1 to complete 
        job1.waitForCompletion(true); 

        // create a new job 
        Job job2 = Job.getInstance(config, "Job 2 started:");
        
        // setting up job2
        job2.setJarByClass(Question2_MapReduce.class);
        job2.setMapperClass(Mapper2.class);
        job2.setReducerClass(Reducer2.class);
        job2.setMapOutputKeyClass(Text.class);
        job2.setMapOutputValueClass(Text.class);
        job2.setInputFormatClass(KeyValueTextInputFormat.class);
        FileInputFormat.addInputPath(job2, new Path(args[1]));
        FileOutputFormat.setOutputPath(job2, new Path(args[2]));

        // wait for job2 to complete
        job2.waitForCompletion(true);
    }

}

