Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2047.outbound.protection.outlook.com [40.107.15.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294228E8;
	Fri, 27 Jan 2023 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56/lKCkSiHldxUIJBMrupbV1OugMXonZlhRBD5cbYcE=;
 b=9LY6plYWKSh/82BC07QEL2ycrCoUkapc46QAtcrsEft1TcdVyBK+5umrks5wrvCT48tpZrLw+hdU7Z+Ce2f/8UO8lW/6sdyVxFagbc9FLVORTmi5WXfF0YLkVMiI8ejEDZ6C8PSLHK8bh4LbmoDjj7XHndh0nR6FNrlNqZVWeYY=
Received: from AM6P191CA0013.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::26)
 by AS2PR08MB10126.eurprd08.prod.outlook.com (2603:10a6:20b:645::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:27 +0000
Received: from AM7EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8b:cafe::4c) by AM6P191CA0013.outlook.office365.com
 (2603:10a6:209:8b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT026.mail.protection.outlook.com (100.127.140.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:41:27 +0000
Received: ("Tessian outbound b1d3ffe56e73:v132"); Fri, 27 Jan 2023 11:41:27 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c1cc763f54560914
X-CR-MTA-TID: 64aa7808
Received: from 2f9e885a9eaf.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B66F0FD0-069A-443F-946C-860CFA1AFD85.1;
	Fri, 27 Jan 2023 11:41:20 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2f9e885a9eaf.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu9LFkrfId+1Beq6OyiCKbqQBkgVscVVHO/F3s2pHvHIjHQIJNqeG/ATZOBlrWiMjl7tgrhCS66ehM3XvyT34Qhe256DTo9QYeHyhyYevMsbkDCXnmHoEf/W9oQUPifoCvMtwwQsCPF9g0Ge8juFYlj4q1/JRHhqPLC89NyOIm7a6BSnMIpez/MmJYsQA0nqXgBOMfl8Q4K0A/nun0dDyBKBLqJO+vAYckCYtZSQqNr9N5a2xsSiYsOMzGUreLgatCwBuf1K1cMJge+goP288hePGLg8klB6UpSUOBtnE40ViujHCvSWzNLPtnxH8o5Hmq3oc9muGfDiPkju317jfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56/lKCkSiHldxUIJBMrupbV1OugMXonZlhRBD5cbYcE=;
 b=ew7g//1Gr4HSGu0hcrenB4d0zfcv//L1ADSMTLq3D3LMfFltLyrxhAW8SwbCEAw1hG8/Vb3XirTHmOxyl28OwwO6YBtAP5D//PRPXiCMwrJ44B6257r7EI/bqxifqzASbKeH76ww8URcQMLpp8OCHkDcaKUbwjT9KHuJqut0PHml16/7V3ftO8SQHo3K4eV1WCofm+E2aSV1MCqGpOmZtcWzOFfdmH4GOwTghuP2SRD0hmZIYq5u0xPN5Dmxof/FQf77dy+ih+HIlTJC/ZixSseDVGI6fUeClgpLR4kuZknI3izCS6HsRoqwnc8mmRb1yv2KeFfXLMcRDydsY8uEQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56/lKCkSiHldxUIJBMrupbV1OugMXonZlhRBD5cbYcE=;
 b=9LY6plYWKSh/82BC07QEL2ycrCoUkapc46QAtcrsEft1TcdVyBK+5umrks5wrvCT48tpZrLw+hdU7Z+Ce2f/8UO8lW/6sdyVxFagbc9FLVORTmi5WXfF0YLkVMiI8ejEDZ6C8PSLHK8bh4LbmoDjj7XHndh0nR6FNrlNqZVWeYY=
Received: from DU2PR04CA0281.eurprd04.prod.outlook.com (2603:10a6:10:28c::16)
 by AS8PR08MB6741.eurprd08.prod.outlook.com (2603:10a6:20b:353::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:18 +0000
Received: from DBAEUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:28c:cafe::ac) by DU2PR04CA0281.outlook.office365.com
 (2603:10a6:10:28c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT048.mail.protection.outlook.com (100.127.142.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:41:17 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:16 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:10 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>
CC: <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joey Gouly
	<Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
	<pbonzini@redhat.com>, Quentin Perret <qperret@google.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Thomas
 Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 00/27] Support for Arm Confidential Compute Architecture
Date: Fri, 27 Jan 2023 11:40:41 +0000
Message-ID: <20230127114108.10025-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	DBAEUR03FT048:EE_|AS8PR08MB6741:EE_|AM7EUR03FT026:EE_|AS2PR08MB10126:EE_
X-MS-Office365-Filtering-Correlation-Id: c74bf676-f482-401d-11e5-08db005b6d1c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 API9IaH3m1qTQXgpRlXs061xJnMcQRU2vEmuRbcpSW8g0dB+cuVYvGSRii2MRu+BhdUBmDUwGqiHDFHeCUBelWR5Hs6jTYHPKPCJuFBgsTsjGpy2EnfA4NbBhxVflusnibGlx5klQjeL3gM2KPgUgtGXi56bQMNdYPz8AJk87cdJ33ggG79Vk2/4TTqHq1OPx4gmPO+sMjgLgJSaHKWEmEg7uuffwLN3UKF/2B4TZniQSHCt9Tl22ZM7uAbN+6ybrYMZtwlkeeIsocSMkcO/47Rb+xq4qggAJDuNZHuC6rioa4KIw+yLEVwYwtWLaWGsPdUxxPFMqezFrChj72fALPHEH4mIWF/NlrCKfy8hU994bmprDt5we28ly2UmqO1UWPGSGXW37NmGrWVdgo2WH6VkkwDiyhyxQksX+oPpR/s6fA95t7BRfKcvqVR+Nlr61SbYS422nUcKcgpbplQTS68Z4CTMa7a8Vwg9PL0HGz7elB4vQXM0fZS/zNVKQKn1/XhdrhOdBN6twpv5CIt87rimz+m3Uqgy9TLYYkZ8ZGiBVokOIjexUTBdJdJWvDTeHuvJvFDLdF2DIBKI5XBeAlyMUkDOhFDuDZby8gWY8J2cep+L5QATGB0DQXOgfG3jV/7Jdhzz2dexqmOyQ3pFS2H8qNQiVwLMlJ2Z9umDgzzJnX+N9Zb8FJLWzJ9durY1J10tpTJiAribRfRQjURLB2f3/kmmgUkLdmUn7TLYikIPuiyCHSHcnzeCzi4qOwiwTFwus/9bSn2Qrcq7ogwDvEx+Hhh9YdRK0VonITR2EEj4Eg6U+kXxlzhhkwJWfy/NH3zU4easA1tHkkzYyWnQXg==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(966005)(478600001)(66899018)(7696005)(316002)(6666004)(54906003)(110136005)(2906002)(26005)(5660300002)(1076003)(36756003)(7416002)(2616005)(426003)(40480700001)(83380400001)(336012)(86362001)(82310400005)(186003)(47076005)(44832011)(81166007)(8676002)(356005)(8936002)(70586007)(41300700001)(40460700003)(70206006)(4326008)(36860700001)(82740400003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6741
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9c5afeea-ffe7-45b2-da7e-08db005b66db
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uwoqM3vtuPgfBj3BZrp8MER1lhbg8sRujOyR4Tb9TVjUhlujXUL1+z4Mt/pg8KongtMHn6laRc1MMXKsw3IWr/7gUF11ABPxFRrrNQCnZU0N3Ew9ksERqxPCD5moWlqET1z2m+us7fI3RDV486FyORIQ5rzWt6V37Cy7z9465hWZSxrrRpr9AFQprU81UYZUHqLXGL6Bn6LdE62pJYUCCYE3n7TD+qeOD0KKV9szEtdjl+3O1HIBZtVjj2bE4CgA0hNxtLV3bim5Cg/WSYrvsBv/smJF+qEiS8fsxYvpxj+ZvG49HDMOb9paFDvwParBaAAEzpfDtCXmpF2NWoVGrWcwi9EqooUvrRFwCxNFysU/c4HojSGnhVbQCTuy/ALebUYf5U96LuTTrHPIsP4MAPR4a2zqxvKB9gX+z5Q9VD1DyqUe8qIDTlbvxSrVA12+YsaKA7q+gMCnq1O705qwfQL5HlFQHP7e3bLVHK2EMWbADfMsntvUSWto1XIZit4aHgRl8YAjEWFQcAWq13fAaxfiLpWY55YKRVQrd1FiY6tMM2d96J/BIMpT+/jBkt7L6teX3rjEeCoP2+gWImz+YSu2EtN3xSAfDmszDVWtwVaPVAi9SbVaoedcmmtlu+x2AOqp6zlAegLbm3ZWheXMa2izdccWRku4xUkqxZPUrOVBKwjvHaUK3TvVQp6o1atdFYvDmVMZH49T3Mc2PErZ4UV9rMyb0XoPJ1cy5vbETmV6Ky2oTOgSm3Iy7+iTcwQfIholLoNlZI6fGt0YHzov2GVCikNA9FcoXoaREEtCROg=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(44832011)(40480700001)(2906002)(36756003)(82310400005)(83380400001)(426003)(47076005)(54906003)(6666004)(110136005)(107886003)(7696005)(966005)(26005)(70586007)(1076003)(478600001)(450100002)(2616005)(336012)(186003)(86362001)(70206006)(8676002)(81166007)(8936002)(4326008)(41300700001)(5660300002)(316002)(36860700001)(82740400003)(66899018)(40460700003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:27.4543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c74bf676-f482-401d-11e5-08db005b6d1c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10126

This series adds support for running the kvm-unit-tests in the Arm CCA reference
software architecture. See more details on Arm CCA and how to build/run the     
entire stack here [0].                                                          
                                                                                
This involves enlightening the boot/setup code with the Realm Service Interface 
(RSI). The series also includes new test cases that exercise the RSI calls.     
                                                                                
Currently we only support "kvmtool" as the VMM for running Realms. There was    
an attempt to add support for running the test scripts using with kvmtool here [1],
which hasn't progressed. It would be good to have that resolved, so that we can 
run all the tests without manually specifying the commandlines for each run.    
For the purposes of running the Realm specific tests, we have added a "temporary"
script "run-realm-tests" until the kvmtool support is added. We do not expect   
this to be merged.                                                              
                                                                                
                                                                                
Base Realm Support                                                              
-------------------                                                             
                                                                                
Realm IPA Space                                                                 
---------------                                                                 
When running on in Realm world, the (Guest) Physical Address - aka Intermediate 
Physical Address (IPA) in Arm terminology - space of the VM is split into two halves,
protected (lower half) and un-protected (upper half). A protected IPA will      
always map pages in the "realm world" and  the contents are not accessible to   
the host. An unprotected IPA on the other hand can be mapped to page in the     
"normal world" and thus shared with the host. All host emulated MMIO ranges must
be in unprotected IPA space.                                                    
                                                                                
Realm can query the Realm Management Monitor for the configuration via RSI call 
(RSI_REALM_CONFIG) and identify the "boundary" of the "IPA" split.              
                                                                                
As far as the hyp/VMM is concerned, there is only one "IPA space" (the lower    
half) of memory map. The "upper half" is "unprotected alias" of the memory map. 
                                                                                
In the guest, this is achieved by "treating the MSB (1 << (IPA_WIDTH - 1))" as  
a protection attribute (PTE_NS_SHARED), where the Realm applies this to any     
address, it thinks is acccessed/managed by host (e.g., MMIO, shared pages).     
Given that this is runtime variable (but fixed for a given Realm), uses a       
variable to track the value.                                                    
                                                                                
All I/O regions are marked as "shared". Care is taken to ensure I/O access (uart)
with MMU off uses the "Unprotected Physical address".                           
                                                                                
                                                                                
Realm IPA State                                                                 
---------------                                                                 
Additionally, each page (4K) in the protected IPA space has a state associated  
(Realm IPA State - RIPAS) with it. It is either of :                            
   RIPAS_EMPTY                                                                  
   RIPAS_RAM                                                                    
                                                                                
Any IPA backed by RAM, must be marked as RIPAS_RAM before an access is made to  
it. The hypervisor/VMM does this for the initial image loaded into the Realm    
memory before the Realm starts execution. Given the kvm-unit-test flat files do 
not contain a metadata header (e.g., like the arm64 Linux kernel Image),        
indicating the "actual image size in memory", the VMM cannot transition the     
area towards the end of the image (e.g., bss, stack) which are accessed very    
early during boot. Thus the early boot assembly code will mark the area upto    
the stack as RAM.                                                               
                                                                                
Once we land in the C code, we mark target relocation area for FDT and          
initrd as RIPAS_RAM. At this point, we can scan the FDT and mark all RAM memory 
blocks as RIPAS_RAM.                                                            
                                                                                
TODO: It would be good to add an image header to the flat files indicating the  
size, which can take the burden off doing the early assembly boot code RSI calls.
                                                                                
Shared Memory support                                                           
---------------------                                                           
Given the "default" memory of a VM is not accessible to host, we add new page   
alloc/free routines for "memory shared" with the host. e.g., GICv3-ITS must use 
shared pages for ITS emulation.                                                 
                                                                                
RSI Test suites                                                                 
--------------                                                                  
There are new testcases added to exercise the RSI interfaces and the RMM flows. 
                                                                                
Attestation and measurement services related RSI tests require parsing tokens   
and claims returned by the RMM. This is achieved with the help of QCBOR library 
[2], which is added as a submodule to the project. We have also added a wrapper 
library - libtokenverifier - around the QCBOR to parse the tokens according to  
the RMM specifications.                                                         
                                                                                
The patches are also available here:                                           
                                                                                
 https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/rfc-v1                     
                                                                                
                                                                                
 [0] https://lore.kernel.org/all/20230127112248.136810-1-suzuki.poulose@arm.com/
 [1] https://lkml.kernel.org/r/20210702163122.96110-1-alexandru.elisei@arm.com  
 [2] https://github.com/laurencelundblade/QCBOR   

Thanks,
Joey

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joey Gouly <Joey.Gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-coco@lists.linux.dev
Cc: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org

Alexandru Elisei (3):
  arm: Expand SMCCC arguments and return values
  arm: selftest: realm: skip pabt test when running in a realm
  NOT-FOR-MERGING: add run-realm-tests

Djordje Kovacevic (1):
  arm: realm: Add tests for in realm SEA

Gareth Stockwell (1):
  arm: realm: add hvc and RSI_HOST_CALL tests

Jean-Philippe Brucker (1):
  arm: Move io_init after vm initialization

Joey Gouly (9):
  lib/string: include stddef.h for size_t
  arm: realm: Add RSI interface header
  arm: Make physical address mask dynamic
  arm: Introduce NS_SHARED PTE attribute
  arm: realm: Make uart available before MMU is enabled
  arm: realm: Realm initialisation
  arm: realm: Add support for changing the state of memory
  arm: realm: Add RSI version test
  lib/alloc_page: Add shared page allocation support

Mate Toth-Pal (2):
  arm: Add a library to verify tokens using the QCBOR library
  arm: realm: Add Realm attestation tests

Subhasish Ghosh (1):
  arm: realm: Add test for FPU/SIMD context save/restore

Suzuki K Poulose (9):
  arm: realm: Set RIPAS state for RAM
  arm: realm: Early memory setup
  arm: gic-v3-its: Use shared pages wherever needed
  arm: realm: Enable memory encryption
  qcbor: Add QCBOR as a submodule
  arm: Add build steps for QCBOR library
  arm: realm: add RSI interface for attestation measurements
  arm: realm: Add helpers to decode RSI return codes
  arm: realm: Add a test for shared memory

 .gitmodules                         |    3 +
 arm/Makefile.arm64                  |   17 +-
 arm/Makefile.common                 |    1 +
 arm/cstart.S                        |   49 +-
 arm/cstart64.S                      |  123 ++-
 arm/realm-attest.c                  | 1125 +++++++++++++++++++++++++++
 arm/realm-fpu.c                     |  242 ++++++
 arm/realm-ns-memory.c               |   86 ++
 arm/realm-rsi.c                     |  157 ++++
 arm/realm-sea.c                     |  143 ++++
 arm/run-realm-tests                 |   56 ++
 arm/selftest.c                      |    9 +-
 arm/unittests.cfg                   |   94 +++
 lib/alloc_page.c                    |   34 +-
 lib/alloc_page.h                    |   24 +
 lib/arm/asm/arm-smccc.h             |   44 ++
 lib/arm/asm/psci.h                  |   13 +-
 lib/arm/asm/rsi.h                   |   16 +
 lib/arm/gic-v3.c                    |    6 +-
 lib/arm/io.c                        |   24 +-
 lib/arm/mmu.c                       |   73 +-
 lib/arm/psci.c                      |   19 +-
 lib/arm/setup.c                     |   17 +-
 lib/arm64/asm/arm-smccc.h           |    6 +
 lib/arm64/asm/io.h                  |    6 +
 lib/arm64/asm/pgtable-hwdef.h       |    6 -
 lib/arm64/asm/pgtable.h             |   20 +
 lib/arm64/asm/processor.h           |    8 +
 lib/arm64/asm/rsi.h                 |   84 ++
 lib/arm64/asm/smc-rsi.h             |  139 ++++
 lib/arm64/gic-v3-its.c              |    6 +-
 lib/arm64/rsi.c                     |  143 ++++
 lib/libcflat.h                      |    1 +
 lib/qcbor                           |    1 +
 lib/string.h                        |    2 +
 lib/token_verifier/attest_defines.h |   50 ++
 lib/token_verifier/token_dumper.c   |  158 ++++
 lib/token_verifier/token_dumper.h   |   15 +
 lib/token_verifier/token_verifier.c |  591 ++++++++++++++
 lib/token_verifier/token_verifier.h |   77 ++
 40 files changed, 3640 insertions(+), 48 deletions(-)
 create mode 100644 .gitmodules
 create mode 100644 arm/realm-attest.c
 create mode 100644 arm/realm-fpu.c
 create mode 100644 arm/realm-ns-memory.c
 create mode 100644 arm/realm-rsi.c
 create mode 100644 arm/realm-sea.c
 create mode 100755 arm/run-realm-tests
 create mode 100644 lib/arm/asm/arm-smccc.h
 create mode 100644 lib/arm/asm/rsi.h
 create mode 100644 lib/arm64/asm/arm-smccc.h
 create mode 100644 lib/arm64/asm/rsi.h
 create mode 100644 lib/arm64/asm/smc-rsi.h
 create mode 100644 lib/arm64/rsi.c
 create mode 160000 lib/qcbor
 create mode 100644 lib/token_verifier/attest_defines.h
 create mode 100644 lib/token_verifier/token_dumper.c
 create mode 100644 lib/token_verifier/token_dumper.h
 create mode 100644 lib/token_verifier/token_verifier.c
 create mode 100644 lib/token_verifier/token_verifier.h

-- 
2.17.1

