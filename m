Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EDAC2ED
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748305523; cv=fail; b=fDRTqypSMrebVu6w1N3p4ATZW9aXjiF9bQJNwz5eG47qrQDRPO2jdh1RIST8A1N4k0hwqJQe2suVX8+/lTDsJSu7gPcNmSxnP78MmWAjHl788cBCqcQpHB1Dv14MqTk6/Q4oBI/YVfTxhw3pBl9WfbVy08f1UNFys1jFtivxugU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748305523; c=relaxed/simple;
	bh=M38PkoY99cPvvK+pBySCkF0cem84uZcaGQvMQ0U7OzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FGxJAhxbHNwQMzmhpwSV/jnIeARNx8DbAprgT1V2Y0G77E15AqLdC6WssGOdGVaeBXH0Ux/pkf9PIE0BX89tC9rnIaVwf5lcAyzpfYS68WqvXzZsR3ebvPA9h0Fi3XYc67ifnMZtPm82LpyBW4kDm1ILCctWAeRDvhId88lRNnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ljHbFM9z; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ljHbFM9z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcPuKAia0jtZksqLs7DaTikXru34d7fs8XnT/AyuhdvRmzd24Ai+bXkiTL+lTcdQGy6YxFboKfptR1QNusEMs8d1DLapzg1cayqcUNPKByI1WAfH7WrLztlNzhJ539+tAFzLwgHlV24q0ZtaiCB2iicaij8sbvyb1w235vXwyS4KKKJ3pL1Bh7hfanCbCskM8P74a5y5dCrq458Oj6fo5BRqI0zIiiMBlL41Cc5frjXM6pt5Xy1gcIqzmcrM9avM7OSfjgWKSXaorL2coHhINNW+d8qY+QY5YWsDU9HN1lAc7TWLmwZylW5RtO2wip1127EHNitVO84VlQrQzIYJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGwDdhA8JKUG1L0c/8dKVYzDZkpAdvFhOKnypW7liJ4=;
 b=eunK4kGje434baRYO63Nd+ld6YSxmS+OP8n9MtZzbY54qJAW30sb8ICFEbvxbyUl6Ezu3iXZq/lBuM3+/GXE+018S7aINNy4edQ0jY6ze+uir80MMN0UWAfLwvM/Uf6Alig2JGZsfraRLATi6nOEgTH+yn0Js4N6BXe2IygaY1SwB/npTK76ZJ3fZxFtFGepadJ26phBe4cCNq7HrVVX4PccsSR8csim2ymq+tZ2Jn37jDgKsfvXwwoO3sx/V3XbkgmbjhN9Hl2OOiu3GYYc0dhGD05EFqWNAqUEdtoggaerBi1n6UUaEw9AtKFoaFRmE9fOkO5qzY2McNbVYUqisw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGwDdhA8JKUG1L0c/8dKVYzDZkpAdvFhOKnypW7liJ4=;
 b=ljHbFM9z9Sm7mUQhfjKmU7oe4rRRoHs0Au7o1ChinmZ6IfQ4MAN1uW5SlN13fd0d1uHQmhJ+Kre1hvqGsoSf1HFAZSSf71TzGw41IFxqqYy488HUNIZ63LPPq/CGnp9Zb3/MgnU44cN3AorGrAhvf8Id8ucrkAKxQDkrtxxI4SnGiKddPstJg8y071+CjOS7BL+i2efX2yv4R30p09E7ivqQpOE9qLhq3PkXVyqK4W7SdnfVTLdPFJbxvwOV09E5vHUkt1slbQTzrVoR1xZVTAtwKL5AADfx/qEKnaam4PfvnSc942xjwn9DHGyFj9ECZ3/BV7Kny7UclOTQ8V492g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 00:25:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 00:25:17 +0000
Date: Mon, 26 May 2025 21:25:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v6 2/5] KVM: arm64: New function to determine hardware
 cache management support
