Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F828305666
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 02:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774918; cv=none; b=Bm9EoRxUsnZEHVDFGLlqZXe+OY+E9B29c3dRX3l4n8RxdJ8H+Xt0UrouaYm0+1ssG1KPDV6x0Qtf/ybBc4j/T1gv+eReiEXlgjanoLvJlFeat2GJ13GLdXhI1ahjxnVzGU4Rc1zYODto6YqbaG972x7LDux0qIMU74kvFjd1QRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774918; c=relaxed/simple;
	bh=xO4Xsg6WMoznKKLCX2VF4Rxpd9VvTwSKgFTxYveIfGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBczSLYPzbDbk5qnSkOds3XkOYlYCa6E/9B/6jyMvnBvETpZLXwCfV73SXskzjwbXhpprj6VWGxSI7emDZUcZOyGvxygM2tJvGrkiXqR2Lzp/zPv0A1BJFMtOx+YPLfOILNT4yqiI2XqOG0HB5bzoemqM/d5p4196FURqSKsH5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=neDX52RF; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="neDX52RF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784774916; x=1816310916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xO4Xsg6WMoznKKLCX2VF4Rxpd9VvTwSKgFTxYveIfGI=;
  b=neDX52RFF9nhLLcjcGpGCQmv8NfaZkEIaIo8vOfLiH187FdbflX3bt2L
   /F7MBgMQwIEq4zHRzvQ3PGF38Z4s6NH3NghwOgXkNp8ldcI893yMS9e1Q
   jZuSKPsL/bGVZ9uRVums7t1ZjKFKFPoXB3onB+HW7Cu+wXOZ1q3LibIMK
   bAnPHyA8qoWE5JWihz/zkuNXzxJSGNY43gnmLDOjJjMN4xGdUbTf9IWQV
   GJY2Uoi7qycgC3eVv9o+3J0ZYbkXVRGsTRK10hopetM/5TeSsc0HzP6ej
   mDqk4Cz0KhWTGn+BFCuaLA1EUdGo96he77chLt1cRx0t2AfJ3P6rPGVO/
   w==;
X-CSE-ConnectionGUID: lNwtstspRqOhnELGH/GdGA==
X-CSE-MsgGUID: qx8NOjmrR9Wl+gQiwPjMEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="248295242"
X-IronPort-AV: E=Sophos;i="6.25,179,1779116400"; 
   d="scan'208";a="248295242"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 11:47:25 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id A7855839A
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 02:47:25 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 5436318009FF
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 02:47:25 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id CECEC10001D0;
	Thu, 23 Jul 2026 02:47:19 +0000 (UTC)
Date: Thu, 23 Jul 2026 11:47:16 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 8/9] KVM: arm64: selftests: Add infrastructure for
 using stage-2 in guest
Message-ID: <amGAtKiTirVSHUky@sm-arm-grace07>
References: <20260516183003.799058-1-weilin.chang@arm.com>
 <20260516183003.799058-9-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516183003.799058-9-weilin.chang@arm.com>

