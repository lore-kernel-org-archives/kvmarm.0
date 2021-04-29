Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E13C433B4
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 09:49:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFE8F6141C
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 09:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFE8F6141C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2234B3A6;
	Fri, 30 Apr 2021 05:49:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 49zwRcdjOl3h; Fri, 30 Apr 2021 05:49:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EDC4B3EF;
	Fri, 30 Apr 2021 05:49:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DA474B3AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 18:08:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ud2hAQopwrtA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 18:08:29 -0400 (EDT)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF8334B390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 18:08:28 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HehnpJxeO3cyACaTngfDge0ey8/Z7cFTKMQWMwUm9weUJKcG3VjWPKEfin2ur9AU70y6H+NLzxky/6uC+AHJuS1hsmVGcm3rojwfwypsY2eZJ0+ny0q2gDWbpomqxCiFoWMB9M7idX58+uI1s16WPtLvDC9ctJadtXBOM9qKqmaxLsMXK8t1x1CoIdrUQGfw9HU3du2FK+dv9djXAj01gnZQetM6spYh7/6ftrW4I7g7jcvjdprJy2qDsvcWU8dnVqmkm5CuQvYqAvm/RR2d7i3b2oSBE+fr5MMKkSmMvr/m9WayLNp8y2nqBabsoSUq6HymQb3CoccFfOEQwdx7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X0hFpZa6Vi1NbFLrnAq97wFhQMPxNy/Xy7aGLOCHFM=;
 b=NhPFDXzvcZx27eIs/LFpHgkT6QcKdtRtub5NZ6Eg6eLpLZES2/bubKLgvnNc4IZ1S0HNtssaND9+CSZa3GknCsyY5PkU+DysdbeVOXkHquQ+Cfbhu8WG+QHeW1Ptf5abariY96V7ypObO1wkBXoBXhbR1jz6EsKUwmYTOmXFCd4LA5WWH7QpML7bmdM8QnlP0z+Qio0yYZ8PthzTpKnWTTIhD7amhO8XDZoC5fV4TZvKwtF+QmVtAOMppotIAntfCLgd6zt1pXZQz6Pw+7Xvl/xme4eXoc1bOH9cW8m9k6j8v9SyJw5oWCEF6QUkfd3eWYfoVpV2jEcbTfIju2CcGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X0hFpZa6Vi1NbFLrnAq97wFhQMPxNy/Xy7aGLOCHFM=;
 b=eu6xfiUCvMmKfo5sL8UPwK0aDCTAM/svftu0cF0Ieizv2j94LOPVDugPUeuR0ZydzigHsQMFokehNYELHXkLrTDwsPK60YKkoLPBf6Gb+w+jSA8VvnlwvAZZnLGhjJ9Zh6zGsvedY1OUEpcZBeAEqTOIYBLwucYIyBkbNr/H9BinCcySbJV1+Owelb2dF+4j9SQX6prA3Bkn+oqPUtDasMmmIpB5tkFN0txZkSp0Ja0kABShmYKfzpDEjlMECCHSRfmTjWv5Rmv4iGDw1AWNa3Fi4oRiPXcH96h5LVQYdqCPOwCIE0MtNrC++iyaBw8+9oo9EuFoMQSuiynFfQFD2A==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 22:08:26 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 22:08:26 +0000
From: Vikram Sethi <vsethi@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, Shanker Donthineni
 <sdonthineni@nvidia.com>
