Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E7A14831D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736869647; cv=none; b=ZIT6Um/+YUHb8+R4hEE0pRWif4yrqwEeMbyUs4zo72G4GzXwQMz0S9zYMxz+Q/X+nq/ZXTYG8rYzN6Nm+e7qsdhyXo9/6oMiBDniDgS6mY6ehEcgvRr9u4Vsfn3H30P8wWLKPXFm0qoWrMZbW9xrSkAMUIWZmg0esXOc1eyT03A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736869647; c=relaxed/simple;
	bh=8mmx3InanCa8q6MtBxciAfvYccqyAZM+DLsJCo7hKxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHKQC/uvRPbmgwqdJunHgGFAdi/5jkpRtw8Jag4nCH7QVUdtKLeHaK+CtSC2ufVKZtF+F/Er+hWmwOj5g+BC4en5S5A6kX7vLCAX+z6LMgaW3HNRnlCjN3LMpWqcHI7JtOBwD5k2p0dj7EssubyT6ccjyp/BIG/8dIYctLyqNpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DA0911FB;
	Tue, 14 Jan 2025 07:47:52 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.32.102.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35C443F673;
	Tue, 14 Jan 2025 07:47:22 -0800 (PST)
Date: Tue, 14 Jan 2025 15:47:18 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3] arm64: Add basic MTE test
Message-ID: <Z4aHBrpgiyWNXac2@arm.com>
References: <20250102111020.130788-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102111020.130788-1-vladimir.murzin@arm.com>

Hi,

