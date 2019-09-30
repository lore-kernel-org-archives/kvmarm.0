Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC36C32792
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 15:16:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC9D220640
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 15:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="2g+wvguj";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="CF4qXhGU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC9D220640
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 380644A6FB;
	Mon, 30 Sep 2019 11:16:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nutE1SYi14Py; Mon, 30 Sep 2019 11:16:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D969D4A69B;
	Mon, 30 Sep 2019 11:16:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E59BB4A69B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 11:16:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VgBhPzsTjPdW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 11:16:04 -0400 (EDT)
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40044.outbound.protection.outlook.com [40.107.4.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25CE74A65D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 11:16:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l6b0DWo8g+GFqaYF/9RVXpBY/aMzX+Q0+L24G8HuwU=;
 b=2g+wvgujA+dxudEHU6L1zWuVN+w2w4oH/8sqjBei89yVlJlCGnZVH1F2z7UMaYHTeAgUL1xVuCfizAjDUadl72CzbGJS6VHX/6ZKMhQP7llEc9EeAk/8rYByxB4E/iIN+ixEND0EbAcDXcTOOV875oMjjyEAkzkWfKddXDGlIj8=
Received: from VI1PR08CA0124.eurprd08.prod.outlook.com (2603:10a6:800:d4::26)
 by HE1PR0802MB2331.eurprd08.prod.outlook.com (2603:10a6:3:c1::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2305.20; Mon, 30 Sep
 2019 15:16:00 +0000
Received: from DB5EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::202) by VI1PR08CA0124.outlook.office365.com
 (2603:10a6:800:d4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.15 via Frontend
 Transport; Mon, 30 Sep 2019 15:16:00 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT058.mail.protection.outlook.com (10.152.20.255) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Mon, 30 Sep 2019 15:15:59 +0000
Received: ("Tessian outbound e4042aced47b:v33");
 Mon, 30 Sep 2019 15:15:58 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2a299e50669ee4c2
X-CR-MTA-TID: 64aa7808
Received: from 9e0d70fd4ff7.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.12.53]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 E085D8AF-A32B-4176-B94E-771331C03BAE.1; 
 Mon, 30 Sep 2019 15:15:53 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9e0d70fd4ff7.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Mon, 30 Sep 2019 15:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm9hKGs+5njsQTWmd9UMCdoEStrnmMBnbgn8ELs19tOW2HeUYaY3d6jdiEW6b+7vZPtO/sviP2zRxODFnoMDHzFGezPPsFNlAEodqRy/hmE2wqN0F10VR//NNHhcPdVqYJn8mPeaBb0Xl4RQpzj2/bVTeVbwsRQno9vU2LmA3NCF9+rz9tXF2QSmbbM4n9878cqBb7/mEPafvEldqqqdw3LyTcTBkJAPMjIW8zjh2ZLSXew7G/fKK6ZuQsk4zQKCOwEVY3CdR5VGNi4xKY5G8q2T03E7k2b6hn5CiGmi3Qde4p7tmSHq4FzT5RkqVUPD5avxU0ng3O6wQSyKMJwFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=289Nt+lUfQpT+KpTbd8iRw4J3QI1jg/VdfTBK5osgzA=;
 b=KpMR6837dQ/rvF0/tdLSsm4WbytqQrUbbDs/cfoNQVhsi3S5uVoxQXNXcTgl+d+wqwPetn7T557fT1EqZJPbzb+pW+RrkrWTFV9o3NK63Og+YS7MfVCqt4NcxKcJ4gnm3kPyaT7eSHr//7HflvkgUm+An5yQ6oBiih92yXBj8PxoEFxgbLG/zfbTpSNZNWtEKeQPuYZnQrOdQu4xvL4Dtz12byfTQ0KEQAnKS1msd7zUb407jsFgtIBa4WmTCup0zZLcSiW3I1PWlhZJ+n5sfYxKuOwM9Ln2w31eH1zLZ250PnqW+j2QvKTh0jMhMZD9uNsQNU2yz9iqMhuZRAzkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=289Nt+lUfQpT+KpTbd8iRw4J3QI1jg/VdfTBK5osgzA=;
 b=CF4qXhGUHRDQabwR2l/Mro5TPV+0lq+PP/bGt8V7WpBbTxerB8QgDbGP9iFQeBvKOQlLFz79Tx4/X0cipFZJHDngAahGgfXkE6key7HXoEuYkXYLdfJGLJYiE9+iiYOU4mTacUoe/vQ4XOQFEZBO82kZluao+r/S8Di8zdO6Fjc=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.99.17) by
 AM6PR08MB3816.eurprd08.prod.outlook.com (20.178.90.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 15:15:52 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::6848:2a38:498c:81a2]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::6848:2a38:498c:81a2%3]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 15:15:52 +0000
