Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C60EC00140
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 17:40:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A434D60C;
	Wed, 24 Aug 2022 13:40:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9KFHjh6nHPEA; Wed, 24 Aug 2022 13:40:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30A484D610;
	Wed, 24 Aug 2022 13:40:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90A34D609
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qdfJaNfl6nw7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 13:40:39 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 399ED4D60E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:40:39 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=d2kiUOhrEHVnMnt91fUntzZyC2tcR92Sk0yAF4U04a5/6B7b9ykC3bHgNR9PeIzsD9c16XMJ6oIK5mP2NF943c+46fkTjqUAMV5gbgs8nMZ3Y7D8sQrAMojq5HJ+bAOkrVDSl3jqU9BMiDaQVM8ymBFKiblkLmCm4ZRubcngfYOmezn8MDzNiEv4gTBUzuChkSG7uiwY6Ot+EHnKbYKSwDGQ3PNNFrAFklaC8K2mkdy44+fPlwV+yPRFQduwb0HmuOUPgY/7H/BAcRRQ9HCQMQFFDer3HMOKhZaSoss7BuJgOPiHnFB0Nl9b08eBoDyjMqc750UnY7iiUve73eemZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=Oc8TZQyFzHMRX94uU2UMDFSsB0J7bUir4S4yFsiRM3ToO4j7wNMsIr52OhcLg5oQZC5VTC+HITDiqKUA6gifjdHxNTg0KY7zdLKRSb/+Unza/giash3/5uksr5E22JcJv2G8Ybjhke3aSvLQYxtyons1twJmJOoXTWINDthy7nPpttOJHHBNaeFtO6XFx15fbcd8BOrRiByZGuCxWUuLBdkVTV7Y0OO0AyPU7oPtUJL8RF55smPKTRkLhQ3xp13taj7zgQKx6plSiQlatulw/Q6tx1W/8bTW0o62MG9Yne9KczL4qKnZQZKSy1yEvZC1VXkR1TdBS0u1ahb2LND0Iw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=E8K3tfgYR16XXoMvgyl8eGf1mu6pJ2Vz9SP6C7nWdksjoSj7j732oqSL2Vj4CEU+rU+th9Ur/xboM3IftsX6vKHQKzNHZixk97Ndw3fPO+DBSRHe3gDhYXjaTWStxU+gZKMfmN51iZwyFrd8RetdBk7zmPObkn3sX7IDczlzJLM=
Received: from AM6P192CA0093.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::34)
 by HE1PR0802MB2300.eurprd08.prod.outlook.com (2603:10a6:3:c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 17:40:34 +0000
Received: from VE1EUR03FT032.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8d:cafe::60) by AM6P192CA0093.outlook.office365.com
 (2603:10a6:209:8d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 17:40:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT032.mail.protection.outlook.com (10.152.18.121) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 17:40:32 +0000
Received: ("Tessian outbound fa99bf31ee7d:v123");
 Wed, 24 Aug 2022 17:40:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 02f4580d91b07a39
X-CR-MTA-TID: 64aa7808
Received: from f1ec42e7c881.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 3F56B78B-D386-4307-B5DF-E9B104D80ED6.1; 
 Wed, 24 Aug 2022 17:40:20 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f1ec42e7c881.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 24 Aug 2022 17:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRBOlOmDwH3O7fbFwOcMejMebPsCsh4rDBsyhg1z+X7oXGu07BA9cHk/JQcj2WdJ5nDhKhX+ivXnztT7aX1xy2Q6mWYgwwFg/UOfsBKeeyWvetS+c1Vww3gJ4yqrzbB2HJHIO359JkayWA+Wya7q1mFx3ryzAH9tsCbOUyxlMCU8bet3zmL0Tk7hfY8JHn90CPG5wvtskxrdG3U7nScoKmhkoFq8uQjnnIKVA4hyZtbM+MCPLaD3qoNWk5HEujoutlXy49JNdozlkPjDCiBT5aEtsJc8qrXY4WmQpfx9cL9KlrfFmyEgPDeJnZyZ+6X/hFDUTe+duG++W+81rpky0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=YqaKnTu6Q0CONrNktIpGGi/fKlIxeFj5SMvWhR0Neyk97oFjmZRKrRqPJfZY0Gzf+OIz6ErL1lAgkE9Dsa+Vut7HG9TO7kror2SAAJoShPzFDmyau1HESKQVztK0BQq8jTZRR4hEGvytzPtye7XDJ2BKDOGlUhcmxhOABnuFKiJWAD9KDvin90c+LMFfkt0NSvrZ9nTPzADR+ca7o48/YhAtDjXPxpjlGOkhdysEXZpQqoISx1FFesRTY9k4BTqt0cUHKMB8KT80Xg4Ul+LhVXSmZjN5i4FlQsgfjg9NMSZ6GS3FC160S4wJDznWXbhPLtev6m+JXnTfoa2Kx2EhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=E8K3tfgYR16XXoMvgyl8eGf1mu6pJ2Vz9SP6C7nWdksjoSj7j732oqSL2Vj4CEU+rU+th9Ur/xboM3IftsX6vKHQKzNHZixk97Ndw3fPO+DBSRHe3gDhYXjaTWStxU+gZKMfmN51iZwyFrd8RetdBk7zmPObkn3sX7IDczlzJLM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM9PR08MB6997.eurprd08.prod.outlook.com (2603:10a6:20b:418::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:40:17 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 17:40:17 +0000
Message-ID: <69b50235-b77d-5310-2cc6-040f936b8864@arm.com>
Date: Wed, 24 Aug 2022 18:40:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Content-Language: en-US
To: Yosry Ahmed <yosryahmed@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-2-yosryahmed@google.com>
 <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
 <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
X-ClientProxiedBy: LO6P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::17) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: c148d09b-d9d7-4c47-db8a-08da85f7bed0
X-MS-TrafficTypeDiagnostic: AM9PR08MB6997:EE_|VE1EUR03FT032:EE_|HE1PR0802MB2300:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 7G6m6EeEYKRlZaosUmCJht9vP9OlW5WbdQ3sai/Bhhh1YH0P8E4JGYPVm0ogJom5ZuaHPLXsWtcZ0mdsswl8IwV1awGTP5KzORs3kz4T2C8/E3lsjFQmvYD8o0ksdQAO7kNWMb4U9ayGEBdg6aAklUUtPza2plHxn2IRoLU03vYdXgHYHY8mLuFy/E31pew0WGBDtOo1phOhh/LjD5Otkc7Hv0IiLccWcAfQCQeFuTTyUSn0Pjvl1BmNT+PwibmzXdY5mZLD8q9Rpk+EsOw4QwBLqxcex813xEUWb4B0KU4eF8KJtO9bsC12v8sg99sv/tMhMt7kTBXjxVzupd8llzr39orYVLHta/65/nAE1fisDADLlzpn90lWaXLdRwHcA9OSV8mEcR0oSgaZ0aF6XrvWDpJbDCgpL2AMds3Ynrs0JQLHVU/TWr8ujLRO/wmtMYsOc3APLbv6hrEilHJH7H/4lA28bFUacOlFwt10R0gzfcmdmppjsUQgOTvwOV/3FG7X6HT9OyKK7EMFefd7IPmwPLrddaPtnJW7wgLVWVhwJ8FIrCdu+d7NO7vWgLZxlRAMWCl1bKh1YbXsGr8zmb25Z8wS0/5LTyPN+v2D7djlgNmIKthAvE+gJeQcAkfK6ZEHQUaOvqOmjxvUJFp8HKH3qpu/+6VWgLICF17SCN0O9w9II+fQDXdZ0aPvTDYdvJmbS+u09NOpl04ORJ1j3lvNb5kOFR6oCfDj6gOHInb0K0K8Jj9bwkG6dI8NiukgUDcM20wOp2FYot3INvSYK+qdByoLZM/M771XsA+F3r0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(6916009)(2616005)(316002)(41300700001)(83380400001)(44832011)(36756003)(38100700002)(31686004)(186003)(54906003)(8676002)(66556008)(66946007)(4326008)(478600001)(6506007)(6666004)(53546011)(31696002)(2906002)(7416002)(5660300002)(66476007)(6512007)(6486002)(26005)(86362001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6997
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: b1ae2a65-6c02-492f-cec1-08da85f7b489
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hilBFbK8XmZlN8bKt7FcqYqYBJNNLtSXkrf6nRlXg8MSgH8rHKUlae+CdZrZe6A9MAXTk1xdVPqQMlgHfgEYJst5LJ/cDBw8ymFy64o4u8s6rkJoGOKx0jJZEmE/b53jSxUKqZhWkAFpsRD/o3JuXPnzghCNI4ICkq6zMnjMGNdsRrltNFPsAbteYYW/9h4OnoXo2JMzFz+Uq79iHvdYoVRFTzWvO1zKxltLBgXTWtZ1sBT1lGn76BsfRamYrgeTbj8WoGi2Z+Dt6sGBY+r91xp5j3P4ojQU3lfknZ9e4+gLQAHIyS8gXfCrN6+EH+Y8p8XAKvMxDpV4hAdsBZLxQEBnRVnxXoaevSfIlAR8XzIdxX6MXGnaHhIvfT/gnFeOTrnohqeVF3Qzd1TbYnuBmdGtntIDGir1DXtBIxVP8rCadunqM2DA1tK3ew9kr57TuR6YsVxn5+Cci+asAtmGCFfMVCGxOid9s7iklQD6F7SuQ1CpCPux9b4imEMIiHXaBvqYypQilMrzDMtWPpRpyL4KuAAn561Hg+GlJ7fW2O0M7SGrDkS6dPIkCVGTrEQCBuVEcRXo64fW2f1sXkbRzY1pMY2zGNWkRd6OfYinpMqmeeUxz3ZrEpUk8gIXDjOR1zr7aIwp/u/7WxfPe7keRsbKuw904L8Nno/T/AUMfjuI8Ho8ZbfIse8h4qB2QGo21PMhG5HtbU4Mo2kdVAQT2MltvT9ehNV2Uy7t4g70goVSpJKdV+5BQs8okL9rCC5nAWgntFZzTXT3KMiuFOBCyKEvfNlq77D0lqwXl6zBevJDszwxJKepoA87rwvAE9sC
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(40470700004)(36840700001)(46966006)(36860700001)(36756003)(82740400003)(316002)(4326008)(70206006)(8676002)(70586007)(81166007)(31696002)(356005)(86362001)(31686004)(53546011)(6486002)(83380400001)(2616005)(41300700001)(186003)(336012)(26005)(6506007)(6512007)(478600001)(6666004)(40460700003)(54906003)(40480700001)(82310400005)(2906002)(5660300002)(47076005)(8936002)(44832011)(6862004)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 17:40:32.9993 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c148d09b-d9d7-4c47-db8a-08da85f7bed0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2300
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 nd@arm.com, Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 24/08/2022 18:25, Yosry Ahmed wrote:
> On Wed, Aug 24, 2022 at 6:42 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index e7aafc82be99..898c99eae8e4 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
>>>        SUnreclaim:       142336 kB
>>>        KernelStack:       11168 kB
>>>        PageTables:        20540 kB
>>> +    SecPageTables:         0 kB
>>>        NFS_Unstable:          0 kB
>>>        Bounce:                0 kB
>>>        WritebackTmp:          0 kB
>>> @@ -1090,6 +1091,9 @@ KernelStack
>>>                  Memory consumed by the kernel stacks of all tasks
>>>    PageTables
>>>                  Memory consumed by userspace page tables
>>> +SecPageTables
>>> +              Memory consumed by secondary page tables, this currently
>>> +              currently includes KVM mmu allocations on x86 and arm64.
>>
>> nit: I think you have a typo here: "currently currently".
> 
> Sorry I missed this, thanks for catching it. The below diff fixes it
> (let me know if I need to send v8 for this, hopefully not).
> 
> diff --git a/Documentation/filesystems/proc.rst
> b/Documentation/filesystems/proc.rst
> index 898c99eae8e4..0b3778ec12e1 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1093,7 +1093,7 @@ PageTables
>                 Memory consumed by userspace page tables
>   SecPageTables
>                 Memory consumed by secondary page tables, this currently
> -              currently includes KVM mmu allocations on x86 and arm64.
> +              includes KVM mmu allocations on x86 and arm64.
>   NFS_Unstable
>                 Always zero. Previous counted pages which had been written to
>                 the server, but has not been committed to stable storage.
> 

Looks good to me!


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