On Thu, Jan 02, 2025 at 11:10:20AM +0000, Vladimir Murzin wrote:
> Test tag storage access and tag mismatch for different MTE modes.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  v2 -> v3
>     - Use non-zero tag by default
>     - Explicitly clear TCR_EL1.TCMA0 (per Alexandru)
>     - Drop $MACHINE_PROPS  (per Alexandru)
>     - Moved tests under mte group (per Alexandru)
>     - Perform mte_init() from main() (per Nikos)
>     - Free allocated memory after the test (per Nikos)
> 
>  v1 -> v2
>     - Addressed comments (I hope I did not miss any) from Alexandru
> 
>  arm/Makefile.arm64            |   8 +
>  arm/cstart64.S                |   4 +-
>  arm/mte.c                     | 316 ++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg             |  19 ++
>  lib/arm64/asm/mmu.h           |   1 +
>  lib/arm64/asm/pgtable-hwdef.h |   3 +
>  lib/arm64/asm/sysreg.h        |  14 ++
>  7 files changed, 364 insertions(+), 1 deletion(-)
>  create mode 100644 arm/mte.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 3b9034e3..fbf11c98 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -17,6 +17,13 @@ ifneq ($(strip $(sve_flag)),)
>  CFLAGS += -DCC_HAS_SVE
>  endif
>  
> +mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")
> +ifneq ($(strip $(mte_flag)),)
> +# MTE is supported by the compiler, generate MTE instructions
> +CFLAGS += -DCC_HAS_MTE
> +endif
> +
> +
>  mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
>  CFLAGS += $(mno_outline_atomics)
>  CFLAGS += -DCONFIG_RELOC
> @@ -57,6 +64,7 @@ tests += $(TEST_DIR)/micro-bench.$(exe)
>  tests += $(TEST_DIR)/cache.$(exe)
>  tests += $(TEST_DIR)/debug.$(exe)
>  tests += $(TEST_DIR)/fpu.$(exe)
> +tests += $(TEST_DIR)/mte.$(exe)
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>  
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index b480a552..b9d7a446 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -242,6 +242,7 @@ halt:
>   *   NORMAL             100     11111111
>   *   NORMAL_WT          101     10111011
>   *   DEVICE_nGRE        110     00001000
> + *   NORMAL_TAGGED      111     11110000
>   */
>  #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>  
> @@ -275,7 +276,8 @@ asm_mmu_enable:
>  		     MAIR(0x44, MT_NORMAL_NC) |		\
>  		     MAIR(0xff, MT_NORMAL) |	        \
>  		     MAIR(0xbb, MT_NORMAL_WT) |         \
> -		     MAIR(0x08, MT_DEVICE_nGRE)
> +		     MAIR(0x08, MT_DEVICE_nGRE) |       \
> +		     MAIR(0xf0, MT_NORMAL_TAGGED)
>  	msr	mair_el1, x1
>  
>  	/* TTBR0 */
> diff --git a/arm/mte.c b/arm/mte.c
> new file mode 100644
> index 00000000..3a9eb411
> --- /dev/null
> +++ b/arm/mte.c
> @@ -0,0 +1,316 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2024 Arm Limited.
> + * All rights reserved.
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <stdlib.h>
> +#include <asm/mmu.h>
> +#include <asm/sysreg.h>
> +#include <asm/pgtable-hwdef.h>
> +#include <asm/processor.h>
> +#include <asm/thread_info.h>
> +
> +
> +/* Tag Check Faults cause a synchronous exception */
> +#define MTE_TCF_SYNC	0b01
> +/* Tag Check Faults are asynchronously accumulated */
> +#define MTE_TCF_ASYNC	0b10
> +/*
> + * Tag Check Faults cause a synchronous exception on reads,
> + * and are asynchronously accumulated on writes
> + */
> +#define MTE_TCF_ASYMM	0b11
> +
> +#define MTE_GRANULE_SIZE        UL(16)
> +#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
> +#define MTE_TAG_SHIFT           56
> +
> +#define untagged(p)									\
> +({											\
> +	unsigned long __in = (unsigned long)(p);					\
> +	typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\
> +											\
> +	__out;										\
> +})
> +
> +#define tagged(p,t)							\
> +({									\
> +	unsigned long __in = (unsigned long)(untagged(p));		\
> +	unsigned long __tag = (unsigned long)(t) << MTE_TAG_SHIFT;	\
> +	typeof(p) __out = (typeof(p))(__in | __tag);			\
> +									\
> +	__out;								\
> +})
> +
> +/*
> + * If we use a normal (non hand coded inline assembly) load or store
> + * to access a tagged address, the compiler will reasonably assume
> + * that the access succeeded, and the next instruction may do
> + * something based on that assumption.
> + *
> + * But a test might want the tagged access to fail on purpose, and if
> + * we advance the PC to the next instruction, the one added by the
> + * compiler, we might leave the program in an unexpected state.
> + */
> +static inline void mem_read(unsigned int *addr, unsigned int *res)
> +{
> +	unsigned int r;
> +
> +	asm volatile ("ldr %0,[%1]\n"
> +		      "str %0,[%2]\n"
> +		      : "=&r" (r)
> +		      : "r" (addr), "r" (res) : "memory");
> +}
> +
> +static inline void mem_write(unsigned int *addr, unsigned int val)
> +{
> +	/* The NOP allows the same exception handler as mem_read() to be used. */
> +	asm volatile ("str %0,[%1]\n"
> +		      "nop\n"
> +		      :
> +		      : "r" (val), "r" (addr)
> +		      : "memory");
> +}
> +
> +static volatile bool mte_exception;
> +
> +static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +	unsigned int dfsc = esr & GENMASK(5, 0);
> +	unsigned int fnv = esr & BIT(10);
> +
> +	if ((dfsc == 0b010001) && (fnv == 0))

What happens if DFSC == ESR_ELx_FSC_MTE and FnV is 1? That could be because
of a malformed MTE exception - maybe the hypervisor is incorrectly
emulating the exception? I would print a warning if ESR_EL1 reports a tag
check fault and FnV = 1, and still treat it as an MTE exception.

