Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9318CC32796
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 17:03:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09FFA4D549;
	Wed, 24 Aug 2022 13:03:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ks3yzoCzvgPM; Wed, 24 Aug 2022 13:03:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ACFB4D54D;
	Wed, 24 Aug 2022 13:03:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9F54D538
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:03:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vpw32gMTvFVc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 13:03:39 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2082.outbound.protection.outlook.com [40.107.22.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5F7D4D548
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:03:39 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=N1cVEcvr3YW3cmn/pTN+8qKctC6XKhBpSgbmtCbspAvZS+ea1CtxRdyoZrVJQ+fCO9BakAKp7zD9Amv6g65rOyvTQJsZleK4XdD/trqHZ4q6Znig0GJfBBUUTK1v+mtlfDlD9HFpLSSoaKV7VPDhIiINtInFnHxxxA4SHEgqh0qMyFJOCsAKa+M1AYjuRr0rnM0ynHb1dyHIoyabmTk8Ll+9zBxl2x/PKE9cYhKR9vZdIAioFK93L3H9l3UtNzOkzSZYr/xci1W4sOkzuQXxIpUbiA3c2QaVgWoxh12LNbjZODs9oqeGuqBNlfmhZW+wy9clQzVhYfZtnh68N12n7A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=l7bPmvvUg2A8ieISpe7vACulbTInuxmFeLbeA1+rphNfUWfsJJSJ1bmqhCetLOt06Mkj+gbkNWQ8X29+hR8Kp41H70yyc0hM601M6rw/hwniQzayofPE6nAZgyJ+w5RH+y8CPBN0QNZdflV6/hb8MIbC1imDifTb6YAvcPDTLcMIxZ43rlh6w6fNnWMFy/HmkELM3X4fM+xDZD2ySx3/3VnH8EKw1hJAMld6ja33hK4GhcsIENQn6O+Mo9KXLPZ5Wn6KLjbc1mW7SKr/j4D9ackCgUC1E9aTLAn93qUfLXVnQ8jneFM930KXXJd7CRfzSeQg535qDeHqBw871otj4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
Received: from DB6P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:4:b8::14) by
 GV2PR08MB8679.eurprd08.prod.outlook.com (2603:10a6:150:b3::17) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Wed, 24 Aug 2022 17:03:34 +0000
