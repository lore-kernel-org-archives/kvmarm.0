Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C71A2D5C70
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751636869; cv=fail; b=CCq6a7N/HBoAkNYsJVT2tx/OPXSjMkMjlXaFnS4O+h+RUnunsNnvLD9rDt8JrJTXPM6mNukOlpv+S/uqYJ7WhZJ1EumXWVyPIfAsBmWPtqP65cezddZjQ42ZxPywP2XIIM2AERU3/Bs3/7wsD1EJhxPqByxm8otEaehZAOKpoQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751636869; c=relaxed/simple;
	bh=THUoNWP6+YH8YUXjFE24f5/hIcpp84hAJHIJngKNVfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o9Qh6isllVqHSG/Rnq4eVwfLOnomhVJuRnjBsXk8IGfmASIRvgLrJWfO+A6+kdmFqhs6KJKJejWLgwWR2GxvktWz1XN+0qwDOWl54HIbpD810mKHWQfiVXa01T5YGl05PQsgCFDx9xxLUbugPxkKGKnABGpUYRz1DBKJAcelt4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TB2hEznH; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TB2hEznH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEKI0E3FYRIhth4DPK2SG2zEOZqNC0jXsInX06cVh+bCfusZIaLH4UQhlPnk7beNYtb7YKp+b41Qe29aSy1ynEnprXfnPx2nLC4snbZh/Io7Yg3hxDaNvuE584kXaIkhMZPhESasKVWJQMiAGRmrmYIVQFs0gW61FZ4GGwlkSMXOc405AGP6sQ/HeVzWOOd3ZUZcgeLgNiupuvamCk/4xJ0PfxGVbxWZ0/cu2TFvXwH8fLXIPz6DInpZ/A8KLLKVrk064+lE/PHrAZZwnf475iZ2MkrGZUORBE2DVzmmu8rYhQunl+3hT1nsZLo5olxu2ukokfccnP06Pni8O040aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrVWBPfkZG2YTS29zTaM48UOtOrXQm+m5Oxp5k6Mxsk=;
 b=Ua0luVwuCqvASXO0Ze0aQTffjhnFmtRmNHKLEjUVVEjXnSooKWB3raTWadOaXE9qT0PDokjQNYYbyXmNziedYNDitXmRxbBJOr2YiMkbOZaausJtSwomw+zHTqk+kJGc25hBpGI3+gduIEkUsymLSA3TK3QZtUQYQlD3d6SD0S1cbeYRB2HczWe9L2SMM8lgKdyDyGsJsE7bEjYdR0GckZo0uiHXy3/O0kek/wzr4rZZ4Uk7CaDod9yj/fPh+frynUmK+DQHuAXlIDPPyNTQOkTn4XI1tsSu2YBhOPWQjCrsKq7JUo0GfWg6y4YX+n2h4psgZ+DZlKUVwH8PldHTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrVWBPfkZG2YTS29zTaM48UOtOrXQm+m5Oxp5k6Mxsk=;
 b=TB2hEznHCCj/9coMAZJiOIi5YuZ1pzxLtuGwu0xSFXmun23NrVctSz8v798y75ru4N4DSD4f4UxxVUFnMZ6eISRqaT0YMAAgF6SIJX6lLQQshWpU9mKbie9hRJsQzlAyZvKCOma+5Z1Tpp9kL+zo2Ea7yGlI/AYb2HALbZDJxpAP1lAGTAA6BmFqgxgWyjmDD6wKQshMVdSsjVuPRNw6LJr2CA3r8+k02ARH71i1oQnfq2ykH/Xif6tvJyl9DPjrAMHMAX1hMB16EReIY7hAcXPlHiP9b61eKOkvzwmbIpr3ACsI3mCov+qtGPDJnnueiyUlk0n06jfqxOfE+2pIjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PPF04DCE520E.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Fri, 4 Jul
 2025 13:47:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 13:47:42 +0000
Date: Fri, 4 Jul 2025 10:47:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	ddutile@redhat.com, seanjc@google.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, kjaju@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
	dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	tabba@google.com, qperret@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v9 4/6] KVM: arm64: New function to determine hardware
 cache management support
