Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E43D8107
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 21:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787349046; cv=fail; b=bGNMxm10HhmBwNaF9mQYDfiRY5TXOHktGPL2Xg9mVo4iycilM4/lhumKtRp7xfVU9GJcJvj/v/YRCccIUVvJpCdwUqMqhYuwn02iOp2cURha5ttHCf2HMbsM790X2fZXF435yiOY6leKZvRuTDX4JRvDdhYiMjZvq7LazUliPq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787349046; c=relaxed/simple;
	bh=OkZFjnAKpZ5RcGEqLXM6z1djxU8e6LpRPepHTu9eZOs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwZ0yTfyexQ/wQAdWfpkSjXN9Bf/Irlq0cGhNtlGUdE1GCaTRhz5vjwJxnRVLdnsphLNRSBxQ9HYxAquk0tblb/N1ys6CFWXjQaJWqZausFl0NQv2Cy96DN57bX9EoFKOp7ICP1sYD2jrpI0cW44/7WWBRLrFDu7yfiO54brD1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AVzPWjn3; arc=fail smtp.client-ip=52.101.53.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AVzPWjn3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQFe++0xoxk3lSKf1jdns4lZ33voWybOOuv4FLB6pLRrX87e5waK/gWls3TjQ11s/v4ubFWEr8BEMRqiovAXnDp5NYi2f9MCrfC0K3mQh8Rm3t6Yn8aK71i4d9p2ohz/uRa4sCGvy1fKiI0NYbarLI7pboB97OMl6adqQnk8BZ+P3HXUaHkxZT+jR+rUqgpm1xV4OxXkdw8L7hoHLyMXyfOfTYACJkxAK+L8CK/n+4eWO/MiCVVsEwQiKIqw6biZWnG9wCxHL9K+aA8HdDfe+I8oIabg4s/QffGcPtk2p09eDfBp9D/cuvDawN3lcg8OjfFr1HB9TlrVMeDk6rqTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwwgyaD+p0O9U0RzZu7Nlwn2UtQRdAZg7GmEFhAoQ2k=;
 b=DuAOVkOSsM5DU7ofAL1J5WiMHWJ7yLL5zt40qS+QD6jBt1tbWDdxUw7sG0GB8hWIImTcKP+jjkO0u2Z3Wcx4bqoQfQykB2WAGhcqN4pF953GtuEQyb+oW0y+uCVO1GpCtJh+QyWXcqWmXgb24KdHx4Kk0YmsIiaNzoFdS7Fhn6mdsufuhjFltcP/VJoebOd31LDt2GWd3cIc2GhYn3jiRMt8rLSN75xAyRmGYuXRnfFh/u+4TrUka4hsk5l9HKE7nEAgymPPCG5LBirBe74w/p86QJnJ8p66X0pGouKpp7agCEYjzmrJZ9yB5n8bvAnKplv68C7GeXi7ubcjeHS4vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwwgyaD+p0O9U0RzZu7Nlwn2UtQRdAZg7GmEFhAoQ2k=;
 b=AVzPWjn3UudG1RlL+ff+eIoO2z8JjVqX3ok/5VMVyxIU3I4fjqdH8C9+mczu9GPFBjGugeNNVh+UkPduGdPSucM3BE+9uNe3QBdzhHLR2+WBgC2TfQw7NR43+SnuT7vTn3OWYRvZ21OQkglpHs6CXZrKZM80mLu1VmHVygE02S8=
