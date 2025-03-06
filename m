Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7029D20E71F
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275111; cv=none; b=jFqzauO0fPRP7acb3LFY8mnCsvZ5sx8BAwCbYwEaTXy/18SH5gtDBiABtj2ILujQDmvptrVYwXEYNAQhsjEIpARbnCxfsem0eUXI/UJzfNlrBM7yMK+7k53sJ2HURdUYieYQ7KwrfVMibFFBIOnJjwot6rL6HRc0kFtL+RX8Zus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275111; c=relaxed/simple;
	bh=g3ks2uCd+bnTibW2N3p6vUlNYCrI4+R0vHX4Cyl8g7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iheVR/FRoZu3ZBJSJc+yJoHxY8sY4zSJVAZ/qZm4tr3R78Y6A8N2y5F/ZmDpqATv/h5NWpBJxNYAd9StxqQGJ891bATWiuLjoRmiL4NUY53iRIcWy69DrgHxgtr3v29EBI1nGefCd/n4+cf/E8g38YgPF5oHJr3EnAQ97tX0iUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iX23GrhA; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iX23GrhA"
Date: Thu, 6 Mar 2025 16:31:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741275106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FgWAXpASprBartKSO0KzdxMv+1o5lzeFmfAb7W1QHk0=;
	b=iX23GrhAq+A7UFBHGA1PHSJ4f704XQRZTOhtR39BOK84O6p/SU7iftS2s7t1ijopKD5yde
	s2RlPB25zFlVw8XZcCc5TJpHJlYhsM6BzLSyAIpFQaaksbhUaGmwpAIsQJfMvqlnvFHL65
	NGW2e+pK6KY8pysoVPkJQyXN7mdo1ts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <20250306-eaaa0d3c4fa51fe7b5564f84@orel>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
 <Z8mtEoFuuAGJ_91v@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8mtEoFuuAGJ_91v@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 06, 2025 at 02:11:30PM +0000, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> Thank you for writing the test, looks good to me:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> @Drew: I'm trying to make time for the --qemu-cpu series. I have the first few
> patches, the ones that implement ./configure --processor for arm64, I can send
> those separately if you want.

Works for me.

Thanks,
drew