> +		mte_exception = true;
> +
> +	/*
> +	 * mem_read() reads the value from the tagged pointer, then
> +	 * stores this value in the untagged 'res' pointer. The
> +	 * function that called mem_read() will want to check that the
> +	 * initial value of 'res' hasn't changed if a tag check fault
> +	 * is reported. Skip over two instructions so 'res' isn't
> +	 * overwritten.
> +	 */
> +	regs->pc += 8;
> +}
> +
> +static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
> +{
> +	pteval_t *p_pte = follow_pte(pgtable, untagged(vaddr));
> +
> +	if (p_pte) {
> +		pteval_t entry = *p_pte;
> +
> +		entry &= ~PTE_ATTRINDX_MASK;
> +		entry |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
> +
> +		WRITE_ONCE(*p_pte, entry);
> +		flush_tlb_page(vaddr);
> +	} else {
> +		report_abort("Cannot find PTE");
> +	}
> +}
> +
> +static void mte_init(void)
> +{
> +	unsigned long sctlr = read_sysreg(sctlr_el1);
> +	unsigned long tcr = read_sysreg(tcr_el1);
> +
> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
> +	sctlr &= ~SCTLR_EL1_ATA0;
> +	sctlr |= SCTLR_EL1_ATA;

Still don't understand why accesses at EL0 are being configured here if the
tests execute at EL1. Not saying it's wrong, just saying it's not
immediately obvious and maybe a comment would be useful here.

Also, mte_set_tcf() below assumes that the the caller wants to set
SCTLR_EL1_TCF, and not SCTLR_EL1_TCF0, which makes touching TCF0 in the
initialization phase even more interesting.

> +
> +	tcr &= ~TCR_TCMA0;
> +	tcr |= TCR_TBI1 | TCR_TBI0;

This is inconsistent - the code clears TCMA0 so it doesn't interfere with
tagged accesses when the address is in the lower VA space, but then it
configures TCR to ignore the top bits of the addresses in the lower and
**upper** VA space.

> +
> +	write_sysreg(sctlr, sctlr_el1);
> +	write_sysreg(tcr, tcr_el1);
> +
> +	isb();
> +	flush_tlb_all();
> +}
> +
> +static inline unsigned long mte_set_tcf(unsigned long tcf)
> +{
> +	unsigned long sctlr = read_sysreg(sctlr_el1);
> +	unsigned long old = (sctlr & SCTLR_EL1_TCF_MASK) >> SCTLR_EL1_TCF_SHIFT;
> +
> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
> +	sctlr |= (tcf << SCTLR_EL1_TCF_SHIFT) & SCTLR_EL1_TCF_MASK ;
> +
> +	write_sysreg(sctlr, sctlr_el1);
> +	isb();
> +
> +	return old;
> +}
> +
> +
> +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
> +{
> +#ifdef CC_HAS_MTE
> +	unsigned long in = (unsigned long)untagged(addr);
> +	unsigned long start = ALIGN_DOWN(in, 16);
> +	unsigned long end = ALIGN(in + size , 16);

Space *before* the comma.

> +
> +	for (unsigned long ptr = start; ptr < end; ptr += 16)

Missing braces around the asm statement.

> +		asm volatile(".arch   armv8.5-a+memtag\n"
> +			     "stg %0, [%0]"
> +			     :
> +			     : "r"(tagged(ptr, tag))
> +			     : "memory");
> +#endif
> +}
> +
> +
> +static inline void mte_memset(void *addr, int val, size_t size)

Would you mind explaining why you opted to memset the entire page instead
of doing *mem = 0xffffffff?

> +{
> +	unsigned long old = mte_set_tcf(MTE_TCF_SYNC);
> +
> +	memset(addr, val, size);
> +	mte_set_tcf(old);
> +}

I don't like having the check for writes to tagged addresses hidden behind
memsetting the memory. There's also no test for successfully reading from
tagged addresses.

I would have expected that, for each test, there would be a check that
reads and writes work with the corresponding configuration; for example,
for the asymmetric test:

diff --git a/arm/mte.c b/arm/mte.c
index 3a9eb411c4f4..37e125039b48 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -100,6 +100,12 @@ static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
 {
        pteval_t *p_pte = follow_pte(pgtable, untagged(vaddr));

+       /*
+        * Wait for writes to the address to complete before changing the memory
+        * type to MT_NORMAL_TAGGED.
+        */
+       dsb(ish);
+
        if (p_pte) {
                pteval_t entry = *p_pte;

@@ -213,24 +219,46 @@ static void mte_sync_test(void)

 static void mte_asymm_test(void)
 {
-       unsigned int *mem = tagged(alloc_page(), 2);
-       unsigned int val = 0;
+       unsigned int *mem = alloc_page();
+       unsigned int val;
+
+       if (!mem)
+               report_abort("alloc_page() failed");
+       *mem = 0xffffffff;

        mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
+       mem = tagged(mem, 2);
        mte_set_tag(mem, PAGE_SIZE, 2);
-       mte_memset(mem, 0xff, PAGE_SIZE);
+
+       write_sysreg_s(0, TFSR_EL1);
        mte_set_tcf(MTE_TCF_ASYMM);
-       mte_exception = false;

+       mte_exception = false;
        install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);

+       val = 0;
+       mem_read(mem, &val);
+       if (!report((val == 0xffffffff) && !mte_exception && (get_clear_tfsr() == 0),
+                   "successful read"))
+               return;
+
+       mte_exception = false;
+       mem_write(mem, 0);
+       if (!report((*mem == 0) && !mte_exception && (get_clear_tfsr() == 0),
+                   "successful write"))
+               return;
+
+       val = 0;
+       *mem = 0xffffffff;
+       mte_exception = false;
        mem_read(tagged(mem, 3), &val);
-       report((val == 0) && mte_exception, "read");
+       report((val == 0) && mte_exception && (get_clear_tfsr() == 0),
+              "failed read");

        install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);

        mem_write(tagged(mem, 4), 0xaaaaaaaa);
-       report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
+       report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "failed write");

        free_page(untagged(mem));
 }