Message-ID: <20250704134740.GG1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-5-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621042111.3992-5-ankita@nvidia.com>
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PPF04DCE520E:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ae90d3e-e87f-4975-162b-08ddbb015947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+sF5q/XYMTgyiLRYYe6lvKL0LCGNQo0qjrfkv6yMKxz/v216UwxpBlE6jjxM?=
 =?us-ascii?Q?t/ItilWTq8T6CuDXQb9MA3kpS5RdU30tQLTfldv4b91WwY0V2Dx8qvSr1ZjS?=
 =?us-ascii?Q?YUr+2z1n1us+508eavxyQVSaxlTQ1kThxEgvY8UdpPE128S9raRui+WIZp9M?=
 =?us-ascii?Q?dmYo8yVSs/zjCRHz3IqBU28R6hJ1WwE4zfnwNiL4QXhfvcv5pfyI3dHL2h5W?=
 =?us-ascii?Q?+65FbXhbAOVAOgREJNcsq48ccD48OnJjdHdWql16aZfpTNb5FPHzCFjvoLiT?=
 =?us-ascii?Q?AEiPt4zqexfqqfvMnK5laCYItqmfbbejIwEXoT5SlA/14RFnwk3wFlDlmJYU?=
 =?us-ascii?Q?zl32gDTxjxS+xEeYnG2KICWvaP6tEqzqBDiKj3QHEeuvqwW+O7uwANMa+dVt?=
 =?us-ascii?Q?sx+j+y3Y3H6RVZEQXT0o4QCecYmmfFJHsV8FRnDYAEZj75LbzXpzUk5sbg7k?=
 =?us-ascii?Q?/8Sz5+dl6G8MhrwCy9HrHQg2dzjIl9X323ZjkNBcEgTWRxvK0firPlC6f3id?=
 =?us-ascii?Q?8aMP+5iuqZ2me5RKvIykuP4gakGBpNdvHPs0BFI46vxJNnXciM2a0RCIwcXZ?=
 =?us-ascii?Q?ZYErE90l0BXQM3FHItu8vbnQM8+8YwoEdX1gM6SDp2y29HDmPFkyCj2ie5Xi?=
 =?us-ascii?Q?B+u4dsShwse2Qxoev8BliG1CUXrREePUoqBVargBrXJdz5byToCP6+8kl0aA?=
 =?us-ascii?Q?RMfxr75w9rYPYrpfNHCbHF6ND28hh7aYjQfgMiyjDKWIZF2sMk2PCMfnyhmv?=
 =?us-ascii?Q?ffkjWMy2wmw/mw3+kYwDhLNKj5zCEJkirja2RIDMTnLqWgxkdklVcbIMZKhK?=
 =?us-ascii?Q?hfN/jZuGceknSDMcEi83vQT9jNc1Nuxi689/ehtLxvzQkxzj2cxkNFCnuDop?=
 =?us-ascii?Q?yRjZlCXLX4hUyYERrOV/CtQ+6whAZRgO5q1yaMU7SGtGJUAc2fMz/ZYUHFWn?=
 =?us-ascii?Q?4uC7rfM6y27Nb/nQaee23TSkxD6syBNz9uyB8No7Ys+mXplTmzXDt4x5RAKt?=
 =?us-ascii?Q?ClY2rZtf6uL9ohN9951X5SAJ1t7/QrgyCSdxNgZyFgGJ5uUo8LVHeAQOCKCj?=
 =?us-ascii?Q?tEFCZfbF09AAU1mC7mRVfoM2x657Kbp83MBP6NdfALhjH6BVnU3SLZkohbpw?=
 =?us-ascii?Q?0Um9jP7y6ARYinyDaaDR+cvYoJQS+p4NjLxkVj5d9sfbuC/I9TRRhGQSzm6A?=
 =?us-ascii?Q?Vnp5YxEVLaVZ/Vzrt+OK/h46KPRBIe4xAZKuG6uTqDjcum2+nv+PfHTPCJAS?=
 =?us-ascii?Q?C/5cmYnN67MwOqrpmHj2bdavtpTf1vDyxnRcYEmPEOgj8tu7xNcCDiqenlQ6?=
 =?us-ascii?Q?Ty44p5mgnruewsVcYYNC11NZrtaTtKhA6rZBIm2B0YIUfjAnB+q1Im51vVb9?=
 =?us-ascii?Q?fbso3EF3zFnuInGbw8qLn0q8e0lxAD/qBMkSBNkJlSLpa2fHBr2+dTZT2zno?=
 =?us-ascii?Q?bruUtVhXdmk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eIRzgsJzwYFJeadB9YG3LbkDrTIOtJoArTr0FpCwchl+Gn/qHUvXi++81hmH?=
 =?us-ascii?Q?5eNtGjZuPtResGLrEnupAlY7RMuYeadu0uAXZNWs7K34sXlIX6wXq5A5KCHK?=
 =?us-ascii?Q?CZ2IbQX34eXIneqIrPh/Mwwqe/prwxzypcZBT1XnN2WWoD4apff81PkmtcAM?=
 =?us-ascii?Q?ZPQNBHb8CrCtWT9M8zBUEvLtTPISgooIlvXBNxaAB4TR70BZ9S8I3huOUBc1?=
 =?us-ascii?Q?2IFycwyUgJXvqOy6BvP2GGpgYo5RsKBZLOllUZQ7khQnwQ/+NArJOYGLWeay?=
 =?us-ascii?Q?tI2CLciH8tiPI6DFXCi6rbpaH9FKoSjqZZJ7/DB10IWcjHBVqbvmyl7CxA8i?=
 =?us-ascii?Q?uHXE6M/9AcXqMf3ojUG736GZVd28isL8MDtnCYlM6iGXstSRD9zGY7K4sbjP?=
 =?us-ascii?Q?XYse2PV4BDdkcF3XqqDd9UC2sJczGlleuHbzAwiR8Jy9CfwZgOkbu8o1W93I?=
 =?us-ascii?Q?xyqeCbrcFn2nzI8VJhyw5BXPrMpNxZDTgGAqx6q7CqLViAEWJimzS0mSGrDH?=
 =?us-ascii?Q?Ugu8G4gfSgEdQAP4OozXT9Sa6AXew+lGzaWuRJS8t4bNGdaxc8LKGbVemYmK?=
 =?us-ascii?Q?Gfck5oZTdahb71XCBzJpKGteqenXxPGLJgTGbV2e0l2j6ctwTjVQZQiJvHsD?=
 =?us-ascii?Q?Su2AK4lUZLdBKBlkN3UF6i5hvyG8N9hKXVxYLqldmaG4Ut7tnmtaLcx7uEsJ?=
 =?us-ascii?Q?KSHygvjIAEN8U2uz2GcniZVChE2GoW6lkYC3J09iGupnVsyih2TFKujD8MkR?=
 =?us-ascii?Q?6tqrT+tCFiFd0f6PfcmwFJXVBNxGpHyh4TchlP2GKkLYELly/TaXlW8aYy9b?=
 =?us-ascii?Q?mdlhfvXIy6E5gRRKdXYD4R6dHI4CQRd7WHOztXadtj5KpvZXHeTCcq8m4XTY?=
 =?us-ascii?Q?l7e4lTyBTR5e04+J62E1fNlWYvUzeTy2X9690UNi5an5Aq+SWz1xNJ6t63mS?=
 =?us-ascii?Q?LG6oxB6x8NyNBhGQXAsR4U4qGlnWJJ+JIInwD0CUE0JgxOJvi/rFHhUPkD2h?=
 =?us-ascii?Q?Ov2gn9TeKlzHLfEzlP9rRtmrCHQ2D9E5BBKoMQJos7aCE0p4OJRZ82bl5Mkm?=
 =?us-ascii?Q?TeIGoM84QYMB8IiQRIAM8TLZD09RPMZ0uLz0ETGEFb1nDLylWxj8BnM5FC47?=
 =?us-ascii?Q?VmBs/ug822dWumUwasDutxieDpo39sFJk6vtQ7WDWIZQRn5xEeOKkF38Svb1?=
 =?us-ascii?Q?a9farh7oocq8wTV1988CpifJBhWO1fD+qQgKcMPphWb5rxLkKHBFe8iRyFla?=
 =?us-ascii?Q?Kw3RlalzMGKpL/QOYuXxwtErzS5XE84RXM7SnoMDVF+6f2dtwszda8aU53M2?=
 =?us-ascii?Q?9YnFEODO1U6GDS1MQeWzDwFIS7MjGtT2UtwjjzMrgsl8b2jiBslV3Fi5DaqH?=
 =?us-ascii?Q?ka05d9MM5+VBCCxEdKTUwUvy9+lKS+cWFPtKCX+BkPyleCh2lvGn2IqUR+nv?=
 =?us-ascii?Q?jxxiWNWFJHYObHT48CA1a68+s9NYiT4gE/8m51jjU/z9PEjXweWPULFeOr1e?=
 =?us-ascii?Q?9zcltins9sQjsIMU2kS6ZcCxQ5eXeQZYLqu+drNDUjW06PowqD7Fm62drXqq?=
 =?us-ascii?Q?KtvYLVOns6/DXfppvXE7K6BYizKFfGSGZxE85xw2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae90d3e-e87f-4975-162b-08ddbb015947
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 13:47:42.7590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBfkyeAr7Ulnd/rBUG7PT/ZOWCsjdF/rTWlJbuqH7/OLqUZ/JDxCadMBpLOuDrx/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF04DCE520E

