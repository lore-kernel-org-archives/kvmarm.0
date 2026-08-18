Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC123BD64B
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044536; cv=fail; b=ef/icFqiRpNmaqXPmD5ofHpLwOe4Urw2zIy/AqLn2qCN6ih2pWnNKMxxezyN0pZbG4LxMy3uw2xxfPqOcOZGrVFNH1BcOo6bNMyfZLYSLRgq+W+bxBPMVhNh4yu6IdsSujVo526oJIiuTyXcHGRzZYDkg8FxLdZSbbi8StlUhVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044536; c=relaxed/simple;
	bh=fz2tmwin8PgaaglcGPjRvDsVIRub9sP5XqOn2gSLLVQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cs9ox/cMeX+a7p4TcJO8JNZTm0J1ts0J1XSXQA8mlsFDntXXQXYtrZL4vN5T9ki/zja0HTSQEoF3yA7v2mJrvaUnoKeY4TXz4KoQkw5Pld9Ot5gfwQGm2HKMLt79qeG2q3dr43S0FvsIiqfirHr9G/mH5Jot87F2D0EEuZK/VzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JDk3vceW; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JDk3vceW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787044534; x=1818580534;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fz2tmwin8PgaaglcGPjRvDsVIRub9sP5XqOn2gSLLVQ=;
  b=JDk3vceWiTEKkoOXat2wic6713rI9xv40EFefxMQrqChkXJ6GextOIz2
   YlHPAEPaFOGlPy01LlSoJaUYVOklQypy0aO1DuBef4aGtnDQIUXikbnRn
   NJ4D024ojddTH3XV7NOnXtQNxbOLiKpAph1SjK/bgEv2mgHxWRHC7OypW
   VwMvVIqhYSPFDi7bboKWmfANIVpA0VA1Jcib+1AKfiyBvdw3D1RrVHNAO
   t37X9nqGYObsdqkQan78DaJ0CKvAQdFF5D3zN0UdrwHpvP42hjQcwNGh+
   /yjDvJhi9aFyxmQfLgPiTU5qcCxS9XU2dDGLTsk5GgO6dzxkuisWJcK9L
   g==;
