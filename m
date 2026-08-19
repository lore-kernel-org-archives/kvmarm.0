Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010060.outbound.protection.outlook.com [52.101.193.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55463911CA
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100579; cv=fail; b=GccILw64w0ZUJBWYFO/I3xsueI9wl8AbPhejpCO9kqHAxgXA8f8+cNp7/1fcL3oUrsqfcouQ4nd0eygrRa1n3RLPaFvi5C/8z19J+rpMU8vgb1R89fOGskpSv578qF/zk/oDzAWz6rcj4LORezEzEb6mQ5ugysDPpRj8Vso9KNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100579; c=relaxed/simple;
	bh=9KjhvNp9NyDy2BIrHQx53GNi/7uBPJ/YM7OyCvc08v4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kju3RBExrMRBXhhVaj5LKjtq7/5L/7YcMFfejglN/gw1V1UUwiEepK3ubYDCNDsFsJRkFgwIMv/X8U9ZRPn3v6UCogFmUN6pbVfc1Wbz0nqLCjLhlCtjf3jFOTrfJwf/KyyZXZ17F7MiPfJCfvFD+St3S4I7YeElJSzvl9zItUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cep3j/2r; arc=fail smtp.client-ip=52.101.193.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cep3j/2r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P3Z39WQOamr4qenJMY1VxM37zDVxHvi+F9N/RzbodEMNXA8mAGLEVmkX1WLtpDyLadC6vZbBLfcTlGyEkQajfsSB0d9O6Vy8P5dkeNKIt0iHX2OgdSpkIcVnr/ZKdrup6u5fypxtjtOxgHtL0q+cbw00bX48ijo9ms7UnqKV+Q7w2O1oVYkZUUql7gB/RLN2coEB25wgSZ6xiZ80SUDd/gpUGBQdwoh+4w/6qxKKslvFgU/8jrZRhx5T+mL2Q2iW2cUJUMcyMxVPtPCzF3eSyHHLiwgHNtHHSnwsbku+fTDQnDHkRgXYedx7CvLB/83sc9oLID/w16SO4gR5VqUoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpN/Q3Gi5YABNOMiuXTUChAsOLY88LLxPU5QlLJOW0c=;
 b=iJ7Ij2upM1LJl/i8sTUSJOxQPFetU1/895fgTbLIp7e3QceKWx+i3rzPVcZpxKgMu/l1ToS3QjGpr/xZrtYHKoJ3/8YbnoYp4ruPrz5m02ewTeTGJ3B/ZJy1DHWhn0rzyp6o3IiEK66bh5DPv7Ldu00ZWZP1x0yJC3GXh5ri6RheAVb8opWLXcujYfAVDOOBlWSwqwa70kOkJRFO2xEds86nZOGVYCM6s+0hxe4MlVTV5oND3tFqsvk9QnDJm9ujgWkdXSpqvWFP+Cowk3ds/P+rmzLwN2YKYkZGd1cNkUQ1hQ6342FBz1XJzUMFQbtPNzv+NFzgZCesUGqqeB5OKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpN/Q3Gi5YABNOMiuXTUChAsOLY88LLxPU5QlLJOW0c=;
 b=cep3j/2rz5ywwDIymVj2NculQt/2oUMrLA5uqfKxbeXu8Rpw83wU/keuQiTTujWBVRWrlEW9Fo5frZEACwZcqdNtmXfJhoc6ml+5k4gjY7bDTHJIPk86R+2UgTwA6cDi1iAVLL5j4Tmr8tKzBDjyuX58XNL6JUI1uPFItRIgjXI=
Received: from SA0PR13CA0021.namprd13.prod.outlook.com (2603:10b6:806:130::26)
 by LVUPR12MB999183.namprd12.prod.outlook.com (2603:10b6:408:3a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 00:49:26 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:130:cafe::3e) by SA0PR13CA0021.outlook.office365.com
 (2603:10b6:806:130::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 00:49:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 00:49:25 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 19:49:25 -0500
Date: Tue, 18 Aug 2026 19:49:08 -0500
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
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
Message-ID: <eey6juiwdmunedyslruw2gr5c2h67gtdmfmvdjycih7ib3s7ff@sfx24kvff4df>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|LVUPR12MB999183:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf8dfbb-ddb8-4239-a2c4-08defd8bb7b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|376014|82310400026|36860700016|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KjGQRAacl8i6TKCkmYXzZqR7Vfmn9867OaUomjVshpFgkYozzgHakqiEOU3+nT7t2VuhapeP8BMTAtvqzgdjvm4Pv376b4utBK5B4H9GjZaZ8cTJt/+bYGECtN0hUukeSGU3MNYAaa1hj+venbEynqo6mLjAfME/1PbGAlxTBCDSTqbWJQy7gOsW3DAvGyBwg9BY2TqkpiNtzBo30P6UqpBVqMczIyFqQBCK6i8maYQ/jPYuM+UyE0e8ceMf3pWGvskJLSJacXY64iseJyfiRGXe4XmY2B9U/75Wsd7agYLbfubCxl7TRsF3CFdZWw9eQ0cnPFZdEBDa/gTkSz1kqyEj5ALYaUIz1pASY9eAIh75jrt44BsZ4CIykiy2jWL0FpRDVzlsfgcUpTIQ/XK4ljZG1am1i1jcjDhkFGnEbU0QLmFx1c3RL2bojuZB2ax6/4MxaQZqjoZE9x58qFby7lH0JeRiBWlp0F2iKKotO4vFWJaYdsrJu0rLrgWssjWa5b5fQm+1jo9MBz5bXDN56aDCN0uTnMRpIa2ZeliL3zj1pZgy+veVmi0p2CM6CItPyhKNm3+M/aleYigLrz8qJyYShY+imUadUiGXRTy2ymWSoBQEp9uNWoTgtLpxS0wMH0xnKhG+5MH9Fc6WP31WSeiEu3gL8VN+fs3L51UaktWzieRap5QJuWIEQXqM8qySsy5XG8wIO/BhbOrRKcmoJw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OZNPmDH3kut6MXWFvmQQ+fDQJvdW5oEYLGFHCu18HGBTMe70AHJzuc35rDU3OCJm+RN9HlYvGd/+6JuD8Y0/tcxqEliEjxV2UdYJC4ISbOqN+Qu896EZYCoAeRNlbZVHS7NDfdliUqPuCOFQx4esxOvTrocY9EyYc8tjYh8fdVtAyDSG+Y1OmDNOlqV+AwsnSZX0hiCyIRbEp2tY1ILLgHHvURbi4zXOniJE67XTHyUVJrY7GiXyJbDGP6YKluqUwxbICiTlTtzfB7Tjx3NvyoBTmJQ6KiwmTIyF51K4NeO9nxUX1/LDIpf8GhM6eE49Z0KjtMw+obve1J/HVopvqACPSOqupCjXbq2vjBpbaEIvq0XIQlNcRJ5iFmaAnFny9izpfwzKd+BwDvR7Y/iXx0CMTroIkhEVF9pKvfFEb/+Wj7uvF0sK644YMKL5ULpg
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 00:49:25.7230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf8dfbb-ddb8-4239-a2c4-08defd8bb7b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999183

On Tue, Aug 18, 2026 at 09:15:55AM +0000, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> KVM currently expects guest_memfd PFN lookups to return a refcounted
> struct page, which callers hold across fault handling.
> 
> Holding a page reference across fault handling is problematic for
> guest_memfd. In-place memory conversions between confidential
> computing shared and private states inspect folio refcounts to ensure
> exclusive ownership by guest_memfd. A concurrent guest page fault
> taking a reference on the folio causes conversions to fail due to an
> elevated refcount.
> 
> guest_memfd already notifies KVM of page invalidations, so callers
> within KVM only need to respect the MMU invalidation protocol to safely
> rely on guest_memfd for page presence.
> 
> Furthermore, removing struct page from the guest_memfd PFN lookup moves
> KVM closer toward supporting memory backends that are not backed by
> struct page.
> 
> Drop the folio reference immediately before returning from the
> guest_memfd PFN lookup, and stop returning the struct page pointer.
> 
> For ARM, initialize the local page pointer to NULL so that the shared
> cleanup path that releases fault-in pages safely no-ops for guest_memfd.
> 
> For x86, no additional changes are required in the MMU fault path
> because the page fault tracking structure is zero-initialized at the
> start of page fault handling, ensuring the refcounted page pointer is
> already NULL.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com/
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Other than what Suzuki pointed out:

Reviewed-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/arm64/kvm/mmu.c     | 4 ++--
>  arch/arm64/kvm/nested.c  | 4 ++--
>  arch/x86/kvm/mmu/mmu.c   | 2 +-
>  arch/x86/kvm/svm/sev.c   | 8 ++------
>  include/linux/kvm_host.h | 6 ++----
>  virt/kvm/guest_memfd.c   | 9 ++-------
>  6 files changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..e5d637a5ec558 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1613,7 +1613,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>  	unsigned long mmu_seq;
> -	struct page *page;
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
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index fb54f6dad995c..43523bb17621a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1360,7 +1360,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  	bool write_fault, writable;
>  	unsigned long mmu_seq;
>  	struct vncr_tlb *vt;
> -	struct page *page;
> +	struct page *page = NULL;
>  	u64 va, pfn, gfn;
>  	int ret;
>  
> @@ -1411,7 +1411,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
>  			return -EFAULT;
>  	} else {
> -		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
> +		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
>  		if (ret) {
>  			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
>  					      write_fault, false, false);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c519e8e8d646f..129d403308051 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4604,7 +4604,7 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>  	}
>  
>  	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
> -			     &fault->refcounted_page, &max_order);
> +			     &max_order);
>  	if (r) {
>  		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>  		return r;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d3d620bc04dce..32db979daaaf0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4016,7 +4016,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  	struct kvm *kvm = vcpu->kvm;
>  	gfn_t gfn = gpa_to_gfn(gpa);
>  	unsigned long mmu_seq;
> -	struct page *page;
>  	kvm_pfn_t pfn;
>  
>  	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
> @@ -4060,9 +4059,8 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  	 * The new VMSA will be private memory guest memory, so retrieve the
>  	 * PFN from the gmem backend.
>  	 */
> -	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
> +	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
>  		return;
> -	kvm_release_page_clean(page);
>  
>  	read_lock(&kvm->mmu_lock);
>  	/*
> @@ -5003,7 +5001,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	struct kvm *kvm = vcpu->kvm;
>  	int order, rmp_level, ret;
>  	unsigned long mmu_seq;
> -	struct page *page;
>  	bool assigned;
>  	kvm_pfn_t pfn;
>  	gfn_t gfn;
> @@ -5033,13 +5030,12 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	mmu_seq = kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> -	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
> +	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
>  	if (ret) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
>  				    gpa);
>  		return;
>  	}
> -	kvm_release_page_unused(page);
>  
>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>  	if (ret || !assigned) {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bfc92864b6e..502465119ca0c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2586,13 +2586,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  
>  #ifdef CONFIG_KVM_GUEST_MEMFD
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> -		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> -		     int *max_order);
> +		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
>  #else
>  static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
> -				   kvm_pfn_t *pfn, struct page **page,
> -				   int *max_order)
> +				   kvm_pfn_t *pfn, int *max_order)
>  {
>  	KVM_BUG_ON(1, kvm);
>  	return -EIO;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184ca..589762140c3ef 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -751,8 +751,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  }
>  
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> -		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> -		     int *max_order)
> +		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct folio *folio;
> @@ -780,11 +779,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  #endif
>  
>  	folio_unlock(folio);
> -
> -	if (!r)
> -		*page = folio_file_page(folio, index);
> -	else
> -		folio_put(folio);
> +	folio_put(folio);
>  
>  	return r;
>  }
> 
> -- 
> 2.55.0.699.gb54405d56f-goog
> 