On Sat, May 16, 2026 at 07:30:02PM +0100, Wei-Lin Chang wrote:
> Add a stage-2 page table generator, the s2_mmu structure, and vEL2
> stage-2 preparation code for a guest hypervisor to turn on stage-2
> translation for its nested guest.
> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  .../selftests/kvm/arm64/hello_nested.c        |   2 +-
>  .../selftests/kvm/arm64/shadow_stage2.c       |   2 +-
>  .../selftests/kvm/include/arm64/nested.h      |  15 +-
>  .../testing/selftests/kvm/lib/arm64/nested.c  | 145 +++++++++++++++++-
>  4 files changed, 160 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
> index 9ed5285f5f2d..b57e41c73214 100644
> --- a/tools/testing/selftests/kvm/arm64/hello_nested.c
> +++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
> @@ -62,7 +62,7 @@ static void guest_code(void)
>  	l2_stack_top = ucall_translate_to_gpa(&l2_stack[L2STACKSZ]);
>  
>  	init_vcpu(&vcpu, l2_pc, l2_stack_top);
> -	prepare_hyp();
> +	prepare_hyp_no_s2();
>  
>  	ret = run_l2(&vcpu, &hyp_data);
>  	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
> diff --git a/tools/testing/selftests/kvm/arm64/shadow_stage2.c b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
> index c5332b8b5683..2b274b810dcf 100644
> --- a/tools/testing/selftests/kvm/arm64/shadow_stage2.c
> +++ b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
> @@ -72,7 +72,7 @@ static void guest_code(void)
>  	l2_pc = ucall_translate_to_gpa(l2_guest_code);
>  
>  	init_vcpu(&vcpu, l2_pc, l2_stack_top);
> -	prepare_hyp();
> +	prepare_hyp_no_s2();
>  
>  	while (true) {
>  		GUEST_PRINTF("L2 enter\n");
> diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
> index fc59fabff12d..1bcbb31b8d67 100644
> --- a/tools/testing/selftests/kvm/include/arm64/nested.h
> +++ b/tools/testing/selftests/kvm/include/arm64/nested.h
> @@ -38,6 +38,14 @@ struct vcpu {
>  	struct cpu_context context;
>  };
>  
> +struct s2_mmu {
> +	gpa_t pgd;
> +	unsigned int vmid;
> +	unsigned int page_size_shift;
> +	u64 vtcr;
> +	u64 ipa_bits;
> +};
> +
>  /*
>   * KVM has host_data and hyp_context, combine them because we're only doing
>   * hyp context.
> @@ -56,8 +64,13 @@ struct page_pool {
>  size_t get_page_size(void);
>  gpa_t alloc_page(struct page_pool *pp);
>  bool has_tgran_2(u64 mmfr0, size_t size);
> -void prepare_hyp(void);
> +void prepare_hyp_no_s2(void);
> +void prepare_hyp(struct s2_mmu *mmu);
>  void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top);
> +void create_s2_mapping(struct s2_mmu *mmu, u64 ipa, u64 pa, size_t size,
> +		       struct page_pool *pp);
> +void init_s2_mmu(struct s2_mmu *mmu, unsigned int vmid, gpa_t pgd,
> +		 size_t page_size, u64 ipa_bits);
>  int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
>  
>  u64 do_hvc(u64 action, u64 arg1, u64 arg2);
> diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
> index cda41f355263..9848d607ef64 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/nested.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
> @@ -71,13 +71,22 @@ gpa_t alloc_page(struct page_pool *pp)
>  	}
>  }
>  
> -void prepare_hyp(void)
> +void prepare_hyp_no_s2(void)
>  {
>  	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW, hcr_el2);
>  	write_sysreg(hyp_vectors, vbar_el2);
>  	isb();
>  }
>  
> +void prepare_hyp(struct s2_mmu *mmu)
> +{
> +	write_sysreg(mmu->vtcr, vtcr_el2);
> +	write_sysreg(mmu->pgd | ((u64)mmu->vmid << 48), vttbr_el2);
> +	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW | HCR_EL2_VM, hcr_el2);
> +	write_sysreg(hyp_vectors, vbar_el2);
> +	isb();
> +}
> +
>  void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top)
>  {
>  	memset(vcpu, 0, sizeof(*vcpu));
> @@ -86,6 +95,140 @@ void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top)
>  	vcpu->context.sys_regs[SP_EL1] = l2_stack_top;
>  }
>  
> +static int stage2_levels(unsigned int page_size_shift, u64 ipa_bits)
> +{
> +	/* taken from ARM64_HW_PGTABLE_LEVELS(ipa) in KVM */
> +	return (ipa_bits - 4) / (page_size_shift - 3);
> +}
> +
> +static u64 get_index(struct s2_mmu *mmu, u64 ipa, int level)
> +{
> +	int width = mmu->page_size_shift - 3;
> +	int shift_amount = mmu->page_size_shift + (3 - level) * width;
> +
> +	return (ipa >> shift_amount) & GENMASK_ULL(width - 1, 0);
> +}
> +
> +static u64 pte_gpa_to_gva(u64 gpa)
> +{
> +	/*
> +	 * This depends on how the memory used for s2pt is mapped in GVA,
> +	 * currently it is assumed they are idmapped.
> +	 */
> +	return gpa;
> +}
> +
> +static u64 pte_to_pt_base(u64 pte)
> +{
> +	return pte & GENMASK_ULL(47, 12);
> +}
> +
> +#define S2_PTE_AF		(1ULL << 10)
> +#define S2_PTE_SH_INNER		(3ULL << 8)
> +#define S2_PTE_S2AP_RW		(3ULL << 6)
> +#define S2_PTE_ATTR_NORMAL_WB	(0xfULL << 2)
> +#define S2_PTE_TYPE_TABLE	(1ULL << 1)
> +#define S2_PTE_TYPE_PAGE	(1ULL << 1)
> +#define S2_PTE_VALID		1ULL
> +
> +/* No block mappings for now. */
> +static void create_one_s2_mapping(struct s2_mmu *mmu, u64 ipa, u64 pa,
> +				  struct page_pool *pp)
> +{
> +	int levels = stage2_levels(mmu->page_size_shift, mmu->ipa_bits);
> +	u64 index, pte, pte_new, table_attr, page_attr;
> +	gpa_t pte_addr, pt_base = mmu->pgd;
> +
> +	table_attr = S2_PTE_TYPE_TABLE | S2_PTE_VALID;
> +	page_attr = S2_PTE_AF | S2_PTE_SH_INNER | S2_PTE_S2AP_RW |
> +		    S2_PTE_ATTR_NORMAL_WB | S2_PTE_TYPE_PAGE | S2_PTE_VALID;
> +
> +	for (int level = 4 - levels; level <= 3; level++) {
> +		index = get_index(mmu, ipa, level);
> +		pte_addr = pt_base + index * 8;
> +		pte = *((u64 *)pte_gpa_to_gva(pte_addr));
> +
> +		if (level == 3) {
> +			/* Last level, install leaf entry. */
> +			pte_new = pa & ~GENMASK_ULL(mmu->page_size_shift - 1, 0);
> +			pte_new |= page_attr;
> +			*((u64 *)pte_gpa_to_gva(pte_addr)) = pte_new;
> +		} else if (!(pte & S2_PTE_VALID)) {
> +			/* Empty next level table, allocate and install. */
> +			pte_new = alloc_page(pp);
> +			pte_new |= table_attr;
> +			*((u64 *)pte_gpa_to_gva(pte_addr)) = pte_new;
> +			pt_base = pte_to_pt_base(pte_new);
> +		} else {
> +			/* Next level table found, descend into it. */
> +			pt_base = pte_to_pt_base(pte);
> +		}
> +	}
> +}
> +
> +void create_s2_mapping(struct s2_mmu *mmu, u64 ipa, u64 pa, size_t size,
> +		       struct page_pool *pp)
> +{
> +	u64 ipa_end;
> +	u64 mask = pp->page_size - 1;
> +
> +	ipa_end = (ipa + size + mask) & ~mask;
> +	ipa &= ~mask;
> +	pa &= ~mask;
> +
> +	while (ipa < ipa_end) {
> +		create_one_s2_mapping(mmu, ipa, pa, pp);
> +		pa += pp->page_size;
> +		ipa += pp->page_size;
> +	}
> +	dsb(ishst);
> +}
> +
> +void init_s2_mmu(struct s2_mmu *mmu, unsigned int vmid, gpa_t pgd,
> +		 size_t page_size, u64 ipa_bits)
> +{
> +	u64 ps, tg0, sl0_base, mmfr0 = read_sysreg(id_aa64mmfr0_el1);
> +	int levels;
> +
> +	mmu->vmid = vmid;
> +	mmu->pgd = pgd;
> +	mmu->ipa_bits = ipa_bits;
> +	mmu->vtcr = 0;
> +
> +	switch (page_size) {
> +	case SZ_4K:
> +		tg0 = VTCR_EL2_TG0_4K;
> +		mmu->page_size_shift = 12;
> +		sl0_base = 2;
> +		break;
> +	case SZ_16K:
> +		tg0 = VTCR_EL2_TG0_16K;
> +		mmu->page_size_shift = 14;
> +		sl0_base = 3;
> +		break;
> +	case SZ_64K:
> +	default:
> +		tg0 = VTCR_EL2_TG0_64K;
> +		mmu->page_size_shift = 16;
> +		sl0_base = 3;
> +		break;
> +	}
> +
> +	levels = stage2_levels(mmu->page_size_shift, mmu->ipa_bits);
> +	mmu->vtcr |= FIELD_PREP(VTCR_EL2_SL0, (sl0_base - (4 - levels)));
> +
> +	ps = SYS_FIELD_GET(ID_AA64MMFR0_EL1, PARANGE, mmfr0);
> +	/* cap ps to 48-bit */
> +	ps = ps > 0b0101 ? 0b0101 : ps;
> +	mmu->vtcr |= VTCR_EL2_RES1 | SYS_FIELD_PREP(VTCR_EL2, PS, ps)           |
> +				    SYS_FIELD_PREP(VTCR_EL2, TG0, tg0)         |
> +				    SYS_FIELD_PREP_ENUM(VTCR_EL2, SH0, INNER)  |
> +				    SYS_FIELD_PREP_ENUM(VTCR_EL2, ORGN0, WBWA) |
> +				    SYS_FIELD_PREP_ENUM(VTCR_EL2, IRGN0, WBWA);
> +
> +	mmu->vtcr |= FIELD_PREP(VTCR_EL2_T0SZ, 64 - ipa_bits);
> +}

I understand that the selftest intentionally passes 40 as ipa_bits to init_s2_mmu().
However, with a 16KB granule and DS=0, a 48-bit IPA requires two
concatenated level 1 root tables, which this implementation does not
appear to support.

Thanks,
Itaru.

> +
>  void __sysreg_save_el1_state(struct cpu_context *ctxt)
>  {
>  	ctxt->sys_regs[SP_EL1] = read_sysreg(sp_el1);
> -- 
> 2.43.0
> 