X-CSE-ConnectionGUID: QHI6Nrd1SoWmDaoOg+XKwQ==
X-CSE-MsgGUID: XNxn4ZfGShayY0THS2gvNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87737453"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87737453"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 02:15:33 -0700
X-CSE-ConnectionGUID: nnWLgM59Tz2vj4xb2Xk45g==
X-CSE-MsgGUID: f58YFRBeQ6CAyPUaQ24Vlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="303398446"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 02:15:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 02:15:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 02:15:32 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 02:15:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3ToVoD6Rnl8ssirxCU1zLMQpKPH0T9s4m+gQfqsVoTOI4/52P4EOl3AHfWfIXjwBlZBMlvtmPhJ+TGKZVo6RqEjQruGxKY1lvAswrlTUf8sumGvrMk8gS8CqDDY1hANhzvQFypAkfwp0oK8IwKLE5eYu8UIZUMz9hBnMa8lDFRLjotvPcfVyPFInwZPY56s0ITnXqi6uwfSO9FElnDpnryyuR5SNQbiJ1wXRu2cLfxuVOUpivC5VU04ML8pJYM2hxHA4Ip182IRxzg47kFraXbN474mMYFqvgItMq1kX7WFVJSEqJCf/mnVgNxKJq5djIpEW9Ii/HLpOojwFNgF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9NorpPm4WFf0euIfha9V6pA3lWISnwjwnbRl/8Tiew=;
 b=FxGv6jW37pGsu1gvgPGNqu1rlJIfwm5ii6Tdg97IuO0zKMh8B+Q26s7lXZ/RHcldI2155SlIjh93Pwfjfa6cDTW61MWZa6hSH1URD6mNw7CmMTWRbC9pyLLod4+qAf3JrgLsDjjYF7p5jc1KDzaBSnlokwQUX726kbrj1RGtWT+UuXH5ohw+SEPS+HyifxH45f2Pr7IC5N2xragG57Kmaavm022KSgMJ/ga6A5H47eIVJ1IFvlCPjDp7seGyBuzY6SM0odUKDEOXw8hGEHTV1IlPICI2Ac5d2keKuDR3rX2DUUXM0bDmrEFH3py5JLT4G9CAA/ll1ZIiDRESgAHxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by SJ2PR11MB8347.namprd11.prod.outlook.com (2603:10b6:a03:544::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:15:27 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 09:15:27 +0000
Date: Tue, 18 Aug 2026 16:34:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Michael Roth
	<michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, David Hildenbrand
	<david@kernel.org>, Fuad Tabba <tabba@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
Message-ID: <aoQZFtSd671ti4sr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-4-4f8d939efdbc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v1-4-4f8d939efdbc@google.com>
X-ClientProxiedBy: TPYP295CA0026.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::20) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|SJ2PR11MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1248c3-4965-405f-a8fd-08defd093e06
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info: 53j8P3pz6fBvCYzoIJ7tce5SaRVM/Dr1mPsT/i/8xSJTQ4wWMEJfr4dZo08vI3m+z//S+cKj6PvKePqnSlYyo3algcJkqr0BuCska/NXMllfPoQsj/0yajpK9x5gjiNs4l1JCt3OXE9laXIZq16+XvohOdOdXtpRIUBtBIlfxzBDuZwZkN8gcmOl+w8MCQmBsFwcNMtvGEqn7o21SLGEBjGbMYrWPxKHrjyTiTUmmFfFPhM9hyXP38YWoiiJCtTwdnqG9vIIxqQS4cBtlgOSMPwwTpsBG6uuMbRJJb+incLPWkjtud6AEvTl4PNzwfsAUOEEm9vZW2WFMualqNPb+YzT8f6oILNkhouywBLHifQw5Q8oNB3KzTuIZL/IA7QtMDUhCS1w9NZLxwY5GMih6yb3UpjykioxjLi2HhJfuR5RE0lTr1e44WAfrSKpir6/2oY+eUKWdhlzUIQiGHH0NdqN3fDBgthWxywkxIoNgVrNeaqRdHRMDdlrpuZoxl1HAIA5V7cOsjwKGiqRsJ9jy5JW7YN/lfBpc1gLD4lzBsErMJzs6I60lY6ZI5y9TgZE0LSdjvh7agRkpVTrTP9aDYiQ+L86L7jiqQSS7aNnc0508l26PFAFsqx8NFE19Gxs/5TotRBU+0SqyqCHDCEMJINu9vhenOUxtkpp20psIiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uR0+X5sl338yH+ktq0DJ19wfEUOxblXKCfigA714wAgJZo5nxxYUl53gwnoA?=
 =?us-ascii?Q?7bq8MNlbyZIJgebtKD3/fl72+Xr30vVzs8m+Bfp/3Vheta0Hw0lWO9GiawSy?=
 =?us-ascii?Q?i2bqXXD2EHMISUGM7cqSbLuZYkER+EC/FuPqiseQNIJwbj0QJRU9XI2aAir8?=
 =?us-ascii?Q?Kqao67QyDE0skZinuTi3zs1o2Bgim5MW2RMPSYIQQtGsjEziWjO0zGXcwVFb?=
 =?us-ascii?Q?5Tznclc7iusW0lANcP6YFH7kzkcyYc3GxP8wvYqWKfQ7tRTPFShvo9VXfuFE?=
 =?us-ascii?Q?sytXmpLOEvfFcy8aRQ3eNdgoGpSTt4kOcBZf1Wwk+uWL99qCBqTJ/a15dmfu?=
 =?us-ascii?Q?1lDzDyYKQRhkTnDVjXeR1c/dilpRPlLXwEjG7x7+N78Eg+V8BS22koYUSKq3?=
 =?us-ascii?Q?IEDD7+2mViYZJwK9LJnYM/IfDIdC4sdV5lnV4Dg5ylYiOD+s+BzHj9owlXOm?=
 =?us-ascii?Q?NEMITVfzviuZtrRnDPodB/i2HuoHe4IaA3DEJ/ngpOc0YqGrQmgmbvpSTl60?=
 =?us-ascii?Q?LAoaIR2H5VpsyOcDGV3d/xnnBYlnOX0ROD79y5Kr7Vh8iX5S7WvkqKq2oqr/?=
 =?us-ascii?Q?clz8XJJBF9Xe1Pp6l1/Ss+4YLbWdO8qlP70qqO7xRF3WURZ/fn3ooi941CyJ?=
 =?us-ascii?Q?jYkYQXZOLqyYq4OKJsKQCGTne8lRlZXqaC1JNi5RJ3DvO8qFnmusdm+veZRu?=
 =?us-ascii?Q?M75dq2D6NgW2vj4eEvCqb9cRhTIKNHHshvHGvI8Cbys5217C+2woGJNJhv6z?=
 =?us-ascii?Q?wBqBjmCgBIAFkS/cmaHisy5xI/qgyFCnpgG9QHgx6j4LjXw8h3WJ8kbd8/VO?=
 =?us-ascii?Q?P8NPAayDeDFhaESCgBRVBLJYGQXXKsugEQH71srtkqFjucMABN+/lol438CJ?=
 =?us-ascii?Q?RhuYJs5EWi7hNRcsczH6aRGqAzu3syR321SOWzHhy37OtU+M6ubZ6dL5y7Sc?=
 =?us-ascii?Q?idh1po+gkYUifSoL046fccFCWiMrXbwltXxdabYOiL0wOH2fTHPtqngK/u/G?=
 =?us-ascii?Q?52V887RGhax9KLqYqyESiHk8ki5HRLFLt4oTw8Nq7ch4aTWxy5zxX4aCmVvj?=
 =?us-ascii?Q?78Zx1qFdo/+DyPQvIPR9+ZvXMrr8r35OAa0aGtUb+FJuvcsQrO6RzPrLC67Q?=
 =?us-ascii?Q?fEgiRejpX2a8XpFCPNNVeWHODfPWxgLfQGjg05Iw9SU3EzQcZkMQIEn2xLmc?=
 =?us-ascii?Q?ZwvHahwkdXW3qzx6OQpelXOlK2CEN0wEQPYTSmTDRMk8IIZQKWiyHutsrESM?=
 =?us-ascii?Q?zcKDRWODj/Uk7eRJqo/eLtdA7AtbDwJjPdIYh1kM2BahGn+g4LHMB7oMxVB1?=
 =?us-ascii?Q?/AGcRJOww2HG/ry983ecragHI6EyjrUmW6g9KNkOZKifNdXG4HhKRfi52tYt?=
 =?us-ascii?Q?zeYVysZXbU53cq3JUcIjyVBHibzAaC3QxccU7PXLCg+7sfHQbcUzQySgVzLl?=
 =?us-ascii?Q?SjPo8zOhDywm5YFMjPirKxgvjCm7+JRMFv19oqXmOZd0EVuJqCOURXO8RtL/?=
 =?us-ascii?Q?/gh7u2GfPn+AKS+UKZbioE1xKjpnCyhqUIrl5oHAjWWMaZkRG7Ie98ULy+D7?=
 =?us-ascii?Q?gX5xLvTfz9UQnbB1rg2hY+/ONsJojCzNzCKrc1Dih8/lxP5ftMNO7QtREypr?=
 =?us-ascii?Q?XVlK6EyMtn8hkuNwFr9Ssd6+sFMg0MURrCDPWQ1/xBRI1i70nXYeNMB8iYZN?=
 =?us-ascii?Q?Jt9RRIIweXLAI47sBuzxYlqj4PiM11HuH4EG5vvNef1v803RZXDV6n8GnJoX?=
 =?us-ascii?Q?WFumHV/r/w=3D=3D?=
