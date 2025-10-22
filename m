Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E7F2E972A
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 05:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761110758; cv=none; b=oNZCoBubTJ96fXxnlRn5a4d0Sppb8MS938s5YNf6bZYFFieR0Dd5CCwdEkEECrai+/C9E+WzjNs4gVRyQ5Adl4ZZ0APlJs7f/diPcvUwaR6nQ2Gkr7+Z8sxTJfcwz06fQeQx+779ZGPTqzfpe3ODfoa88uCRMEEKC8dEQr6mApw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761110758; c=relaxed/simple;
	bh=G71K7Chya0vzKwrfg07rQyjCA+udJjZ132zgBOvKOU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9378qEklK3hXBRY3MupgfFhnVOjMHJhkAnXKXL9NY2V6yyo2fhgyfOHRu10e/H2sMNQIb8CYLRy9v9T6Wv1h8Z5oOCQpzYldqzXa8VFG+3C2HwPHZCLwDXnIbseN27XuywIaA27VXccGNWjO8ww0AOD1qxvo+4Sb3T+X4Tk69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hIMerKZE; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hIMerKZE"
Date: Wed, 22 Oct 2025 14:25:42 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761110751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MCRLkuBoPXFKmK4tP5OtwkR5l3+er46jd6hyXnZM6fY=;
	b=hIMerKZEk0BRobnkacMvphwAKHtooCuzPuwMurxMfq1GK9gzexCnqUsAiUkoa4nIAyzOWi
	t2M7NMI0d1S69Jnl5dO6C3Pp0pqfZCgJJ05mBWsBBl4fcgREALBYiiaW+A3/AyilKUq667
	FQqUEfnjTicm0in8poXyNmvthUYnMSY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
Message-ID: <aPhq1tKKQCxhae43@vm4>
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
 <aPbL8NCPCfLHIB3w@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPbL8NCPCfLHIB3w@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 20, 2025 at 04:55:28PM -0700, Oliver Upton wrote:
