Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D37E1B59A
	for <kvmarm@lists.linux.dev>; Thu,  5 Dec 2024 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408783; cv=none; b=CoS9LXBCuWGhnz24z2EtZsqKNJWpJuCj/Eeylaju4yWSWPoeoApuTwYm+jpSlAGfDbLx/d2xeq8acpl7iTfSOoCOFmFSeY5YIiJX8VTxLv6X35OamZ65c0m9EEi9FnR7LmNTDnoPXyWz2SJKoBXl4phRr91XLxqJmdA5eN58s6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408783; c=relaxed/simple;
	bh=fmiLvPxLXyXJHVZaxZe5zH4M6TO5DwbtvuFZP1idAts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pqylv6TnhMTbS31hgBJN8u8HsNf5AvcLVUv69TE+VfjWXr/Y2ON2CaxIaX84KqmuL1/aktc5FDFetKPK8N0vCcZNJrXHbD6ICMoamLViIiAwD6wodTcjiH+magG3iArp+mDfJvmY0V4YdexpdPWhXEuOkEWwV9NzkjOsLezVW5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D5231063;
	Thu,  5 Dec 2024 06:26:46 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FC003F5A1;
	Thu,  5 Dec 2024 06:26:17 -0800 (PST)
Date: Thu, 5 Dec 2024 14:26:14 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Add basic MTE test
Message-ID: <Z1G3QKefOxKtkfDj@raptor>
References: <20241126095513.129737-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126095513.129737-1-vladimir.murzin@arm.com>

Hi Vladimir,

This is very useful, thank you for writing the test.

On Tue, Nov 26, 2024 at 09:55:13AM +0000, Vladimir Murzin wrote:
> Test tag storage access and tag mismatch for different MTE modes.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/Makefile.arm64            |   9 ++
>  arm/cstart64.S                |   4 +-
>  arm/mte.c                     | 266 ++++++++++++++++++++++++++++++++++
>  arm/run                       |   3 +-
>  arm/unittests.cfg             |  19 +++
>  lib/arm64/asm/mmu.h           |   1 +
>  lib/arm64/asm/pgtable-hwdef.h |   2 +
>  lib/arm64/asm/sysreg.h        |  12 ++
>  8 files changed, 314 insertions(+), 2 deletions(-)
>  create mode 100644 arm/mte.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 3b9034e3..30df4e56 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -17,6 +17,14 @@ ifneq ($(strip $(sve_flag)),)
>  CFLAGS += -DCC_HAS_SVE
>  endif
>  
> +mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")
> +ifneq ($(strip $(mte_flag)),)
> +# Don't pass the option to the compiler, we don't
> +# want the compiler to generate MTE instructions.

I think the comment is at odds with the code, the define tells the test
that the compiler *has* mte, but the comment talks about not passing the
option to the compiler.

Maybe something like this would be easier to parse:

# MTE is supported by the compiler, generate MTE instructions.

> +CFLAGS += -DCC_HAS_MTE
> +endif
> +
> +
>  mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
>  CFLAGS += $(mno_outline_atomics)
>  CFLAGS += -DCONFIG_RELOC
> @@ -57,6 +65,7 @@ tests += $(TEST_DIR)/micro-bench.$(exe)
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

The attribute matches the Arm ARM and the Linux source tree.

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
> index 00000000..ae8d8b75
> --- /dev/null
> +++ b/arm/mte.c
> @@ -0,0 +1,266 @@
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
> +#define MTE_TCF_SYNC		0b01
> +#define MTE_TCF_ASYNC		0b10
> +#define MTE_TCF_ASYMM		0b11

Matches the definition for the SCTLR_EL1 TCF and TCF0 fields.

Do you think renaming MTE_TCF_ASYNC->MTE_TCF_ASYNC_ALL and
MTE_TCF_ASYMM -> MTE_TCF_ASYNC_WRITES makes it easier to understand?

