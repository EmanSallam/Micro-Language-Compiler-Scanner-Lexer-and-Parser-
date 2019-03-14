// import antlr
import org.antlr.v4.runtime.*;
import java.io.FileInputStream;
import java.io.InputStream;

/**
 *
 * @author Eman Sallam
 */

/*****************************
    This is a code for the first two steps of Micro language Compiler using Java and antlr api
    Micro language is similar a little a bit to C language
    The grammar file is Micro.g4
*****************************/

// Driver is the main Class which will test the lexer and parser on your test micro file
public class Driver {

    public static void main(String[] args) throws Exception {
        // Read input MICRO code
        InputStream is = null;
        try {
            String inputFile = args[0]; // You can edit the IDE Run Configuration or :
            //or simply : String inputFile = "/*Your file Directory*/";
            is = new FileInputStream(inputFile);
        }
        catch (Exception e) {
            System.out.println("You must specify an input file");
            System.exit(0);
        }

        // Lexer instance
        ANTLRInputStream input = new ANTLRInputStream(is);
        MicroLexer lexer = new MicroLexer(input);

        // Token instance
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();

        // Parser instance
		MicroParser parser = new MicroParser(tokens);
        parser.program();

        // Parser checking
        int err = parser.getNumberOfSyntaxErrors(); // Number of syntax errors
        boolean buildTree = parser.getBuildParseTree(); // Can build the Parse tree 
        System.out.println(( err == 0 && buildTree ) ? "Accepted" : "Not Accepted");
    }
}
