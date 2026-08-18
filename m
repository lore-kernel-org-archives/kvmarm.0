Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066C33C9EE4
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043188; cv=fail; b=HaRy7nGKUdff3d9HywFFErwLctRvjJGr1SYDUwoZ4MBtLexHp+70UB5jYK2bjDQdyHqlfbh+H58LnKokxKviYnKicGsH77SKYlktJyw0KIxok6xW0T/pgPbALNjRmQmwlIq/D9/RkATywF8KA16Y2Q+MIqyJ6S01ntUhs+9NQO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043188; c=relaxed/simple;
	bh=LzqhDujbHXcUnOjV300TIOsXQzQ0Jy8fXOcy/4lfSKQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mEiRDQE+TwSLQt26FSyO6NkL/SnxbHGgkIyHdUjezqkXyY1ds/8NbjYbA0CgZZcjudlo6Lt/oL098fEHmRgj/Iu3jsvgSIcE4TgLetqzFIOkoxo7exImYSaBJ6yPdrgb+F5qXh2spXFlhsPRQrp5sEn54bmJPnBAl6gM8vo0LYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIuVnCy2; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIuVnCy2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787043186; x=1818579186;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=LzqhDujbHXcUnOjV300TIOsXQzQ0Jy8fXOcy/4lfSKQ=;
  b=WIuVnCy2/mzC53UzzYfDd3t9Al16XTDfp7Znd4MUqMZqdrxlPRVXvZeJ
   fqiawBVkTcgJV30IRZcp3/PCElWIqLM4S0helraRfOReyV59iSa634/zz
   gpYXmYfS0jBKM7xMtOGVBTzBW6XfoamUAzxY/M3TLwxe703cWq+tZD2v2
   b6NliUhJOR60EC4htTCSJhW1nBmL0D2fSUaAnXfry+9pAZD4o69Lkzxu+
   Ue1C6QsmvH1Z2mU18swTaT+un1GXwF4wXWDidAJV9fdGnDDia5Lpd8DAA
   4sSRSVsk49XzAV8J9wMgYdv4TQAHi2hIwMrPAqCy55M7gRV2bf6PtsVkU
   g==;
