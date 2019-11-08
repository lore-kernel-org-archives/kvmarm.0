Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3283C5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 16:25:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ACC721882
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 16:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="iLiQDc4i";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="oEIOPihF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ACC721882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84B544ACED;
	Fri,  8 Nov 2019 11:25:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mncmMwsEYoRt; Fri,  8 Nov 2019 11:25:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E3B4AD09;
	Fri,  8 Nov 2019 11:25:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F07A74AEAF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 08:59:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rIwLEixsNaRg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 08:59:38 -0500 (EST)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30087.outbound.protection.outlook.com [40.107.3.87])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27EB64ACD8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 08:59:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjgHKYjq7oqSbSpxEDwfFng1XHT2lFXMf86ysMRkC8o=;
 b=iLiQDc4iDBRwoRlhCu1McEtq9z65g46bGcQ3ZtVtILMoB4BwQrmGwttSu+c0QY/cXLdr1OktJr5EHQsAgeAKslGbEwC9ZcwtBePCtauKRVF927tjuBs9gjkY+lJWCQ1bTLvDRsYbSwbmQMHR29a55CUCyouxSAweBxt7NrB51JE=
Received: from VE1PR08CA0031.eurprd08.prod.outlook.com (2603:10a6:803:104::44)
 by AM5PR0801MB1729.eurprd08.prod.outlook.com (2603:10a6:203:3b::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.23; Fri, 8 Nov
 2019 13:59:35 +0000
Received: from VE1EUR03FT009.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::202) by VE1PR08CA0031.outlook.office365.com
 (2603:10a6:803:104::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.23 via Frontend
 Transport; Fri, 8 Nov 2019 13:59:35 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT009.mail.protection.outlook.com (10.152.18.92) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2430.21 via Frontend Transport; Fri, 8 Nov 2019 13:59:34 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33");
 Fri, 08 Nov 2019 13:59:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 005bd53b5cd89064
X-CR-MTA-TID: 64aa7808
Received: from fe762897a665.2 (cr-mta-lb-1.cr-mta-net [104.47.14.53])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 CED5BD97-489A-4458-9FFF-3FA289A7E106.1; 
 Fri, 08 Nov 2019 13:59:28 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fe762897a665.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 08 Nov 2019 13:59:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKiAxF2g3Zol48ZipN3EvvBpfbCoTp8JA35iY9Eqb6DRVac6yHUfRgtCIXqjOJK+7Www2Tyb1eRncLA1kkgat6u3E8FCGyXSxwRS4zCzyax2Q8394lRh7pEmylql2xutksCVNx8tYJJfLNQqvIgAfGTVzxYi7Vf3ZYq7QSLg9+297heeVIluNtpaeRY2Slwf5dQ3MK9/tTHA99sjvsn+4NR62DtKRf2BQ3Od3la3KaeYdZeEN3DyfVUQXJUEEzssFBhqALVx5d113xxAztkXk6SaMf19LkvPWXeanqzVtdKVcuJUzp1r9K8GBbuaAoMYOb4nQft5t+MYxnFcdm1yyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4asgjvfl/TpWaq4QD4U+QVpdjCtmTYRgOZ7kECgQQLE=;
 b=RF+PIWtKdyVFyv5c5HcHlLCubFE3J2eih7jWFlQgop7+ZTr65noGXqH+7qDJJuCDQYDQaDmKL6pe7N3H5ZP0PLLuxWmd5ZxepLiTNscb7V397RUVTk4SCmN9qsORGGxaYShPNzGYSpO/kMTtmrCzwdL8xd7pVBaY6nkGQxGfATx0LWbBMDsnX3HufGgCG9/NJqB7D1cXbN3u390ruHD2lkjyfHsCbasCPgcYxdGjNYUKbXG0hd1R3FXhiB05gctPaSplkLPnbX3kYxb3rF4qbRLRpypfYI+UzSaZ5KU3luJ8fz7Ba1/aR2xoLO1ylSj3j3OSU7ipGrhHygvTX+0gMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4asgjvfl/TpWaq4QD4U+QVpdjCtmTYRgOZ7kECgQQLE=;
 b=oEIOPihFDYVdsqqreefR6TvUiUqdIvnAice01X0RurguQlPYyxPU3s9sqQ9tVTdL5pBHu3gVDHsSR0OMwfbqKF/BVFx7ikrVh4I2UX2jEi8Cu8ljwTqQlS7B4YbGpqtud82+JXU774+2mRzGe8O7AF/oAV80ny5S6wtR1tkSkeo=
Received: from AM6PR08MB3176.eurprd08.prod.outlook.com (52.135.164.25) by
 AM6PR08MB3286.eurprd08.prod.outlook.com (52.135.161.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 13:59:26 +0000
Received: from AM6PR08MB3176.eurprd08.prod.outlook.com
 ([fe80::f9b1:6623:ab49:7b13]) by AM6PR08MB3176.eurprd08.prod.outlook.com
 ([fe80::f9b1:6623:ab49:7b13%3]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 13:59:26 +0000
From: Ard Biesheuvel <Ard.Biesheuvel@arm.com>
To: Christoffer Dall <Christoffer.Dall@arm.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: Re: Memory regions and VMAs across architectures
Thread-Topic: Memory regions and VMAs across architectures
Thread-Index: AQHVliZl1EGI7TljeEqvAqrUR5wJl6eBTRyA
Date: Fri, 8 Nov 2019 13:59:26 +0000
Message-ID: <d49efeb7-3cad-9400-5e67-8a1e80ef7407@arm.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
In-Reply-To: <20191108111920.GD17608@e113682-lin.lund.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0056.prod.exchangelabs.com (2603:10b6:800::24) To
 AM6PR08MB3176.eurprd08.prod.outlook.com
 (2603:10a6:209:46::25)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Ard.Biesheuvel@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.96.140]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a26adce2-6cbe-46e4-31d2-08d76453e302
X-MS-TrafficTypeDiagnostic: AM6PR08MB3286:|AM6PR08MB3286:|AM5PR0801MB1729:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0801MB17290BBFFB43A356EA3888B0887B0@AM5PR0801MB1729.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0215D7173F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(6436002)(6506007)(486006)(476003)(7736002)(71200400001)(2616005)(386003)(66066001)(256004)(110136005)(316002)(446003)(14444005)(11346002)(6512007)(66946007)(66476007)(66556008)(64756008)(66446008)(31686004)(6246003)(2906002)(6486002)(44832011)(102836004)(52116002)(229853002)(86362001)(478600001)(99286004)(4326008)(186003)(25786009)(71190400001)(36756003)(14454004)(54906003)(53546011)(26005)(81156014)(305945005)(81166006)(3846002)(31696002)(6116002)(76176011)(2501003)(8676002)(8936002)(5660300002);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB3286;
 H:AM6PR08MB3176.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: nI03puv6OIyLODdfk+mgHsgQji/c/HNP89ivdDp81+WpIyn0QUDxlbnY3WkfUGWvN66PvT8K6tXV+XbQlKjk0OoVCfadX69qJoHwPxHFsQZgsSTmdFgdYpm7uAcOk2NZR516RnuJdj6shc1R72Y0AnO7gy+ttPqgi2bDjbJqzLJm9kjJoyVgsSvUHGtOHsYQgbB2WaFVxhXHfBBxrmc3+P4muUFwioMEDxFQuvPqpKfs7U+Q87xhEBVP8s8foDurjJOOpbHctao1faVmRTkpn6OavSx/aM9ctwlyosmYxevPeT8LWo2aWRSVhgvkfiBEXRIw1Yykeutu7ZUDTvSQ1aDDzaghH6zMnsYD/Y+hnyaQfCLcUPZMjbU5GL6M9D+BynfmfkUGZEsrCLuGoPTqISOYoVCcZVqnC/bYkLJTSZ7b7eflF0HNhCTmL02kYQyP
Content-ID: <ED42909F6BFB084D9B660B1E9E2A52A5@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3286
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ard.Biesheuvel@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT009.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(1110001)(339900001)(40434004)(199004)(189003)(31686004)(229853002)(2501003)(436003)(6116002)(3846002)(36756003)(2906002)(25786009)(110136005)(6486002)(356004)(478600001)(99286004)(36906005)(316002)(126002)(486006)(8676002)(76130400001)(14454004)(81166006)(81156014)(476003)(8936002)(11346002)(336012)(86362001)(26826003)(54906003)(5660300002)(446003)(70586007)(107886003)(2616005)(14444005)(22756006)(31696002)(5024004)(7736002)(305945005)(26005)(66066001)(47776003)(6246003)(50466002)(4326008)(23676004)(386003)(105606002)(102836004)(70206006)(6512007)(6506007)(186003)(76176011)(2486003)(53546011);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM5PR0801MB1729;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Fail; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2abd0225-7547-478f-0daa-08d76453ddd0
X-Forefront-PRVS: 0215D7173F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsoeDDhgXL+Zd+lwZKov7UojftHij7J/ZGgLMAuDWaCiUOKSXE/pLRmeSgV7Yvc4Nru4eaZEifivWc2qkFtI5AcBDFVjEoFRw//03yyoj8uXMnkYYXE6mvbu2vG7fDTOEigoWjZ/aoP4yzjD3634pWBDsUXOy4tGZNQCWMTZtsxRR8tj8IGsUPvD6xsucuMCxaWpRiHWlnklSqIq52fE2uKYWquReJ+Ib3w60MSigMnqTjXcRKyz/lsh//kIjelWVtf/qhkM/4i8GSZN0lDQOsgX1V95L6AVYCL5ydIcm+lSoa9XA6e+PPrnKjrRMBW6HlgVDhIN9KyElAZq0mmc9iEwrpxemxUGJ1XzegVYSx4XLU/3FJrvGZSfke+TgmDgbF82lEbxJSh+03fU7kAd6EHS23WjCi4Sa0xZAjvUA1wWUC8E878VWrRsU06Fh10V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:59:34.8798 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26adce2-6cbe-46e4-31d2-08d76453e302
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1729
X-Mailman-Approved-At: Fri, 08 Nov 2019 11:25:32 -0500
Cc: Marc Zyngier <maz@kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On 11/8/19 12:19 PM, Christoffer Dall wrote:
> Hi,
>
> I had a look at our relatively complicated logic in
> kvm_arch_prepare_memory_region(), and was wondering if there was room to
> unify some of this handling between architectures.
>
> (If you haven't seen our implementation, you can find it in
> virt/kvm/arm/mmu.c, and it has lovely ASCII art!)
>
> I then had a look at the x86 code, but that doesn't actually do anything
> when creating memory regions, which makes me wonder why the arhitectures
> differ in this aspect.
>
> The reason we added the logic that we have for arm/arm64 is that we
> don't really want to take faults for I/O accesses.  I'm not actually
> sure if this is a corretness thing, or an optimization effort, and the
> original commit message doesn't really explain.  Ard, you wrote that
> code, do you recall the details?
>

I have a vague recollection of implementing execution from read-only
guest memory in order to support execute-in-place from emulated NOR
flash in UEFI, and going down a rabbit hole debugging random, seemingly
unrelated crashes in the host which turned out to be caused by the zero
page getting corrupted because it was mapped read-write in the guest to
back uninitialized regions of the NOR flash.

That doesn't quite answer your question, though - I think it was just an
optimization ...

> In any case, what we do is to check for each VMA backing a memslot, we
> check if the memslot flags and vma flags are a reasonable match, and we
> try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
> and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
> However, there are some things which are not clear to me:
>
> First, what prevents user space from messing around with the VMAs after
> kvm_arch_prepare_memory_region() completes?  If nothing, then what is
> the value of the cheks we perform wrt. to VMAs?
>
> Second, why would arm/arm64 need special handling for I/O mappings
> compared to other architectures, and how is this dealt with for
> x86/s390/power/... ?
>
>
> Thanks,
>
>      Christoffer
>

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
