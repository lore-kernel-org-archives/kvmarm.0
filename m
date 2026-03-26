Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CEF341062
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 21:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774560898; cv=none; b=BjHz5gnVXuJHkFreJw8WxU8fKBn9NlQWb0cYceD/e6k3VYXCjjMIsHGbV5NrzgITfL9sFtRNv7F3u+37VeEe7oISLFflx5mOa/Qr0Gdlynlz3k5KZoSvtWChnB/ebYAZKJ2DabQGf5WlFbM+q6i2ojaVh1Q0483maWEmjVmaK/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774560898; c=relaxed/simple;
	bh=vFMzB5FzE/YeUOfPlYcV8dkuzyJituD5v8MIp3FFntA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nILsNE8fkbvR0ms0xX4Jy2e0YyTNBmicyWhe22B95zRvWw1HIAMq42eZGLOPgE1AHuZhVDQ+uIcOOX8v72PrVksuoZwacLPsL1ySpx13+rUimv0Po76Tewhsyj/Vdw6YiKw7Tnr4o0vggPvFMz1r3qOxVqCkba4M7yQ2S4AR9k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SzyCptW2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SzyCptW2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 943172BCB;
	Thu, 26 Mar 2026 14:34:49 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 209D73F905;
	Thu, 26 Mar 2026 14:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774560895; bh=vFMzB5FzE/YeUOfPlYcV8dkuzyJituD5v8MIp3FFntA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SzyCptW2sHfGNRvQ0ORLOh4uwj+j/9C1mNnqIwJpNMyt/huaihkYQls/skdE0xGD4
	 z+hV+4TIZZAWTi2/adw3cBCdhf5cTfzInUg8nnVMWmoqV4kKQT+4Ah2qX0lNhh29zI
	 V9OnoG+FzAekd4m/rEzJ/xOG1fG04EX1hBzE/a5U=
Date: Thu, 26 Mar 2026 21:34:45 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 3/3] KVM: arm64: selftests: Enable stage-2 in NV
 preparation functions
Message-ID: <tiwr5dxrkk5ghn7r7j4wksp7237ttft3mdsrvuc7cck7ljomwg@tvytbqrjttf7>
References: <20260325003620.2214766-1-weilin.chang@arm.com>
 <20260325003620.2214766-4-weilin.chang@arm.com>
 <acN_YIzr6JZmYhZ8@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acN_YIzr6JZmYhZ8@sm-arm-grace07>

On Wed, Mar 25, 2026 at 03:23:28PM +0900, Itaru Kitayama wrote:
> Hi Wei Lin,

Hi,

> On Wed, Mar 25, 2026 at 12:36:20AM +0000, Wei-Lin Chang wrote:
> > Introduce library functions for setting up guest stage-2 page tables,
> > then use that to give L2 an identity mapped stage-2 and enable it.
> > 
> > The translation and stage-2 page table built is simple, start level 0,
> > 4 levels, 4KB granules, normal cachable, 48-bit IA, 40-bit OA.
> > 
> > The nested page table code is adapted from lib/x86/vmx.c.
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  .../selftests/kvm/include/arm64/nested.h      |  7 ++
> >  .../selftests/kvm/include/arm64/processor.h   |  9 ++
> >  .../testing/selftests/kvm/lib/arm64/nested.c  | 97 ++++++++++++++++++-
> >  3 files changed, 111 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
> > index 739ff2ee0161..0be10a775e48 100644
> > --- a/tools/testing/selftests/kvm/include/arm64/nested.h
> > +++ b/tools/testing/selftests/kvm/include/arm64/nested.h
> > @@ -6,6 +6,13 @@
> >  #ifndef SELFTEST_KVM_NESTED_H
> >  #define SELFTEST_KVM_NESTED_H
> >  
> > +uint64_t get_l1_vtcr(void);
> 
> Using a type u64 is simpler? And I think you configure guest
> hypervisor's stage 2 translation table, I felt this gives us
> an impression somewhere the configuration IA and OA sizes etc 
> are stored.

Sure, u64 is okay.
In this version I basically just used hard-coded values whenever I not
needed IA, OA and other related values e.g. page shift, which is not
good and as Marc said would not even work on some platforms. I'll make
it more modular in the next iteration.