Subject: RE: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Topic: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIAAJJTg
Date: Thu, 29 Apr 2021 22:08:26 +0000
Message-ID: <BL0PR12MB2532C10511989BE9EAD2A032BD5F9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
In-Reply-To: <20210429134659.321a5c3c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [2603:8080:1102:19fe:94b2:89d7:739a:1f5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76761dad-c047-42b4-3569-08d90b5b5034
x-ms-traffictypediagnostic: MN2PR12MB4093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB4093D70F17BDBAF12A8C4152BD5F9@MN2PR12MB4093.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vuZ33HfbrYqUt5G1uYWV7GmifO4LP8qRD7qMlAjmjCtiigA1ECcXksqnkpmGFbyOf/KOgRSbXTUb9YBEiglVeuKGQj7uImdaFsklVX0QIVytOfy12e63jYA1SEpk+7ZER7+AH7i0IvJIIJ5TyQ9ffJyrs3LOs+fMvv8QiVAODPjjO0v4f7JmLFMFxeXQg6247aTX4TkOGh2MC263RAbYpyn/Q5hALElGqWfBBHP7mfBov+3eJNCE9YDAFVEQGZe+1hBKHJTVE9MuxyfwbJ9mv/lTyKSXGbgWE1vIseQ6YmWbRBCujsSlcSHncfNSugSlJajj3+x8KnNr4zRHdZMGclN+0IFy+xTrCPUTyf+muQN1nkctZxYsVkM/uWuzfMCTfi39mOCYx4an+AbRyJxxbMOBZZ58L/Iqxeh+ejivLxpwszFj/a4Ojq7Z76DnlQUon77NWHehmLCgHYlIedW1Vhb3jmGBHhtjTWbXPxLYzfdHJuo0D+NIIqVIaniE8fshU3YOzqbd3lyzMzogzgvYrlAZYRRwb0d8hmulk+mQo6Xr+EwlHn1LVKAhSq7/pgfWxmKRFd9wTxEX50r5ngd+X254Jd69Em1/OxFBAe5eKjs=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB2532.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(122000001)(66476007)(38100700002)(6506007)(7696005)(478600001)(66946007)(53546011)(86362001)(186003)(52536014)(71200400001)(66446008)(6636002)(316002)(54906003)(9686003)(55016002)(110136005)(83380400001)(2906002)(8936002)(64756008)(107886003)(76116006)(33656002)(8676002)(5660300002)(4326008)(66556008);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?YWhqekpVeEQvRzAxOE9LdmdpSXZ6bnNjSlBnUUMvaEhKRWJjSXJwUS9nSDFN?=
 =?utf-8?B?WmJ3UE1ZM0o2Um14YktpZGNEYkNDTmdIRllMZ0t1bEFGZXA5ajFjMFc1YkZi?=
 =?utf-8?B?eStaNEd3T2J0eEQ2ZjZ0aDE4ejU2c2FJQ3YrendRbWFuYklDYndjeHJnMGVI?=
 =?utf-8?B?V1lla0UwNVBFM1JuMnJJYTBjaTN4T1RqT1p1Zlc5N1p3dndJNHdWNnNUM1VW?=
 =?utf-8?B?d1pQMVlPUnNaSFJnSnBoTk9OS1ZiTXh4Y01hNHp1dWdtdUcvYXJ4Y0ZQUndO?=
 =?utf-8?B?Nk9ZbDNoY1k2SEhZNHlCaWZvVWZSVm4vUHZqTlYrUjZEaFFhRHllbFo1K0lv?=
 =?utf-8?B?UUhkSXlCYkVTaURuSXVDYWVqMytoWjJaQkFnb2YzdER1dFMyRWxKS3lRRU9P?=
 =?utf-8?B?YkdQZWNOMzFSYkhwOWFxWTZFQlJyekF5WTVvckZUUjhHWHB0aTM1bndKS2Fs?=
 =?utf-8?B?UjMzTy9xTWZMaHpPNEcyY1ZPbjdSeFBhdWdwNk01Wk1kbTh1UmJpdklMNExo?=
 =?utf-8?B?UFQ0ZHJGSTdMdTdKVGpQaE45VkRWVWdFb3FzMXlvWFEyMUhzMkxVMnN3aWZy?=
 =?utf-8?B?aUlYVFB1dFFZbEJJWVNIN09wU05tTnY4UGJ4YXZKQ25wZGdFUE9CWDJILzFU?=
 =?utf-8?B?RXhQaDVDNy9zYmZXNndCeUViaVdCVjZvT0lqMFQxcllaQ0ZYSk1OWlFBdkVD?=
 =?utf-8?B?WFpXb0F5VUEzUmZxOEFtblIyWHRMWEVjczZBNjZrdUNoL0pGZjZuZjVRbnE0?=
 =?utf-8?B?bUtMUldlL2ZUa2V4K0JtYzBNSHFneUc0YkRZaGVTVHEySitJTTQveHV1cThS?=
 =?utf-8?B?alR4YVpoM09vTzA5NEVKMEJJdjVLdUJsUHRMUS9SZkJaK3lya0prTVN6MG1W?=
 =?utf-8?B?R0R6cmlrZk5NaDFJMjBnb0dmRlhsbmRMZ3B3L2Z3dVhzNmhoNk1EczFIT3FP?=
 =?utf-8?B?cUNWczI4SDJ5Z0ZOWGpDMzV3QXc3RGdkMzAwNitrbnl1cy9PZjQxN0E5UzQr?=
 =?utf-8?B?TUhnVEh2MnMxTDFTbnNhRmRBRGNOaDBkZ2xSTkxSRkZHTG0xdGdlTlZRUXVw?=
 =?utf-8?B?SndWV0V1QWh3Mzl5V01VYWlDQmZQRGxzV1FMbFlKM2FMMkxYdnliR2pVVHBM?=
 =?utf-8?B?N1lJcXdhUHF2K2xqNVdsMTRXMjVpZXZyUSs5aVRScDkxN3AyVkdtc1hCd0tp?=
 =?utf-8?B?bExzTVQrakpnSkx5cmh6Q1lkMm1sRUo4VlB5U3BxeFQrNVd2K2RqQmFpcU45?=
 =?utf-8?B?SkxpWkZ4YWdWUjM1YzhRREtEUWpjTk1SRjZYV0lGb1o3SVlVWmxwWlR0ZWJG?=
 =?utf-8?B?L3Z2SmNYNmhzWTBvVSt5RTUvTHdmY1lIb21uR09kL1VZZVpKNzhva1RkdkRZ?=
 =?utf-8?B?eFdkWDBld1N4L1d2bDl6WFgvZHVodW4vQ3dza3BxWmFTRzBYZGpDQTVSQzZB?=
 =?utf-8?B?ZEQ4NmhiSnprd1hBd2NFcWpkcTQ1VXFuWVZPNU1IS3JNV0x6NGdreVNGeG9D?=
 =?utf-8?B?bi9kQ3RwbVltOWJzWEVwQlF0eGMxdHBZY29UckluQXlCNFFlV1VFTTRkUXdV?=
 =?utf-8?B?WFhEaDVpNDBYOTZHS2dyOE5WQUhGTGRZaTFOME5kWGp5d1BJeHFRbXJBbm1h?=
 =?utf-8?B?QWo4N21rSTlJSno2K0tSZFpVZG1FMWcwWjFHVHFFQkg2VzNKaStnTmJzdVJW?=
 =?utf-8?B?c1pBcnNFMTF3dnZrb0VDOVpzVGRmQWN2ZWRpR1JjWGpQUVJQdDdRazB3ajAw?=
 =?utf-8?B?eWsrZ0NvYlduNTdITUNSU0lOQVlYTlJTdzB5SC9sd2JDR3oyWFJYa09XYmJp?=
 =?utf-8?B?N2NZT1g2VHlGd3NndWpOYnl0NnNzQnZIOU05S0NXR2RVZFhweWtBbnUrYTU0?=
 =?utf-8?Q?Bqz1J4A/mvbtu?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76761dad-c047-42b4-3569-08d90b5b5034
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 22:08:26.1816 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cbPSSB5HVMNDPHEcD1RR0qObLXUaWb/tPMXX2VaxArYEmt3BLg9p8sA9ZK/TauxhaGXs7kGvR3dVkbBICMoHiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093
X-Mailman-Approved-At: Fri, 30 Apr 2021 05:49:48 -0400
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
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

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR region
> in VMA
> On Thu, 29 Apr 2021 14:14:50 -0500
> Shanker R Donthineni <sdonthineni@nvidia.com> wrote:
> 
> > Thanks Alex for quick reply.
> >
> > On 4/29/21 1:28 PM, Alex Williamson wrote:
> > > If this were a valid thing to do, it should be done for all
> > > architectures, not just ARM64.  However, a prefetchable range only
> > > necessarily allows merged writes, which seems like a subset of the
> > > semantics implied by a WC attribute, therefore this doesn't seem
> > > universally valid.
> > >
I didn't get your exact concern. If we removed the check for ARM arch
and simply stored that this is a prefetchable region in VMA, then each arch KVM
port could decide which PTE mappings are OK for prefetchable BAR.
KVM doesn't want to go through PCIe enumeration, and would rather
have the properties stored in VMA.
Beyond that, on arm64 specifically there is no WC Memtype, but we use
Normal Non Cacheable mapping for ioremap_wc which can be prefetched 
and can be write combined. What semantics break for a device if
its prefetchable BAR is marked as Normal Noncacheable on arm64?

We need a way for write combining to work in a KVM-ARM guest, as it is
an important usecase for GPUs and NICs and also NVMe CMB IIRC. So
*some* way is needed of letting KVM know to map as write combine 
(Normal NC) at stage2. Do you have a better solution in mind? 

> > > I'm also a bit confused by your problem statement that indicates
> > > that without WC you're seeing unaligned accesses, does this suggest
> > > that your driver is actually relying on WC semantics to perform
> > > merging to achieve alignment?  That seems rather like a driver bug,
> > > I'd expect UC vs WC is largely a difference in performance, not a
> > > means to enforce proper driver access patterns.  Per the PCI spec,
> > > the bridge itself can merge writes to prefetchable areas, presumably
> > > regardless of this processor attribute, perhaps that's the feature
> > > your driver is relying on that might be missing here.  Thanks,
> > The driver uses WC semantics, It's mapping PCI prefetchable BARS using
> > ioremap_wc().  We don't see any issue for x86 architecture, driver
> > works fine in the host and guest kernel. The same driver works on
> > ARM64 kernel but crashes inside VM. GPU driver uses the architecture
> > agnostic function ioremap_wc() like other drivers. This limitation
> > applies to all the drivers if they use WC memory and follow ARM64
> > NORMAL-NC access rules.
> 
> x86 KVM works for other reasons, KVM will trust the vCPU attributes for the
> memory range rather than relying only on the host mapping.
> 
> > On ARM64, ioremap_wc() is mapped to non-cacheable memory-type, no
> side
> > effects on reads and unaligned accesses are allowed as per ARM-ARM
> > architecture. The driver behavior is different in host vs guest on
> > ARM64.
> 
> Per the PCI spec, prefetchable memory only necessarily allows the bridge to
> merge writes.  I believe this is only a subset of what WC mappings allow,
> therefore I expect this is incompatible with drivers that do not use WC
> mappings.
> 
> > ARM CPU generating alignment faults before transaction reaches the
> > PCI-RC/switch/end-point-device.
> 
> If an alignment fault is fixed by configuring a WC mapping, doesn't that
> suggest that the driver performed an unaligned access itself and is relying on
> write combining by the processor to correct that error?
> That's wrong.  Fix the driver or please offer another explanation of how the
> WC mapping resolves this.  I suspect you could enable tracing in QEMU,
> disable MMIO mmaps on the vfio-pci device and find the invalid access.
> 
> > We've two concerns here:
> >    - Performance impacts for pass-through devices.
> >    - The definition of ioremap_wc() function doesn't match the host
> > kernel on ARM64
> 
> Performance I can understand, but I think you're also using it to mask a driver
> bug which should be resolved first.  Thanks,
> 
> Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