> Hi Itaru,
> 
> Thanks for looking in to this.
> 
> On Mon, Oct 20, 2025 at 06:08:58PM +0900, Itaru Kitayama wrote:
> > Hi,
> > 
> > Below is my attempt to add stage 2 mapping helpers for the KVM selftest test framework as almost a duplicate of _virt_pg_map(), I thought for FEAT_NV2 feature testing, it’d be nice to have helpers rather than writing it in selftests. Comments are appreciated. 4KB page size, and 4 levels of stage 2 translation is assumed. 
> 
> FYI, you've got some line wrapping issues here and in the diff itself.
> 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 11b6c5aa3f12..6fe9210eeeb6 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -106,6 +106,7 @@ struct kvm_vm {
> >  	bool pgd_created;
> >  	vm_paddr_t ucall_mmio_addr;
> >  	vm_paddr_t pgd;
> > +	vm_paddr_t s2_pgd;
> >  	vm_vaddr_t handlers;
> >  	uint32_t dirty_ring_size;
> >  	uint64_t gpa_tag_mask;
> 
> A better approach would be to add a tracking structure for a stage-2 MMU
> context. Eventually we will need selftests to create multiple stage-2
> page tables, complete with the MMU context (VMID, VTCR, etc).
> 
> e.g.
> 
> struct s2_mmu_ctxt {
> 	vm_paddr_t	pgd;
> 	u64		vtcr;
> 	u16		vmid;
> };
> 
> > +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
> > +
> > +static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> > +{
> > +	virt_arch_s2_map(vm, ipa, paddr);
> > +}
> 
> This is all going to be arm64-specific, no need for indirection through
> something pretending to be arch-generic.
> 
> > --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > @@ -124,6 +124,96 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
> >  				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> >  				     vm->memslots[MEM_REGION_PT]);
> >  	vm->pgd_created = true;
> > +
> > +	vm->s2_pgd = vm_phy_pages_alloc(vm, nr_pages,
> > +                                     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> > +                                     vm->memslots[MEM_REGION_PT]);
> > +}
> > +
> 
> Instead introduce a helper for initializing a "struct s2_mmu_ctxt" (or
> whatever you choose to name it).
> 
> > +static void _virt_s2_map(struct kvm_vm *vm, uint64_t ipa, uint64_t paddr, uint64_t flags)
> > +{
> > +	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
> > +	uint64_t pg_attr;
> > +	uint64_t *ptep;
> > +	uint64_t *pgdp;
> > +
> > +	ptep = addr_gpa2hva(vm, vm->s2_pgd) + pgd_index(vm, ipa) * 8;
> > +	if (!*ptep) {
> > +                *ptep = addr_pte(vm, vm_alloc_page_table(vm),
> > +                                 PGD_TYPE_TABLE | PTE_VALID);
> > +	}
> > +
> > +	switch (4) {
> 
> Taking a constant here instead of the page table geometry.
> 
> > +#define KVM_PTE_VALID                   BIT(0)
> > +
> > +#define KVM_PTE_ADDR_MASK               GENMASK(47, PAGE_SHIFT)
> > +#define KVM_PTE_ADDR_51_48              GENMASK(15, 12)
> > +#define KVM_PTE_ADDR_MASK_LPA2          GENMASK(49, PAGE_SHIFT)
> > +#define KVM_PTE_ADDR_51_50_LPA2         GENMASK(9, 8)
> > +
> > +#define KVM_PHYS_INVALID                (-1ULL)
> > +
> > +#define KVM_PTE_TYPE                    BIT(1)
> > +#define KVM_PTE_TYPE_BLOCK              0
> > +#define KVM_PTE_TYPE_PAGE               1
> > +#define KVM_PTE_TYPE_TABLE              1
> > +
> > +#define KVM_PTE_LEAF_ATTR_LO            GENMASK(11, 2)
> > +
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX GENMASK(4, 2)
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_AP      GENMASK(7, 6)
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO           \
> > +        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW           \
> > +        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
> 
> cpucaps don't exist in selftests.
> 
> Actually -- we don't need to worry about creating a an EL2 stage-1 in
> selftests in the first place, so you can drop all these definitions.
> 
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_SH      GENMASK(9, 8)
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS   3
> > +#define KVM_PTE_LEAF_ATTR_LO_S1_AF      BIT(10)
> > +
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR GENMASK(5, 2)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R  BIT(6)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W  BIT(7)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_SH      GENMASK(9, 8)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS   3
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_AF      BIT(10)
> > +
> > +#define KVM_PTE_LEAF_ATTR_HI            GENMASK(63, 50)
> > +
> > +#define KVM_PTE_LEAF_ATTR_HI_SW         GENMASK(58, 55)
> > +
> > +#define KVM_PTE_LEAF_ATTR_HI_S1_XN      BIT(54)
> > +
> > +#define KVM_PTE_LEAF_ATTR_HI_S2_XN      BIT(54)
> > +
> > +#define KVM_PTE_LEAF_ATTR_HI_S1_GP      BIT(50)
> > +
> > +#define KVM_PTE_CLEAR_RSBZ_BIT10 (~(1ULL << 10))
> > +
> > +#define S2_PTE_LO_FLAGS_MASK 0x3FFF
> > +
> > +	pg_attr = KVM_PTE_VALID | FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_PAGE) | KVM_PTE_LEAF_ATTR_LO_S2_AF | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, KVM_PTE_LEAF_ATTR_LO_S2_SH_IS) & KVM_PTE_CLEAR_RSBZ_BIT10;
> > +
> > +        if (!use_lpa2_pte_format(vm))
> > +                pg_attr |= PTE_SHARED;
> > +        *ptep = addr_pte(vm, paddr, pg_attr);
> > +
> >  }
> >  
> >  static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> > @@ -186,6 +276,13 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> >  	_virt_pg_map(vm, vaddr, paddr, attr_idx);
> >  }
> >  
> > +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> > +{
> > +	u64 attr_idx = MT_NORMAL;
> 
> MT_NORMAL is a MAIR index. Memory attributes are conveyed directly in
> the stage-2 descriptor with the encoding dependent on HCR_EL2.FWB.
> 
> This is a good starting point but in order for us to pick up this
> upstream we will need a corresponding test. Even something simple like
> hello_el2 that demonstrates selftests can ERET to EL1 with the stage-2
> MMU enabled.

Hi Oliver,
Thanks for your review. Below is the updated helper patch and a test program
which does ERET in L1 guest (in guest_code). However, upon execution I keep 
getting IABTs from lower EL.


diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 11b6c5aa3f12..d4ae23a9e5c1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -114,6 +114,8 @@ struct kvm_vm {
 
 	struct kvm_binary_stats stats;
 
+	struct s2_mmu_ctxt *s2_mmu;
+
 	/*
 	 * KVM region slots. These are the default memslots used by page
 	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
@@ -122,6 +124,12 @@ struct kvm_vm {
 	uint32_t memslots[NR_MEM_REGIONS];
 };
 
+struct s2_mmu_ctxt {
+	vm_paddr_t	pgd;
+	u64	vtcr;
+	u16 vmid;
+};
+
 struct vcpu_reg_sublist {
 	const char *name;
 	long capability;
@@ -1202,6 +1210,12 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
 	virt_arch_pg_map(vm, vaddr, paddr);
 }
 
+void _virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
+
+static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
+{
+	_virt_s2_map(vm, ipa, paddr);
+}
 
 /*
  * Address Guest Virtual to Guest Physical
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 369a4c87dd8f..bfa8feaedc7b 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -113,6 +113,18 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 	return 1 << (vm->page_shift - 3);
 }
 
+static init_s2_mmu_ctxt(struct kvm_vm *vm)
+{
+	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+
+	vm->s2_mmu = calloc(1, sizeof(*vm->s2_mmu));
+	vm->s2_mmu->pgd = vm_phy_pages_alloc(vm,
+					nr_pages, 
+					KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+					vm->memslots[MEM_REGION_PT]);
+
+}
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
@@ -124,6 +136,90 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				     vm->memslots[MEM_REGION_PT]);
 	vm->pgd_created = true;
+
+	init_s2_mmu_ctxt(vm);
+}
+
+void _virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
+{
+
+#define KVM_PTE_MEMATTR_MASK GENMASK(4,2)
+#define KVM_PTE_MEMATTR_SHIFT 2
+	u64 flags = MT_NORMAL;
+	uint8_t attr_idx = flags & (KVM_PTE_MEMATTR_MASK >> KVM_PTE_MEMATTR_SHIFT);
+	uint64_t pg_attr;
+	uint64_t *ptep;
+	uint64_t *pgdp;
+
+	ptep = addr_gpa2hva(vm, vm->s2_mmu->pgd) + pgd_index(vm, ipa) * 8;
+	if (!*ptep) {
+                *ptep = addr_pte(vm, vm_alloc_page_table(vm),
+                                 PGD_TYPE_TABLE | PTE_VALID);
+	}
+
+	switch (4) {
+        case 4:
+                ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, ipa) * 8;
+                if (!*ptep)
+                        *ptep = addr_pte(vm, vm_alloc_page_table(vm), PUD_TYPE_TABLE | PTE_VALID);
+                /* fall through */
+        case 3:
+                ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, ipa) * 8;
+                if (!*ptep)
+                        *ptep = addr_pte(vm, vm_alloc_page_table(vm), PMD_TYPE_TABLE | PTE_VALID);
+                /* fall through */
+        case 2:
+                ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, ipa) * 8;
+                break;
+        default:
+                TEST_FAIL("Page table levels must be 2, 3, or 4");
+        }
+
+#define KVM_PTE_VALID                   BIT(0)
+
+#define KVM_PTE_ADDR_MASK               GENMASK(47, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_48              GENMASK(15, 12)
+#define KVM_PTE_ADDR_MASK_LPA2          GENMASK(49, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_50_LPA2         GENMASK(9, 8)
+
+#define KVM_PHYS_INVALID                (-1ULL)
+
+#define KVM_PTE_TYPE                    BIT(1)
+#define KVM_PTE_TYPE_BLOCK              0
+#define KVM_PTE_TYPE_PAGE               1
+#define KVM_PTE_TYPE_TABLE              1
+
+#define KVM_PTE_LEAF_ATTR_LO            GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R  BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W  BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH      GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS   3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF      BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_HI            GENMASK(63, 50)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW         GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN      BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN      BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_GP      BIT(50)
+
+#define KVM_PTE_CLEAR_RSBZ_BIT10 (~(1ULL << 10))
+
+#define S2_PTE_LO_FLAGS_MASK 0x3FFF
+
+#define KVM_PTE_MEMATTR(t) ((t) << 2)
+
+	pg_attr = KVM_PTE_MEMATTR(attr_idx) | KVM_PTE_VALID | (KVM_PTE_TYPE_PAGE << 1) | KVM_PTE_LEAF_ATTR_LO_S2_AF | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, KVM_PTE_LEAF_ATTR_LO_S2_SH_IS) | KVM_PTE_VALID;
+
+        if (!use_lpa2_pte_format(vm))
+                pg_attr |= PTE_SHARED;
+        *ptep = addr_pte(vm, paddr, pg_attr);
+
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,