What do you think?

> +
> +static inline unsigned long get_clear_tfsr(void)
> +{
> +	unsigned long r;
> +
> +	dsb(nsh);
> +	isb();
> +
> +	r = read_sysreg_s(TFSR_EL1);
> +	write_sysreg_s(0, TFSR_EL1);
> +
> +	return r;
> +}
> +
> +static void mte_sync_test(void)
> +{
> +	unsigned int *mem = tagged(alloc_page(), 1);

alloc_page() can fail.

> +	unsigned int val = 0;
> +
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 1);
> +	mte_memset(mem, 0xff, PAGE_SIZE);
> +	mte_set_tcf(MTE_TCF_SYNC);
> +	mte_exception = false;
> +
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> +
> +	mem_read(tagged(mem, 2), &val);
> +
> +	report((val == 0) && mte_exception, "read");

Is it worth checking that TFSR_EL1 is 0 for the read and the write test?

> +
> +	mte_exception = false;
> +
> +	mem_write(tagged(mem, 3), 0xbbbbbbbb);
> +
> +	report((*mem == 0xffffffff) && mte_exception, "write");
> +
> +	free_page(untagged(mem));
> +}
> +
> +static void mte_asymm_test(void)
> +{
> +	unsigned int *mem = tagged(alloc_page(), 2);
> +	unsigned int val = 0;
> +
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 2);
> +	mte_memset(mem, 0xff, PAGE_SIZE);
> +	mte_set_tcf(MTE_TCF_ASYMM);

TFSR_EL1.{TF1, TF0} reset to UNKNOWN values; I would clear the fields
before SCTLR_EL1.TCF.

> +	mte_exception = false;
> +
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> +
> +	mem_read(tagged(mem, 3), &val);
> +	report((val == 0) && mte_exception, "read");

I would also check that TFSR_EL1 is 0 here.

> +
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
> +
> +	mem_write(tagged(mem, 4), 0xaaaaaaaa);
> +	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
> +
> +	free_page(untagged(mem));
> +}
> +
> +static void mte_async_test(void)
> +{
> +	unsigned int *mem = tagged(alloc_page(), 3);
> +	unsigned int val = 0;
> +
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 3);
> +	mte_memset(mem, 0xff, PAGE_SIZE);
> +	mte_set_tcf(MTE_TCF_ASYNC);

I would clear TFSR_EL1 before writing TCF.

