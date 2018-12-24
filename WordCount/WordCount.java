import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.io.File;
import java.util.Arrays;

public class WordCount {
    public static void deleteFolder(File folder) {
        File[] files = folder.listFiles();
        if(files!=null) { //some JVMs return null for empty dirs
            for(File f: files) {
                if(f.isDirectory()) {
                    deleteFolder(f);
                } else {
                    f.delete();
                }
            }
        }
        folder.delete();
    }
    public static void main(String[] args) {
        String inputFile = args[0];
        String outputFile = "/tmp/data/result";
        SparkConf conf = new SparkConf().setAppName("WordCount");
        JavaSparkContext sc = new JavaSparkContext(conf);
        long t1 = System.currentTimeMillis();
        JavaRDD<String> data =
                sc.textFile(inputFile).flatMap(s -> Arrays.asList(s.split(" ")).iterator());
        JavaPairRDD<String, Integer> counts =
                data.mapToPair(w -> new Tuple2<String, Integer>(w,1)).
                        reduceByKey((c1,c2) -> c1 + c2);
        deleteFolder(new File(outputFile)
        );
        counts.saveAsTextFile(outputFile);
        long t2 = System.currentTimeMillis();
        System.out.println("======================");
        System.out.println("time in ms :"+(t2-t1));
        System.out.println("======================");
    }
}