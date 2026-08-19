Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A27D3B3BE1
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 00:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787099722; cv=fail; b=Cm0WB/1PJVuNjV/wPqC4sOjMKKZ02EkhotmlqCdH9YYwLUUmvqFcgP2bBCYVRJLiukoVV7uuWwRYdwgOEcpkjC15pYEio1kbjnzlLVCLPD3T+ZIDi4fGMH89RsNajYDuzYDza46BShecqE9ykDCn13cfgg6PZVFQruw262ettg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787099722; c=relaxed/simple;
	bh=o9g4l3zCpEFUkVkvxyfmfI4cAmyL+5GUvdkaAwN4IYA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S79iQ5izYQ3YIzHcVwrzTEMj38IIOtSRpS6cJLAvV/55WvZC2HbUhShQOaZwuPKARmXhop4BxPAsIvD9foXCfGVYdyfrBgw0ni06yqbgtbI/gZ7rtPToyxKXBc2zzpKwhNd8qyo7q2eSF1iwoUTCUzY40XFYzPEdXexi5dxEVCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ru8Hcdid; arc=fail smtp.client-ip=52.101.48.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ru8Hcdid"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cfXqRgw6RebDTJ3g4wWuTdkK+04C5koyTZqFU9I0FLeWlYE21m3CsDDYskVdOR4kS5xnVR6YuX6vy+raP+ksT3ZbvERMGb6H+3GRfqI+ePXryXTjuhXIDGyJQ0lfSY+Jt3qxbymNFRP8pFKbPEsAm1a9OyVK35j+DUGSIy5hViJvQSdia2ng1dfYkTftkPbIuLMQdTZ28gKlP+O9EtZmwj4NhUu+rZ7lNa3KLOyO8pd8ShzGJya136OXUUUn9a7PDgCd7iRZmGrLlNMmeJs+Ec10dQrwxC7EQ8Y68GwXOaFMCMkDJ8UmqM5mTfHyYHrAHaFfxeEuSvKsiyMEwAScyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APvgxVJnU1X7sj6Yc2typUpskInkjjdo8wcnDUVeQ8E=;
 b=aTcOxBMrJtO5Y2JIE1iFcupilH4f8OFr8L+n/Fa5fsw2iMt57n5rysAfofcNuaXz/okfKoAWRgbNhkBCGcXK/mDxzeI/c/Yde00jeAB+xpmYAItZM7zAHZxDjuu0La4sV4BeDeKTBNdU7kvVPuocCsYpbI3w9vdjCNUdUPVwtjmYfEzX8fDS96ME3dK4Hv4CIEZTZA7mJkuBJzz7pUy8my7ALHbpR3vT0qlHkGusx//KNlS73SD5Qc0Veg7aSTqYnFs5PixpQY2bGnCgk5FMpj8FRz9drgZOcdaX1ZqGtSuPcynR4+IzwbsRwT1k9UnpwHpTHUYWARgKIguwkL58Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APvgxVJnU1X7sj6Yc2typUpskInkjjdo8wcnDUVeQ8E=;
 b=ru8HcdidKg1OJLr6WwhYUwQdaM9/YcadPjKni3WYP4LA/rbLo+QbUhoGNBBF7gJxq9xDcPT0mrEcOHUsAMQmGwPVHkH5SGuhQkzGh6R6TQpf8p284nTvNeNhKApSxhhpbDaE0W/DnoUcSuu0no8syjRKrEEn8lwyhxDmb+iLbfc=