From: Alexandru Elisei <Alexandru.Elisei@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Thread-Topic: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Thread-Index: AQHVd5rkkorMtiVcoEGqwu99vMHDlqdETo+AgAAEb4CAAAFRAIAAAF+A
Date: Mon, 30 Sep 2019 15:15:52 +0000
Message-ID: <1703f24c-5682-0b37-d804-31b4a46483f8@arm.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
 <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
 <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
 <20190930151432.zgcaxtn7glrffkkn@kamzik.brq.redhat.com>
In-Reply-To: <20190930151432.zgcaxtn7glrffkkn@kamzik.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::24) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.54]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b1b7ee26-97a9-4581-8105-08d745b919c0
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: AM6PR08MB3816:|AM6PR08MB3816:|HE1PR0802MB2331:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0802MB233125F979A02EFD14674DF586820@HE1PR0802MB2331.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 01762B0D64
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(52314003)(189003)(199004)(2616005)(478600001)(6116002)(53546011)(64756008)(31686004)(54906003)(316002)(2906002)(3846002)(8676002)(81156014)(81166006)(66066001)(66946007)(8936002)(66476007)(66556008)(11346002)(66446008)(25786009)(102836004)(26005)(14454004)(6506007)(386003)(186003)(76176011)(99286004)(476003)(52116002)(44832011)(486006)(446003)(6486002)(6436002)(31696002)(4326008)(86362001)(6246003)(36756003)(6512007)(5660300002)(229853002)(71190400001)(7736002)(256004)(71200400001)(14444005)(305945005)(6916009);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB3816;
 H:AM6PR08MB4756.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cquy0nlM3TO1Gk9J+7ZDH6/xu7BU6oGoW51QIfc4tLFmItIbJYRaekXsvyTeukZ3datefsBjpSVi26mcluAIPTOB0PIbJYoUEx8kppsZ1gjnbnzmnwW7lYQveoiMJOxgnfKkxO6Fg011yFgRWiGlPJWZo4MJ4JbFFHX/tJxjrRLg2rHn16F4sibMvIm3AYfFOLV8lajQAQoXYJan1ABFWhX33O+WuIz3Ac7YlWpbu0dfYn9j1t/zuJ9HCzbYxx2mtfcrXothDNO7OCcRPugPpFSRk1mart6eY4pfJlwK++a5ivDcqFlJdOyww6BS/vWf/ejT3Zf4NSgvH0+f5vKO3V8idabCy2hp3YJ88qgAGYoY1MJ2xn7cRQkjlTVf4EdPZm/y0+VCDE74nK9RmsdadnfYZ/RHaPjJMmSoZru+wY4=
