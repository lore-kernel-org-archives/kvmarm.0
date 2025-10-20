Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03765733E
	for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004544; cv=none; b=hTyvh29oSFzkYa4LNy5tongaq1KUPm8LkyJVjQFKIEwdmMDhEFD0D4q6hct4rNzqIhRfsiZ2hd1/RnzCZ77tCGqzRe5W8FZd1HJY2kjA+eK/TGat6FBZvGEnH3ze8PDUSREGE9OzsBWiggCj9Jg/Tvv0ol5PppXuBoEUnIr6MEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004544; c=relaxed/simple;
	bh=7B9Q949LyCTi/uWG8XxY/wlXF/2XkP8y6115YnUjfqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQ96/s+pZ9yLmzf+xQ9ec1X/O9UUkwbAgeiIwAf18v72VxYl9u3ypvOqZnHq1rbw6lzux9B+zxCZedF1UDXk2o+NCf7t/Rm/XcUyh8d0h9XuCU9ByZhZqUds47bbUtN0V8EanpfiFXUdsk0MkuzwdtJgoMOLCOca8NOHZj5Yp/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=saJoZk18; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="saJoZk18"
Date: Mon, 20 Oct 2025 16:55:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761004539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnOhbJNV63wEIPrr4TL5LUq5z/Xh0OfjqLgXSuspKbM=;
	b=saJoZk18Eu5/IeLbCS1m2/9ngWJfcDe/+fv2xc71Vd+Nk6ZJ4FzktRbjVyrQDU8uiHv5Xj
	oWbNgAXSzFQ2o+b2wMWVpUDI0kAiyIvbzDK9hwCZUvNbMQrW/q6e96WXELO8Ml/nqzeIEB
	vjdqaumTpI7w6mdRq4czjB9L6Nlrkdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
Message-ID: <aPbL8NCPCfLHIB3w@linux.dev>
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
X-Migadu-Flow: FLOW_OUT

Hi Itaru,

Thanks for looking in to this.

On Mon, Oct 20, 2025 at 06:08:58PM +0900, Itaru Kitayama wrote:
> Hi,
> 
> Below is my attempt to add stage 2 mapping helpers for the KVM selftest test framework as almost a duplicate of _virt_pg_map(), I thought for FEAT_NV2 feature testing, it’d be nice to have helpers rather than writing it in selftests. Comments are appreciated. 4KB page size, and 4 levels of stage 2 translation is assumed. 

FYI, you've got some line wrapping issues here and in the diff itself.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 11b6c5aa3f12..6fe9210eeeb6 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -106,6 +106,7 @@ struct kvm_vm {
>  	bool pgd_created;
>  	vm_paddr_t ucall_mmio_addr;
>  	vm_paddr_t pgd;
> +	vm_paddr_t s2_pgd;
>  	vm_vaddr_t handlers;
>  	uint32_t dirty_ring_size;
>  	uint64_t gpa_tag_mask;

A better approach would be to add a tracking structure for a stage-2 MMU
context. Eventually we will need selftests to create multiple stage-2
page tables, complete with the MMU context (VMID, VTCR, etc).

e.g.

struct s2_mmu_ctxt {
	vm_paddr_t	pgd;
	u64		vtcr;
	u16		vmid;
};

> +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
> +
> +static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> +{
> +	virt_arch_s2_map(vm, ipa, paddr);
> +}

This is all going to be arm64-specific, no need for indirection through
something pretending to be arch-generic.

> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -124,6 +124,96 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
>  				     vm->memslots[MEM_REGION_PT]);
>  	vm->pgd_created = true;
> +
> +	vm->s2_pgd = vm_phy_pages_alloc(vm, nr_pages,
> +                                     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +                                     vm->memslots[MEM_REGION_PT]);
> +}
> +

Instead introduce a helper for initializing a "struct s2_mmu_ctxt" (or
whatever you choose to name it).

> +static void _virt_s2_map(struct kvm_vm *vm, uint64_t ipa, uint64_t paddr, uint64_t flags)
> +{
> +	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
> +	uint64_t pg_attr;
> +	uint64_t *ptep;
> +	uint64_t *pgdp;
> +
> +	ptep = addr_gpa2hva(vm, vm->s2_pgd) + pgd_index(vm, ipa) * 8;
> +	if (!*ptep) {
> +                *ptep = addr_pte(vm, vm_alloc_page_table(vm),
> +                                 PGD_TYPE_TABLE | PTE_VALID);
> +	}
> +
> +	switch (4) {

Taking a constant here instead of the page table geometry.

> +#define KVM_PTE_VALID                   BIT(0)
> +
> +#define KVM_PTE_ADDR_MASK               GENMASK(47, PAGE_SHIFT)
> +#define KVM_PTE_ADDR_51_48              GENMASK(15, 12)
> +#define KVM_PTE_ADDR_MASK_LPA2          GENMASK(49, PAGE_SHIFT)
> +#define KVM_PTE_ADDR_51_50_LPA2         GENMASK(9, 8)
> +
> +#define KVM_PHYS_INVALID                (-1ULL)
> +
> +#define KVM_PTE_TYPE                    BIT(1)
> +#define KVM_PTE_TYPE_BLOCK              0
> +#define KVM_PTE_TYPE_PAGE               1
> +#define KVM_PTE_TYPE_TABLE              1
> +
> +#define KVM_PTE_LEAF_ATTR_LO            GENMASK(11, 2)
> +
> +#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX GENMASK(4, 2)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP      GENMASK(7, 6)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO           \
> +        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW           \
> +        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })

cpucaps don't exist in selftests.

Actually -- we don't need to worry about creating a an EL2 stage-1 in
selftests in the first place, so you can drop all these definitions.

> +#define KVM_PTE_LEAF_ATTR_LO_S1_SH      GENMASK(9, 8)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS   3
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AF      BIT(10)
> +
> +#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR GENMASK(5, 2)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R  BIT(6)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W  BIT(7)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_SH      GENMASK(9, 8)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS   3
> +#define KVM_PTE_LEAF_ATTR_LO_S2_AF      BIT(10)
> +
> +#define KVM_PTE_LEAF_ATTR_HI            GENMASK(63, 50)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_SW         GENMASK(58, 55)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN      BIT(54)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S2_XN      BIT(54)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S1_GP      BIT(50)
> +
> +#define KVM_PTE_CLEAR_RSBZ_BIT10 (~(1ULL << 10))
> +
> +#define S2_PTE_LO_FLAGS_MASK 0x3FFF
> +
> +	pg_attr = KVM_PTE_VALID | FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_PAGE) | KVM_PTE_LEAF_ATTR_LO_S2_AF | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, KVM_PTE_LEAF_ATTR_LO_S2_SH_IS) & KVM_PTE_CLEAR_RSBZ_BIT10;
> +
> +        if (!use_lpa2_pte_format(vm))
> +                pg_attr |= PTE_SHARED;
> +        *ptep = addr_pte(vm, paddr, pg_attr);
> +
>  }
>  
>  static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> @@ -186,6 +276,13 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx);
>  }
>  
> +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> +{
> +	u64 attr_idx = MT_NORMAL;

MT_NORMAL is a MAIR index. Memory attributes are conveyed directly in
the stage-2 descriptor with the encoding dependent on HCR_EL2.FWB.

This is a good starting point but in order for us to pick up this
upstream we will need a corresponding test. Even something simple like
hello_el2 that demonstrates selftests can ERET to EL1 with the stage-2
MMU enabled.

Thanks,
Oliver
