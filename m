Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F213142E7C
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751637882; cv=fail; b=JG/6uTzcBmW4jfhEL6COzv34cltz9T17Kj6V144wFLpb4wkBmUQB2kNFoIVNUEKEmorDtc/rktuzVd43c7T/w4ET+kLGAK1Hv9SCxc+saVi4+PQ8otG4Qzft8soz4/duqVIkOSrw/qxR6bmO7cUtVXKuZVEbmUPJlmGu+RH3OfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751637882; c=relaxed/simple;
	bh=ksIR+KjUm2hvVjLs3XPukBuKsNDWDUCfLlD4yfF3v6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QvDeQkjjdsiYX3rCAPw7knr/I7tAGMNtumSd3O/tvDZArllEWEJieFiaNOLwyMM33mFvMzOQrj8GWJZjxKa/hH1EFYqn7ZgGNtigMjOpxY+Oue/lfv39k85bFk0l7Gc0DCmNZYR+LWf0rqWaJXLBvParc8gQZtnxYplKpliOK4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M7NkmRTB; arc=fail smtp.client-ip=40.107.92.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M7NkmRTB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vrOLgFhNkPtd9IardNcxxM9LTf7kTgbGZ0qdx0k4UMqEdd553vkkfZOF2IZWsUh4OFAeC6hF9MpE3YT357SzPWTh8bKQvJYkbs8AuAYYzCodvIhsOjlk7di3GLLKHapCEsML4wZ2Zjlu4Nq2Zy4C55mDoifQ9iAsAdbiWYT/zgsRDv5AH3frs/G/G41c/r8zXjEo8yM5tn1UPlF7hVcqTuTYTFdWIwiKIWBJK+mz7L8G7fN0v734Or+p7uIdqwHJN4IFzSTC6ZfAgAnQnq+pB2y9vBD9BhxmD1ZANAg0Ua46amCIKwXWbrAwtJ8HHv+SHkQp5OUCMSGcZHQ57bUtpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHE17Jp11Nl56HMddAVtk8HO9MOFi4r48pOyV880a2w=;
 b=pJzOqmoKmP+n0WNMWFisnDrKZiG5SGdqU4mBYItTHfoEcmoqj2HqKs1FwyuUHtVNpLnjt6Al3kf2ngffed2F8WJWbEMYtm7qpIeiCnjW7w5uqSn/mm7N9D7Ly+atpRodL3xB+nkgugPp0mmnaDC0uJKTpuVt+jDLxaGuYwGhujK9lPapZ57GVeUvs1Unh2bxBa15+5hZgMipbnFNvrXBlRP/uhoZQ2CR7E7KLWg/A8Nno5jM1ysmZxZelAIB7nVx9PgUqkAHvbMnPMfkzHa64xbQ3Cq2W/Pz2K+WjqsN8VQTFNJM42WZiWfgEbdh+16dwjx/NAJcTE2w2vPSkpNVzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHE17Jp11Nl56HMddAVtk8HO9MOFi4r48pOyV880a2w=;
 b=M7NkmRTBTTB6GtRM7D8QIKCynU14w7Zl75Wg5pc3Eirk26c4N1sjgwzd2LdVa4TIKOAK1T1ZuP0vG6bHG1NVqTe7s77gbQZXGhaDR9gbC6uBOmE5ZdPvinDvEbW2cFPWuf+TJwwn1zqvKI6fA4y9kyIG3nsUKremZNzsmzk++umlRjOoNwnTFLTE/wOJkvAdutGL83GOh7d9TLmrSx3fzJChx+RkahX6GkquTMrFYIUUk1TiTEngxcRjIzij/+EligCFnGiiC1UyVMH7eFTJB0EU+eeqOCOctnAU3CmGI00JbFMkm9hQY5LDdNQi7YWtv+/E2/9b3bxo4Wyi019nzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Fri, 4 Jul
 2025 14:04:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 14:04:34 +0000
Date: Fri, 4 Jul 2025 11:04:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com, david@redhat.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, ddutile@redhat.com,
	seanjc@google.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v9 5/6] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250704140431.GH1410929@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-6-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621042111.3992-6-ankita@nvidia.com>
