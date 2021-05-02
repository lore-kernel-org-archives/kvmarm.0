Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E872C433ED
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 09:11:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF10A6127A
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 09:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF10A6127A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 521844B39C;
	Mon,  3 May 2021 05:11:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2HaS8U3FVsZS; Mon,  3 May 2021 05:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0EFF4B3C8;
	Mon,  3 May 2021 05:11:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590AB4B32E
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 May 2021 13:57:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kcgaRJdq325L for <kvmarm@lists.cs.columbia.edu>;
 Sun,  2 May 2021 13:57:32 -0400 (EDT)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6EBD4B323
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 May 2021 13:56:34 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZwlxIoTos6UrMynqPemo/A1ODhN2KV9MBiOUZOlTDEquqgclmgEZfKOGzjodTN5pGzarOx0vgpiz0hLKAWokX1lSIyf0hjs+byLNoJ0YrwznU8jNXxv9VPU+KLRQNDsiMy6H3e7N6cjTb1FrfQXI6QkCkknoVpzwRFI5c0V9GHV7NlVNRIlAfTOhTrt+x/mrp4UOrluNZXIyCC+fR71P5C9JyecquPYH1opiJqWf3y5lVmJoB18bgg6mwWuKGM/Qb39JjQjkYUiNvqGfFnekIwxcpTHiCbG1trlBXt/6Fn3CZeRE3cp0VdQXFJWh1RU0J4LQ4uL54RKx+xvRr/N1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZLRSiQmUiqLxIIkAUhYDnzWcGrHV8uxrm0nUiKanuI=;
 b=gnDXtd94FCuIfxp0O9pBE1NPhCRYW3UaFQqo3eGlU44r+zQeznUhvZbR85V5M5gMBLM/sZhBwVsRZ9PsUVGKdpXXCEJqgkusyqJIBb6cKHn6WX7IK84levplWkfxK/+HbckzDSS7eey4sqaXl87BtKyL/g2ya+OYWRCXmGhyZGsjxH0lOpFdP0cAWM0qZqlfeOI4/TSkcUFgn8Eeu6pypdtOlAUFV2vH9PFFeV1/o5brSBjBwFan987JBCvb4zUVVvPgyZETZG/SzIqDPOFSeLQl7V4m45mXCOiA0erJx7WawLUX+NF/Gg6sx91My0MCCdWYLsKRQFJHgZEVOLFB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZLRSiQmUiqLxIIkAUhYDnzWcGrHV8uxrm0nUiKanuI=;
 b=PE3K2n0xrgUQDRZe8WFRTJIDAd80eqLpe3Dv+ZdymOi7pKUGSwCDdvJquk9ctzSprMapfR8bdnCLIGbdT1aYCWY/tw1X5FbEqsqxXh+VhfqjYj+hMl05677fGlsROvgTpgY9hRuecyA+N0LYgrOnriOM8hdurYdjnTgvGIm6Ho75SBC0Q+zg34MhYkO44aePhmqcUJZeaaPQ6mQ1OAggVBb7P3LtdinalW34986CIjE0KPVkbaQjMru7FYGU+rALafLhJJ7Q5oXmipZpRljjfpUvo89xyivDyq8uAnL2SrJE2OHaaZywjqGBoJ5YKt3Fzn6cVeqf7/1E2LM7CU+VRA==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB4288.namprd12.prod.outlook.com (2603:10b6:208:1d2::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.39; Sun, 2 May
 2021 17:56:31 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4087.040; Sun, 2 May 2021
 17:56:31 +0000
From: Vikram Sethi <vsethi@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Topic: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIABBh4AgAAGT4CAADU7AIAACSoAgAABt+CAASvZAIACHFDw
Date: Sun, 2 May 2021 17:56:31 +0000
Message-ID: <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
In-Reply-To: <87eeeqvm1d.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [12.97.180.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aadfdfc5-46ef-49a9-f55e-08d90d939e43
x-ms-traffictypediagnostic: MN2PR12MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB428866324FC76A1F267C1101BD5C9@MN2PR12MB4288.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IU5BE2BNKccQFJmdkqliJVg4SXbL/v0GOajjIW/11Ku/i5mtg95inWXmmFULVx4xcBOHxuqvYKb8GhDxcD5SI2XmLKzaQdEvKOiSfNm8kd0JUueMz19nbIfzhGhfliCoiYbuPYuhLF2kXD7YhAXm1mEKLizb8vFEd8iVco+gsMVT3Z1O9Dek8W+drANzUvRTKf6BQECZXlt/46EL5gDb5pt1yUv88wPLFxYNqwW2+tESPqfSFyQl8vupwoGx0XV6HOyZH2b6H6RzQHoH+V+aRF8pkY2bQWL6arT5W0QkjjW27JPt+9Zsn5BP3V2MlUp3nLtoh1M5m3uSFsm1sJuYJEF7Yh18/udkxfKPvrh+UWZ0eLjhRaX47oV/nAsYAdVtGUhSNG37McGy//oyJtaNLcNQKg5ocZwgwQf9Ev15Y69n9ndXhKXXrXKoQyXzhJWrqF5AFSf/iKGYLRduV0mx4h1IFfvMRvqXCW+/vCzuEKKuq2UNGebRQXpsxhqppi7GoghhjRr6okPoYozqxAIroZfQQ7UOYza51xxqdqJ2xhTkDmVrcN5fsWGjxPgnCiw4bSUzh6uRgHzfVLqhpLoNotWgaE/Tvejk34bdaeJ7MF0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB2532.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(6506007)(5660300002)(4326008)(7696005)(33656002)(71200400001)(107886003)(122000001)(38100700002)(86362001)(478600001)(8936002)(52536014)(64756008)(76116006)(6916009)(186003)(54906003)(8676002)(316002)(55016002)(66446008)(66946007)(2906002)(66556008)(66476007)(26005)(9686003)(83380400001);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?Vi9ZVDlXMnRMckc1MnM0M29iMjBrUlAwM2Z6cWpLZFdJaDljNFU4ZUt5Wngy?=
 =?utf-8?B?YXRMY0gxN3gyQlN6Nk5ZZk91ZTU4UEl1TnV5Y0szb2RaN2Z6aFIyYnB1WWVr?=
 =?utf-8?B?WVh2OTIvQ3IrRDhwaFdHdTBrd2NPODUvRUFYaDNqaGJqbHNVUmQvSFUwZ2lN?=
 =?utf-8?B?cUN1SldZQk50UmliZXFvaURGbk04MlU1bG5rLzdvUEZJUnBCb1U1UHJ1SHZZ?=
 =?utf-8?B?MGhRcDBuS1IyNFB5ME4way9FZTB6SWdHVUR4SjBrUmlzMHhjQjVXOTRMQy9E?=
 =?utf-8?B?cFltZG1ETzE2Sm56dVpzUGZXZTU4TVc3dllkMFZHbW1tMW1qbndFNDdJQ0Vk?=
 =?utf-8?B?Q2ptTjQ4clJSREFtakNadnp3YWZBcVlXdnZteHB6czhydjIyVncyUWR5VzRV?=
 =?utf-8?B?MThkNjRNRW1ua0VkU1ZteDJnSTBvTFhRU0hTUHBDWnhPZHhLbGppTDc5WmFw?=
 =?utf-8?B?MEZ1UU9VTkRyY0J5WW41cjVTcWU3ajBTZzJLdTRmcXJROVZhNTR6OFRpUjdX?=
 =?utf-8?B?NFZVWVk4U1hiNXFFTnRvQnpqUllUT3I2NlJldk5nTFFzR1VIQnlpUzFLZW9i?=
 =?utf-8?B?U0dmVU5MSDd6V0Zsa3hwNVk2WnVBNDJ1WVhIQjhobjNQSU5KdkdOb1pwa083?=
 =?utf-8?B?RnYya3AwTnVYaEx5S0ZZaXFTZ1NHZmlTRnpyQXlVblI1TmZ3cnRQWDhDY1Bj?=
 =?utf-8?B?T0ZnSThRMVRzZmNSeEE3cW9vYWwrUm41WWRMc29iSkFRME5ibXpZZkUybVN3?=
 =?utf-8?B?SElDT0ZkOFhqOEQzMG9TQXRmM3NweUxjc09FbjFZdVlScDB5b084cE51ei9U?=
 =?utf-8?B?ckVuK3JFOGloR0FObEc3Z0lQSG5BVlJ6ZXNjN0R2SlRmQ0plTkN5UzhzK0kx?=
 =?utf-8?B?TVVNY0FudmNJSmVOQkgzQVdyclNQVEk0Kyt3NExlTzJIdHRUcktxcmtOZ05i?=
 =?utf-8?B?MHJ3ZjA3djJmL3diT2NMUHFXWXRLeDl1amJzYWp2eDd3bG9DT09TbWg3cW9x?=
 =?utf-8?B?YzJPM3A5VlVYKzZsZlo5UytqOXJkMHB4Skw3ek1lZXJqb0JtN2IxWXg3WEEw?=
 =?utf-8?B?dHBrNzRpN3puUXRhNWJBM05nNVBtS0w5NGtweTZ2RCtXTTExMEwvNE1rNGFw?=
 =?utf-8?B?ckJjZnpEMjRMRnBTeXpYNWJrZ2Yra2JDVjhYZ0xZcEtVSTNYUFZWcVF0RGo2?=
 =?utf-8?B?QitIQlhnblpnNlB6aU0zU3hUQ3d3bVU1cmJoVFovY2dwU1hEQklNU1p2VVc5?=
 =?utf-8?B?MDBzQ0JUK1dnRUY0b1Z5SWVKVVovM2ZHZkpKenJwUDRsY1J6c1dscWh2bFFF?=
 =?utf-8?B?cStZcWY3MFQ0Q0FhZGp0NXV6QkVFbFY5aWRzT2tsOGtrejZnQzNFWXR0RHlD?=
 =?utf-8?B?OHFxUnZZMnZqM2kxRlJUTGtLV1VFbHFKdXcvMkl2dEtSSXBHc1puN0ZNS3VX?=
 =?utf-8?B?cGFCYnNzR2hrRU1aU0xoWGFCd2dzMDlIM1h5SEVlTDBreTUzOEc5N2ZiRTU4?=
 =?utf-8?B?ZVZHb2JBRm0wWnByUG5adEdiVi9UaHVMbnZidVFSNmgzTUx3UGtDUUsyejNt?=
 =?utf-8?B?MERvellwaHg0dGFIby9FWTVBdGJuZzVGell4REFtYVg1RnhlQkZwRnBnSTlP?=
 =?utf-8?B?a1M0OTZFMm1TaFlXcHZid1Jxd3dkaTNnMkJXejdjbWQ3UTJBMDJJRXFXNi8v?=
 =?utf-8?B?cEk0TXBkK2hsTVhBajBzVk1mUWl1dm0ySjJEdzNHbG5JT0ZNV1FIcERFczZn?=
 =?utf-8?Q?o4i/h7Ikfx+UWYFdAo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aadfdfc5-46ef-49a9-f55e-08d90d939e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2021 17:56:31.4334 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: swcvaY59vNx5wYIgWV8XYFOz2SXTuxZYJBh7i0Q73dpDp8pAEsUgzwWlhEKpoC78SNxWzYAiEw9bfVVXJota4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4288
X-Mailman-Approved-At: Mon, 03 May 2021 05:11:23 -0400
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Sequeira <jsequeira@nvidia.com>, Will Deacon <will@kernel.org>,
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

Hi Marc, 

> From: Marc Zyngier <maz@kernel.org>
> Hi Vikram,
> 
 
> The problem I see is that we have VM and userspace being written in terms
> of Write-Combine, which is:
> 
> - loosely defined even on x86
> 
> - subject to interpretations in the way it maps to PCI
> 
> - has no direct equivalent in the ARMv8 collection of memory
>   attributes (and Normal_NC comes with speculation capabilities which
>   strikes me as extremely undesirable on arbitrary devices)

If speculation with Normal NC to prefetchable BARs in devices was a problem, 
those devices would already be broken in baremetal with ioremap_wc on arm64, 
and we would need quirks there to not do Normal NC for them but Device GRE, 
and if such a quirk was needed on baremetal, it could be picked up by vfio/KVM
as well. But we haven't seen any broken devices doing wc on baremetal on ARM64, have we?
I know we have tested NICs write combining on arm64 in baremetal, as well as GPU
and NVMe CMB without issues.

Further, I don't see why speculation to non cacheble would be an issue if prefetch 
without side effects is allowed by the device, which is what a prefetchable BAR is. 
If it is an issue for a device I would consider that a bug already needing a quirk in
Baremetal/host kernel already. 
From PCI spec " A prefetchable address range may have write side effects, 
but it may not have read side effects."
> 
> How do we translate this into something consistent? I'd like to see an actual
> description of what we *really* expect from WC on prefetchable PCI regions,
> turn that into a documented definition agreed across architectures, and then
> we can look at implementing it with one memory type or another on arm64.
> 
> Because once we expose that memory type at S2 for KVM guests, it
> becomes ABI and there is no turning back. So I want to get it right once and
> for all.
> 
I agree that we need a precise definition for the Linux ioremap_wc API wrt what
drivers (kernel and userspace) can expect and whether memset/memcpy is expected
to work or not and whether aligned accesses are a requirement. 
To the extent ABI is set, I would think that the ABI is also already set in the host kernel 
for arm64 WC = Normal NC, so why should that not also be the ABI for same driver in VMs.

> Thanks,
> 
>         M.
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