Message-ID: <20250527002516.GL61950@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-3-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524013943.2832-3-ankita@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:208:236::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 518ee70c-f2e5-4c6b-8d12-08dd9cb4f4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Ktx6bFnEMd+Tlm4ERv/278MyXbdJEi/B2JpEMrhyjxIAfZEfxuDVNkA92MY?=
 =?us-ascii?Q?+OKFKsoKHQ1bBzgn+Ra9XzeTg92iMLrGW56fnB5QSw9eLtd+n+0s1ILtrj45?=
 =?us-ascii?Q?L66vsPMBkPnJgmwgKWKrqjByJXgucqoDsijYmE/MSMERiOhju/lRfOyl6D/E?=
 =?us-ascii?Q?+dNPxM9Q2zbN1dg2G/m0/cyLt5Fk7kT7t30Bdv/2qGut+BqhfUNlTsCm3bUy?=
 =?us-ascii?Q?oGLbnmqLnNb+s8MVMtPgqMgWMe2QXf60nHpzqKBujBZW1IJGLkNgpI3t8+Ls?=
 =?us-ascii?Q?cg0KCYIx9pq5vSw/u7Tdm+do5Lb6MnT7C4l/Hu8AbCdjwjqgaanSY8MHyhHo?=
 =?us-ascii?Q?oHHyGN1QsPPStpElwifNmUtRophcgJojjkd0va0nbtiyHsYqHEWLqFvG6VC3?=
 =?us-ascii?Q?wnxTnB3rIsMzonM+byRGc09ZqBw2egvzDrhguBBVQ1HyADV6LDnNxXDT/9zC?=
 =?us-ascii?Q?x/JrdXAC0Rhl+PlOBh7tjz46jNnHVmeM0Er1NPIbTDSaB7AXO5SNYISwgksK?=
 =?us-ascii?Q?gGklP5B/z221EiYYimC8J5hbgCfLvEMWZtVllSr2xyRtHyYYLyjKMDqHAXn8?=
 =?us-ascii?Q?R6KqeDh73aTuMifB9eIsJ1L9tBBFk+SSp5U0NVMSECr8VUtCfxt1IjiZK94p?=
 =?us-ascii?Q?tKbKhjAX8jpCaZDI7JgmZy3N5j/jM+KZKg+wM/WmkagxAA2q5Kr41KxQ2fYD?=
 =?us-ascii?Q?SSi00uQ4pd8FcGjcN6zRehOdgoS1GnLqs0ugC5aXui9ziGVIRa2PWfu/gwfc?=
 =?us-ascii?Q?YqyVA0puB7jH6d7kfcMiVYVpuqXh6zOxwdFNGHxX2uTLOOnc7pwKhnScaZdS?=
 =?us-ascii?Q?cBHUEhMsKc253l3iV9HG4nhLGuTR0/FQqSf3dLEHDMDNm2875/Gqhdj/Gv42?=
 =?us-ascii?Q?v8FYqi/3UZ0K1REo0gyTpkGKHF3adGuR3JYlA1VPY++OupHKoap+pEzeXMs2?=
 =?us-ascii?Q?Wm07D5Km3tMsUpamEHY3rvrwwFrEhmBoKUv7V6xh3XNv0dRn10syh7nzMQJC?=
 =?us-ascii?Q?yc8jyRWImSi5TjNpOKEqETkKde5KVD6DKAWlEYhnfYR6Iy4cMP9KJWNUki3C?=
 =?us-ascii?Q?BNVq9Ezy0Pc/Hkp+QBF6/AE4KJRFBBBrpXp6JIlzRyLDzhAl4PxmSp+7RKXy?=
 =?us-ascii?Q?Z9bC7muUN4VnvUgSsHm2x365qfZp9gtpVd1SKC0vhPL5Vfpdo/LeeDsAkrdr?=
 =?us-ascii?Q?cAh9nIwL+8A+VXcKwWTQD4zi1TLHNlA9ssQeonD4G7SnTZyAa73HpzhEgufi?=
 =?us-ascii?Q?CjitgjkS+C4CD0jSVBKTrAKd33blbogMRZfdSUHJYs1s5rEH0F2pep4yLbhF?=
 =?us-ascii?Q?s7yHhOT4/04Y6au/VhHPrsl9zyo2VOFVJLYA4wD+7AbhygIEzWRY+qPh3UHo?=
 =?us-ascii?Q?O2QtNW7sv2xbo/f2SDKek1pcFGQa7ET3jlfuSFTa8U4iPeL5bb+miggmKOCA?=
 =?us-ascii?Q?KcVlplS0cxs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GwIKKlveGzXPXQZbp1S/4Fguwox5GXHpF2J+Pet3xHhjC4S7kBTHzwUvIEc3?=
 =?us-ascii?Q?hY/he8uI26VHcUAfl3DVu0VNpzbs820p3iYZidj9Zyauk2iOL/8z8BDlm1Y2?=
 =?us-ascii?Q?gGrJcZYDvqPKH1Tx2UvKlvrmiq1SxwpeMxsjNJSUmAJgNQkpT9Ccnh59EO+l?=
 =?us-ascii?Q?AhTeUo5oQvuJgyic+fphwlu+NYi70n6IvtDN4f3ZNFF+wc6rPThGqhfGQ2Jz?=
 =?us-ascii?Q?RB9t2n/taicat2TWJbzyjshsEqdqSW4sj22b7bFa3apnOK6fLyRaPzg+r3Dh?=
 =?us-ascii?Q?SEmmusQQHec7x9vc+oad4Qv9Vg+fHaZdrYcBq+7ifke6s41i+gZ+fA9ddLUf?=
 =?us-ascii?Q?OY73HmMmluS6FUCt48KuRbdziz50QuDrGC0g/Cy1TO44iO01E4aFn7LXa+sO?=
 =?us-ascii?Q?UKmb3ONdIh8L0UX1nnf+OW34YZHFwJtygRdLe/G+g3ffl45INOAClkCCuH3w?=
 =?us-ascii?Q?IIYWpV8M7Quu/mFhkl+xSS84Lt95Rggtn68MAVzR5IVVypjpkN/2TfQviftr?=
 =?us-ascii?Q?MFkzkoqmo/kfe++y9oZsNtmq+2ey6FEa1m5xBwk3+5pateKfwrdqqpGW2oj+?=
 =?us-ascii?Q?TSATZRyw+ISSI0FYCK/UkTGoH9GIbltRerHk0zVdqp0ZiYn+lMcIN09pgqOf?=
 =?us-ascii?Q?cSfQH1imiKC9GlxUjCEUyExG2VCUOsDiJtDVMJPxEpS9877To56aA5LUmKFr?=
 =?us-ascii?Q?dtD5+D/ril9NarzTrZk8Cx4oBD3fMFyqcO8YXoH0n78GlixWdnD1lPqoN+kL?=
 =?us-ascii?Q?prCWrLWtiAdGpPWeibYQ6HYjK0XY8eGkyzwP7F4Dp0v+gMHosYZG7qdwRbS5?=
 =?us-ascii?Q?1WNIKhcL+QgM1bsTYxt2iaXu7zJu7XZUdNJhfdFXjyrjFSwt69q0wc/3zdmZ?=
 =?us-ascii?Q?0EQl1xlrsR8ibcduoiduSZbHJVi5w1JzJwXyuOWoq2vQ1AipgirAl8AnhZxs?=
 =?us-ascii?Q?aS/D0c8Wt2MVkqpWiVOPXm12mxwGcTsXcja/ELVsqRFrt7Aw+sR/4A0vaGJa?=
 =?us-ascii?Q?/ASBIOJhF5yzEYcmKGxdljANfF/0B8xwIO00V3odlKeqa2hpMvOHt7r8L276?=
 =?us-ascii?Q?q9txIiw4B+3UjJIXEuWhKO2vt6Bc8VqUcaLvAMJ2wWp7nnjiEzQIy/jIb4Mb?=
 =?us-ascii?Q?LyV1AILuVW1hQRNSd8nvKQMqFz+67x2Xwf0/r+6rV4u4xuos3s3MnRw0eJTX?=
 =?us-ascii?Q?wCSv9XcKNkW0MqvPIUeiFbcTQ0cTxe4dH+6+Sfs/rUfiY9knFcqHIg65oPuN?=
 =?us-ascii?Q?l9N/1B64rP/ejw640dh+HF5Wj8DGAj1TuwSKtNIDOQ55kkq0HP28mRwNdHP4?=
 =?us-ascii?Q?5bnC5d6Ne1xPzE0EX6sc7MXxI8CCestFTmmzTyhT8pKPVkVIYPXGxky6iYrZ?=
 =?us-ascii?Q?UJqrnuBRqEn0G8GN6FbZezJVzHGH+XXe7ya9KOdZ1BqlzU4AHqBeZ9BXyuhc?=
 =?us-ascii?Q?tfMVaevof6Thh24BeDTVHPsr/OHW6t82YjDH4enipgmKkHPv1sGyulD+X+5W?=
 =?us-ascii?Q?6TO5ezPhmA/sSeZPzljxbS2RL6DG/w4zUFlLsClYOTijstlf5mDr2w41V/SG?=
 =?us-ascii?Q?A1M1sVrGYNtrKPZfkQhHqRHSPZL9SmL0OA9O+1kE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518ee70c-f2e5-4c6b-8d12-08dd9cb4f4c1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 00:25:17.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snyoknmBC44Xe1Wjz4qfdA9Y0am2SEJbLS1jZ8wMj02DochIbDtwDpDmRtP8P2XX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

On Sat, May 24, 2025 at 01:39:40AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>

How about:

VM_PFNMAP VMA's are allowed to contain PTE's which point to physical
addresses that does not have a struct page and may not be in the kernel
direct map.

However ARM64 KVM relies on a simple conversion from physaddr to a
kernel virtual address when it does cache maintenance as the CMO
instructions work on virtual addresses. This simple approach does not
work for physical addresses from VM_PFNMAP since those addresses may
not have a kernel virtual address, or it may be difficult to find it.

Fortunately if the ARM64 CPU has two features, S2FWB and CACHE DIC,
then KVM no longer needs to do cache flushing and NOP's all the
CMOs. This has the effect of no longer requiring a KVA for addresses
mapped into the S2.

Add a new function, kvm_arch_supports_cacheable_pfnmap(), to report
this capability. From a core prespective it means the arch can accept
a cachable VM_PFNMAP as a memslot. From an ARM64 perspective it means
that no KVA is required.

> +/**
> + * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
> + *      supports cache management.
> + *
> + * Return: True if FWB and DIC is supported.

I would elaborate some of the above commit message here so people
understand why FWB and DIC are connected to this.

Jason