Received: from DBAEUR03FT065.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:b8:cafe::64) by DB6P192CA0004.outlook.office365.com
 (2603:10a6:4:b8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 17:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT065.mail.protection.outlook.com (100.127.142.147) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 17:03:33 +0000
Received: ("Tessian outbound 63c09d5d38ac:v123");
 Wed, 24 Aug 2022 17:03:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: b84da0a500443880
X-CR-MTA-TID: 64aa7808
Received: from 95073a54352b.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 102F230D-1C71-4112-8E95-81DF39D91E61.1; 
 Wed, 24 Aug 2022 17:03:22 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 95073a54352b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 24 Aug 2022 17:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OySV66iRQUFC2HySUIKfGJS+KmVDtfrNMZlupcxIWDwu284/ecQGqp3JlmWHUl87j8L2FKTTiEA9Ac51keAQxfziLxjrPL3D9ZhY5Vp/x1cTqpc3AjCyXJtfQ1t1nkKb3kgSsednNLO2u7GgM+Z1ZBC6lyhrDhn7iy2LVltA6Fb/FrRrV8xXU/fw3Kk3p+SnRk4XW1+4CyUxvv3F8fC9/CCpmCwwjxRJmQRyZEnVWMEKt/fJsYBr0BRaaF4q6MWB3IiaNJ0zT7h4XasnWuvoKcLpjTVIXpeOcZYwNTipYOlGdtzUYqkASVID02cCP1Pstml+DXgm6zvFsh3hK0w/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=Ugh+jmB5c8pxYS+A1VnxgWYwZ+197U4B/gyM3UutxU4L9BvyT3UGoDYaRVvNviWCFJnni+uMKkGPTovQQhbQwAFUjJbfRJERWhpkHW86LPQpc3H0KauW128XQEFxfkozWHQlmfGLfO0++5rHYYIaZ5aTH85vqmUmWoQDutDWyI/PCMJrriqxDLj6HACB0c9cwbnlEIa2cvLP58URJbFpGRAwLxLZ2yXhFbYCOpN/orPuUr6AbYZvbVhmAoZWIx+pJrQiZl7QwsGQQH9gUNkNahpcr726dhKPAcxZ/6PVUHYYN7RW4qpmAiik9i3rmu61hsIVb8/4RCdDth0PF3tbhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM6PR08MB3029.eurprd08.prod.outlook.com (2603:10a6:209:48::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:03:21 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 17:03:21 +0000
Message-ID: <437ad644-a6f7-4b5e-ecb6-e8ddf4e4dc75@arm.com>
Date: Wed, 24 Aug 2022 18:03:17 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
 <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com> <87zgftra6e.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <87zgftra6e.wl-maz@kernel.org>
X-ClientProxiedBy: LO3P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::9) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 570591c3-36e9-4e2e-e6f7-08da85f2941a
X-MS-TrafficTypeDiagnostic: AM6PR08MB3029:EE_|DBAEUR03FT065:EE_|GV2PR08MB8679:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: mnXNg4j7/7IKN/PKwmwPJYjAtiOVoo2n3eRh7kORhw47/4psRfOHZZdcWyE8M9Q9liV6wqQj0ntxuZANPL/muKSyeP7qg2HODa3wLwW4bdbBKaQ+odzdWYhbPXp0pTPfFIZ7w1RaEIhq/pJGcUI8egYE7Eg1eX9jyfyswDHlqLsTb7gTuVtBMNTIdUVycmXa5eN5BcWtGYWuwS4Vop6T++RxxwV9FdXNs0yuhWFT9DtPoXQdslJ0bQpajLLIiuH70wA6xwmLLqCxUxkelvyLaV0lyfsE5u+uSbqMdrqA2H9EAST+Ye+26MW+7YCMFTd5CaWwa2Ahc3vNkRtl6PNwaseJP4yY33hb9cJgmlNOkOKvAL+9d3NN0ef/xnZ2mRrSCLEDA9R9cEs28J4ZFgUmAOIliqeBcaEWjXEJnjGUWi/8HsZRyhyjPA5BSPkOPmIpXZ37VhJIYIcJm1UdDQYuyuOv3IguSJxFQ6LWZd3j+bKVF3KLleXaCKmcJUK9ck+7Lh4mvYy646zW540cjQWLxhgR463jXqVDJSi6zJv9fidkJ755lI9mJXl7bf7opbPgpEvuiWo/QXtuObimrvD+ecvKCuCI71eewTt0XE0KITRUCxEhaLcYoAo2nAbHozvMkiKc9I9bez10/k1k6UoZLA2EeZGEZ4/vn/JAKq4wWNDI9VRZr+H2tCyTFJCBE1jlDpHcHABqqskdc1u4yPNSRUr0btiLg9ouEqEcN1DvgQhEJT5GQTkMqJNNRxfO88sY3vDs8zl/93mQqXAgPt/SR4zxFmXO+2R9xMGzX5IrgR0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(36756003)(6916009)(31686004)(54906003)(38100700002)(66476007)(66556008)(4326008)(66946007)(316002)(8676002)(186003)(5660300002)(7416002)(478600001)(6486002)(8936002)(53546011)(44832011)(2906002)(83380400001)(6512007)(26005)(6506007)(41300700001)(6666004)(31696002)(86362001)(2616005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3029
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT065.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8399f2c3-5317-4fa7-6316-08da85f28b96
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKrPMS4tg49qz+tWs8qcirs/t1OUWnhIJrP1j3bfY0NxydZth9kJ/LafF6eqKD8oo4FhEK9/56alRz7rbA5q5CJV0zPJeX3JmiDNqqlb/Uq63D9IYZflUF5PMomIrGX0Ac/HYpprUZTA8xKohwLC1BRL8BsGCKmimSLm26KUdgnOwzDiuCOFH6l8nuAOqK876luST5lYyD4YKqsY8I3rIpKWYG7u2ok5Zg233FvZXxpOS03yNXE7adjrXEIMB3NN0JhNGrljzjJGbdn64Yrxz/nU+bM8ppzfBDwAPKZVwzFp6neHQO4Wk/5qAfHEqloXXNrW2yDUHTzSaaakx0vGjtZj0vOse+QViDASBjOr4T/ABaVKaVE7Cot9s84YWsFBUaa2Lo+6iLQp5ez5NIUeUu0srCozs+Our+GMhVHbfLNO6fuFDHbsP2zFouov3VT5sUk4wet0MBISmulj5b9v+BG6eQIfp5aLzlyUn36KHwrbgaF8z3Lhp2k9ULwN2vYjhkDInxVS3pWmHh3PwFYlS3ESZj47GdzrMQ7RnUucxBUZlX7buEkQtagTySE6HyOEvReJAW6/4eYUjcT5h8yh6LpiZ0gh9QC6ScHKaMQQFcRK/xZOqcHoH+HMD/5ihjerkILmd8NT0iTrKPfISfygxj/yE/820tqfxIx9SUbDxFkZDXytbHlRRCtGXM4OcFShCdH25uLPS6WzH66G1QW9Xmea1Dy9SyFCYUsIXWsPWaKn1zoCZGvT37xIAoaexjhdndmk13kfXWvK3/kPzJHu+AEi26oCpSrjd3aNKHwpfGDRQWEXRuT3pky9fl/l0pDb
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(40470700004)(46966006)(336012)(186003)(82740400003)(47076005)(2616005)(82310400005)(31686004)(83380400001)(36756003)(316002)(54906003)(36860700001)(26005)(5660300002)(70586007)(70206006)(8676002)(53546011)(40460700003)(4326008)(6512007)(6506007)(478600001)(6862004)(86362001)(2906002)(31696002)(356005)(41300700001)(44832011)(40480700001)(81166007)(6486002)(8936002)(6666004)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 17:03:33.9561 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 570591c3-36e9-4e2e-e6f7-08da85f2941a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT065.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8679
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, nd@arm.com, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/08/2022 15:24, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 14:43:43 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>>> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
>>> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
>>> to give better visibility into the memory consumption of KVM mmu in a
>>> similar way to how normal user page tables are accounted.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>>> Reviewed-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>
>> I see that you are not including the memory reserved for the host
>> stage2 table when using protected KVM. Is this something worth adding?
>> (See arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).
>>
>> This reservation is done pretty early on in bootmem_init() so not sure
>> if this could cause some init ordering issues that might be tricky to
>> solve though.
> 
> I also don't see what this buys us. This memory can't be reclaimed,
> and is not part of KVM's job for the purpose of running guests, which
> is what this series is about.
> 
> If anything, it should be accounted separately.

OK fair enough. It just struck me from the patch description that the 
host stage2 might qualify as "pages used by KVM in arm64 for stage2 
mmu". But I don't have any understanding of the use case this is for.

Sorry for the noise!

Thanks,
Ryan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