Received: from PH0PR07CA0085.namprd07.prod.outlook.com (2603:10b6:510:f::30)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 19 Aug
 2026 00:35:08 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:510:f:cafe::32) by PH0PR07CA0085.outlook.office365.com
 (2603:10b6:510:f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 00:35:08 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 00:35:07 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 19:35:04 -0500
Date: Tue, 18 Aug 2026 19:23:23 -0500
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
Subject: Re: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
Message-ID: <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd9f3f0-02d5-4732-fd8a-08defd89b82a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|1800799024|82310400026|23010399003|56012099006|22082099003|10067099003|11063799006|3023799007|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	x8kijdVGujwDTqZRCtK/WlWQr9E6db6FDwclpdeTC1HIptPmdoMpflJr6WW4+/bIwW0sGzRH8fDTUIfLhWeiBeGxbyo9TPkBexCNaDXfC9zygjB3ftnQ5YptFoG4Nk8nsvo5f9FdNsK4hYkYaTPWCeKUst43+EEHOoWajA4bK4WGM7tXWpfy6avCA8HkgtbgizLVgz/DKEkiFaIVInL7tScliFJxXJN3oM9u91M414F0TmbhzfJ4VnsRlWkDTHjMnQ4lWeRh6Nt3JF6hf0yZGjcRT9A88QdNArANYeFSc5REkKz87m8yQZd5XycdixJn//KAI/jqFqBll0Ge4AuNwsFkeiEzpXrdnCaWzt2xdHpN5dovecKqsMsjtRHpHqHJBdV4/jwflOgLPckC2rVCnVPw9yQIUY04ZvGCEdQ7gw8wsrSYMXjMHXac4o32xlDvU240J9w5tBYOS7EPTf+3VVxYgr9A4eQzBvXihHWG0RAVP3hmVuO2CdUYSvILtR8oJEoRlVfr8BFGpBsMre/LRRCKffsKZlbpCU1XfsKZhpjIS8eIaGtQwKmBTu2YRPbEtILsTGD5q8DsuoJw75fb+v1OsdllEPQtk3fT26tgs5Xv01NnPn2jmwq/6ogjXJS5caGnCFDnzvh/Xq+MM5oMvE869AqCnCDMeZ4OU6DvsbT/c34SIeqM/+sJHEG2SOunoKFBLf6sJ2xKgQIkbYwjiA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(1800799024)(82310400026)(23010399003)(56012099006)(22082099003)(10067099003)(11063799006)(3023799007)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xVBr/2c0v+P2od89rJuVRSiFDXOaaaME5RG9FOC/7cBPw8w3CsGDanRMV65ijiOk4Spb2wYY5EsfdWEb5kdZS4aEX6G7PWLYDG2mTfzu7+44NyIwrj3ZV/wzbE+5ov+ebwAeUrUT01Ng975lSQzKefjm5JulxKku6lEKQGn8q1i1vUl/hrg8tmqINjQ/mDHZfRF1wqkY44WtabNBlA3vlIjaYSmObCr1b0JCzqk9T8GQ1vtgl6SS7v1VqHPBDQtLE2jUvHHAZcl+iIS0w+RrZKunQo+0ekpge7efVdPerm98qQ5xY2zfSSboBX12Tk+sS5i0TZw4Ka3mzZCdpfNqhO9qDMi6yzt5S2vMbOchfTkDiJcU7Vnw2BSrssOywMoVWvjLQPSlpXV5GZC/HOrhCGAf5gbG0aOEKdbD5Yito/4oRW5un42/UsEr+fGo2U/w
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 00:35:07.4874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd9f3f0-02d5-4732-fd8a-08defd89b82a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769

On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> guest_memfd.
> 
> Drop the page reference immediately after retrieving the PFN instead of
> holding it across the entire handler so that the later patch can follow up
> with completely not returning refcounted pages from kvm_gmem_get_pfn().

Regarding this point:

> 
> On a first look, existing RMP table handling (psmash and checking for
> errors) might seem like it works fine, since truncation of the page from
> guest_memfd would have called rmp_make_shared() and removed the PFN from
> the RMP table. However, that is insufficient since a freed page may already
> be used in a different SNP VM.

In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
ref is enough to avoid the reused-by-another-SNP-VM scenario until after
caller releases the ref, so I think the above explanation should be adjusted
to also be preparatory for "the later patch".

Other than that:

Reviewed-by: Michael Roth <michael.roth@amd.com>

> 
> Hence, adopt the MMU invalidation protocol to guard committing anything
> based on the PFN.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2738362a928b..b34b11d7f8fad 100644
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
> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>  				    gpa, pfn, ret);
> -		goto out_no_trace;
> +		return;
>  	}
>  
>  	/*
> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
> 2.55.0.699.gb54405d56f-goog
> 
