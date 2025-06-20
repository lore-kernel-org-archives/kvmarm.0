Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC661257AF2
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750422028; cv=fail; b=blv66hfr4snalegIE3zGrWtcsMZ3J/6Y1bho/hJUkREGr/gfElviNrWnGz4IjCRNegJLLcXZP1SmtJb7iZoOB83DcHkpFnlgml7rpejxZp9aFCrd3/TUfvHiBUK+lWqXMq4d3iVYGhnaRARbjSP+RmYDik4oW+Xca52FqDyCkQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750422028; c=relaxed/simple;
	bh=EnMFChWHBlz1SHelTUxw4XZg/tQrSf7TUkVI7ByQFGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kueSt2LpNU0X5wIdS5IinvjwT53IqyV9yNmONjuC6sUZN42v3FP2zjpDoOH+31Wdmj/W6O1JfQW5bXJMAE5g+lQJ5UN7chaS3R5FOQCRd2/RY/b2qWYUkGN+1dVq56FYIND49Ir7Z9RhKqPZXLbWZAspCkaI6tfyV/3Lh8DkHYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TykdG6lx; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TykdG6lx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dwnv2dGHSjbZSnstAS2qmL3ld6ct2ScfHxXaDLw2FQ5eTyRlepczYNxIcwIwQFhMDHwo+848Amg8zmjV5oHUpMHNtV3yfgA4tiG9zeILDPFcezo90LFEmGdpmVX2gCys7TOB9twmnHX+oSEKKfWCKJI6U6RWcRZBph9uS6KvvCnwTV3LjMKV824igwenipfV4YSW5NirNKoZlAat3LOWQNxE/BOljA33V/37tMfO+0J8bHZ6KlHHp77WT/7h0Hr6tl9zhOKkCSIPsgyF5CjQ8W0JK6fvKtpu67Qc2XzcaBPLRpqWT8cfEf0ibuHDXA73LmMTX1zbov2pffEuXARuKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFBGszDpx/Zh/wqLI/sYrP44o3WX48AwLw7oNwOYJ0Q=;
 b=ubBh6YJK1v/DFUdar6U84gE1CUI6N38IYSJLtqpkQkjNPyDHY2xG2Ipacn6TRnbnY9LZW/ymV0fyHnKCVsltJ47BFNehTpVcAKM6y2huD6OaX++mM7GIfUCB0RJBSxQu1JfNlY0yO7lKLsJGgNzvGW97+cSw4M/5vuQZGuUV+zSBZzS4CJDKeCo/Lk4ZXp9iJOFObeJklsygGimmL1dOJYNOzHhrfdBTg320xg1eCymByOVxxZDnJNKpiDr6tOelJZ+1xDQXcWEIIBl8dXubNAZar2LCqWz78m/ztUOVOcPqraqWHiv5vcT3F3KEjsvTJyL6cC+lrBh4XN5mIe+62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFBGszDpx/Zh/wqLI/sYrP44o3WX48AwLw7oNwOYJ0Q=;
 b=TykdG6lxKP31CRYlO0VtXFzuplpCcd/kkNLhvPrupLuQ88cAbaJrQ+lzzHGLIG51qAJ6K8UbU9QqZaTRQOSttAuHbxN+dRKdrizQvgeIqmDP7Q7zgBRlOybJ+uvcEcSKZzdWUc2NgzNl3DpcuQP4QBDW7yAT8wAhmBWIViG4j+GErNiUtbLMQaqjPjc15KkOK0hUWqqXyyCC4dHf79Ci/TVjC826l/hxzYCz3pwX0UVorbRb5MKrLATQWGpCHfhbqEeuo1aVWknE2+ncfQfleeSvNiL8eXO4dZkTMexuioUt7f2oaEofo8FTsTRtPlGVA+IRxwE3QRra8eQmvJDYnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS2PR12MB9709.namprd12.prod.outlook.com (2603:10b6:8:276::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 12:20:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 12:20:18 +0000
Date: Fri, 20 Jun 2025 09:20:16 -0300
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
Subject: Re: [PATCH v8 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250620122016.GD17127@nvidia.com>
References: <20250620120946.2991-1-ankita@nvidia.com>
 <20250620120946.2991-6-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620120946.2991-6-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0444.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS2PR12MB9709:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b784986-6386-4183-ec3a-08ddaff4d1ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TTIotCSK5qHQJojBOmeraIiaISTlRB+l03aA8vvUYVGWXL/EyLCRVsqrgON8?=
 =?us-ascii?Q?Fu5CiWqmuON8oedtqo0ekYaxExGia/rruIqszYtEhPUfZtQA7bu1TjB7q5+k?=
 =?us-ascii?Q?X01xNJN6hRYVLSAdhCwdF4KG8EnVv8kXKDWxwkRV59wdA+3J6mDPUiQ0RsQ7?=
 =?us-ascii?Q?+0ePekLvgeX1et+16rMYiTBMWvsHJvJfNLlP4lUeD16m+4IhZzBnAYuzSeuU?=
 =?us-ascii?Q?Va3yWMdmJeMHTDPxfG5ZXZiyNYUR7QHVzqk44xuyivdPf5QW94gjN9CttvyE?=
 =?us-ascii?Q?nPSKow/WfKW49JVq5etMza8Z9Bs/1reRhcP4xWMc25rZ50tsk6Sk1NsOysJa?=
 =?us-ascii?Q?Jg7RRE0EYu2e3pGZfJzPlYD5IpTx90tFcv9mcBCb03XVdB06Iiwv7e2HxJ/+?=
 =?us-ascii?Q?vsBLwnEwZ/4s4H1JKSLN6li6jPBpIcrThynmIAs6dEc6R/Gh40evjkJzWMXV?=
 =?us-ascii?Q?dqwDORLzropASKfr0Fms4TC+WH45ECJIf5v0TUUxBEct60tSYwrcq5OJ7zL1?=
 =?us-ascii?Q?hEzeT0yVhXiCkd07nSp8Y6wdBzRkyzd+CQodzkHWSoAmtjxD4+iHJRiTbJB/?=
 =?us-ascii?Q?M9lRS5LtPvl9G9p/1t3SzuhwstELzpFGzqzQnQFjRwnoLALozUdOlG8t0LLg?=
 =?us-ascii?Q?FITWJWFt/ZkedYSRZVlaO56hsQ7UK7jRJVmix99Kmq9AXtgi0WH/zHJjTqTu?=
 =?us-ascii?Q?HuXZAB9ppid2NzinOzWLFU1nSD3s5kSkvMgooawm+KuEmfPpRie0P9I776Ku?=
 =?us-ascii?Q?oCnbOm+zuM3utbyGE3j5sBb8IuSNuChCgNp2bJWyITHnXEpJFd3XXCXbHNCE?=
 =?us-ascii?Q?/ThkyBKhhaSu5U60DtwYkbpc0rrNRx/uYKoAF4qiqyReTQY7+ZCJQ4ArmTeB?=
 =?us-ascii?Q?lkHU8RUOzF+QUTodjfGSgcUQujhd8Ld2oOygTVCpfYgspw9/xI4llaaInmDB?=
 =?us-ascii?Q?xVC0WpUUKP3wvW9fvwspljxOplWRDWUHEpbg/d6ZOSdxPeXOPosuCxK9KCC5?=
 =?us-ascii?Q?Mc9hxwGC+vShUm3a+SgSXUX1cLN4XiPfrJ+PWrvAHNbv8OwMy4WPhzbCzpGJ?=
 =?us-ascii?Q?9vmP/XVyi5cfFJAQ9ShoFiV4Ne33HvsS7zs+60pWaGFtjeVcq5AMQsrc7X0z?=
 =?us-ascii?Q?H6G4XyaM89NN/sLlLpoidFZEiYb1ZCFRXHdxGOXLwdMxVwvTO2PArFcMYUg0?=
 =?us-ascii?Q?JpEknL/DXltSMpUNkVSbqXG2Ks5++cmv6M4om4B3jgPpBlJIUuJ1xKZGDVWO?=
 =?us-ascii?Q?CpalQRcyP7PokAVoXaD0v9kLyOwQ0VyEQxVpGm5a9DazRvnWWzFSSsa3IMw0?=
 =?us-ascii?Q?b6b5hKOWGh12ViG0E8vbVmu5TAKQK4ra2hN7Xvs7y/MoFWTDMqGiw659YXtl?=
 =?us-ascii?Q?C4mmPAQ6QrmnSfRF7pAaM4/pnTmb/+VK0LEEMf4QePw+jmXSaUJ+3pDXOn78?=
 =?us-ascii?Q?caFcmg9cHSw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4+iZ59Ccw112MCylYbdN4rFsxD8eAoQ7dYjMZrYoWz6mmZ7f+nGPGUErJwaN?=
 =?us-ascii?Q?jlOZHpdTrFXAOFwZYLRlWJQcQSFuR0WOxLzFuwPy1lof4THSRLGXWALsmMFH?=
 =?us-ascii?Q?QFIt5PClcQecVl2vKL9nj+29dQWYRBCRBQgrK49gVgwMhpsdLZ+0CE0ihcmR?=
 =?us-ascii?Q?bCbcYNfyymkjBDUc0JawYLp9xfI/Z4pY/18jI6kwcPjKaFpLpAoDDJByzJuY?=
 =?us-ascii?Q?Fx4f3i02e124iD2rtJpGFXoU2MDrsitu9IrJBcexdXZ1R6Gc/EIwitVZhyWi?=
 =?us-ascii?Q?HKNQ4Wy5qIYDXfTgpPsgpVwzZzd+SEVCtKfDJPRksJ5Xg5N+9YDgH0DJ38Dw?=
 =?us-ascii?Q?4yCkUhd9eyWYfGq7NIwiunqiXxsKe6lnplB+Vya45ZdSvCyxNHj6ANMiQ50f?=
 =?us-ascii?Q?LQ4KcZIxlndrVzsse/LMOc5nR1BY2f3/cskyXmfQUzMD78gS1EGBcDMwjv3u?=
 =?us-ascii?Q?VGKm/GXD1dW1kHS16Q7tDOg8To8pP/0goVaD2z6ph1jiUbeMdw1YSX0dMII8?=
 =?us-ascii?Q?MaIic30FUrORBaRMHBCPnsZRazl4jFXy+WJA4gmZFOsB4NOn+MQugm1hSdcV?=
 =?us-ascii?Q?7c1qvI8lrsfy+/1gKdYsu1XFfWPrihXHd2FTxV0hrAKBL8hblV/HztbmUgBz?=
 =?us-ascii?Q?RI+U+XPYm4xVSghQ+P7CyA4fycGqH1ExTh+7zzGKxOb0Hi9btwKJNElxs10Y?=
 =?us-ascii?Q?f1ZwJZXCOr3VJlOU6JnhK/vdElrY69ta1+YMn2QaIAG9LDdTpTUzUJHkJCpT?=
 =?us-ascii?Q?rfwHdujPgDo+KsSk73pWZ4+SNyG0qbnQJPhZqmS7BmvE6/2rmjKQ8oYBYHa7?=
 =?us-ascii?Q?d8C5x8oY8NdY6AyyKAjRlUIJelljTQhsuDAuTxbrLrqXZDAJG4rBJ4GQq+/O?=
 =?us-ascii?Q?AID7ajz6lLboaLZl6CXFRZ6OV2l/B6fk9i+CF/0r4MVmeukk4u2OIjwjGU55?=
 =?us-ascii?Q?GoR0W2WnI0n5Efh+Lh/2PhA11495Levdxq5cjqfvXAzdMX2gAs5aUBaoij+L?=
 =?us-ascii?Q?SymrkbbFSPf/Ufk5wq5+gmGth0yo5h+d5dL3g/3Fv+Twkx/uPL5LvZ3Yy5Z+?=
 =?us-ascii?Q?icH4vq/bvZijnll+IJS//9DYpgdSghjcoHoX3vOD+TNXE1WaVZAvv0LL+bna?=
 =?us-ascii?Q?c1HYtQYRb1mwSaEEf68tgGVKIMXXYk/wbtO2MMGQWCQ10C8QeYKUx52NCRZY?=
 =?us-ascii?Q?NxygNNnDAOD3v6TueOWMktkLiu0aCYEpwy1Onte+ljD+jeQ02Ty3cQEIUtCS?=
 =?us-ascii?Q?9+xakaDnIK1OSNToUgOPGZ+uG0PHUWdnFBrhWcfQFbhzw2C+F6wXYMxos8G2?=
 =?us-ascii?Q?CwbXEBMXIUDXLV0jLduMm9llCd1+QRcf+YYe/g7gNh+jGAEEAzoUVzpMBdNP?=
 =?us-ascii?Q?mvT87m2pE91eHnV7oIsZNIJxfmx4IfIVI4lucGG00R0KUyFCj+cPF5WIl99K?=
 =?us-ascii?Q?o/rK7DWKJJOgqouC0Yf43RpsRvg7QNRCnmr3TaGM1PHt/10q2vevsZU14ngu?=
 =?us-ascii?Q?6e4dYMGUDrBmFcqxM+ChUNsWajx/d1JszopflcpbfnE64wHF2Ozfuz0AoK3s?=
 =?us-ascii?Q?NvnIV277YqW4J4O7rPpQeGwPfVRln4PVa1aWuzn1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b784986-6386-4183-ec3a-08ddaff4d1ab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:20:18.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTW8o2eVUC8hn/iQNpJiOw0Al8ce2nKl0NflNHTEUoaUa2zmCultsM1yg/pDfh3v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9709

On Fri, Jun 20, 2025 at 12:09:45PM +0000, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d8d2eb8a409e..48a5402706c3 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1683,16 +1683,62 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
>  		/*
> -		 * If the page was identified as device early by looking at
> -		 * the VMA flags, vma_pagesize is already representing the
> -		 * largest quantity we can map.  If instead it was mapped
> -		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
> -		 * and must not be upgraded.
> -		 *
> -		 * In both cases, we don't let transparent_hugepage_adjust()
> -		 * change things at the last minute.
> +		 * This is non-struct page memory PFN, and cannot support
> +		 * CMOs. It could potentially be unsafe to access as cachable.
>  		 */
> -		s2_force_noncacheable = true;
> +		bool cacheable_pfnmap = false;
> +
> +		if (vm_flags & VM_PFNMAP) {

I think this same logic works equally well for MIXEDMAP. A cachable
MIXEDMAP should follow the same rules for PFNMAP for the non-normal
pages within it. IOW, just remove this if, it was already done above.

> +			/*
> +			 * COW VM_PFNMAP is possible when doing a MAP_PRIVATE
> +			 * /dev/mem mapping on systems that allow such mapping.
> +			 * Reject such case.
> +			 */

This is where a COW mapping come from, but it doesn't explain why KVM
has a problem here?

> +			if (is_cow_mapping(vm_flags))
> +				return -EINVAL;
> +
> +			/*
> +			 * Check if the VMA owner considers the physical address
> +			 * safe to be mapped cacheable.
> +			 */
> +			if (is_vma_cacheable)
> +				cacheable_pfnmap = true;
> +		}
> +
> +		if (cacheable_pfnmap) {

If the vm_flags test is removed then this is just is_vma_cacheable

> +			/*
> +			 * Whilst the VMA owner expects cacheable mapping to this
> +			 * PFN, hardware also has to support the FWB and CACHE DIC
> +			 * features.
> +			 *
> +			 * ARM64 KVM relies on kernel VA mapping to the PFN to
> +			 * perform cache maintenance as the CMO instructions work on
> +			 * virtual addresses. VM_PFNMAP region are not necessarily
> +			 * mapped to a KVA and hence the presence of hardware features
> +			 * S2FWB and CACHE DIC is mandatory for cache maintenance.

"are mandatory to avoid any cache maintenance"

Jason