On Sat, Jun 21, 2025 at 04:21:09AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> VM_PFNMAP VMA's are allowed to contain PTE's which point to physical
> addresses that does not have a struct page and may not be in the kernel
> direct map.
> 
> However ARM64 KVM relies on a simple conversion from physaddr to a
> kernel virtual address when it does cache maintenance as the CMO
> instructions work on virtual addresses. This simple approach does not
> work for physical addresses from VM_PFNMAP since those addresses may
> not have a kernel virtual address, or it may be difficult to find it.
> 
> Fortunately if the ARM64 CPU has two features, S2FWB and CACHE DIC,
> then KVM no longer needs to do cache flushing and NOP's all the
> CMOs. This has the effect of no longer requiring a KVA for addresses
> mapped into the S2.
> 
> Add a new function, kvm_arch_supports_cacheable_pfnmap(), to report
> this capability. From a core prespective it means the arch can accept
> a cachable VM_PFNMAP as a memslot. From an ARM64 perspective it means
> that no KVA is required.
> 
> CC: Jason Gunthorpe <jgg@nvidia.com>
> CC: David Hildenbrand <david@redhat.com>
> CC: Donald Dutile <ddutile@redhat.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/kvm/mmu.c     | 23 +++++++++++++++++++++++
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/kvm_main.c      |  5 +++++
>  3 files changed, 30 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