> +
> +	mem_read(tagged(mem, 4), &val);
> +	report((val == 0xffffffff) && (get_clear_tfsr() == TFSR_EL1_TF0), "read");
> +
> +	mem_write(tagged(mem, 5), 0xcccccccc);
> +	report((*mem == 0xcccccccc) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
> +
> +	free_page(untagged(mem));
> +}
> +
> +
> +static unsigned int mte_version(void)
> +{
> +#ifdef CC_HAS_MTE
> +	uint64_t r;
> +
> +	asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
> +
> +	return (r >> ID_AA64PFR1_EL1_MTE_SHIFT) & 0b1111;
> +#else
> +	report_info("Compiler lack MTE support");
> +	return 0;
> +#endif
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +
> +	unsigned int version = mte_version();
> +
> +	if (version < 2) {
> +		report_skip("No MTE support, skip...\n");
> +		return report_summary();
> +	}
> +
> +	if (argc < 2)
> +		report_abort("no test specified");
> +
> +	report_prefix_push("mte");
> +
> +	mte_init();
> +
> +	if (strcmp(argv[1], "sync") == 0) {
> +		report_prefix_push(argv[1]);
> +		mte_sync_test();
> +		report_prefix_pop();
> +	} else if (strcmp(argv[1], "async") == 0) {
> +		report_prefix_push(argv[1]);
> +		if (version < 3) {
> +			report_skip("No MTE async, skip...\n");
> +			return -1;

That should also be:

	return report_summary();

which, if the MTE version doesn't support asynchronous mode, changes the
test output from:

  FAIL mte-async

to:

  SKIP mte-async (1 tests, 1 skipped)

> +		}
> +		mte_async_test();
> +		report_prefix_pop();
> +
> +	} else if (strcmp(argv[1], "asymm") == 0) {
> +		report_prefix_push(argv[1]);
> +		if (version < 3) {
> +			report_skip("No MTE asymm, skip...\n");
> +			return -1;

That should also be:

	return report_summary();

Thanks,
Alex

> +		}
> +		mte_asymm_test();
> +		report_prefix_pop();
> +
> +	} else {
> +		report_abort("Unknown sub-test '%s'", argv[1]);
> +	}
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 2bdad67d..fe101145 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -271,3 +271,22 @@ smp = 2
>  groups = nodefault
>  accel = kvm
>  arch = arm64
> +
> +# MTE tests
> +[mte-sync]
> +file = mte.flat
> +groups = mte
> +extra_params = -machine mte=on -append 'sync'
> +arch = arm64
> +
> +[mte-async]
> +file = mte.flat
> +groups = mte
> +extra_params = -machine mte=on -append 'async'
> +arch = arm64
> +
> +[mte-asymm]
> +file = mte.flat
> +groups = mte
> +extra_params = -machine mte=on -append 'asymm'
> +arch = arm64
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 5c27edb2..9aedd09a 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -10,6 +10,7 @@
>  #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
>  #define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
>  #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
> +#define PTE_TAGGED		PTE_ATTRINDX(MT_NORMAL_TAGGED)
>  
>  static inline void flush_tlb_all(void)
>  {
> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> index 8c41fe12..08a2e91c 100644
> --- a/lib/arm64/asm/pgtable-hwdef.h
> +++ b/lib/arm64/asm/pgtable-hwdef.h
> @@ -145,6 +145,8 @@
>  #define TCR_TG1_64K		(UL(3) << 30)
>  #define TCR_ASID16		(UL(1) << 36)
>  #define TCR_TBI0		(UL(1) << 37)
> +#define TCR_TBI1		(UL(1) << 38)
> +#define TCR_TCMA0		(UL(1) << 57)
>  
>  /*
>   * Memory types available.
> @@ -156,5 +158,6 @@
>  #define MT_NORMAL		4
>  #define MT_NORMAL_WT		5
>  #define MT_DEVICE_nGRE		6
> +#define MT_NORMAL_TAGGED	7
>  
>  #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index f214a4f0..b8d3d66e 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -28,6 +28,7 @@
>  	.endm
>  #else
>  #include <libcflat.h>
> +#include <bitops.h>
>  
>  #define read_sysreg(r) ({					\
>  	u64 __val;						\
> @@ -74,6 +75,7 @@ asm(
>  #endif /* __ASSEMBLY__ */
>  
>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
> +#define ID_AA64PFR1_EL1_MTE_SHIFT	8
>  
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> @@ -81,7 +83,13 @@ asm(
>  #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
> +#define TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
> +#define TFSR_EL1_TF0                    _BITULL(0)
> +#define TFSR_EL1_TF1                    _BITULL(1)
> +
>  /* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_ATA		_BITULL(43)
> +#define SCTLR_EL1_ATA0		_BITULL(42)
>  #define SCTLR_EL1_LSMAOE	_BITULL(29)
>  #define SCTLR_EL1_NTLSMD	_BITULL(28)
>  #define SCTLR_EL1_EE		_BITULL(25)
> @@ -99,6 +107,12 @@ asm(
>  #define SCTLR_EL1_A		_BITULL(1)
>  #define SCTLR_EL1_M		_BITULL(0)
>  
> +#define SCTLR_EL1_TCF_SHIFT	40
> +#define SCTLR_EL1_TCF_MASK	GENMASK_ULL(41, 40)
> +
> +#define SCTLR_EL1_TCF0_SHIFT	38
> +#define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
> +
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> -- 
> 2.25.1
> 
