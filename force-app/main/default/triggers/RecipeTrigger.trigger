//create a trigger that will process Before Insert, After Insert,
// Before Update and After Update.
trigger RecipeTrigger on Recipe__c (before insert, after insert, before update, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            RecipeTriggerHandler.checkRecipeMissingValues(Trigger.new);
        } 
        if (Trigger.isUpdate) {
            RecipeTriggerHandler.checkRecipeMissingValues(Trigger.new);
        }
    } else {
        if (Trigger.isInsert) {
            RecipeTriggerHandler.updateRecipeComplexity(Trigger.new);
        } 
        if (Trigger.isUpdate) {
            RecipeTriggerHandler.updateRecipeComplexity(Trigger.new);
        }
    }
    
    // Call the reviewTask method
    RecipeTriggerHandler.reviewTask(new List<Id>(Trigger.newMap.keySet()));
}