> 
> Thanks,
> Alex
> 
> On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> > Test tag storage access and tag mismatch for different MTE modes.
> > 
> > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> > ---
> >  arm/Makefile.arm64            |   8 +
> >  arm/cstart64.S                |   4 +-
> >  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
> >  arm/unittests.cfg             |  19 +++
> >  lib/arm64/asm/mmu.h           |   1 +
> >  lib/arm64/asm/pgtable-hwdef.h |   3 +
> >  lib/arm64/asm/sysreg.h        |  14 ++
> >  7 files changed, 361 insertions(+), 1 deletion(-)
> >  create mode 100644 arm/mte.c
> > 
> > diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> > index 3b9034e3..fbf11c98 100644
> > --- a/arm/Makefile.arm64
> > +++ b/arm/Makefile.arm64
> > @@ -17,6 +17,13 @@ ifneq ($(strip $(sve_flag)),)
> >  CFLAGS += -DCC_HAS_SVE
> >  endif
> >  
> > +mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")
> > +ifneq ($(strip $(mte_flag)),)
> > +# MTE is supported by the compiler, generate MTE instructions
> > +CFLAGS += -DCC_HAS_MTE
> > +endif
> > +
> > +
> >  mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
> >  CFLAGS += $(mno_outline_atomics)
> >  CFLAGS += -DCONFIG_RELOC
> > @@ -57,6 +64,7 @@ tests += $(TEST_DIR)/micro-bench.$(exe)
> >  tests += $(TEST_DIR)/cache.$(exe)
> >  tests += $(TEST_DIR)/debug.$(exe)
> >  tests += $(TEST_DIR)/fpu.$(exe)
> > +tests += $(TEST_DIR)/mte.$(exe)
> >  
> >  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> >  
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index b480a552..b9d7a446 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -242,6 +242,7 @@ halt:
> >   *   NORMAL             100     11111111
> >   *   NORMAL_WT          101     10111011
> >   *   DEVICE_nGRE        110     00001000
> > + *   NORMAL_TAGGED      111     11110000
> >   */
> >  #define MAIR(attr, mt) ((attr) << ((mt) * 8))
> >  
> > @@ -275,7 +276,8 @@ asm_mmu_enable:
> >  		     MAIR(0x44, MT_NORMAL_NC) |		\
> >  		     MAIR(0xff, MT_NORMAL) |	        \
> >  		     MAIR(0xbb, MT_NORMAL_WT) |         \
> > -		     MAIR(0x08, MT_DEVICE_nGRE)
> > +		     MAIR(0x08, MT_DEVICE_nGRE) |       \
> > +		     MAIR(0xf0, MT_NORMAL_TAGGED)
> >  	msr	mair_el1, x1
> >  
> >  	/* TTBR0 */
> > diff --git a/arm/mte.c b/arm/mte.c
> > new file mode 100644
> > index 00000000..f32203ce
> > --- /dev/null
> > +++ b/arm/mte.c
> > @@ -0,0 +1,313 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2024 Arm Limited.
> > + * All rights reserved.
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <alloc_page.h>
> > +#include <stdlib.h>
> > +
> > +#include <asm/mmu.h>
> > +#include <asm/pgtable-hwdef.h>
> > +#include <asm/processor.h>
> > +#include <asm/sysreg.h>
> > +#include <asm/thread_info.h>
> > +
> > +
> > +/* Tag Check Faults cause a synchronous exception */
> > +#define MTE_TCF_SYNC	0b01
> > +/* Tag Check Faults are asynchronously accumulated */
> > +#define MTE_TCF_ASYNC	0b10
> > +/*
> > + * Tag Check Faults cause a synchronous exception on reads,
> > + * and are asynchronously accumulated on writes
> > + */
> > +#define MTE_TCF_ASYMM	0b11
> > +
> > +#define MTE_GRANULE_SIZE        UL(16)
> > +#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
> > +#define MTE_TAG_SHIFT           56
> > +
> > +#define untagged(p)									\
> > +({											\
> > +	unsigned long __in = (unsigned long)(p);					\
> > +	typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\
> > +											\
> > +	__out;										\
> > +})
> > +
> > +#define tagged(p, t)							\
> > +({									\
> > +	unsigned long __in = (unsigned long)(untagged(p));		\
> > +	unsigned long __tag = (unsigned long)(t) << MTE_TAG_SHIFT;	\
> > +	typeof(p) __out = (typeof(p))(__in | __tag);			\
> > +									\
> > +	__out;								\
> > +})
> > +
> > +/*
> > + * If we use a normal (non hand coded inline assembly) load or store
> > + * to access a tagged address, the compiler will reasonably assume
> > + * that the access succeeded, and the next instruction may do
> > + * something based on that assumption.
> > + *
> > + * But a test might want the tagged access to fail on purpose, and if
> > + * we advance the PC to the next instruction, the one added by the
> > + * compiler, we might leave the program in an unexpected state.
> > + */
> > +static inline void mem_read(unsigned int *addr, unsigned int *res)
> > +{
> > +	unsigned int r;
> > +
> > +	asm volatile ("ldr %0,[%1]\n"
> > +		      "str %0,[%2]\n"
> > +		      : "=&r" (r)
> > +		      : "r" (addr), "r" (res) : "memory");
> > +}
> > +
> > +static inline void mem_write(unsigned int *addr, unsigned int val)
> > +{
> > +	/* The NOP allows the same exception handler as mem_read() to be used. */
> > +	asm volatile ("str %0,[%1]\n"
> > +		      "nop\n"
> > +		      :
> > +		      : "r" (val), "r" (addr)
> > +		      : "memory");
> > +}
> > +
> > +static volatile bool mte_exception;
> > +
> > +static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
> > +{
> > +	unsigned int dfsc = esr & GENMASK(5, 0);
> > +	unsigned int fnv = esr & BIT(10);
> > +
> > +	if (dfsc == 0b010001) {
> > +		if (fnv)
> > +			report_info("Unexpected non-zero FnV");
> > +		mte_exception = true;
> > +	}
> > +
> > +	/*
> > +	 * mem_read() reads the value from the tagged pointer, then
> > +	 * stores this value in the untagged 'res' pointer. The
> > +	 * function that called mem_read() will want to check that the
> > +	 * initial value of 'res' hasn't changed if a tag check fault
> > +	 * is reported. Skip over two instructions so 'res' isn't
> > +	 * overwritten.
> > +	 */
> > +	regs->pc += 8;
> > +}
> > +
> > +static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
> > +{
> > +	pteval_t *p_pte = follow_pte(pgtable, untagged(vaddr));
> > +
> > +	if (p_pte) {
> > +		pteval_t entry = *p_pte;
> > +
> > +		entry &= ~PTE_ATTRINDX_MASK;
> > +		entry |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
> > +
> > +		WRITE_ONCE(*p_pte, entry);
> > +		flush_tlb_page(vaddr);
> > +	} else {
> > +		report_abort("Cannot find PTE");
> > +	}
> > +}
> > +
> > +static void mte_init(void)
> > +{
> > +	unsigned long sctlr = read_sysreg(sctlr_el1);
> > +	unsigned long tcr = read_sysreg(tcr_el1);
> > +
> > +	sctlr &= ~SCTLR_EL1_TCF_MASK;
> > +	sctlr |= SCTLR_EL1_ATA;
> > +
> > +	tcr &= ~TCR_TCMA0;
> > +	tcr |= TCR_TBI0;
> > +
> > +	write_sysreg(sctlr, sctlr_el1);
> > +	write_sysreg(tcr, tcr_el1);
> > +
> > +	isb();
> > +	flush_tlb_all();
> > +}
> > +
> > +static inline unsigned long mte_set_tcf(unsigned long tcf)
> > +{
> > +	unsigned long sctlr = read_sysreg(sctlr_el1);
> > +	unsigned long old = (sctlr & SCTLR_EL1_TCF_MASK) >> SCTLR_EL1_TCF_SHIFT;
> > +
> > +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
> > +	sctlr |= (tcf << SCTLR_EL1_TCF_SHIFT) & SCTLR_EL1_TCF_MASK;
> > +
> > +	write_sysreg(sctlr, sctlr_el1);
> > +	write_sysreg_s(0, TFSR_EL1);
> > +	isb();
> > +
> > +	return old;
> > +}
> > +
> > +
> > +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
> > +{
> > +#ifdef CC_HAS_MTE
> > +	unsigned long in = (unsigned long)untagged(addr);
> > +	unsigned long start = ALIGN_DOWN(in, 16);
> > +	unsigned long end = ALIGN(in + size, 16);
> > +
> > +	for (unsigned long ptr = start; ptr < end; ptr += 16) {
> > +		asm volatile(".arch   armv8.5-a+memtag\n"
> > +			     "stg %0, [%0]"
> > +			     :
> > +			     : "r"(tagged(ptr, tag))
> > +			     : "memory");
> > +	}
> > +#endif
> > +}
> > +
> > +static inline unsigned long get_clear_tfsr(void)
> > +{
> > +	unsigned long r;
> > +
> > +	dsb(nsh);
> > +	isb();
> > +
> > +	r = read_sysreg_s(TFSR_EL1);
> > +	write_sysreg_s(0, TFSR_EL1);
> > +
> > +	return r;
> > +}
> > +
> > +static void mte_sync_test(void)
> > +{
> > +	unsigned int *mem = tagged(alloc_page(), 1);
> > +	unsigned int val = 0;
> > +
> > +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> > +	mte_set_tag(mem, PAGE_SIZE, 1);
> > +	memset(mem, 0xff, PAGE_SIZE);
> > +	mte_set_tcf(MTE_TCF_SYNC);
> > +
> > +	mte_exception = false;
> > +
> > +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> > +
> > +	mem_read(tagged(mem, 2), &val);
> > +
> > +	report((val == 0) && mte_exception && (get_clear_tfsr() == 0), "read");
> > +
> > +	mte_exception = false;
> > +
> > +	mem_write(tagged(mem, 3), 0xbbbbbbbb);
> > +
> > +	report((*mem == 0xffffffff) && mte_exception && (get_clear_tfsr() == 0), "write");
> > +
> > +	free_page(untagged(mem));
> > +}
> > +
> > +static void mte_asymm_test(void)
> > +{
> > +	unsigned int *mem = tagged(alloc_page(), 2);
> > +	unsigned int val = 0;
> > +
> > +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> > +	mte_set_tag(mem, PAGE_SIZE, 2);
> > +	memset(mem, 0xff, PAGE_SIZE);
> > +	mte_set_tcf(MTE_TCF_ASYMM);
> > +	mte_exception = false;
> > +
> > +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> > +
> > +	mem_read(tagged(mem, 3), &val);
> > +	report((val == 0) && mte_exception && (get_clear_tfsr() == 0), "read");
> > +
> > +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
> > +
> > +	mem_write(tagged(mem, 4), 0xaaaaaaaa);
> > +	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
> > +
> > +	free_page(untagged(mem));
> > +}
> > +
> > +static void mte_async_test(void)
> > +{
> > +	unsigned int *mem = tagged(alloc_page(), 3);
> > +	unsigned int val = 0;
> > +
> > +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> > +	mte_set_tag(mem, PAGE_SIZE, 3);
> > +	memset(mem, 0xff, PAGE_SIZE);
> > +	mte_set_tcf(MTE_TCF_ASYNC);
> > +
> > +	mem_read(tagged(mem, 4), &val);
> > +	report((val == 0xffffffff) && (get_clear_tfsr() == TFSR_EL1_TF0), "read");
> > +
> > +	mem_write(tagged(mem, 5), 0xcccccccc);
> > +	report((*mem == 0xcccccccc) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
> > +
> > +	free_page(untagged(mem));
> > +}
> > +
> > +
> > +static unsigned int mte_version(void)
> > +{
> > +#ifdef CC_HAS_MTE
> > +	uint64_t r;
> > +
> > +	asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
> > +
> > +	return (r >> ID_AA64PFR1_EL1_MTE_SHIFT) & 0b1111;
> > +#else
> > +	report_info("Compiler lack MTE support");
> > +	return 0;
> > +#endif
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +
> > +	unsigned int version = mte_version();
> > +
> > +	if (version < 2) {
> > +		report_skip("No MTE support, skip...\n");
> > +		return report_summary();
> > +	}
> > +
> > +	if (argc < 2)
> > +		report_abort("no test specified");
> > +
> > +	report_prefix_push("mte");
> > +
> > +	mte_init();
> > +
> > +	if (strcmp(argv[1], "sync") == 0) {
> > +		report_prefix_push(argv[1]);
> > +		mte_sync_test();
> > +		report_prefix_pop();
> > +	} else if (strcmp(argv[1], "async") == 0) {
> > +		report_prefix_push(argv[1]);
> > +		if (version < 3) {
> > +			report_skip("No MTE async, skip...\n");
> > +			return report_summary();
> > +		}
> > +		mte_async_test();
> > +		report_prefix_pop();
> > +
> > +	} else if (strcmp(argv[1], "asymm") == 0) {
> > +		report_prefix_push(argv[1]);
> > +		if (version < 3) {
> > +			report_skip("No MTE asymm, skip...\n");
> > +			return report_summary();
> > +		}
> > +		mte_asymm_test();
> > +		report_prefix_pop();
> > +
> > +	} else {
> > +		report_abort("Unknown sub-test '%s'", argv[1]);
> > +	}
> > +
> > +	return report_summary();
> > +}
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 2bdad67d..fe101145 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -271,3 +271,22 @@ smp = 2
> >  groups = nodefault
> >  accel = kvm
> >  arch = arm64
> > +
> > +# MTE tests
> > +[mte-sync]
> > +file = mte.flat
> > +groups = mte
> > +extra_params = -machine mte=on -append 'sync'
> > +arch = arm64
> > +
> > +[mte-async]
> > +file = mte.flat
> > +groups = mte
> > +extra_params = -machine mte=on -append 'async'
> > +arch = arm64
> > +
> > +[mte-asymm]
> > +file = mte.flat
> > +groups = mte
> > +extra_params = -machine mte=on -append 'asymm'
> > +arch = arm64
> > diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> > index 5c27edb2..9aedd09a 100644
> > --- a/lib/arm64/asm/mmu.h
> > +++ b/lib/arm64/asm/mmu.h
> > @@ -10,6 +10,7 @@
> >  #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
> >  #define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
> >  #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
> > +#define PTE_TAGGED		PTE_ATTRINDX(MT_NORMAL_TAGGED)
> >  
> >  static inline void flush_tlb_all(void)
> >  {
> > diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> > index 8c41fe12..08a2e91c 100644
> > --- a/lib/arm64/asm/pgtable-hwdef.h
> > +++ b/lib/arm64/asm/pgtable-hwdef.h
> > @@ -145,6 +145,8 @@
> >  #define TCR_TG1_64K		(UL(3) << 30)
> >  #define TCR_ASID16		(UL(1) << 36)
> >  #define TCR_TBI0		(UL(1) << 37)
> > +#define TCR_TBI1		(UL(1) << 38)
> > +#define TCR_TCMA0		(UL(1) << 57)
> >  
> >  /*
> >   * Memory types available.
> > @@ -156,5 +158,6 @@
> >  #define MT_NORMAL		4
> >  #define MT_NORMAL_WT		5
> >  #define MT_DEVICE_nGRE		6
> > +#define MT_NORMAL_TAGGED	7
> >  
> >  #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
> > diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> > index f214a4f0..b8d3d66e 100644
> > --- a/lib/arm64/asm/sysreg.h
> > +++ b/lib/arm64/asm/sysreg.h
> > @@ -28,6 +28,7 @@
> >  	.endm
> >  #else
> >  #include <libcflat.h>
> > +#include <bitops.h>
> >  
> >  #define read_sysreg(r) ({					\
> >  	u64 __val;						\
> > @@ -74,6 +75,7 @@ asm(
> >  #endif /* __ASSEMBLY__ */
> >  
> >  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
> > +#define ID_AA64PFR1_EL1_MTE_SHIFT	8
> >  
> >  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> >  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> > @@ -81,7 +83,13 @@ asm(
> >  #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> >  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> >  
> > +#define TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
> > +#define TFSR_EL1_TF0                    _BITULL(0)
> > +#define TFSR_EL1_TF1                    _BITULL(1)
> > +
> >  /* System Control Register (SCTLR_EL1) bits */
> > +#define SCTLR_EL1_ATA		_BITULL(43)
> > +#define SCTLR_EL1_ATA0		_BITULL(42)
> >  #define SCTLR_EL1_LSMAOE	_BITULL(29)
> >  #define SCTLR_EL1_NTLSMD	_BITULL(28)
> >  #define SCTLR_EL1_EE		_BITULL(25)
> > @@ -99,6 +107,12 @@ asm(
> >  #define SCTLR_EL1_A		_BITULL(1)
> >  #define SCTLR_EL1_M		_BITULL(0)
> >  
> > +#define SCTLR_EL1_TCF_SHIFT	40
> > +#define SCTLR_EL1_TCF_MASK	GENMASK_ULL(41, 40)
> > +
> > +#define SCTLR_EL1_TCF0_SHIFT	38
> > +#define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
> > +
> >  #define INIT_SCTLR_EL1_MMU_OFF	\
> >  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
> >  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> > -- 
> > 2.25.1
> > 
