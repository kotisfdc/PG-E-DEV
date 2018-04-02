public class JO_SAPSyncStats {
    
    public string corpinfo {get;set;}
    public string cdateinfoto{get;set;}
    public string cDateinfo {get;set;}
    public string cTimeinfo {get;set;}
    public string RID {get;set;}
    
    List<string> mycorpid
    {
        get
        {
            if (corpinfo==null)
                return new List<string>();
            else
            {
                List<string> cid = new List<string>();
                system.debug('Corpinfo ===>>>'+corpinfo);
                for(string s: corpinfo.split(','))
                    cid.add(s);
                system.debug('cid add===>>>'+cid);
                return cid;
            }
            
        }
    }
    
    
    public class ObjRecord
    {
        public boolean isselected {get;set;}
        public integer rowid {get;set;}
        public SAP_Sync_Object__c rec {get; set;}
        public DateTime processstartdt {get; set;}
        public DateTime processenddt {get; set;}
        public string msg {get; set;}
        public DateTime startdt {get; set;}
        public DateTime enddt {get; set;}
        public decimal dur {get; set;}
        public decimal processdur {get; set;}
        public DateTime savestartdt {get; set;}
        public DateTime saveenddt {get; set;}
        public decimal savedur {get; set;}
        public List<sObject> queryrecs {get;set;}
        /*{
            get
            {
                if (queryrecscache == '')
                    return new List<sobject>();
                
                system.debug('CacheName ---- ' + queryrecscache);
                
                Cache.OrgPartition orgPart = JO_Util.GetJOPartition();        
                List<sobject> recs = (List<sobject>) orgPart.get(queryrecscache);
                if(recs != null)
                    return recs;
                else 
                    return new List<sobject>();
            }
        }*/
        public Map<string,sObject> convrecs{get;set;}
        /*{
            get
            {
                if(convrecscache == '')
                    return new Map<string,sObject>();
                Cache.OrgPartition orgPart = JO_Util.GetJOPartition();
                Map<string,sObject> crecs = (Map<string,sObject>) orgPart.get(convrecscache);
                if(crecs != null)
                    return crecs;
                else 
                    return new Map<string,sObject>();
            }
        }*/
        public string loginfo {get;set;} 
        public integer instotal {get; set;}
        public integer updtotal {get; set;}
        public integer skiptotal {get; set;}
        public string queryrecscache {get; set;}
        public string convrecscache {get; set;}
        
        public void Add2Log(string val)
        {
            loginfo = loginfo == null ? DateTime.Now() + ' | ' + val : loginfo + '\n' + DateTime.Now() + ' | ' + val;
            system.debug(' ------ API LOG --------- ' + loginfo);
        }
        
        public integer rectotal 
        {
            get
            {
                return queryrecs == null ? 0 : queryrecs.size();
            }
        }
        
        public integer convtotal 
        {
            get
            {
                return convrecs == null ? 0 : convrecs.size();
            }
        }
        
        
        public ObjRecord(SAP_Sync_Object__c inputval)
        {
            rec = inputval;
        }
        
    }
    
    public List<ObjRecord> objs {get; set;} 
    public Boolean allChecked {get; set;}
    List<SAP_Sync_Object__c> SAPObj = new List<SAP_Sync_Object__c>();
    User usr = [SELECT Id, FederationIdentifier FROM User where Id =: UserInfo.getUserId()];
    public JO_SAPSyncStats()
    {
        objs = new List<ObjRecord>();
        corpinfo = usr.FederationIdentifier; //corpinfo = 'JCO1,NXGB';
        cDateinfoto = (Datetime.now()).format('yyyyMMdd');
        cDateinfo =  (Datetime.now()-10).format('yyyyMMdd');
        cTimeinfo = '000000';
        allChecked = true;
        LoadSyncObjects();
            
    }
    public JO_SAPSyncStats(string corpinfo, string cdateinfoto, string cDateinfo, string cTimeinfo)
    {
        objs = new List<ObjRecord>();
        this.corpinfo = corpinfo; //corpinfo = 'JCO1,NXGB';
        this.cDateinfoto = cdateinfoto;
        this.cDateinfo = cDateinfo;
        this.cTimeinfo = cTimeinfo;
        LoadSyncObjects();
            
    }
    
    public PageReference CheckAll()
    {
        
         
      for(ObjRecord objRec : objs)
      {
        objRec.isselected = allChecked;
      }
        return null;
    }
    
    public PageReference toggleAll()
    {
        string state = 'checked';
        for(ObjRecord objRec : objs)
        {
            if(!objRec.isselected)
            {state = 'unchecked';}
        }
        if(state != 'checked')
        {
            allChecked = false;
        }
        else
        {
            allChecked = false;
        }
        return null;
    }
    
    public void LoadSyncObjects()
    {
        Cache.OrgPartition orgPart = JO_Util.GetJOPartition();        
        if(orgPart != null)
        {
            //// ADDED THIS FOR DEV PURPOSES -- NEED TO COMMENT DURING DEPLOYMENT
            orgPart.remove('JOSAPOBJECTS');
            ////////
            SAPObj = (List<SAP_Sync_Object__c>)orgPart.get('JOSAPOBJECTS');
        }
        // Check the cache value that the get() call returned.
        if (SAPObj == null) 
        {
            SAPObj =  [select Id, Name, Object__c, DO__c, Active__c, Query__c, PF__c,RT__c,PO__c, CF__c, MD__c,AC__c, (Select Id, Name, SO__c, DO__c, SF__c, DF__c, SFT__c, DFT__c, SN__c from SAP_Sync_Mappings__r) 
                       from SAP_Sync_Object__c order by Active__c desc, Sort_No__c];
            
            orgPart.put('JOSAPOBJECTS', SAPObj);
        }
        
        integer i = 0;
        objs = new List<ObjRecord>();
        for(SAP_Sync_Object__c r : SAPObj)
        {
            ObjRecord vr = new ObjRecord(r);
            vr.rowid = i;
            i++;
            if (!r.Active__c)
            {
                vr.msg = 'Sync will be skipped - Object Not Active';
                 vr.isselected = false;
            }
            else
            {
                vr.msg = '';
                vr.isselected = true;
            }
            vr.queryrecscache = '';
            vr.queryrecs = new List<sobject>();
            objs.add(vr);
        }
    }
    
    public void SavenSync()
    {

        Jo_Wrapper.SyncWrapper wr = SavenSync('000000');
        for(ObjRecord r : objs)
        {
            r.Add2log(' Final Wrapper: ' + wr);
        }
       
    }
    
    public Jo_Wrapper.SyncWrapper SavenSync(string cTimeinfo)
    {   
        SAP2SFSync();
        ProcessRecords();
        SaveRecords();

        Jo_Wrapper.SyncWrapper sw = new Jo_Wrapper.SyncWrapper();
        sw.rectotal = 0;
        sw.processSrtDt = objs[0].startdt;

        boolean HasError = false;

        for(ObjRecord r : objs)
        {
            r.Add2Log('---- Inside Wrapper: ' + r.msg + ' -- Recs: ' + r.rectotal);
            if(r.msg.containsIgnoreCase('error'))
                HasError = true;
            
            if (r.rec.Active__c)
                sw.processEndDt = r.saveenddt;
            
            sw.rectotal = sw.rectotal + r.rectotal;
        }

        sw.msg = HasError ? 'Error' : 'OK';

        sw.processdur = ((sw.processEndDt.getTime() - sw.processSrtDt.getTime())/1000.0).setscale(2);
     
        return sw; 
        
    }
    
    public string SelectedLogInfo {get;set;}
    public integer rowid {get;set;}
    
    public void ViewReturnLog()
    {
        //system.debug('----inside click' + rowid + objs[rowid].loginfo);
        SelectedLogInfo = objs[rowid].loginfo;
    }
    
   public void SAP2SFSync()
    {
        for(ObjRecord v: objs)
        {
            if (!v.isselected)
                continue;

            v.startdt = DateTime.now();
            v = SyncFromSAP(v);
            v.enddt = DateTime.now();
            v.dur = ((v.enddt.getTime() - v.startdt.getTime())/1000.0).setscale(2);
        }
    }
    
    public ObjRecord SyncFromSAP(ObjRecord v)
    {

        if (v.rec.Active__c)
        {
            try
            {
                string whereqry = '';
                v.rec.query__c = v.rec.query__c.replace('|', ' ');
                whereqry = ' where jobowner__c = \''+ mycorpid[0] +'\''   ;
                
                if(cDateinfo != null && cDateinfo != '') 
                    whereqry = whereqry + ' and changedDate__c >= \''+ cDateinfo +'\''  ;
                
                if(cDateinfoto != null && cDateinfoto != '') 
                    whereqry = whereqry + ' and changedDate__c <= \''+ cDateinfoto +'\'' ;
                
                if(cTimeinfo != null && ctimeinfo != '')
                    whereqry = whereqry + ' and changedtime__c >= \''+ctimeinfo +'\'' ;

                if(v.rec.AC__c != '' && v.rec.AC__c != null)
                            whereqry = whereqry +  ' ' + v.rec.AC__c;                

                v.Add2Log(v.rec.query__c + whereqry + ' limit 2000');

                v.add2log('--Variables --' + mycorpid + '-' + cDateinfo + '-' + CDateinfoto + '-' + ctimeinfo);

                v.queryrecs = Database.query(v.rec.query__c + whereqry + ' limit 2000');
                
                
              v.Add2Log('Records: ' + v.queryrecs.size());
                
                v.msg = 'OK';
            }
            catch(Exception ex)
            {
                v.Add2Log('#####Exception '+ex.getMessage());
                v.msg = 'Error';
            }
            finally
            {
                return v;
            }
        }
        
        return v;
    }

    public void ProcessRecords()
    {
        for(ObjRecord v: objs)
        {
            if (!v.isselected)
                continue;

            v.processstartdt = DateTime.now();
            v = ProcessRecords(v);
            v.processenddt = DateTime.now();
            v.processdur =  ((v.processenddt.getTime() - v.processstartdt.getTime())/1000.0).setscale(2);
        }
    }
    
    public ObjRecord ProcessRecords(ObjRecord v)
    {
        if (v.rec.Active__c)
        {
            try
            {
                Map<String,string> sn = new Map<string, string>();
                sn.put(v.rec.object__c, v.rec.DO__c);
                for(SAP_Sync_Mapping__c mp : v.rec.SAP_Sync_Mappings__r)
                {
                    if(!mp.SN__c)
                        sn.put(mp.SF__c, mp.DF__c);
                }
                v.Add2log(' Mapping Exceptions : ' + sn);
                v.convrecs = new Map<string,Sobject>();//
                //v.Add2log(' Query Records 123 : ' + v.queryrecs);
                for(Sobject r : v.queryrecs)
                {
                    string rec = JSON.serialize(r, true);
                    //v.Add2log(' rec ser : ' + rec);
                    for(string s : sn.keySet())
                    {
                        rec =  rec.replaceFirst(s, sn.get(s));
                    }
                    //v.Add2log(' rec replace : ' + rec);
                    Sobject trec = (Sobject)JSON.deserialize(rec,Type.forName(v.rec.DO__c));
                    trec.id = null;
                    //v.Add2log(' trec deser : ' + trec);
                    v.convrecs.put(string.valueof(r.get('ExternalId')),trec);
                }
                /*
                Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9]');
                Matcher matcher = nonAlphanumeric.matcher(UserInfo.getSessionId());
                
                Cache.OrgPartition orgPart = JO_Util.GetJOPartition();
                v.convrecscache = v.rec.Object__c.remove('__x') + DateTime.Now().format('YYYYMMDDHHmmssSSS'); // + matcher.replaceAll('');
                orgPart.put(v.convrecscache, v.convrecs);
                */
                v.Add2log(' Converted Records : ' + v.convrecs.size());
                //v.Add2log(' Converted Records 123 : ' + v.convrecs);
                
            }
            catch (Exception ex)
            {
                v.add2log(ex.getMessage());
                v.msg = 'Error';
            }
        }
        
        return v;
    }
    


    public void SaveRecords()
    {
        for(ObjRecord v: objs)
        {
            if (!v.isselected)
                continue;
            
            v.savestartdt = DateTime.now();
            try
            {
                v = SaveRecords(v);
            }
            catch (Exception ex)
            {
                v.msg = ex.getmessage();
            }
            v.saveenddt = DateTime.now();
            v.savedur =  ((v.saveenddt.getTime() - v.savestartdt.getTime())/1000.0).setscale(2);
        }
        
    }
    
  public ObjRecord SaveRecords(ObjRecord v)
    {
        if (v.rec.Active__c )
        {
            Set<string> keys = v.convrecs.keySet();
            
            string qry = 'Select Id, SAP_External_Id__c From ' + v.rec.DO__c + ' where SAP_External_Id__c in :keys';
            
            v.Add2log('Existing Records Check Query --- ' + qry);
            
            if (keys.size()>0)
            {
                try
                {
                    v.Add2log('Existing Converted Records : ' + keys.size());
                    List<Sobject> ex = Database.query(qry);
                    
                    v.Add2log('DB Existing Records : ' + ex.size());
                    
                    map<string,sobject> dbrecs = new map<string,sobject>() ;
                    
                    for(sobject r : ex)
                        dbrecs.put(string.valueof(r.get('SAP_External_Id__c')), r);
                    
                    v.Add2log('DB Existing Records (Map): ' + dbrecs.size());
                    
                    if(ex.size()>0)
                        v = InsertUpdateRecs(v, dbrecs);
                    else
                        v = InsertOnly(v);
                    
                    /*                    system.debug('-----  UPSERT SIZE BEFORE TRANSFORM ---- ' + insrec.size() + ' ---- ' + updrec.size());

                    if (insrec.size() > 0)
                    {
                    
                    v.instotal = insrec.size(); 
                    insert insrec.values();
                    
                    }
                    if (updrec.size() > 0)
                    {   
                    v.updtotal = updrec.size();
                    update updrec;
                    }
                    system.debug('-----  UPSERT SIZE AFTER TRANSFORM ---- ' + insrec.size() + ' ---- ' + updrec.size());
                    */                    
                    v.msg = 'Records Saved';
                }
                catch(exception exm)
                {
                    v.add2log(exm.getMessage());
                    system.debug('------- Log Dump ------' + v.loginfo);
                    v.msg = 'Error';
                }
                
                
            }
        }
        
        return v;
    }
    
  
   

    public ObjRecord InsertUpdateRecs(ObjRecord v, Map<string,sobject> savedmpr)
    {
        List<sobject> insrec = new List<sobject>();
        List<sobject> updrec = new List<sobject>();
        
        v.add2log('@@@ Lookups Processing Started');
        
        if(v.rec.MD__c)
            v = ProcessLookups(v);
        
        v.add2log('@@@ Lookups Processing Completed');
        
        v.add2log('@@@ Transform Records Started');        
        for(sobject r : v.convrecs.values())
        {
            r = ProcessRecordTypes(v,r);
            if(savedmpr.containsKey(string.valueof(r.get('SAP_External_Id__c'))))
            {
                sobject rec = savedmpr.get(string.valueof(r.get('SAP_External_Id__c')));
                r.id = string.valueof(rec.get('id'));
                updrec.add(r);
            }
            else{
                // system.debug('@@@ '+(v.rec.MD__c?v.rec.PF__c:v.rec.PMT__c));
                //string fld = v.rec.MD__c?v.rec.PF__c:v.rec.PMT__c;
                insrec.add(r);
            }
        }
        
        v.add2log('@@@ Transform Records Completed'); 
        
        v.instotal = insrec.size();
        v.updtotal = updrec.size();
        
        
        insert insrec;
        update updrec;
        
        return v;
    }
    
    public ObjRecord InsertOnly(ObjRecord v)
    {
        if(v.rec.MD__c)
            v = ProcessLookups(v);
        
        for(sObject r : v.convrecs.values())
            r = ProcessRecordTypes(v,r);
        
        insert v.convrecs.values();
        
        v.instotal = v.convrecs.size();
        v.updtotal = 0;
        
        return v;
    }
    
    public sobject ProcessRecordTypes(ObjRecord v, sobject r)
    {
        
        if(v.rec.RT__c != null && v.rec.RT__c != '')
            r.put('RecordTypeId',v.rec.RT__c);
        
        return r;
    }
    
    public ObjRecord ProcessLookups(ObjRecord v)
    {
        v.add2log('@@@ Processing Lookups: Parent Field -- ' + v.rec.PF__c + '  Child Field -- ' + v.rec.CF__c);
        
        Map<string,sobject> mrecs = new Map<string,sobject>();
        
        Set<string> pids = new set<string>();
        
        for(sobject r : v.convrecs.values())
            pids.add(string.valueof(r.get(v.rec.pf__c)));
        string mqry;
        v.add2log('Record Type ' +v.rec.rt__c);
        /*if(v.rec.rt__c != '' && v.rec.rt__c!= null)
        {
            string rtv = v.rec.rt__c;
            mqry = 'Select Id, name from '+ v.rec.PO__c +' where Name in: pids';
        }
        else*/
            mqry = 'Select Id, name from '+ v.rec.PO__c +' where Name in: pids';
        
        v.add2log('Check for Parent Records Query: ' + mqry);
        
        for(sobject rr : Database.query(mqry))
            mrecs.put(string.valueof(rr.get('name')), rr);
        
        v.add2log('Parent Records ' + mrecs.size());
        v.skiptotal = 0;
        for(string k: v.convrecs.keyset())
        {
            sobject s = v.convrecs.get(k);
            if (!mrecs.containsKey(string.valueof(s.get(v.rec.PF__c))))
            {
                v.skiptotal++;
                v.convrecs.remove(k);
            }
            else
            {
                sobject parentrec = mrecs.get(string.valueof(s.get(v.rec.PF__c)));
                
                if(parentrec == null)
                {
                    if(v.rec.MD__c)
                    {
                        v.skiptotal++;
                        v.convrecs.remove(k);
                    }
                }
                else
                {
                    s.put(v.rec.cf__c,parentrec.id);
                }
            }
        }
        return v;
    }
    
  
    
    public JO_SAPSyncStats(string RID, string corpinfo,  string cDateinfo, string cdateinfoto,string cTimeinfo)
    {
        objs = new List<ObjRecord>();
        this.corpinfo = corpinfo;
        this.cDateinfo = cDateinfo;
        this.cTimeinfo = cTimeinfo;
        this.cDateinfoto = cdateinfoto;
        LoadSyncObjects();
    }   
    

    public void SyncProcessObjectsAsync()
    {
        for(ObjRecord v : objs)
        {
            string whereqry = '';
            
            v.rec.query__c = v.rec.query__c.replace('|', ' ');
            
            whereqry = ' where jobowner__c = \''+ mycorpid[0] +'\''   ;
            
            if(cDateinfo != null && cDateinfo != '') 
                whereqry = whereqry + ' and changedDate__c >= \''+ cDateinfo +'\''  ;
            
            if(cDateinfoto != null && cDateinfoto != '') 
                whereqry = whereqry + ' and changedDate__c <= \''+ cDateinfoto +'\'' ;
            
            if(cTimeinfo != null && ctimeinfo != '')
                whereqry = whereqry + ' and changedtime__c >= \''+ctimeinfo +'\'' ;
            if(v.rec.AC__c != '' && v.rec.AC__c != null)
                whereqry = whereqry +  ' ' + v.rec.AC__c;
            v.rec.query__c = v.rec.query__c + whereqry + ' limit 2000';

            //v.rec.query__c = 'Select DisplayURL, JobOwner__c, NotificationDesc__c, NotificationNum__c, NotificationType__c, Root_NotifNumber__c, Root_ObjNumber__c From PMNotifSet__x where jobowner__c in (\'JII1\') and changedDate__c >= \'20180124\'  and changedDate__c <= \'20180129\'  and changedtime__c >=\'000000\'  limit 2000';
            v.Add2Log(v.rec.query__c );
                
            SyncProcessObjectsAsync(RID, v.rec.Object__c, corpinfo, cDateinfo, cTimeinfo, cdateinfoto, cTimeinfo, v.rec.query__c );
            
            
        }
    }
    
    @future (callout=true)
    public static void SyncProcessObjectsAsync(string RID, string objname, string corpinfo, string cDateinfoFrom, string cTimeinfoFrom, string cdateinfoto,  string cTimeinfoTo, string dbquery)
    {
        List<sobject> resp = new List<sobject>(); 
        List<JO_SAP_Event__e> ls = new List<JO_SAP_Event__e>();

        try
        {
            system.debug('dbquery===>>>'+dbquery);
            resp = Database.query(dbquery);
            
            if(resp != null)
            {
          //      ls.add(new JO_SAP_Event__e(rid__C = RID, JO__c = corpinfo, SO__c = 'objname', SD__c = cDateinfoFrom, ST__C = cTimeinfoFrom, 
          //                                ED__c = cDateinfoto, ET__c = cTimeinfoTo, Status__c = 'OK', RC__c = resp.size()));
                // Call method to publish events
                List<Database.SaveResult> results = EventBus.publish(ls);
                
                // Inspect publishing result for each event
                for (Database.SaveResult sr : results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully published event.');
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error returned: ' +
                                         err.getStatusCode() +
                                         ' - ' +
                                         err.getMessage());
                        }
                    }       
                }
            }

            
        }
        catch(Exception ex)
        {
            
        }
        
    }
    
    public static List<Sobject> ProcessRecordsAsync(List<sobject> recs, string srcobj, string destobj)
    {
        Map<String,string> sn = new Map<string, string>();
        sn.put(srcobj, destobj);
        
/*        for(SAP_Sync_Mapping__c mp : v.rec.SAP_Sync_Mappings__r)
        {
            if(!mp.SN__c)
                sn.put(mp.SF__c, mp.DF__c);
        }
*/        
        Map<string,Sobject> convrecsasync = new Map<string,Sobject>();//
        
        try
        {
            for(Sobject r : recs)
            {
                string rec = JSON.serialize(r, true);
                for(string s : sn.keySet())
                {
                    rec =  rec.replace(s, sn.get(s));
                }
                
                Sobject trec = (Sobject)JSON.deserialize(rec,Type.forName(destobj));
                trec.id = null;
                convrecsasync.put(string.valueof(r.get('ExternalId')),trec);
            }
        }
        
        catch (Exception exc)
        {
            //v.msg = 'Error';
            system.debug('---- Exception While Processing ---- ' + exc.getMessage());
        }
            
        return convrecsasync.values();
    }
    
    
    
    
    
}