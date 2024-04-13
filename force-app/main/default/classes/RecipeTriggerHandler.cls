public with sharing class RecipeTriggerHandler {

    // Method to check if any of (Active_Time__c, Description__c, 
    //Active_Time_Units__c, Servings__) missing before insert or update
    //if ture, check the Draft__c field on the recipe

    public static void checkRecipeMissingValues(List<Recipe__c> recipes) {
        for (Recipe__c recipe : recipes) {
            // Check if any of the essential fields are null
            if(recipe.Active_Time__c == null ||
            recipe.Description__c == null ||
            recipe.Active_Time_Units__c == null||
            recipe.Servings__c== null){
                // Check if any of the essential fields are null, set the Draft field value to true
                recipe.Draft__c=TRUE;
            }
        }
    }
    //Method to update the complexity of the recipes:
    // Gets the numerical rating back from the method 
    // Your method in the recipe trigger handler needs to get the rating 
    //for each recipe in the trigger and update the Complexity field.

    public static void updateRecipeComplexity(List<Recipe__c> recipes) {
        // Calls out to already existing method on the HelperFunctions class 
        //called rateRecipeComplexity.
        for(Recipe__c recipe : recipes){
            Integer rating = HelperFunctions.rateRecipeComplexity(recipe);
            //and use it to fill in the Complexity__c field.
            // If the method returns 
             // A 3 = ‘Difficult’
             // a 2 = ‘Moderate’ and
             //a 1 = ‘Simple’
             if (rating == 3) {
                recipe.Complexity__c = 'Difficult';
            } else if (rating == 2) {
                recipe.Complexity__c = 'Moderate';
            } else {
                recipe.Complexity__c = 'Simple';
            }
        }
    }
    //Method to create review tasks for cookbooks:
    public static void reviewTask(List<Id> recipeIds) {
        // Check Recipe Usage objects related to the given recipeIds (instead of the cookbook)
        List<Recipe_Usage__c> recipeUsages = [SELECT Id, Recipe__r.Draft__c, Cookbook__r.OwnerId 
                                            FROM Recipe_Usage__c 
                                            WHERE Recipe__c IN : recipeIds AND Recipe__r.Draft__c = FALSE];
        // List to store tasks to be inserted
        List<Task> taskToCreate = new List<Task>();
        // Make the task due-date 1 week from today
        Date dueDate = Date.today().addDays(7);
        
        //Iterate over recipeUsage records
        for (Recipe_Usage__c recipeUsage : recipeUsages){
            // Check if the recipe is not a draft
            if (!recipeUsage.Recipe__r.Draft__c){
                // Create a new task for the cookbook:
                Task task = new Task();
                task.Subject = 'Review Task for Cookbook';
                task.OwnerId = recipeUsage.Cookbook__r.OwnerId;
                task.ActivityDate = dueDate;
                taskToCreate.add(task); //add task to list
            }
        }
        insert taskToCreate;
        
    }
}