This is an L2 launch KVM selftest program:

// SPDX-License-Identifier: GPL-2.0-only

#include "test_util.h"
#include "kvm_util.h"
#include "processor.h"
#include "ucall.h"
#include <signal.h>
#include <pthread.h>
#include <linux/sizes.h>
#include <linux/types.h>
#include <asm/sysreg.h>

#define UCALL_GPA 0x500000
#define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN     0xac0000

static void __attribute__((aligned(4096))) l2_guest_code(void)
{
	GUEST_SYNC(0x1234);
	GUEST_DONE();
}

const uint32_t l2_guest_nop = {
	0xD503201F
};

static void guest_code(u64 l2_ipa)
{
	u64 l2_guest_pc = l2_ipa;
	u64 val_elr, val_vttbr, val_spsr, val_hcr;
	GUEST_SYNC(0xaaa);

	asm volatile(
	"msr elr_el2, %0\n"
        : 
        : "r" (l2_guest_pc)
        : 
	);

	asm volatile("eret");	
	GUEST_DONE();

}

int main(void)
{
	struct kvm_vm *vm;
	struct kvm_vcpu *vcpu;
	struct kvm_vcpu_init init = {};

	/* Check we're on a NV2 hardware */
	if (!kvm_check_cap(KVM_CAP_ARM_EL2))
		exit(KSFT_SKIP);

	vm = vm_create(1);

	kvm_get_default_vcpu_target(vm, &init);
        init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
        vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
        kvm_arch_vm_finalize_vcpus(vm);

	vm_vaddr_t l2_dst_gva = __vm_vaddr_alloc(vm, 4096, 0x600000, MEM_REGION_CODE);
	u8 *l2_dst_hva = addr_gva2hva(vm, l2_dst_gva);
	u64 l2_code_gpa = addr_hva2gpa(vm, l2_dst_hva);
	
	memcpy(l2_dst_hva, l2_guest_code, 4096);

	u64 l2_ipa = 0x6000;
	virt_s2_map(vm, l2_ipa, l2_code_gpa);

	if (init.features[0]) {
		u64 vtcr = 0;
		vtcr = (25ULL << 0) | // T0SZ 25, IPA 39 bits
		       (0b10ULL << 6) | // SL0 start at level 1, if 4KB
		       (0b00ULL << 14) | // TG0 0b00 4KB granule
		       (0b101ULL << 16) | // PS 0b101 48-bit PA
		       (0b0ULL << 32) | // DS 0, assume FEAT_LPA2 not implemented
			(0b0ULL << 33) | // SL2 RES0, as DS==0
			(0b0 << 38); // FEAT_D128 is not implemented RES0 

		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTCR_EL2), vtcr);
		u64 hcr;
		hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
		hcr |= HCR_EL2_VM;
		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), hcr);

		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2), vm->s2_mmu->pgd);
		u64 spsr = (0b0101 << 6) | (1 << 7) | (1 << 6) | (1 << 9);
		vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SPSR_EL1), 0x3c5);
	}

	vcpu_args_set(vcpu, 1, l2_ipa);
	//vm_dump(stderr, vm, 2);

	while (1) {
                vcpu_run(vcpu);

                struct ucall uc;
		int ucall_type = get_ucall(vcpu, &uc);

                switch (ucall_type) {
                case UCALL_SYNC:
                        printf("Guest sync: val = 0x%lx\n", uc.args[1]);
                        break;
                case UCALL_DONE:
                        printf("Guest done\n");
			goto done;
                case UCALL_PRINTF:
                        printf("Guest: %s\n", uc.buffer);
                        break;
		case UCALL_ABORT:
			REPORT_GUEST_ASSERT(uc);
			break;
                default:
                        TEST_FAIL("Unknown ucall %lu\n", uc.cmd);
                }
        }

done:

	return 0;
}

Thanks,
Itaru.

> 
> Thanks,
> Oliver