> +
> +#define MTE_GRANULE_SIZE        UL(16)
> +#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
> +#define MTE_TAG_SHIFT           56
> +
> +#define untagged(p)                                             		\
> +({                                                              		\
> +    unsigned long __in = (unsigned long)(p);                    		\
> +    typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\

Can you add a space between the variable declaration and the return value from
the macro? Same for the tagged() macro.

> +    __out;                                                      		\
> +})
> +
> +#define tagged(p,t)                                     	\
> +({                                                      	\
> +    unsigned long __in = (unsigned long)(untagged(p));  	\
> +    unsigned long __tag = (unsigned long)(t) << MTE_TAG_SHIFT;	\
> +    typeof(p) __out = (typeof(p))(__in | __tag);        	\
> +    __out;                                              	\
> +})
> +
> +
> +static inline void mem_read(unsigned int *addr, unsigned int tag, unsigned int *res)
> +{
> +	unsigned int r;

Space between the variable declaration and the rest of the function?

> +	asm volatile ("ldr %0,[%1]\n"
> +		      "str %0,[%2]\n"
> +		      : "=r" (r)
> +		      : "r" (tagged(addr, tag)), "r" (res));
> +}
> +
> +static inline void mem_write(unsigned int *addr, unsigned int tag, unsigned int val)
> +{
> +	asm volatile ("str %0,[%1]\n"
> +		      "nop\n"
> +		      :
> +		      : "r" (val), "r" (tagged(addr, tag))
> +		      : "memory");
> +}

I don't understand why these functions are needed.

I first assumed that they are necessary to avoid the compiler optimising
the memory accesses and reusing a stashed register value. But the address
is changed by adding the tag, and the tests never use the same tag, so the
compiler won't have values in registers for the tagged addresses.

I guess it's because in the future a test might reuse the same tag? That
can easily be avoided by adding a random tag to the address - the example
from Documentation/arch/arm64/memory-tagging-extension.rst does that.

I think another way to get around this would be to add a barrier() in
tagged.

> +
> +static volatile bool mte_exception;
> +
> +static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +	unsigned int dfsc = esr & 0b111111;

GENMASK_UL(5, 0)?

> +
> +	if (dfsc == 0b010001)

This matches the DFSC in the Arm ARM.

For a synchronous tag check fault, ARM DDI0487K.a also states the following:

'When FEAT_MTE is implemented, for a synchronous Tag Check Fault abort taken to
EL1, ESR_EL1.FnV is 0 and FAR_EL1 is valid.'

Do you think there's value in checking that FnV is 0 when MTE is configured to
generate a synchronous tag check fault exception?

> +		mte_exception = true;
> +
> +        regs->pc += 8;

I think two instructions are skipped here because the test assumes that
the first instruction from the mem_{read,write} macros will cause the
fault.  But what happens if the first succeeds and the second instruction
causes a tag check fault?

IMO, I see two options here:

1. Increment PC by one instruction, which means the second instruction gets
executed, which is harmless as far as I can tell.

2. Remove the macros, assign a random tag to the addresses and use a single
instruction to access the address, then increment the PC by one instruction
in the exception handler.

> +}
> +
> +static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
> +{
> +	pteval_t *p_pte = follow_pte(pgtable, vaddr);

Space between local variable declaration and the body of the function?

> +        if (p_pte) {

Indentation with spaces instead of tabs?

> +                pteval_t entry = *p_pte;
> +
> +		entry &= ~PTE_ATTRINDX_MASK;
> +		entry |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
> +
> +                WRITE_ONCE(*p_pte, entry);
> +                flush_tlb_page(vaddr);
> +        }

As far as I can tell, follow_pte() fails if:

1. The test hasn't correctly allocated memory for 'vaddr', or
2. Something is very wrong with the library code.

I think having a report_abort() if !p_pte (with a comment explaining it)
would be useful for debugging.

Alternatively you can add a comment explaining why follow_pte() should
never fail and don't check that p_pte != NULL.

> +}
> +
> +static void mte_init(void)
> +{
> +	unsigned long sctlr = read_sysreg(sctlr_el1);
> +	unsigned long tcr = read_sysreg(tcr_el1);
> +
> +	sctlr &= ~(SCTLR_EL1_ATA | SCTLR_EL1_ATA0);

This can be dropped, and replaced with the second instruction below which
sets the bits unconditionally.

> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
> +	sctlr |= SCTLR_EL1_ATA | SCTLR_EL1_ATA0;

Why set ATA0? All the tests execute at EL1 as far as I can tell.

> +
> +	tcr |= TCR_TBI1 | TCR_TBI0;
> +
> +	write_sysreg(sctlr, sctlr_el1);
> +	write_sysreg(tcr, tcr_el1);
> +
> +	isb();
> +        flush_tlb_all();

Indentation with spaces instead of tabs?

Also, invalidating the TLB is the right thing to do, because both the
TCR_EL1 and SCTLR_EL1 bits are permitted to be cached in the TLB.

> +}
> +
> +static inline void mte_set_tcf(unsigned long tcf)
> +{
> +	unsigned long sctlr = read_sysreg(sctlr_el1);
> +
> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
> +	sctlr |= (tcf << SCTLR_EL1_TCF_SHIFT) & SCTLR_EL1_TCF_MASK ;
> +	sctlr |= (tcf << SCTLR_EL1_TCF0_SHIFT) & SCTLR_EL1_TCF0_MASK ;
> +
> +	write_sysreg(sctlr, sctlr_el1);
> +	isb();
> +}
> +
> +