X-CSE-ConnectionGUID: q7DOpC6GQ7y+AxW/OyR66w==
X-CSE-MsgGUID: lOhr8HAPSFq3amyKGNJMYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87444255"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87444255"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:53:06 -0700
X-CSE-ConnectionGUID: VmXZ4L0JQ6mUU9RtFb/yyg==
X-CSE-MsgGUID: 6DzZ3h3TR2Km96v1BMZoMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="261881077"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:53:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 01:53:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 01:53:04 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 01:53:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ez9ua8bFnHxZSNV5qBmX79n/0GKUELs/0AkFGjgwaYJjLuTTQROy0iJFdjnr2lTLtDyxezVo1cbYoS7QycXWCqjGQJWaYHbHsbrwUayy9JZvZ6p+tzsiYl0XYV4+lbBheP8+XuroKTqQ+kDM4UmeW4BVnwmXjXN8tFZGJuyguuHP1rcGrSe+9Mnym4VtPYKc51KmtdudCJeExyBs5QixWU4lk0cus0z3VbYFMCjHiLQd5Hs10xzeJPUIxO3Tp14SpID0CebmMBIhErGs/+giRQcLlTa11kmILL1+n6JYrz+q6SN9btkooiJoe7crcJhL3aIoK7O2kIpk3WXRU8F0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TL0EIE91dYzCGSgq6uon+ZHotXvDkCtCiEVAjFgj8B4=;
 b=Bpj7SaNWqDhvgriU/7jgpu+aCxMZ3BygMoNNlIsXdulMWJpJQv0JSUbqAWXp87Eo6qkVAJ93YX1dJXrZHLCaTm7i3JU4lAPs0pIaPfVBo4v62drJWCvAZ5yN0bnvarX3Zg9LMJ2424SNEdnVm5aZf7mFvO1WtZzqHBjJDWuk85D8dg2Nq5sV1VoNdZC4d+WtKfaqkzYXeYnNq2qqig7X3pcyHOrWoU5m36NJJ6yoNyNXC4NBtJ1V5h+HaHdbNbGbpVY2fC/rxPfMCGF8JmKAxUCGA3nzWrMHo59gZW28qQ78ZAn1y5m+IxDJwrQRK3pSxaQbBBriYYDrpsevsx5icw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by MN0PR11MB6109.namprd11.prod.outlook.com (2603:10b6:208:3cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 08:53:01 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 08:53:00 +0000
Date: Tue, 18 Aug 2026 16:12:03 +0800
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
Subject: Re: [PATCH 2/4] KVM: SEV: Drop page refcount early during RMP fault
 handling
Message-ID: <aoQT00rN8a5TQ88+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com>
X-ClientProxiedBy: TP0P295CA0037.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::9)
 To DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|MN0PR11MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 252bb990-39e1-4059-807a-08defd061b8d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info: BqkkWNpfzdrOdeyoaItaJwEY+VdP2M22dZLu4cChG5OUpjULmlSIfHc7aU7BgayJ8qtjh8HY85wJ5hlo3UA+54xM5rl37hWe2BlSfkiJVbqM4Wkq8ovV7k7PONihWqvcpH++96c7eqir3vXDQSanbot1FBTqVD6+99BigTxLPh27ooa/5O5pm+ILcfKIbEjaTQJVQvTKBp9QEATRY6/UbNcnwhTqVQujx25cTl60U067WILD2JUQL3OlLoMnzQBd5aUQqAF1hcPos65c9OFpDkt/EGP30yKcIbzd3KD1uNiVto2hh7lfqz5qqd0VHgkRNIxjxX5l0LmO5zIO7/5Z6oRGRCu+6TjcPpJ3dvPJF6GwdNGDE5ZFPiEk6CXaq+jiHEOCWl7mm0qPnlI16tkvMvsvjwzNFMXQtOXFmQHbxUJHIRF6uvSfN3e8re6Ml6MxQ9GQwtRtIK2mc1U+nrd1xpjmfR+EVztFAlBTs5ePDDP+gD961beVFwIQRv1FzaYgVX8iZbZw0NRUl9TOwA/nqgItJbhLrXsyoX3pQ7TSB9lzmxYCiFSOx4WvniFFx3C+tEQUiEw7eSZGZERrdIZPrUtCtZ2qc/uadiQqQkuLkVDGjf3UcHAamZWbcsOTZPZo7QfmyPIbHlvZ8A3X8MP4ajTG+I7sX/Ej1ZKkyPe7qLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?haKSWRsDkP+Sb4FGDBpyFb0pV/bAvLbODrEwSE7nCS7Ouhm6xoMHhEcBr6Zn?=
 =?us-ascii?Q?0MbGSNiQw/bShoKnzGi3e5AcZrcttzV8TE5oOC4ZpEh0z4/g31cFplD4Qet+?=
 =?us-ascii?Q?6NB/MyGqyd0SouKtmILqlDmOwhvEzQ+FspG0j4d/KC3u08iR6P/T5hTHOZ53?=
 =?us-ascii?Q?zX2L1lYe8KqfnEGQ0N+S+Yd+xfmm4uTw4qn6jGx58sFmGsdntuNk7qa6ynnE?=
 =?us-ascii?Q?ytn08DEu7cp2Jku+W5xZb8lhyOj+OrVJsfj8OF+rVfH1uRvGVr39UII5eFGu?=
 =?us-ascii?Q?rv+KU8uNunxHhmuY3s88fsN5Tmaunp85Q1ia7pNzwoGgw9TX+23HIsrwjKnh?=
 =?us-ascii?Q?zGUMxPJ0D0klowCEkS501ZPtn4SKUl10xI7Tbat9P5SH0/0dypa2WrwpsWCN?=
 =?us-ascii?Q?6wbQyzrvscxjWbpKN9ge7oFM6BoztlF0MqpNEdj3hkg1FTMwm7EGYZ/+g3v/?=
 =?us-ascii?Q?nbhrH67wMHRXR6hAy38yCyO1AlsAHCndghrOuFa8XmuZFszzV2pasfNGCpoP?=
 =?us-ascii?Q?3BSH2KuBjdxCTcNOZcdsNnMN5oPCp6U6WjJhRdyiAp+sdxKh6CdTujqhZ2CT?=
 =?us-ascii?Q?e+Vsrh8UOYmeRhgk/hZ1kTtcWEcYFa4/iebIpmufJcyTYZx1HZgOYHVRrCEF?=
 =?us-ascii?Q?NO86gKPyb7ySLux6yum+e1WT0krE1NWqMJu+23iAbVc5ZB7Xg3/MVlcjCNNB?=
 =?us-ascii?Q?h0TKj6mh1sTb7wYzVcXVxB57cuqcrAJU9iu4xW/Keel5dn6ngTE6WL4/qEo3?=
 =?us-ascii?Q?6SsJN1hStBPVUiydUhMHJc/64GW0yApfWNYMBouEaL1hCJL00vPOdakIPl7w?=
 =?us-ascii?Q?OI/SR8W0T/mGzgO+PY5WN7H9XjV2PJFl6uwOVrKHHdv7pBkFd+dUJQPy0ik3?=
 =?us-ascii?Q?hSnlc+BYI2zF4H6JE1VVYa3AuE2cL+gPt8ZcUDEEiVlv6PWVM8Eo9/QoWAtE?=
 =?us-ascii?Q?jHqwNicTzf6/ZhHUJyd/UuOeCGGO+K+0yLdXFlsWC+rV49+CYYF0A51ZKo2s?=
 =?us-ascii?Q?r/3hhbmfgjXUA60LfamG8U3kRYzlCGRBZA4M0P7/zolyvEk1I8P4XNxprFa2?=
 =?us-ascii?Q?bGMR6Q9kia3Nu3acB0nWdXj9HTNkRddCHLCf1lsE546dqvX+0CJGj3GutHWU?=
 =?us-ascii?Q?IaL1yUnorUOuquc+a/fTqcFjcdctv22L1ndwtbpfqf5SB1OVoQ2v04sKH1Fh?=
 =?us-ascii?Q?TitaJeZGhSQGeKMEvZ4Qj7ckUlQ2YTwrVSMqL5q8U+tUjxemw3xN6Gq6fxyV?=
 =?us-ascii?Q?yet3JXfM3OmyVIPyDsGbYd+0SU3IbfNJBLLBm+sI8d8dVb89UxfxtY4lCOXU?=
 =?us-ascii?Q?YywjvmZVCi8LJcNez7J3WRvD7e3Awg6dWPnVqZrCEgXemSWTSIeikSjW1afy?=
 =?us-ascii?Q?rDeRTFlQRUqIBCuyJJTEu+lnfuxn9uajO4eD19i44BIXQ3G/OHih5Y8wy7PF?=
 =?us-ascii?Q?oF8RAS9O1Epe3s+8bvbF4UAxsdJxA5SUu+UrjLlSsu1vTS/jsRRbyfevlA4j?=
 =?us-ascii?Q?PQ3hqf+rzx5owfTvnqOiU1ucXWXLzF5gSPDcfveovUUe34bIBNJsmZJAK9y3?=
 =?us-ascii?Q?65LtUM3tmZGhgprTin9X5azi7/R7NpDx0yezEeRI993i5QoQC1WQ8z94lEGm?=
 =?us-ascii?Q?hkJHejs8vHxEkj+KUk7510x8aui4+WxCtqIKTXLbERQwbQ8jJTKNJbA2ixhL?=
 =?us-ascii?Q?i3SnIhq9J+yP1DY25Rzn4ugTSx+0YQv1a/R7jUxRihaQqsWkx/g5pwiLDyEA?=
 =?us-ascii?Q?Lyfz0kh2KQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: UXHLWIf4VuBCXWnDDpxFkS7SVNMm0WD9s2lzbw025N5y4j0LIFfBIy+hO9tjWDGy8HgX3iCb2jNLbRMv4bJVdKCFrgfPUiHUq5kyz4uuHqne+6m9F59bhMKW7Nmpzuan0w39az9kobDgMUgeHQshjn/YmbpwmKv8LJnKEzRauIvAkgHpikRHGKZ2AlnIjLKVBCN/omdCtQZfOViwPPu1ncwCWEoT//lo21ivC0AEVP8mixmKJkD62HQQ/CmAyjREhFeGgCOfA/l44KNpF1/9sje5MUZIPTvPPF6yYe2uKUreFDsYeItvpIaxurUQMgtlYkroXQi66xHe6Tvs73UhrA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 252bb990-39e1-4059-807a-08defd061b8d
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 08:53:00.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1jB501Cx6kEwpA2p1UMuZAPolUgfsz9+5jlf0YWiayfJOKTfaEEw/sfsjREVQlHaUF2vqPGTeWGo/6iptkzSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6109
X-OriginatorOrg: intel.com