X-ClientProxiedBy: SN1PR12CA0061.namprd12.prod.outlook.com
 (2603:10b6:802:20::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 985cda36-9e99-4810-a922-08ddbb03b429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0cTE7czBh/uJSMjNaSWq5yPVDOphv42bXSE0k/T6XaK6/dQSBIBojh1JUwS2?=
 =?us-ascii?Q?XWznAS3m91V6svk59yV/olwxIvbe5tMoofKoIBVK6R4hcCUfY1iJBY1HfBdU?=
 =?us-ascii?Q?c1XjxtU0oVoA9sMnAL/YmrtHD657vsxTzsy043ywMBVXwE0hoLlTRhdvITPE?=
 =?us-ascii?Q?7WOLpsS76/rQNcln68o7gSGa3AOrVmiCNb86H3xKx6+exsJTQldqbJmsOijC?=
 =?us-ascii?Q?VG2Bgj8eF5z3jQEe/W8G5lG9IPyt3Ilf+ctXf+GhAwv0QrKmxTHG58q/pXiG?=
 =?us-ascii?Q?tWGhQR8NUMmyA+RMYawp5tM/jl93OYrqjJ7ldH9u4QXZJnE2Vczg3ttLM6aI?=
 =?us-ascii?Q?ccIM0rCFTTLqZFxP1PDtByxLOgsdLkOZFvE3eMbk6NCe6U4POdAw9ivK6GOD?=
 =?us-ascii?Q?F3WrAAw/4tEMnSm75Zu7JQgZhAAqa59HGtgH8BKDZuLNyzlK5867hBzyWhQT?=
 =?us-ascii?Q?fJyN+vJXvw1neTEwXRT+qO8xfDN1d0ZNYhL8R/fZA3pIOmf7Es95+LsMmovw?=
 =?us-ascii?Q?JHI4jWniWoLVCmcXWQcCpolM0TU3WEtj4sAmklwZA1HkTR9We2T3/JxKlRt0?=
 =?us-ascii?Q?VR9/IygU/3OVPOVjeHiP40cyzysxeIQN3RsZfkRT/O3QbDpcYAYkHKCoqy6l?=
 =?us-ascii?Q?X0FNwDZyvColYsZgWs65doYHvyQKV7b037xpzO716ierEbuI+buLPwgvLQqA?=
 =?us-ascii?Q?GJ7kictrsSkDg37td69IMXlxi3kvnzpg13WdSc77bFridzpndk+zYB8JM8aD?=
 =?us-ascii?Q?TfvxxdvqbN6XhtusytzKPAIUYJARU52QG1ctgHCrTvTaWjxhwv7oZXjiqL7n?=
 =?us-ascii?Q?AQusrJYhzx7WG2TPBrrOEwvf0HYcctJg0zAM1/BA8+icqEx8g0vfbpfHsPFQ?=
 =?us-ascii?Q?dKcho5SKokU7hu8Quqizgp6TQGBVfiZNOC2aT2/ZV8rRRbD9U8e+nm3xMkT/?=
 =?us-ascii?Q?kzz81gUiXW6KOFY0r7Lb2jnQlvkYIWPZDZaz3GD5318JpADHQiVLUiPLP+S7?=
 =?us-ascii?Q?tcwCqS+dPvhLNHWMYACpMEnDs0aY5rcIGaUhOLbiuCsIgK9TSjXEAQqJpAnF?=
 =?us-ascii?Q?H75KT5wtWAJREkH3ks8fxYjMq6qkheGea56r1uBe3+IN7PYYVl80J6wjL/K9?=
 =?us-ascii?Q?NRzl1B9bt3jrgfFvHNYkHc7L5KSWLeMQeUMmPvRJu9gF9MAq6JJ0fpWmNGQC?=
 =?us-ascii?Q?nrhLl+bupCZDwoAAwcFnhWc9Qhui97+qvJ7HzB74uPP2QfCQA/BTExYObDXh?=
 =?us-ascii?Q?/rF2TT7UqMu6UGWDtt0EPRXE0IgCz+6WwkZ6ohJZtT8a+U8BLfFYEGBKCnPo?=
 =?us-ascii?Q?+qB8pJoGpNMgzsphWvfiHwb6QvlzKgOQNmtOEagZqbFfYGV3tBff06toPZDR?=
 =?us-ascii?Q?48qiDYYdJqDWOUa6AcByonbHLcyzyzCHjM89Qg1cbSDsDsD0oYL6juzRWwb/?=
 =?us-ascii?Q?wWMWAtVvMQ4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nV4l9kiY6mt+S5xcezuC/ps1APgaUfww8g5G6RZh98sSxCyx0y5t901JiZF8?=
 =?us-ascii?Q?h0pHzWPtypf5vndeRSxGz4aZIWJDBHf3Fjp7f7RWzWRXBQuDiOlRNC7z0Zqn?=
 =?us-ascii?Q?4sxbWzAmKfQesDsNKefy9HPxn+i0MrONRyRgWqdaeP8HqhTzlxxApE+axOuc?=
 =?us-ascii?Q?nvt7KhZsawP3SRIsYWj8sgWvtNdaYeUPLD0s/XdSabCsLA0TK2Vii+qEEPL4?=
 =?us-ascii?Q?+pybSws/4z8orK9qPbkgH62n6DjPv5af+dj55Xw7bnB15tRxOl+Uip6WGvdu?=
 =?us-ascii?Q?j/oc4WuaAGhlT5aqDeDbk84Lkcv6ZTodqhdTfiMyZUavwVSZURzhqw2rCVVv?=
 =?us-ascii?Q?wEQmaC8RXGmJ61893vbJlxf6A+WAsSbnKbOzo0PyUZxjwy6ntmghyxvEZz62?=
 =?us-ascii?Q?0J39N9jsudWmy9aZgMroGPfM92pF77uPc19IHEVJx3Ug73PWdEdkywPrPbUy?=
 =?us-ascii?Q?Clkz6q6IfqiswPEBeSXYHe0STFVgbBWLYGOeSg1zjoPOf6kpY37rzupF5RHY?=
 =?us-ascii?Q?TzCFXl8cIETx8PKMl6zwupciFnS2kui4c3Lqnfn3LDDcEKrBn9Dl1M9glzTc?=
 =?us-ascii?Q?J0n4AVNcnDuX1prNx0OGpIdPSBMKZDBuqPV2HaOiWisaV1q676q+e2lHDh+M?=
 =?us-ascii?Q?98DiRIrXeBJvJF6dXlXw5eC45JQJX4Z86nUTYV8x9HxJjV738HLLR9B/ijGz?=
 =?us-ascii?Q?kbkJBKK/bVpkX3q2X1kc3Os88o9bBAdQqk8x7rgiDTdQSPe6mAo7iuv23WEr?=
 =?us-ascii?Q?/OrnKJI0IP48LUS7JQEnAueuhV7Xbnj5Olv+ijd4Xpc9kVSl+asj7+mV4i0D?=
 =?us-ascii?Q?m6yHxfa+JGVmvqYmECUpHeH9B1dU/AJPCvE9wyuz6qKNIXWB6N2UoNFf9q8j?=
 =?us-ascii?Q?CxRcleFEHOVPCY887s5F8MeMIFhK09x5UYeqkjFcGov6wITP1AurZ+ooFrjS?=
 =?us-ascii?Q?RdJGkQ5m8X1uSO+YZMhTnd5b9YzNdYhpZ9z+M8h8SSny32OsPux4Jg38bwvY?=
 =?us-ascii?Q?aOjxQZqYHuxPixyG83Pt+dXmtYW3wqc3dtEl/ovma7RBVIbef8On2/pSokmS?=
 =?us-ascii?Q?na1ZqbnKckset8dtBoSpsSVUqUW9mWWsgb5hfO3Ds6OhJCiNjxtiK5oAbCgN?=
 =?us-ascii?Q?Aaz5Q4e559/7fmJ2avOdbmeLchqo+o6ctzn0Oz/a++KrFhtYHWnmuMvBqlgr?=
 =?us-ascii?Q?U5ll0+tXpm2BIP8GFF39UjBuNek5jn7WDFMW7XpayX9oS2gIp/kz5WIujm0Q?=
 =?us-ascii?Q?nD+WI//nR6GzkAfnsIddxpU/6Q+2Egc7w6DQK3CQNUVduo5S7srf/+BfbIzR?=
 =?us-ascii?Q?wW9XwOVTySOT718+IQNS1qrpyYfhv8QWPggOhjprn840jpO5DPPxyarCjI9X?=
 =?us-ascii?Q?Hdem/DfEqxrtWHDwfRoQbS89tjQoUh7VT4AqzhfKb8h0oVj00tneoovjpGvO?=
 =?us-ascii?Q?5yxOsctY4eClOr8Iw86kZH8gs8yMKDOnBLE9Mg7Qab8Eljo0byXmBnLXD6v2?=
 =?us-ascii?Q?SkAJ6V8KQcH4OYjFkad3f0S678v3SMgpl70AqH5DUTUa0HFWwVGCpaPwOu23?=
 =?us-ascii?Q?vFt8+5IfzxKgmv1RrF+QmACd5F0HbWcD9u3wTNq7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 985cda36-9e99-4810-a922-08ddbb03b429
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 14:04:34.3023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FyGn0BoCDoax0gmEehtmn5XDXeMt84Cl6SYVRy6Vw/5nAZebnLZ+iE/4Rog2/MR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462

On Sat, Jun 21, 2025 at 04:21:10AM +0000, ankita@nvidia.com wrote:
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1681,18 +1681,53 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (is_error_noslot_pfn(pfn))
>  		return -EFAULT;
>  
> +	/*
> +	 * Check if this is non-struct page memory PFN, and cannot support
> +	 * CMOs. It could potentially be unsafe to access as cachable.
> +	 */
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
> +		 * COW VM_PFNMAP is possible when doing a MAP_PRIVATE
> +		 * /dev/mem mapping on systems that allow such mapping.
> +		 * Reject such case.
>  		 */
> -		s2_force_noncacheable = true;
> +		if (is_cow_mapping(vm_flags))
> +			return -EINVAL;

I still would like an explanation why we need to block this.

COW PFNMAP is like MIXEDMAP, you end up with a VMA where there is a
mixture of MMIO and normal pages. Arguably you are supposed to use
vm_normal_page() not pfn_is_map_memory(), but that seems difficult for
KVM.

Given we exclude the cachable case with the pfn_is_map_memory() we
know this is the non-struct page memory already, so why do we need to
block the COW?

I think the basic rule we are going for is that within the VMA the
non-normal/special PTE have to follow the vma->vm_pgprot while the
normal pages have to be cachable.

So if we find a normal page (ie pfn_is_map_memory()) then we know it
is cachable and s2_force_noncacheable = false. Otherwise we use the
vm_pgprot to decide if the special PTE is cachable.

David can you think of any reason to have this is_cow_mapping() test?

> +		if (is_vma_cacheable) {
> +			/*
> +			 * Whilst the VMA owner expects cacheable mapping to this
> +			 * PFN, hardware also has to support the FWB and CACHE DIC
> +			 * features.
> +			 *
> +			 * ARM64 KVM relies on kernel VA mapping to the PFN to
> +			 * perform cache maintenance as the CMO instructions work on
> +			 * virtual addresses. VM_PFNMAP region are not necessarily
> +			 * mapped to a KVA and hence the presence of hardware features
> +			 * S2FWB and CACHE DIC are mandatory for cache maintenance.
> +			 *
> +			 * Check if the hardware supports it before allowing the VMA
> +			 * owner request for cacheable mapping.
> +			 */
> +			if (!kvm_arch_supports_cacheable_pfnmap())
> +				return -EFAULT;
> +
> +			/* Cannot degrade cachable to non cachable */
> +			if (s2_force_noncacheable)
> +				return -EINVAL;

What am I missing? After the whole series is applied this is the first
reference to s2_force_noncacheable after it is initialized to
false. So this can't happen?

> +		} else {
> +			/*
> +			 * If the page was identified as device early by looking at
> +			 * the VMA flags, vma_pagesize is already representing the
> +			 * largest quantity we can map.  If instead it was mapped
> +			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
> +			 * and must not be upgraded.
> +			 *
> +			 * In both cases, we don't let transparent_hugepage_adjust()
> +			 * change things at the last minute.
> +			 */
> +			s2_force_noncacheable = true;
> +		}


Then this logic that immediately follows:

        if (is_vma_cacheable && s2_force_noncacheable)
                return -EINVAL;

Doesn't make alot of sense either, the only cases that set
s2_force_noncacheable=true are the else block of 'if (is_vma_cacheable)'
so this is dead code too.

Seems like this still needs some cleanup to remove these impossible
conditions. The logic make sense to me otherwise though.

Jason