Two empty lines instead of one?

> +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
> +{
> +#ifdef CC_HAS_MTE
> +	unsigned long in = (unsigned long)untagged(addr);
> +	unsigned long start = ALIGN_DOWN(in, 16);
> +	unsigned long end = ALIGN(in + size , 16);

Space between local variable declaration and the body of the function?

> +	for (unsigned long ptr = start; ptr < end; ptr += 16)
> +            asm volatile(".arch   armv8.5-a+memtag\n"
> +			 "stg %0, [%1]"
> +                         :
> +                         : "r"(tagged(ptr, tag)), "r"(ptr)
> +                         : "memory");

STG generates an untagged access, so the destination address can be also be
tagged, i.e:

		ptr = tagged(ptr, tag);
		asm volatile("stg %0, [%0]" : : "r"(ptr) : "memory");

I dropped the assembler directive because you can invoke the compiler with
-march=armv8.5-a+memtag (the top level Makefile already checks if that
options is supported).

Up to you what you prefer.

> +#endif
> +}
> +
> +static inline unsigned long tfsr(void)

The name here is particularly bad. The function reads TFSR_EL1, clears the
register and returns the old value. How about get_clear_tfsr()?

> +{
> +	unsigned long r;
> +
> +	dsb(nsh);

From the definition of DSB:

'In addition, no instruction that appears in program order after the DSB
instruction can alter any state of the system or perform any part of its
functionality until the DSB completes other than:

* Being fetched from memory and decoded.
* Reading the general-purpose, SIMD and floating-point, SVE vector or
predicate, Special-purpose, or System registers that are directly or
indirectly read without causing side effects.'

The read of the TFSR_EL1 register below does not have any side effects, so I
assume it can be executed **before** the DSB completes, and thus potentially
missing that one of the TFx fields is set. I assume that's why the kernel does
an ISB after the DSB and before reading TFSR_EL1.

> +
> +	r = read_sysreg_s(TFSR_EL1);
> +	write_sysreg_s(0, TFSR_EL1);
> +
> +	isb();

ISB here is not needed, because there's no indirect read of the TFSR_EL1
register (got that from the comment for mte_check_tfsr_el1() from the kernel
source - it's now table D23-1 in ARM DDI0487K.a if want to double check).

> +
> +	return r;
> +}
> +
> +static void mte_sync_test(void)
> +{
> +	unsigned int *mem = alloc_page();
> +	unsigned int val = 0;
> +
> +	memset(mem, 0xff, PAGE_SIZE);

alloc_page() can fail.

> +	mte_init();
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 0);
> +	mte_set_tcf(MTE_TCF_SYNC);
> +
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);

I think I would prefer mte_exception to explicitely be set to false here
because it makes the tests more robust. Yes, it's a static variable and
it's initialized to 0 (false). But the main() function could be changed to
run all the tests in one go (see timer.c::main()), and then mte_exception
might not necessarily be false here.

Or maybe I'm just overthinking things.

> +
> +	mem_read(mem, 1, &val);
> +
> +	report((val == 0) && mte_exception, "read");
> +
> +	mte_exception = false;
> +
> +	mem_write(mem, 2, 0xbbbbbbbb);
> +
> +	report((*mem == 0xffffffff) && mte_exception, "write");
> +}
> +
> +static void mte_asymm_test(void)
> +{
> +	unsigned int *mem = alloc_page();
> +	unsigned int val = 0;
> +
> +	memset(mem, 0xff, PAGE_SIZE);
> +	mte_init();
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 0);
> +	mte_set_tcf(MTE_TCF_ASYMM);
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> +
> +	mem_read(mem, 3, &val);
> +	report((val == 0) && mte_exception, "read");
> +
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);

I would have left the exception handler, and checked that mte_exception is
false. Just to make sure that the access doesn't set the TF field and also
generate an exception.

Same for the fully asynchronous test below.

> +
> +	mem_write(mem, 4, 0xaaaaaaaa);
> +	report((*mem == 0xaaaaaaaa) && (tfsr() != 0), "write");

Would it be more useful to explicitely check that TFSR_EL1.TF0 == 1? As it
stand, tfsr() != 0 can be true if TFSR_EL1.TF1 == 1, but TFSR_EL1.TF0 == 0,
which I would say it's not correct.

