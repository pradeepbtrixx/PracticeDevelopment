public class OpportunityTriggerHelper {

    public static void UpdateTheAccountRollUps(set<Id> setOfAccIds){
        
        Map<Id,Account> mapOfAccountToUpdate = new Map<Id,Account>();
        
        AggregateResult[] groupedResults = [SELECT AccountId,Isclosed, SUM(AMOUNT) total FROM Opportunity WHERE AccountId IN: setOfAccIds GROUP BY AccountId, Isclosed];
    
    	//system.debug('groupedResults --> '+groupedResults);
        For(AggregateResult agg : groupedResults){
            string accId = String.valueOf(agg.get('AccountId'));
            Boolean IsClosedVar = Boolean.valueOf(agg.get('Isclosed'));
            Integer OppAmountTotal = Integer.valueOf(agg.get('total'));
            //system.debug('accId -> '+accId+' OppAmountTotal -> '+OppAmountTotal);
            If(mapOfAccountToUpdate.containsKey(accId)){
                If(IsClosedVar == true){
                    mapOfAccountToUpdate.get(accId).sum_of_closed_opp_revenue__c = OppAmountTotal;
                }else{
                    mapOfAccountToUpdate.get(accId).sum_of_Open_Opp_Revenue__c  = OppAmountTotal;
                }
            }else{
                If(IsClosedVar == true){
                    mapOfAccountToUpdate.put(accId,new Account(Id=accId,sum_of_closed_opp_revenue__c = OppAmountTotal));
                }else{
                    mapOfAccountToUpdate.put(accId,new Account(Id=accId,sum_of_Open_Opp_Revenue__c = OppAmountTotal));
                }
            }
        }
        
        List<Account> listOfAccountsToUpdate = mapOfAccountToUpdate.values();
        If(!listOfAccountsToUpdate.isempty()){
            UPDATE listOfAccountsToUpdate;
        }
    }
    
}