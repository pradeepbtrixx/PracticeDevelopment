public class OpportunityTriggerHandler extends TriggerHandler {
    
    private Map<Id, Opportunity> newOppMap;
    private Map<Id, Opportunity> oldOppMap;
        
    public OpportunityTriggerHandler() {
        this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldOppMap = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    public override void afterInsert() {
        set<Id> setOfAccIds = new Set<Id>();
        For(Opportunity opp : this.newOppMap.values()){
            setOfAccIds.add(opp.AccountId);
        }
        If(!setOfAccIds.isempty()){
            OpportunityTriggerHelper.UpdateTheAccountRollUps(setOfAccIds);
        }
    }
    public override void afterUpdate() {
        set<Id> setOfAccIds = new Set<Id>();
        For(Opportunity opp : this.newOppMap.values()){
            If(opp.AccountId != this.oldOppMap.get(opp.Id).AccountId){
            	setOfAccIds.add(opp.AccountId);
                setOfAccIds.add(this.oldOppMap.get(opp.Id).AccountId);
            }else if(opp.Amount != this.oldOppMap.get(opp.Id).Amount){
                setOfAccIds.add(opp.AccountId);
			}
        }
        If(!setOfAccIds.isempty()){
            OpportunityTriggerHelper.UpdateTheAccountRollUps(setOfAccIds);
        }
    }
    public override void afterDelete() {
        set<Id> setOfAccIds = new Set<Id>();
        For(Opportunity opp : this.oldOppMap.values()){
            setOfAccIds.add(opp.AccountId);
        }
        If(!setOfAccIds.isempty()){
            OpportunityTriggerHelper.UpdateTheAccountRollUps(setOfAccIds);
        }
    }
    public override void afterUndelete() {
        set<Id> setOfAccIds = new Set<Id>();
        For(Opportunity opp : this.newOppMap.values()){
            setOfAccIds.add(opp.AccountId);
        }
        If(!setOfAccIds.isempty()){
            OpportunityTriggerHelper.UpdateTheAccountRollUps(setOfAccIds);
        }
        
    }
}