Received: from SJ0P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::33)
 by SA1PR12MB8887.namprd12.prod.outlook.com (2603:10b6:806:386::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 21:50:38 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::23) by SJ0P220CA0022.outlook.office365.com
 (2603:10b6:a03:41b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.11 via Frontend Transport; Fri,
 21 Aug 2026 21:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Fri, 21 Aug 2026 21:50:37 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 16:50:36 -0500
Date: Fri, 21 Aug 2026 16:50:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba
	<tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v3 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
Message-ID: <45itvwmwd76psskfslolzxjhkd54jy6hvh3kns77wr6ojk3hpl@fnif5jsutefq>
References: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
 <20260820-gmem-no-return-page-v3-2-3bf8f80a7b4d@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260820-gmem-no-return-page-v3-2-3bf8f80a7b4d@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|SA1PR12MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f8e8a95-2b28-404e-2469-08deffce3cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|7416014|1800799024|82310400026|6133799003|56012099006|3023799007|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tykrYSuach+gsY51+qa9WUoDGASS9gCbLe4gdWTlfVOKYQOZZgCOhHgAEQr4V3N+CVJOxYqKCuM7kUPWCKASLb9OZuDpGUYbIzAAic04v4YY3YJruzeZDTVni3om69XsJwQON4RVLby/EuPaXHv7lQza+qjsGn6nFNiNofguLf7Yve43SbmK7LjPQfpVMLjcUFmx0Y1Zr9JDu62HFY/ZwN8L6tNZ8JrD8cIsGaBdJEKrc+WKQOuWi4AQ/wM4N9N5ydhLx/kwKytve44whIb9jL4JqqKHs/Fy/Pw5Z1Yc3SJHhpzXrQzxolIMgLFoJSHu9q/EFF3j7jTKdihkdSC6pQmTZIcm5QCpRCDxvfWZPYVEQlO4Qplll+s3T4V3+8654maYEHxoOaTBZLjgakyfqGTatm9p+HkkpkCDWNaYmo3Z7R31v7W3A9afFyE/Js7L15TZFaqC2+i0fJHQf98x6ot4+hhsGWbHEmh6uyzmRpeOnIqVioUcSwe6/b/Gz+fhCNvcOjpRLqE0u17Qq/zCDXQ+tTufUlt1hGwfmwGUGSCJOYBHWJSU+NdgPZLZMw1JrbNWiS+QiEDnF1S5N6pJ53kemh8n1HXOhtp6RJLyIeqV3nq5D79cyl/MC2yUk7oOyoHfSI0TsyP9AXkNRAIscJhJuT6YRo7vFxyrQWxvh0d7IQQ9Rw+KMvWppR/djNOz2Go6eIyRP6thzfJbLpUndw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(7416014)(1800799024)(82310400026)(6133799003)(56012099006)(3023799007)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f773WEbKxCy+6pungF4FPS72ohQiRqnh9CDvTr4J1WNAMMxaWuzmSOpHYaPEF5Pw15lc6agCLuKhUY7X4Dz/PLACeDIUt+ZDDLGD/dARZ0iU/xlXjQ4BW5j+QNWCuUlDfXOkKhAyHbQkYb85+GJtzXo+ht078efCHXkbQWwoB9uMJRKYnsJIiCQNRCv7maaqa2CGjI417m+1Akb4zYiAS6WfcnA2f3+Z5LmPXKVVrSExeIIJhikvKrOsT4rngIEisQrzNgc1WGG4hAKN2GgHSZCqYj1lcprenyYWcqUgZZYEfUb70jQsZM1UcZb/cMtoEssoGUOvFbH8Q495sWN7tOAsvUyZBU5XOT63UvqNw0AgwxUa0y4HOkb8z2F/X8zNGG3x3xcHhyupKEWxKRBsTHSQXtoW/pPiFaqf1a87EPHeJrQ7Uy3d5nccefZte17w
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 21:50:37.4252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8e8a95-2b28-404e-2469-08deffce3cb7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8887

On Thu, Aug 20, 2026 at 11:32:35PM +0000, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> guest_memfd.
> 
> Drop the page reference immediately after retrieving the PFN instead of
> holding it across the entire handler, and adopt the KVM MMU invalidation
> protocol.
> 
> To avoid wrongly warning about not finding an assigned RMP entry if an
> invalidation had taken place, check for invalidations before warning.

I'm ok either way, but something like the following I think would read a
bit clearer:

  When handling an RMP fault, KVM retrieves the PFN for a private GPA from
  guest_memfd as well as a refcounted struct page. This reference is
  held for the duration of the RMP fault handling to ensure the page isn't
  reallocated to another guest while processing the RMP fault.
  
  A later patch will follow up with completely not returning refcounted pages
  from kvm_gmem_get_pfn(), so prepare for that by dropping the page reference
  immediately after retrieving the PFN and, in place of that, implement the
  stardard KVM MMU invalidation logic to address the above scenario.

  While here, also make use of this KVM MMU invalidation logic to avoid
  warning about not finding an assigned RMP entry by first checking if an
  invalidation had taken place since entering the RMP fault handler.

But after writing that I realize the last paragraph is pertaining to a
new hunk added in v3, which is sort of a bug fix (in the same that patch #1 is
a fix anyway), since it fixes spurious warnings that were previously
triggerable via truncate() racing with RMP faults. However, that's exactly the
same scenario patch #1 is trying to fix, except in this case the race happens
before this path reaches the PSMASH vs. after the PSMASH like patch #1
addresses.

However, unlike patch #1 where we only need to check once again
after-the-fact, it's not possible to reliably check the before case without
the MMU invalidation logic in place, so I'm okay with squashing that
additional check in here, but decoupling that change (prep-for-something-else
vs. bug-fix made possible by prep-for-something-else) and moving it to a
patch #3 would help with de-tangle things for future git blame's.

(sorry if this seems like nit-picking; this function unfortunately spends a
lot of time in the spotlight so trying to make life easier for people making
sense of it)

Thanks,

Mike

> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> guest_memfd.
> 
> Drop the page reference immediately after retrieving the PFN instead of
> holding it across the entire handler, and adopt the KVM MMU invalidation
> protocol.
> 
> To avoid wrongly warning about not finding an assigned RMP entry if an
> invalidation had taken place, check for invalidations before warning.
> 
> When the RMP level is 4K, the function exits. That doesn't need checking
> for invalidations, since if it is 4K and there was an invalidation, not
> psmashing and not zapping is the right thing to do.
> 
> If the RMP level is 2M (the only other option), use the invalidation
> protocol before attempting to psmash. This ensures that if the page is
> truncated and freed, and then re-allocated to another SNP VM (the RMP entry
> is now assigned, but to another SNP VM), psmashing would be correctly
> skipped.
> 
> A later patch will follow up with completely not returning refcounted pages
> from kvm_gmem_get_pfn().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Michael Roth <michael.roth@amd.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2738362a928b..563870342a2ba 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	struct kvm_memory_slot *slot;
>  	struct kvm *kvm = vcpu->kvm;
>  	int order, rmp_level, ret;
> +	unsigned long mmu_seq;
>  	struct page *page;
>  	bool assigned;
>  	kvm_pfn_t pfn;
> @@ -5030,18 +5031,26 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  		return;
>  	}
>  
> +	mmu_seq = kvm->mmu_invalidate_seq;
> +	smp_rmb();
> +
>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
>  	if (ret) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
>  				    gpa);
>  		return;
>  	}
> +	kvm_release_page_unused(page);
>  
>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>  	if (ret || !assigned) {
> -		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
> -				    gpa, pfn, ret);
> -		goto out_no_trace;
> +		guard(read_lock)(&kvm->mmu_lock);
> +
> +		if (!mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
> +			pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
> +					    gpa, pfn, ret);
> +
> +		return;
>  	}
>  
>  	/*
> @@ -5069,27 +5078,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	if (rmp_level == PG_LEVEL_4K)
>  		goto out;
>  
> -	ret = snp_rmptable_psmash(pfn);
> -	if (ret) {
> -		/*
> -		 * Look it up again. If it's 4K now then the PSMASH may have
> -		 * raced with another process and the issue has already resolved
> -		 * itself. If it's not assigned, then this must have raced with
> -		 * another process that made this page shared.
> -		 */
> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> +	scoped_guard(read_lock, &kvm->mmu_lock) {
> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
>  			goto out;
>  
> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> -				    gpa, pfn, ret);
> +		ret = snp_rmptable_psmash(pfn);
> +		if (ret) {
> +			/*
> +			 * Look it up again. If it's 4K now then the PSMASH may
> +			 * have raced with another process and the issue has
> +			 * already resolved itself. If it's not assigned, then
> +			 * this must have raced with another process that made
> +			 * this page shared.
> +			 */
> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> +				goto out;
> +
> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> +					    gpa, pfn, ret);
> +		}
>  	}
>  
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
> 2.55.0.766.g2966f0265a-goog
> 