> +}
> +
> +static void mte_async_test(void)
> +{
> +	unsigned int *mem = alloc_page();
> +	unsigned int val = 0;
> +

Two empty lines instead of one.

> +
> +	memset(mem, 0xff, PAGE_SIZE);
> +	mte_init();
> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> +	mte_set_tag(mem, PAGE_SIZE, 0);
> +	mte_set_tcf(MTE_TCF_ASYNC);
> +
> +	mem_read(mem, 5, &val);
> +	report((val == 0xffffffff) && (tfsr() != 0), "read");
> +
> +	mem_write(mem, 6, 0xcccccccc);
> +	report((*mem == 0xcccccccc) && (tfsr() != 0), "write");
> +}
> +
> +

Two emtpy lines.

> +static unsigned int mte_version(void)

Why unsigned int? Sorry, but this seems arbitrary - r is 64 bits, the field
is 4 bits, and the function returns 32 bits.

> +{
> +#ifdef CC_HAS_MTE
> +	uint64_t r;
> +
> +	asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
> +
> +	return (r >> 8) & 0b1111;
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
> +        if (version < 2) {
> +                report_skip("No MTE support, skip...\n");
> +                return -1;
> +        }
> +
> +        if (argc < 2)
> +                report_abort("no test specified");

Spaces mixed with tabs.

> +
> +	report_prefix_pushf("mte");

report_prefix_push("mte")?

> +
> +	if (strcmp(argv[1], "sync") == 0) {
> +                report_prefix_push(argv[1]);
> +                mte_sync_test();
> +                report_prefix_pop();
> +        } else if (strcmp(argv[1], "async") == 0) {
> +                report_prefix_push(argv[1]);
> +		if (version < 3) {
> +			report_skip("No MTE async, skip...\n");
> +			return -1;
> +		}
> +                mte_async_test();
> +                report_prefix_pop();
> +
> +        } else if (strcmp(argv[1], "asymm") == 0) {
> +                report_prefix_push(argv[1]);
> +		if (version < 3) {
> +			report_skip("No MTE asymm, skip...\n");
> +			return -1;
> +		}
> +                mte_asymm_test();
> +                report_prefix_pop();
> +
> +        } else {
> +                report_abort("Unknown sub-test '%s'", argv[1]);
> +	}

Spaces mixed with tabs again.

> +
> +        return report_summary();
> +}
> diff --git a/arm/run b/arm/run
> index efdd44ce..b129e4e0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
>  	exit 2
>  fi
>  
> -M='-machine virt'
> +MACHINE="virt"
> +M="-machine $MACHINE$MACHINE_PROPS"

I did this

$ grep -r MACHINE_PROPS

and there were no other matches beside of the line above.

>  
>  if [ "$ACCEL" = "kvm" ]; then
>  	if $qemu $M,\? | grep -q gic-version; then
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 2bdad67d..9b428c02 100644
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
> +groups = nodefault
> +extra_params = -append 'sync'
> +arch = arm64
> +
> +[mte-async]
> +file = mte.flat
> +groups = nodefault
> +extra_params = -append 'async'
> +arch = arm64
> +
> +[mte-asymm]
> +file = mte.flat
> +groups = nodefault
> +extra_params = -append 'asymm'
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
> index 8c41fe12..b66b62da 100644
> --- a/lib/arm64/asm/pgtable-hwdef.h
> +++ b/lib/arm64/asm/pgtable-hwdef.h
> @@ -145,6 +145,7 @@
>  #define TCR_TG1_64K		(UL(3) << 30)
>  #define TCR_ASID16		(UL(1) << 36)
>  #define TCR_TBI0		(UL(1) << 37)
> +#define TCR_TBI1		(UL(1) << 38)

Matches the Arm ARM.

>  
>  /*
>   * Memory types available.
> @@ -156,5 +157,6 @@
>  #define MT_NORMAL		4
>  #define MT_NORMAL_WT		5
>  #define MT_DEVICE_nGRE		6
> +#define MT_NORMAL_TAGGED	7
>  
>  #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index f214a4f0..60f51dad 100644
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
> @@ -81,7 +82,12 @@ asm(
>  #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
> +#define TFSR_EL1			sys_reg(3, 0, 5, 6, 0)

Matches the Arm ARM.

> +
> +
>  /* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_ATA		_BITULL(43)
> +#define SCTLR_EL1_ATA0		_BITULL(42)

Same here.

Thanks,
Alex

>  #define SCTLR_EL1_LSMAOE	_BITULL(29)
>  #define SCTLR_EL1_NTLSMD	_BITULL(28)
>  #define SCTLR_EL1_EE		_BITULL(25)
> @@ -99,6 +105,12 @@ asm(
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
