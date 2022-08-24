Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325BDC00140
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 13:44:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2584CF60;
	Wed, 24 Aug 2022 09:44:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j1MiROAvUAbF; Wed, 24 Aug 2022 09:44:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3034CF61;
	Wed, 24 Aug 2022 09:44:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06F384CF63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 09:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m3ksyMiLciGI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 09:44:03 -0400 (EDT)
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr00052.outbound.protection.outlook.com [40.107.0.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64BC24CF60
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 09:44:03 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=PJII+nts7BhrtBR5v3IlaPub1j++hZ3FOvUwUyd8zCi/835jT4zWh65By9NNFXpY5C3r6m4Mj03LmbAkoBl5ihvdmZrOAMkic+BAdW3QjyoVsMP5KmVdFCvHIkeAgnybGZru1qvjqCEfoFLE207FW5Z5dmBPYmUaP70coGuIjlgZuH8AnaA9Pwm9lSsk7HfYbZBT6s0Lw+LLdC7ArRPPO/b4SfEJHk8mhLvEYv/HywoUN2DWH1TI0w6Gg2RUQRDuiWZi2qjlg0eIWfIXgqM+bpG9IrUrll+qLwcZlKzGoQa891iCuuYL/eeMmuILubLRY1L3KwFre8EE1l9g8+J/VQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=XekOgSeeQS2M/RMNWq8TRYfDEaOEDLyXmyX+vbKXUD1IvKHVt9gW2DjZRI/P9ZdGgXd/W9hw4aIUmCpeOQIiYnqTzNQoBAKQa7jT3bGYXFamKSZ5dRJGEl2atFCoqXkTJa9dIAI15mT4xOIYaIOjHoD/KdYTlCmVxhBAmLm/eAJDSk9H2lElPSfLZisRRsO9J0gr04Km/p0qcZWGIqWBwHGeXGIO3N2U9OwjaPvoY6zzR5OFm+6IBf5e4uIoaPwB6LX1oJHLc5uwaRNzwj+yXyoabkdnUACooBA3MhvhEfRwLTPXU8fOxbVUSa0fVuXW3N/drT+rdQqld8q3CuilnA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
Received: from DB8PR06CA0023.eurprd06.prod.outlook.com (2603:10a6:10:100::36)
 by PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Wed, 24 Aug
 2022 13:43:59 +0000
Received: from DBAEUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:100:cafe::50) by DB8PR06CA0023.outlook.office365.com
 (2603:10a6:10:100::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 13:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT008.mail.protection.outlook.com (100.127.142.107) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 13:43:59 +0000
Received: ("Tessian outbound 2af316122c7a:v123");
 Wed, 24 Aug 2022 13:43:58 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8e4f0ce82f4219da
X-CR-MTA-TID: 64aa7808
Received: from 6219e544a6eb.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 2745645B-60D2-4855-8413-531A8A5ED5AE.1; 
 Wed, 24 Aug 2022 13:43:51 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6219e544a6eb.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 24 Aug 2022 13:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f37uPng9LYNB/D65AnwGi7GTzcpYVxXhZUjPkL9dcIiXF1J1WeUI6SKZiX80RIyXQ4f9VCa9Z4jAQI2wvl3JWbc/Zkf335MHe6UdtNWrDZjDqSXrhBQQVsnQ81MAGtmYO29qe8h2wZNP15eZd6C5svf/2q2UV+vHCUXAe/obKh7YFycDNN/v3iMSsqK9LRB+NLc5Ne0v0Kq9mzWpWYkK1c1j/8Y2qjpzwHzTfTjXGMbvO2y7krbYzP431B3kKkZaV9Z1v8e/+JanPwLn9biPGYyY7/EFrrANTRfGVGqHHfARUJFq4Ux6tCcuJ6rfPRr6WYfnr4RtAnpFsjLVoWaGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=oGOFwLaWN3Z/szBg1bXRPqddJFIFdNacAdkbsqFcl6g19whmuwDzF1+dBvkrPlOaZXKy7XRKTT5uxvHGHGRbHEgM4vXwF2Amx8yfAHJJ0QRTrlIJQv8wsg8vs6jj+ge0IIor+lMJ2SFvO5uCpPrRuVMdgU2UBe+laq3ve9a5KnsJLtcXCKbtW8WrEQaG2+1Y6iWJo/3B5ydSnwq4lUFjx1WkUENn3/97mMIEVKZZ6WME7xX78T+E0sv8h3jICT0N48MLg6hoFGnmT7ryqborznMiJLfBSYXDgLcE9taqp0sTJqgg8ZyxJCFjFSkhH0W8xz81CBXDbFhLCxKneMkyTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AS8PR08MB8371.eurprd08.prod.outlook.com (2603:10a6:20b:56a::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 13:43:50 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 13:43:50 +0000
Message-ID: <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com>
Date: Wed, 24 Aug 2022 14:43:43 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
Content-Language: en-US
In-Reply-To: <20220823004639.2387269-5-yosryahmed@google.com>
X-ClientProxiedBy: LO4P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::23) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 54604b0c-f39d-4194-f661-08da85d6b284
X-MS-TrafficTypeDiagnostic: AS8PR08MB8371:EE_|DBAEUR03FT008:EE_|PR3PR08MB5786:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OcHCa2e61BRfhsscsZd2nybAR3We5PpWjd2RSS1PJGQf6DLbk0CEzy/AHCuJ44e+Me9XyY2p9zxuMVBrPim+RA3je/dH21x03D3iY9JfRrTnbMDaLIzra0Oxn0yz/tdr4/NRyRZqv10dkO5+1yrS05Ai4Tq6fb0J98jkmkpEK8VIjJ7Ojy/LE23U+C3XPUwXQuOWsEqNoELU01qZAcI8p1VHhd/HiZfF0P74IkdmkLm89GE5rmwa3iyG+l4nWHbWRbAnYflepdykuzo59GMK4cgj7MJe5TkOwyiIgzh9+QD7v2B+PaoKQlwRfnr3YvlyRO6MBuFdiPq0bagtGRWd2HplzC1qbtoWvZ2rOAGasATvjYEtWkTT+m2xDBh86UHrVYT1rvGtdWRB4Q5CGV/aBgNvc1KmSAi6Be8/piPGsqlS2HQU/vuU3OFbjp8pJ3fuLeo6aIqi9TyKwNcxpWTwJ+ZgAuZXffH1wYyMpku3q3dqZvktmZ8j43ID5LuKb+YrMFWW3X7CfZZxHLtEUykaWlvjXEz94dLQgaxaevr2GpJZY9DO5I7BeMR1TtE/OSulbfMHiIzQoW0XDxdnExEvVLRP7GnVnZVSvcoaZNX6oFudhqIm4X6xKYCikcn4Oz17STTRFNMRIWYKr1kyoRiJPkpWYyJ0wvz0jmj+qiHF1hRCv2idtuouYcUaFjJyYzX6xDvLwRug3WsFDNixoyX0EaHW4IeZYf5sDDDNuYkvPxJTups6HpdtgAmoWIlgbDEbP9IM+AVRGeRFpKUk1yU4Pb+5qSkgUiIV2rEgZxd0qemlkClvByFU52+Le4NJbEve
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(7416002)(44832011)(86362001)(36756003)(66556008)(4744005)(31686004)(2906002)(66476007)(66946007)(316002)(41300700001)(6666004)(8936002)(110136005)(6506007)(5660300002)(478600001)(6512007)(6486002)(8676002)(26005)(2616005)(186003)(83380400001)(4326008)(921005)(38100700002)(31696002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8371
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT008.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: d8dca33e-7ff8-4320-2151-08da85d6ad01
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77GEn3dTaFxqmJ29gZOqGKWJ2sM1btiiVPyl7KJ2j5Gt1o9/2Ncu8SEGePUXsho2rGhAppMdfiTgwZo2Jj6mgDkuQzkBD6OdqpBCoj94HnXPlUvwok66eiakzvzmEqOI3HnACpijcSwq5nQHf+Rc90gtmugid3ZcAEKHfzGpnz8Yg5Cj0YHfZTso/P+EMTTM9KAE9li8UI3/PEnwVdp4PqugD86o0ifj6+uPYk9Kndp/n7TYLNys5Jzs4l+IpHZq2s3VwHBZKVCPtegJhQjrLNmmFmfX2Ove9Wsi0hfM6riFB6gmg1oR6GqzYAKhDSNF34bQ6aSapAZkgH4+azL4sEk8c9439IEHNrEkK3k5fk3PmV0cRrzbg38xQFXHAis66okhL45G8O8xiZZX1NwSICz6/Er3JbbOKin07K0I7++CgUfT/FmQ5MxFgzxkXMotO+t0nNekdJNKIMxuGKEvQrVjm2Ax1MZ/YMjUYfkM95BdsO2j9kIN2UWFAJvFfPed5tGGjp2/TD8AUbkFvdqOdF6uPa9aZfanJVaqET6+ycGOjbq+Vil5WzRKnGCryXOXtRl+Vb092oxTKw35GwvSSaOe2iy6QQp6Z1pK/hx97+N2P1JFRpRXR0CvteuOtkf3h85CSBhiX/mxEXq5fU9Yb/9qklmRPbdCn9L1NbkHk8M5wtO5402yRKAbXJnF5h4YgLP7xf+YZGCZBxGrH7XU3V3xnTeL/L1nspSwQdCVuaEhg5aAQHbQBlsBVXXZQEKIOm/dFjrgPljPZMwlM/I1YrWPTnFMA0NWz8YIzRvaFdQZ/HXZKS3qbL8TIbIbMycO
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(376002)(36840700001)(40470700004)(46966006)(83380400001)(186003)(336012)(36860700001)(2616005)(47076005)(110136005)(36756003)(31686004)(70206006)(4326008)(70586007)(8676002)(316002)(26005)(44832011)(2906002)(6512007)(4744005)(6506007)(40460700003)(31696002)(5660300002)(41300700001)(6486002)(8936002)(478600001)(82310400005)(40480700001)(6666004)(921005)(82740400003)(81166007)(356005)(86362001)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:43:59.0900 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54604b0c-f39d-4194-f661-08da85d6b284
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT008.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5786
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Shaoqin <shaoqin.huang@intel.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, nd@arm.com, Huang@google.com,
 linux-arm-kernel@lists.infradead.org
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

> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
> to give better visibility into the memory consumption of KVM mmu in a
> similar way to how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> ---

I see that you are not including the memory reserved for the host stage2 
table when using protected KVM. Is this something worth adding? (See 
arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).

This reservation is done pretty early on in bootmem_init() so not sure 
if this could cause some init ordering issues that might be tricky to 
solve though.

Thanks,
Ryan


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