On Tue, Aug 18, 2026 at 08:12:36AM +0000, Ackerley Tng wrote:
> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> guest_memfd. The page reference taken during PFN lookup is not needed for
> the remainder of the handler, as checking the RMP entry, splitting the
> 2MB page via PSMASH, and zapping shadow page tables only operate on PFNs.
> 
> Drop the page reference immediately after retrieving the PFN instead of
> holding it across the entire handler.
> 
> A later patch will follow up with completely not returning refcounted pages
> from kvm_gmem_get_pfn().
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2738362a928b..19c31fa944e34 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5036,12 +5036,13 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  				    gpa);
>  		return;
>  	}
> +	kvm_release_page_unused(page);
>  
>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>  	if (ret || !assigned) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>  				    gpa, pfn, ret);
> -		goto out_no_trace;
> +		return;
>  	}
Hi Ackerley,                                                                     
 
You missed the parts in [1] which save mmu_seq before invoking kvm_gmem_get_pfn(),
+       mmu_seq = kvm->mmu_invalidate_seq;
+       smp_rmb();

and check mmu_invalidate_retry_gfn() before snp_rmptable_psmash(pfn):

+       scoped_guard(read_lock)(&kvm->mmu_lock) {                                
+               if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))                 
                        goto out;                                                

[1] https://lore.kernel.org/all/an5RJYTwlYeym--O@google.com/    
>  	/*
> @@ -5088,8 +5089,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
>  out:
>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
> -out_no_trace:
> -	kvm_release_page_unused(page);
>  }
>  
>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> 
> -- 
> 2.55.0.699.gb54405d56f-goog
> 