> 
> > +
> > +void nested_map(struct kvm_vm *vm, vm_paddr_t guest_pgd,
> > +		uint64_t nested_paddr, uint64_t paddr, uint64_t size);
> > +void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t guest_pgd,
> > +			uint32_t memslot);
> > +
> >  void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
> >  void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
> >  void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc);
> > diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
> > index ac97a1c436fc..5de2e932d95a 100644
> > --- a/tools/testing/selftests/kvm/include/arm64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/arm64/processor.h
> > @@ -104,6 +104,15 @@
> >  #define TCR_HA			(UL(1) << 39)
> >  #define TCR_DS			(UL(1) << 59)
> >  
> > +/* VTCR_EL2 specific flags */
> > +#define VTCR_EL2_T0SZ_BITS(x)	((UL(64) - (x)) << VTCR_EL2_T0SZ_SHIFT)
> > +
> > +#define VTCR_EL2_SL0_LV0_4K	(UL(2) << VTCR_EL2_SL0_SHIFT)
> > +#define VTCR_EL2_SL0_LV1_4K	(UL(1) << VTCR_EL2_SL0_SHIFT)
> > +#define VTCR_EL2_SL0_LV2_4K	(UL(0) << VTCR_EL2_SL0_SHIFT)
> > +
> > +#define VTCR_EL2_PS_40_BITS	(UL(2) << VTCR_EL2_PS_SHIFT)
> > +
> >  /*
> >   * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
> >   */
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > index 111d02f44cfe..910f8cd30f96 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/nested.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > @@ -1,8 +1,11 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  /*
> > - * ARM64 Nested virtualization helpers
> > + * ARM64 Nested virtualization helpers, nested page table code adapted from
> > + * ../x86/vmx.c.
> >   */
> >  
> > +#include <linux/sizes.h>
> > +
> >  #include "kvm_util.h"
> >  #include "nested.h"
> >  #include "processor.h"
> > @@ -18,6 +21,87 @@ static void hvc_handler(struct ex_regs *regs)
> >  	regs->pc = (u64)after_hvc;
> >  }
> >  
> > +uint64_t get_l1_vtcr(void)
> > +{
> > +	return VTCR_EL2_PS_40_BITS | VTCR_EL2_TG0_4K | VTCR_EL2_ORGN0_WBWA |
> > +	       VTCR_EL2_IRGN0_WBWA | VTCR_EL2_SL0_LV0_4K | VTCR_EL2_T0SZ_BITS(48);
> > +}
> > +
> > +static void __nested_pg_map(struct kvm_vm *vm, uint64_t guest_pgd,
> > +		     uint64_t nested_paddr, uint64_t paddr, uint64_t flags)
> > +{
> > +	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
> > +	uint64_t pg_attr;
> > +	uint64_t *ptep;
> > +
> > +	TEST_ASSERT((nested_paddr % vm->page_size) == 0,
> > +		"L2 IPA not on page boundary,\n"
> > +		"  nested_paddr: 0x%lx vm->page_size: 0x%x", nested_paddr, vm->page_size);
> > +	TEST_ASSERT((paddr % vm->page_size) == 0,
> > +		"Guest physical address not on page boundary,\n"
> > +		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
> > +	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
> > +		"Physical address beyond maximum supported,\n"
> > +		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> > +		paddr, vm->max_gfn, vm->page_size);
> > +
> > +	ptep = addr_gpa2hva(vm, guest_pgd) + ((nested_paddr >> 39) & 0x1ffu) * 8;
> > +	if (!*ptep)
> > +		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PGD_TYPE_TABLE | PTE_VALID;
> 
> Same but given this is stage 2 translation tables, KVM_PTE_VALID?

I see your point, but KVM_PTE_VALID is only defined for KVM, not here in
kselftest userspace. However since I will redo the page table generator,
I can add this, let's see.
Thanks for the suggestions!

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> > +	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 30) & 0x1ffu) * 8;
> > +	if (!*ptep)
> > +		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PUD_TYPE_TABLE | PTE_VALID;
> > +	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 21) & 0x1ffu) * 8;
> > +	if (!*ptep)
> > +		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PMD_TYPE_TABLE | PTE_VALID;
> > +	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 12) & 0x1ffu) * 8;
> > +
> > +	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
> > +	pg_attr |= PTE_SHARED;
> > +
> > +	*ptep = (paddr & GENMASK(47, 12)) | pg_attr;
> > +}
> > +
> > +void nested_map(struct kvm_vm *vm, vm_paddr_t guest_pgd,
> > +		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
> > +{
> > +	size_t npages = size / SZ_4K;
> > +
> > +	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
> > +	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
> > +
> > +	while (npages--) {
> > +		__nested_pg_map(vm, guest_pgd, nested_paddr, paddr, MT_NORMAL);
> > +		nested_paddr += SZ_4K;
> > +		paddr += SZ_4K;
> > +	}
> > +}
> > +
> > +/*
> > + * Prepare an identity shadow page table that maps all the
> > + * physical pages in VM.
> > + */
> > +void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t guest_pgd,
> > +			uint32_t memslot)
> > +{
> > +	sparsebit_idx_t i, last;
> > +	struct userspace_mem_region *region =
> > +		memslot2region(vm, memslot);
> > +
> > +	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
> > +	last = i + (region->region.memory_size >> vm->page_shift);
> > +	for (;;) {
> > +		i = sparsebit_next_clear(region->unused_phy_pages, i);
> > +		if (i > last)
> > +			break;
> > +
> > +		nested_map(vm, guest_pgd,
> > +			   (uint64_t)i << vm->page_shift,
> > +			   (uint64_t)i << vm->page_shift,
> > +			   1 << vm->page_shift);
> > +	}
> > +}
> > +
> >  void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> >  {
> >  	size_t l2_stack_size;
> > @@ -32,7 +116,16 @@ void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> >  
> >  void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), HCR_EL2_RW);
> > +	vm_paddr_t guest_pgd;
> > +
> > +	guest_pgd = vm_phy_pages_alloc(vm, 1,
> > +				       KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> > +				       vm->memslots[MEM_REGION_PT]);
> > +	nested_map_memslot(vm, guest_pgd, 0);
> > +
> > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), HCR_EL2_RW | HCR_EL2_VM);
> > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2), guest_pgd);
> > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTCR_EL2), get_l1_vtcr());
> >  }
> >  
> >  void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc)
> > -- 
> > 2.43.0
> > 