X-Exchange-RoutingPolicyChecked: n33MLPRJy88wBHobDNAdtAqSX7iFOvPUS/JNHUZbHCN8QhM3Aovs2QdfZnnONN3STDbdLyd/v9Hu6xHu0q7mDz759P1WfQ25XD5H7sFsC1FiJVCb6VyZ751yM+ove5qSauRnW0i5f9XQYYo7g4LKLS9GjgYzuSqnU096UX/V3BqAmaj/d4w5SeqQVbqiJLmr2cRg4m6Y/02NwAdgdUZniipQkQIlm7jJby4nZ0lGZ/9by6sjNfd+vHqIcvP8RRza3WKJA86hCii7hKJpe2Fgzyxaz6DQMlIX3Buv2SLuf3PPrC+PA0em745h8hfeIieF+JgCVRPGW+W5lUclBR4cSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1248c3-4965-405f-a8fd-08defd093e06
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 09:15:27.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13J4VFwe6ztRaNpGwBtMP5zI1i/LrepmdqxbMb/suPL+vT5kyys3kPJeKGCMVAE+5x0gF0EyqLOJp37ECANWXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8347
X-OriginatorOrg: intel.com

Hi Ackerley,

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..e5d637a5ec558 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1613,7 +1613,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>  	unsigned long mmu_seq;
> -	struct page *page;
Just drop the page should be ok, since
> +	struct page *page = NULL;
>  	struct kvm *kvm = s2fd->vcpu->kvm;
>  	void *memcache = NULL;
>  	kvm_pfn_t pfn;
> @@ -1641,7 +1641,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>  	smp_rmb();
>  
> -	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
> +	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
>  	if (ret) {
>  		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>  					      write_fault, exec_fault, false);
here missed a hunk:
 out_unlock:
-       kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
        kvm_fault_unlock(kvm);

I will fully test this series tomorrow.