Content-ID: <F07C9B73D7EE594FB01E263CAF203505@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3816
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(1110001)(339900001)(199004)(189003)(52314003)(40434004)(6506007)(26005)(99286004)(229853002)(86362001)(305945005)(2616005)(7736002)(54906003)(102836004)(50466002)(5660300002)(2486003)(70586007)(8936002)(3846002)(316002)(81166006)(81156014)(6116002)(6862004)(186003)(2906002)(31696002)(8676002)(478600001)(26826003)(22756006)(66066001)(11346002)(6486002)(47776003)(4326008)(126002)(76130400001)(53546011)(486006)(446003)(36756003)(31686004)(5024004)(386003)(76176011)(336012)(23676004)(476003)(70206006)(14444005)(14454004)(436003)(25786009)(6512007)(6246003)(356004);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0802MB2331;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Fail; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 38b46d9e-b2cb-4e1c-e702-08d745b91522
X-Forefront-PRVS: 01762B0D64
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvD0C/YS5NHtHiRnBTaYltPTB+apa11uaHuQEhs35JIK2pUHHrvWopihptoriiuBmweENk4kCD+21LxYVKB2iLuSYJkkH3zIMcJn8OVAq4+G4YyAp06UDDWZOwcGd4cq3lgjOT4dVuoorLfUKdNiLNXtJmmOIv5Z2y8GG4WCpT+xKv/Ac4fM+NA/xrFvuFDvB9PASxJJahFc9CItqCbIGOFIo8yQGdxklHoFuTKBayWSqKfK5Z7B/lTwVENTnTpNKNcx3Aua1xoUEE0btEAAJ3VRaisV1EljdXmtm2WNlu3eTj1Bf4AsWCwkad0gLUN9kauyNC+21bTTX1XnSao4hU19bL1dgr2C7c1iHZdrSuZ1KwmZ4HITCUNIgoHkjLHh+7jR8KpMm+YUbofk96U8KmbyUeN1k60h2HrRxF0V3yI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2019 15:15:59.8866 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b7ee26-97a9-4581-8105-08d745b919c0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2331
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Andre Przywara <Andre.Przywara@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 9/30/19 4:14 PM, Andrew Jones wrote:
> On Mon, Sep 30, 2019 at 04:09:49PM +0100, Alexandru Elisei wrote:
>> Hi,
>>
>> On 9/30/19 3:53 PM, Andrew Jones wrote:
>>
>>> On Mon, Sep 30, 2019 at 03:25:07PM +0100, Alexandru Elisei wrote:
>>>> The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
>>>> (EL0, on arm64, or PL0, on arm) can read and write from that memory
>>>> location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
>>>> when is set [3]. Add a function to clear the bit which we can use when we
>>>> want to execute code from that page or the prevent access from lower
>>>> exception levels.
>>>>
>>>> Make it available to arm too, in case someone needs it at some point.
>>>>
>>>> [1] ARM DDI 0406C.d, Table B3-6
>>>> [2] ARM DDI 0487E.a, table D5-28
>>>> [3] ARM DDI 0487E.a, table D5-33
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>    lib/arm/asm/mmu-api.h |  1 +
>>>>    lib/arm/mmu.c         | 15 +++++++++++++++
>>>>    2 files changed, 16 insertions(+)
>>>>
>>>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>>>> index df3ccf7bc7e0..8fe85ba31ec9 100644
>>>> --- a/lib/arm/asm/mmu-api.h
>>>> +++ b/lib/arm/asm/mmu-api.h
>>>> @@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>>>>    extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>>>>                                   phys_addr_t phys_start, phys_addr_t phys_end,
>>>>                                   pgprot_t prot);
>>>> +extern void mmu_clear_user(unsigned long vaddr);
>>>>    #endif
>>>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>>>> index 3d38c8397f5a..78db22e6af14 100644
>>>> --- a/lib/arm/mmu.c
>>>> +++ b/lib/arm/mmu.c
>>>> @@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>>>            assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
>>>>            return addr;
>>>>    }
>>>> +
>>>> +void mmu_clear_user(unsigned long vaddr)
>>>> +{
>>>> +  pgd_t *pgtable;
>>>> +  pteval_t *pte;
>>>> +
>>>> +  if (!mmu_enabled())
>>>> +          return;
>>>> +
>>>> +  pgtable = current_thread_info()->pgtable;
>>>> +  pte = get_pte(pgtable, vaddr);
>>>> +
>>>> +  *pte &= ~PTE_USER;
>>>> +  flush_tlb_page(vaddr);
>>>> +}
>>>> --
>>>> 2.20.1
>>>>
>>> This is fine, but I think you could just export get_pte() and then
>>> implement the PTE_USER clearing in the cache unit test instead. Anyway,
>> I thought about that, but I opted to make this a library function because I
>> would like to modify it to also act on block mappings and use it in patch #4
>> from the EL2 series (the patch that adds the prefetch abort test), and send
>> that change as part of the EL2 series. I am assuming that this patch set
>> will get merged before the EL2 series.
> Yeah, I need to get back to that EL2 series. I just need to wrap up a
> couple more things and then I'll be able to focus on it. If you have
> some plans to refresh it, then feel free to do that now. When I get
> back to it, I'll just jump into the refreshed version.

That's great, I have v2 almost ready, I'll send it tomorrow.

> Thanks,
> drew
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
