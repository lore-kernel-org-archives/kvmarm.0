Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6298320897F
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742302533; cv=fail; b=gLqWOmGMHrsYrh0wOB+C53tkSyB4Vgq77EQm4hJ153ddhj+PAmNYzL9fpp8lSQXP6O1qodEV3iGNS5z617beAzwRS8idhJdHRsQN3f5TgyMiiO62yYSOAxS/c30w57FanzfFHwh77xJR+yc+dOc9qpz0LpVUf8K0I3DQ+vLnQ1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742302533; c=relaxed/simple;
	bh=uHMLr5SM7LmJw5x7GykFCZQmTJLoczTWOepsQys1MdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uteVMNN3/lMkamTFx3qqyBxsKpHVXMqENdkw+nTP1hJffOdNF/RHmL8q+UJ8PBg/4TsTRaC3VJADSvz13PcPByb3pvSrC2bOgS+B3lYYdbYHapFa7q/9L+NUsLW4JBjl+lZuftVFQlOOrRpmZpJgJ8rax3xsDD4yKyMdEIzKdec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MNH2G9di; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MNH2G9di"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lOOAQH8QhvwVYNTr9kDZJ8oR2AkBhjWxOf1yxPYhgen/cR8UQwiu9spoAFqz2zSv+oXvbO7avf00eKKKULp1FwUfpJDIsf6dDeDBh/3JjUweflCJPwAB4xQ1sUPhUn78u4G5ZzTme4UUlFak31wXUJKqVUmN5n3trB9Kzo/2M0FP/bxsuXsvhjAsQMOAENkVpa/VN+ZoGJo0yPOatCkZJyLsxdaYGMD9kufj/X2WQtES2EFCb2s+F8CwLwrU0CAUirj4CsuspBL0SILKX/GkdxcWa5A9fIGycFl8mrqpNuJIW6r6jjehp+U80KFYA+pGTNPZP8SepQpfvaHxfNIBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkBq+lTYGtck9JR7pTF6ar4e4/sXc6r/iEL1x3pslJ4=;
 b=uPK+idSzqdT9kmuy4DKz4SD74QA/wW26MSj89unfvRRte5kJwH/wtSGViWHf+wthtlO+3u2VQ3h3WoCM1C32e/6+yTa6fmkrnyX4STzVYLW/010kFYUIxM/BijZzgRh+eOcrcguJnq35igCNQ6t49LdGhX38HRgqsEqcyK98KUKWR0EsJnJfWWbCA3RY1PUKKiwwiGUoCxs+eoLYorLYJ1XNrALkse7wrTsThTRhtTWWqsvxX7VUmLyRS1exrBLhVvA8d5VpBKv1u83LoaU9KyPCU48qYWXnjAn01LYYvi5uxNLNs8lN6Y8rSbm6rManTYlVv36SBfPGFCK9Qheh9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkBq+lTYGtck9JR7pTF6ar4e4/sXc6r/iEL1x3pslJ4=;
 b=MNH2G9diEVvATrXP+sVV6r9Xmj8UENA6VlVp3rveh9eAziBq1Mfk9eUiEXhCZpVu14qbzN8IZf1eLLljLdyDVQAQyzdp3BobRa8fQOLbaV/iWESx7ujvkyMukYOWjBNZ5OktoHydN62WffJ4U9kEB7OLvG7AoGtygKVXk0gpjtahnNxaHavbko+ei/q5Ezw0ldSqIw4XprGXXnW5KtegEFrGrt+RDv3Qbwa7VRNumQNbP1lPNrFI+6hIVsTfj6e3OEcG3YYSuTfAQVsL82+tzrz5tlxOUJz/NYGtyMXfKdE9Lt5lC4PqfNXkI0N5SBK8+jgW1RIbRSuE45U+gRLpeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7900.namprd12.prod.outlook.com (2603:10b6:8:14e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 12:55:29 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Tue, 18 Mar 2025
 12:55:29 +0000
Date: Tue, 18 Mar 2025 09:55:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250318125527.GP9311@nvidia.com>
References: <20250310103008.3471-2-ankita@nvidia.com>
 <861pv5p0c3.wl-maz@kernel.org>
 <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmcmn0dp.wl-maz@kernel.org>
X-ClientProxiedBy: MN0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: dab026e0-4545-4c59-bc5f-08dd661c2902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fSW79jwoB0UyufcHNwYo/NkzLyKe9g+iAp8+MVYxQ2OmBMpYdz1h6Gcx/sHJ?=
 =?us-ascii?Q?RlWKQ/jqgYMTZKWzcLGSwvwecfGThRa3Xf8gyCmt2MhaTxDrG87nLZOB5JtT?=
 =?us-ascii?Q?DwKbAxfqcUZZd/O+TK3Pfzp4Z1EHPcPhS5HSoUDZcBSYgIc+Ni1J5r3u9Yoc?=
 =?us-ascii?Q?fGHdZqLhgHhozsRm1LpL8RGtJIhyQ6PMwYbjxpvB4YypsMqhaC/IO0JS5yZO?=
 =?us-ascii?Q?MlMxgK50KFnJwys7ysQ0nHrodcVu7kTeKZc6Js4yhNFOTXXQ5Q2jgO4OqpXM?=
 =?us-ascii?Q?rFPTxrASWgP1FqFegfdnZhoT1FHrlPLbKeAGCG58tbQNXYFJRxESEnmOMuf/?=
 =?us-ascii?Q?wO9ZvO5xYBWWTN0Qc1Ff7nWvn6zvQ53M4wIMks0hlHt9JQ3vhaZBp7OLVrnL?=
 =?us-ascii?Q?7yVsyqWLpdYDB5SuR5Wu7TFs16aQfaVYtW/zL+aj0B13whlH1/Dgn4UaJd63?=
 =?us-ascii?Q?1q1GPkkUkSa9xvaSWPA6z6e9WvvzA5jdn0+18VzNR0RoS/MgX5Y150GZH3jg?=
 =?us-ascii?Q?J+K4PH7wFS5Pm9owec4zaVguouZxUkH3+bNrIItWjyW14YntqSV4iOzQY1XA?=
 =?us-ascii?Q?QvqQF5j8qjLcIDVypxyMsVvOeNKWMeDs7lKwucWVeVX/NWzHBgtA+4FYtgyz?=
 =?us-ascii?Q?/s8/VUZ034dBBHJS9gaGuBamk19iLKM4irVfxEGQiPAwyJ/1nNsWFO4bsqeN?=
 =?us-ascii?Q?nYgzVFl2wwrvKlYIW+mFvT69eqvZd9uurJG1wEHlVawQUNrsCRaxUYCzkYI1?=
 =?us-ascii?Q?zxNsE3c6foW4bl72Tke/pBjXlRDbPFo/0Zdj7yCQwlgz3M7wOmgTDRl7o7K8?=
 =?us-ascii?Q?DPwCGDxvA/bMTpSN1u09InT8XDWyLtxVD1+kuZxwotxmHvhcGQYkOgV7cDUW?=
 =?us-ascii?Q?BDLhcYuSzO4xqC1PDAV11C6uu9BwJx9maNoTO3toZq6s/GxGOOLbi7Cy36qC?=
 =?us-ascii?Q?YqTrAhaRch36d2s6X7MErOF1eHvoB7OLBgI2OIcX9AgmnCPclC1P0dKSwrbv?=
 =?us-ascii?Q?8pAK/voFIjgkVRmmZKDvkvDwPmjB9487D/s98eN0wEslQIwSZiiJDjVTepzl?=
 =?us-ascii?Q?J0iC91YlA2aqzuGfuOxrKplKZXz5M0J8uUu387koDIYAh0Rrk/CZeFoxf9Tn?=
 =?us-ascii?Q?E+rfpp4+QwWSHGKiKOBgUxyuLNRo6oKDkpw+023l5gKNb12CUhRyRG36ET+v?=
 =?us-ascii?Q?h4vBNO5ySjwrTnNDqMFn6Yx6KNU968Yg/+j7JarXvHg6+R1U5Z9od+oGSCdg?=
 =?us-ascii?Q?BDc4ajmHJ6T/xwoKpNT0+3GYCwROsakwiIm2Z0tPoJyG/wqnKLuYT1yeP1lW?=
 =?us-ascii?Q?vj4nRwP1mI5mmTxKIoMT1vWZ6XWx1Gpr+5djPUZYpE2ga6+8MaKgcz0nA4ca?=
 =?us-ascii?Q?yFIEU3Sb9ZQDt4KcZ2rUQY1dhOxN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kdqr9vgndYSslZIrrU6oQC2XIFlZl/TZJaeQqS6ujvMyZFoWyju8sqLYKxma?=
 =?us-ascii?Q?YVe0AHpJVfAp3wiVapwRK7jcanM9uPTKDT35mSOhScllonLZx3+Y0o/XXCgj?=
 =?us-ascii?Q?8yn5tkYGJefeI3P5WIwycFwFrabhvugCCjiBGem6KUhuyxc55sD79O2S9Adr?=
 =?us-ascii?Q?pnYdwwKEMmiIWoxAdG/KhAWXcuizIQynmzKtPpnNQry3DL12Ff2mUN6vn1Bn?=
 =?us-ascii?Q?gX8HYfCDQQJ2Fpu4dLNgFZwSLeKuaiPnj7hIxwyS1tx3msF0WaezcDzRB/Wy?=
 =?us-ascii?Q?Tmu56pe4s5Pgc/wQH+eUgfHlzDSI6TIDubVrtV67J47cpPvIvZ/2ykkabxQ6?=
 =?us-ascii?Q?B4CoQfczysbmdXPSSvJNRRwSeVKrwCYuJuVJ+Tovwuw3IlcDw0u+o280bz41?=
 =?us-ascii?Q?FaziX1WMu5KXy2wdZO9Q8uza3NyQyMTKbQgOm4zvtwen56p9bwbrZTC1tyGY?=
 =?us-ascii?Q?HLsnnjK/XjOChvDcpmUtLddyPUlJCzk6qFdsdwPCFVRIJwhzIV6lv3StbhE+?=
 =?us-ascii?Q?YighqEl1IWlfCAwXriBhN9DEywOW6nN1JssMDMPHF7vTnDpcZuXx1HtdEjVf?=
 =?us-ascii?Q?8Jh1EzfTVzRa1untm4hIuZc0rSs1ZF0L40IEX1MPu9+4lCnTUNePiuR67P1J?=
 =?us-ascii?Q?yGZAU6/fkcLMyQC8XL58GgXo215R8geH6UEWvaWv2kzidMWm2UmnoEBMhGwm?=
 =?us-ascii?Q?JUvCjFT5Vv1xxcAGaXrnyp1goUTEe8z62B/984yZXzB8pRECPfLqFMvBNZRk?=
 =?us-ascii?Q?J4Gjc4qZcQoUnIYO7rJW4OOdv0FzSWpjRZA4obZ98/2IIA/P5r6jgNxz/VEu?=
 =?us-ascii?Q?MiMxOuEPVjmf4kCDYpsNAOGpjg6qXN1rsZsEGf9FUHY3+nCvO4BCyPT4U7jS?=
 =?us-ascii?Q?DvHOu5PMg8eSpqIV89sj/qH/5x9O6+t5Ebx0Y0J0d24BL//60sN+X6dznGIF?=
 =?us-ascii?Q?tVqkoX2vscgFybvvPcbYqLu/Fi/n5s5H9A+yjAFTUI+OMLfST3rQ2g1QArYB?=
 =?us-ascii?Q?GS/fwTPl8wPMUV+5x7uMHIARbQJyEGNO6vgpDabyOZt2kXY8djnH/Ovtjq8u?=
 =?us-ascii?Q?jzAn4H6dzzr9xB4jHrxTf8tlmLxemGPp55i/9/kbA1tKo29BOkMQMBhP9nKa?=
 =?us-ascii?Q?18md5ublzfvX14+e5/T7rOGDbPPYCxo8nKMNikc7gFbqCuDF3NzwITdFv3HM?=
 =?us-ascii?Q?8NEX88moHj1roiCowFcpOq9Nbvf9GlPt2RWH2kHtqNNKK7bIRFbvrKHU12+l?=
 =?us-ascii?Q?Q5jt7IwOTN9vvYlRF+AbS1YG9sjpyjrenqciQEubv5swuh52DJetGHyve4XO?=
 =?us-ascii?Q?4IeXPGskYHSN5esoxUrFL70+KpzNp9F+xU9kIdvTfRSLh7yMeQYXN6FqLsIG?=
 =?us-ascii?Q?KLDkjmjAQyAzw7fwuAk7ThEVs2ZGRt88Pyd5AgkiQMmZEZORhB4GfeJykWTg?=
 =?us-ascii?Q?whUE/dJ1YHZlpU0+5o1/v5YSZA47X/MmwkW32LM9emJ+RW2z1r14xoefNq42?=
 =?us-ascii?Q?uvr2A4bcWSJMf7565bdTvkPmvSWQds1SX0pEx1R3+J9orpEPK0JncWMxpwXJ?=
 =?us-ascii?Q?kSzKTAGcU+Jb0l0uN16jzzGEAR6VrB8FWC00a3YF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab026e0-4545-4c59-bc5f-08dd661c2902
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 12:55:29.2065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ywNt05UlXlpily98oZ/oJb+bYMF48Hq+UXiMn0wPe+ABW5iO4dzgFzyA/Oaewzee
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7900

On Tue, Mar 18, 2025 at 09:39:30AM +0000, Marc Zyngier wrote:

> The memslot must also be created with a new flag ((2c) in the taxonomy
> above) that carries the "Please map VM_PFNMAP VMAs as cacheable". This
> flag is only allowed if (1) is valid.
> 
> This results in the following behaviours:
> 
> - If the VMM creates the memslot with the cacheable attribute without
>   (1) being advertised, we fail.
> 
> - If the VMM creates the memslot without the cacheable attribute, we
>   map as NC, as it is today.

Is that OK though?

Now we have the MM page tables mapping this memory as cachable but KVM
and the guest is accessing it as non-cached.

I thought ARM tried hard to avoid creating such mismatches? This is
why the pgprot flags were used to drive this, not an opt-in flag. To
prevent userspace from forcing a mismatch.

> What this doesn't do is *automatically* decide for the VMM what
> attributes to use. The VMM must know what it is doing, and only
> provide the memslot flag when appropriate. Doing otherwise may eat
> your data and/or take the machine down (cacheable mapping on a device
> can be great fun).

Again, this is why we followed the VMA flags. The thing creating the
VMA already made this safety determination when it set pgprot
cachable. We should not allow KVM to randomly make any PGPROT
cachable!

> If you want to address this, then "someone" needs
> to pass some additional VMA flag that KVM can check.

pgprot does this already, we don't need a new flag to determine if the
VMA is cachably mapped.

Jason
