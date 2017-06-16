import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.*;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.NaturalLanguageUnderstanding;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.NaturalLanguageUnderstanding;
/**
*/
public class Pomny {
	public static void main(String[] args) {
		String url = "http://damon.sicore.com/stillman.txt";
		understand(url);
		discover(url);
	}
	/**
	* {
   * 	"url": "https://gateway.watsonplatform.net/discovery/api",
   * 	"username": "7d2de6a9-9034-4185-9e19-05e2182b09a6",
	*  "password": "hmszACvsooju"
	* }
	*/
	public static void discover(String url) {
		Discovery discovery = new Discovery("2016-12-15");
		discovery.setEndPoint("https://gateway.watsonplatform.net/discovery/api/");
		discovery.setUsernameAndPassword("7d2de6a9-9034-4185-9e19-05e2182b09a6", "hmszACvsooju");

		//Build an empty query on an existing environment/collection
		String environmentId = "<environmentId>";
		String collectionId = "<collectionId>";
		QueryRequest queryRequest = new QueryRequest.Builder(environmentId, collectionId).build();

		QueryResponse queryResponse = discovery.query(queryRequest).execute();
		System.out.println("RESPONSE:  \n");
		System.out.println(response);

	}

	public static void understand(String url) {
		NaturalLanguageUnderstanding nlus = 
	 			new NaturalLanguageUnderstanding(
							NaturalLanguageUnderstanding.VERSION_DATE_2017_02_27,
							"d91d87e7-438c-485b-a1df-bc7b7f06c8a9",
							"MYIKG7Dj2Yo2");

		KeywordsOptions keywords= new KeywordsOptions.Builder().sentiment(true).emotion(true).limit(50).build();
		//the top 50 concepts found in the analysis
		//AggregateData ad = client.analyzeData("https://en.wikipedia.org/wiki/IBM", DataType.URL, "IBM Wikipedia entry");
		Features features = new Features.Builder().keywords(keywords).build(); 
		AnalyzeOptions analyzeOptions = new AnalyzeOptions.Builder().url(url).features(features).build();

		AnalysisResults response = nlus.analyze(analyzeOptions).execute();

		System.out.println("RESPONSE:  \n");
		System.out.println(response);

	}
}

/*
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.AnalysisResults;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.AnalyzeOptions;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.AnalyzeOptions.Builder;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.CategoriesOptions;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.CategoriesResult;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.ConceptsOptions;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.ConceptsResult;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.DisambiguationResult;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.EntitiesOptions;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.EntitiesResult;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.Features;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.FeatureSentimentResults;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.KeywordsOptions;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.model.KeywordsResult;
import com.ibm.watson.developer_cloud.natural_language_understanding.v1.NaturalLanguageUnderstanding;
*/


