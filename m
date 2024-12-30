Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED58133C9
	for <kvmarm@lists.linux.dev>; Mon, 30 Dec 2024 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735578164; cv=none; b=UrIT5iP6Z8e19XotaMJB9BvEck4pM0aCA6hwTktY8B8VQ/0FfI5H+HDZVpy0OllpT+7icM2Ox8GrKHrOEzAaMFbiFe4Thga3cMD8cXilRVZMWBuhfEpuKKYVmAMvlrACra/Svzegvv7BtjfC81rdUrxiH+vwIBrj+LaSGCtuSaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735578164; c=relaxed/simple;
	bh=fOy7ofeKqWKAB16+h8n1sKmMU95pzbk/SW4tXgXi45c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=miyfP9wMnLUcGgEJAn3YrZr6qJvr/NEn1SNTauzzwrqvZ2cr8Q633C5usXdBaKMExTWvzH9P9IRr0jxWQfTGjTU8dZLrCLQPzvBM6Lh/vDO5Zch/HCJsBJ9NSyN94BuTwEynHOVnmY4s4Di4xatCv+cptaSut415/2AIAmSjJjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 364DE12FC;
	Mon, 30 Dec 2024 09:03:09 -0800 (PST)
Received: from [10.57.73.165] (unknown [10.57.73.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C8BB3F673;
	Mon, 30 Dec 2024 09:02:39 -0800 (PST)
Message-ID: <98b12b89-34f5-4203-a7c2-e6c4cebad6a7@arm.com>
Date: Mon, 30 Dec 2024 17:01:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, andrew.jones@linux.dev, eric.auger@redhat.com
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
Content-Language: en-GB
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Z2lRk_NLHxDPvmrS@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vladimir,

Thanks for this! Some comments inline.

On 23/12/2024 12:03, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> The patch looks good, but it just occured to me, the tests do a great job
> checking that tagged accesses fail when they should be failing, but they don't
> check that taggedd accesses *succeed* when they should not be failing. I think
> that's useful to have at the start of each test, if nothing just as a sanity
> check.
> 
> On Thu, Dec 12, 2024 at 10:34:47AM +0000, Vladimir Murzin wrote:
>> Test tag storage access and tag mismatch for different MTE modes.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>
>>   v1 -> v2
>>      - Addressed comments (I hope I did not miss any) from Alexandru
>>
>>   arm/Makefile.arm64            |  10 +-
>>   arm/cstart64.S                |   4 +-
>>   arm/mte.c                     | 299 ++++++++++++++++++++++++++++++++++
>>   arm/run                       |   3 +-
>>   arm/unittests.cfg             |  19 +++
>>   lib/arm64/asm/mmu.h           |   1 +
>>   lib/arm64/asm/pgtable-hwdef.h |   2 +
>>   lib/arm64/asm/sysreg.h        |  12 ++
>>   8 files changed, 347 insertions(+), 3 deletions(-)
>>   create mode 100644 arm/mte.c
>>
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index 3b9034e3..48dcdbd4 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -17,10 +17,17 @@ ifneq ($(strip $(sve_flag)),)
>>   CFLAGS += -DCC_HAS_SVE
>>   endif
>>   
>> +mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")

FEAT_MTE2 is an optional feature from v8.4. Should we lower the 
requirement? I've also tried checking for armv8-a+memtag and that work 
too, since we don't really care about the exact version.

>> +ifneq ($(strip $(mte_flag)),)
>> +# MTE is supported by the compiler, generate MTE instructions
>> +CFLAGS += -DCC_HAS_MTE
>> +endif
>> +
>> +
>>   mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
>>   CFLAGS += $(mno_outline_atomics)
>>   CFLAGS += -DCONFIG_RELOC
>> -CFLAGS += -mgeneral-regs-only
>> +CFLAGS += -mgeneral-regs-only -save-temps
> 
> Hmm.. I can't seem to figure out why -save-temps is required for the MTE test.
>  From man gcc, -save-temps is a knob that tells gcc not to delete the
> intermediate files that it generates. Am I missing something?
> 
>>   
>>   define arch_elf_check =
>>   	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
>> @@ -57,6 +64,7 @@ tests += $(TEST_DIR)/micro-bench.$(exe)
>>   tests += $(TEST_DIR)/cache.$(exe)
>>   tests += $(TEST_DIR)/debug.$(exe)
>>   tests += $(TEST_DIR)/fpu.$(exe)
>> +tests += $(TEST_DIR)/mte.$(exe)
>>   
>>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>>   
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index b480a552..b9d7a446 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -242,6 +242,7 @@ halt:
>>    *   NORMAL             100     11111111
>>    *   NORMAL_WT          101     10111011
>>    *   DEVICE_nGRE        110     00001000
>> + *   NORMAL_TAGGED      111     11110000
>>    */
>>   #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>>   
>> @@ -275,7 +276,8 @@ asm_mmu_enable:
>>   		     MAIR(0x44, MT_NORMAL_NC) |		\
>>   		     MAIR(0xff, MT_NORMAL) |	        \
>>   		     MAIR(0xbb, MT_NORMAL_WT) |         \
>> -		     MAIR(0x08, MT_DEVICE_nGRE)
>> +		     MAIR(0x08, MT_DEVICE_nGRE) |       \
>> +		     MAIR(0xf0, MT_NORMAL_TAGGED)
>>   	msr	mair_el1, x1
>>   
>>   	/* TTBR0 */
>> diff --git a/arm/mte.c b/arm/mte.c
>> new file mode 100644
>> index 00000000..718f0a61
>> --- /dev/null
>> +++ b/arm/mte.c
>> @@ -0,0 +1,299 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2024 Arm Limited.
>> + * All rights reserved.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>> +#include <stdlib.h>
>> +#include <asm/mmu.h>
>> +#include <asm/sysreg.h>
>> +#include <asm/pgtable-hwdef.h>
>> +#include <asm/processor.h>
>> +#include <asm/thread_info.h>
>> +
>> +
>> +/* Tag Check Faults cause a synchronous exception */
>> +#define MTE_TCF_SYNC	0b01
>> +/* Tag Check Faults are asynchronously accumulated */
>> +#define MTE_TCF_ASYNC	0b10
>> +/*
>> + * Tag Check Faults cause a synchronous exception on reads,
>> + * and are asynchronously accumulated on writes
>> + */
>> +#define MTE_TCF_ASYMM	0b11
>> +
>> +#define MTE_GRANULE_SIZE        UL(16)
>> +#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
>> +#define MTE_TAG_SHIFT           56
>> +
>> +#define untagged(p)									\
>> +({											\
>> +	unsigned long __in = (unsigned long)(p);					\
>> +	typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\
>> +											\
>> +	__out;										\
>> +})
>> +
>> +#define tagged(p,t)							\
>> +({									\
>> +	unsigned long __in = (unsigned long)(untagged(p));		\
>> +	unsigned long __tag = (unsigned long)(t) << MTE_TAG_SHIFT;	\
>> +	typeof(p) __out = (typeof(p))(__in | __tag);			\
>> +									\
>> +	__out;								\
>> +})
>> +
>> +/*
>> + * If we use a normal (non hand coded inline assembly) load or store
>> + * to access a tagged address, the compiler will reasonably assume
>> + * that the access succeeded, and the next instruction may do
>> + * something based on that assumption.
>> + *
>> + * But a test might want the tagged access to fail on purpose, and if
>> + * we advance the PC to the next instruction, the one added by the
>> + * compiler, we might leave the program in an unexpected state.
>> + */
>> +static inline void mem_read(unsigned int *addr, unsigned int tag, unsigned int *res)
>> +{
>> +	unsigned int r;
>> +
>> +	asm volatile ("ldr %0,[%1]\n"
>> +		      "str %0,[%2]\n"
>> +		      : "=r" (r)
>> +		      : "r" (tagged(addr, tag)), "r" (res));
>> +}
>> +
>> +static inline void mem_write(unsigned int *addr, unsigned int tag, unsigned int val)
>> +{
>> +	/* The NOP allows the same exception handler as mem_read() to be used. */
>> +	asm volatile ("str %0,[%1]\n"
>> +		      "nop\n"
>> +		      :
>> +		      : "r" (val), "r" (tagged(addr, tag))
>> +		      : "memory");
>> +}
>> +
>> +static volatile bool mte_exception;
>> +
>> +static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
>> +{
>> +	unsigned int dfsc = esr & GENMASK(5, 0);
>> +	unsigned int fnv = esr & BIT(10);
>> +
>> +	if ((dfsc == 0b010001) && (fnv == 0))
>> +		mte_exception = true;
>> +
>> +	/*
>> +	 * mem_read() reads the value from the tagged pointer, then
>> +	 * stores this value in the untagged 'res' pointer. The
>> +	 * function that called mem_read() will want to check that the
>> +	 * initial value of 'res' hasn't changed if a tag check fault
>> +	 * is reported. Skip over two instructions so 'res' isn't
>> +	 * overwritten.
>> +	 */
>> +	regs->pc += 8;
>> +}
>> +
>> +static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
>> +{
>> +	pteval_t *p_pte = follow_pte(pgtable, vaddr);
>> +
>> +	if (p_pte) {
>> +		pteval_t entry = *p_pte;
>> +
>> +		entry &= ~PTE_ATTRINDX_MASK;
>> +		entry |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
>> +
>> +		WRITE_ONCE(*p_pte, entry);
>> +		flush_tlb_page(vaddr);
>> +	} else {
>> +		report_abort("Cannot find PTE");
>> +	}
>> +}
>> +
>> +static void mte_init(void)
>> +{
>> +	unsigned long sctlr = read_sysreg(sctlr_el1);
>> +	unsigned long tcr = read_sysreg(tcr_el1);
>> +
>> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
>> +	sctlr &= ~SCTLR_EL1_ATA0;
>> +	sctlr |= SCTLR_EL1_ATA;
>> +
>> +	tcr |= TCR_TBI1 | TCR_TBI0;
>> +
>> +	write_sysreg(sctlr, sctlr_el1);
>> +	write_sysreg(tcr, tcr_el1);
>> +
>> +	isb();
>> +	flush_tlb_all();
>> +}
>> +
>> +static inline void mte_set_tcf(unsigned long tcf)
>> +{
>> +	unsigned long sctlr = read_sysreg(sctlr_el1);
>> +
>> +	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
>> +	sctlr |= (tcf << SCTLR_EL1_TCF_SHIFT) & SCTLR_EL1_TCF_MASK ;
>> +	sctlr |= (tcf << SCTLR_EL1_TCF0_SHIFT) & SCTLR_EL1_TCF0_MASK ;
>> +
>> +	write_sysreg(sctlr, sctlr_el1);
>> +	isb();
>> +}
>> +
>> +
>> +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
>> +{
>> +#ifdef CC_HAS_MTE
>> +	unsigned long in = (unsigned long)untagged(addr);
>> +	unsigned long start = ALIGN_DOWN(in, 16);
>> +	unsigned long end = ALIGN(in + size , 16);
>> +
>> +	for (unsigned long ptr = start; ptr < end; ptr += 16)
>> +		asm volatile(".arch   armv8.5-a+memtag\n"

Is the .arch directive necessary? IIUC, this is typically used to 
instruct the compiler to use a reduced feature set.

>> +			     "stg %0, [%0]"
>> +			     :
>> +			     : "r"(tagged(ptr, tag))
>> +			     : "memory");
>> +#endif
>> +}
>> +
>> +static inline unsigned long get_clear_tfsr(void)
>> +{
>> +	unsigned long r;
>> +
>> +	dsb(nsh);
>> +	isb();
>> +
>> +	r = read_sysreg_s(TFSR_EL1);
>> +	write_sysreg_s(0, TFSR_EL1);
>> +
>> +	return r;
>> +}
>> +
>> +static void mte_sync_test(void)
>> +{
>> +	unsigned int *mem = alloc_page();
>> +	unsigned int val = 0;
>> +
>> +	memset(mem, 0xff, PAGE_SIZE);
>> +	mte_init();

The mte_init() could also be called by main as it is common across all 
three tests?

>> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
>> +	mte_set_tag(mem, PAGE_SIZE, 0);
>> +	mte_set_tcf(MTE_TCF_SYNC);
>> +	mte_exception = false;
>> +
>> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);

Would it make sense to call this from mte_init() and maybe check whether 
we got an exception for sync fault and that we didn't for async faults?

>> +
>> +	mem_read(mem, 1, &val);
> 
> When I came back to the patch, I read this and I thought that the value 1
> represents what the value of 'val' should be. Do you think the code would be
> easier to read if mem_read() took a tagged address directly, i.e:
> 
> 	mem_read(tagged(mem, 1), &val);
> 
> Up to you what you prefer.

I agree with Alex. But up to you Vladimir.

> 
>> +
>> +	report((val == 0) && mte_exception, "read");
>> +
>> +	mte_exception = false;
>> +
>> +	mem_write(mem, 2, 0xbbbbbbbb);
>> +
>> +	report((*mem == 0xffffffff) && mte_exception, "write");

Minor but you might want to call free_pages(mem) as well.

>> +}
>> +
>> +static void mte_asymm_test(void)
>> +{
>> +	unsigned int *mem = alloc_page();
>> +	unsigned int val = 0;
>> +
>> +	memset(mem, 0xff, PAGE_SIZE);
>> +	mte_init();
>> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
>> +	mte_set_tag(mem, PAGE_SIZE, 0);
>> +	mte_set_tcf(MTE_TCF_ASYMM);
>> +	mte_exception = false;
>> +
>> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
>> +
>> +	mem_read(mem, 3, &val);
>> +	report((val == 0) && mte_exception, "read");
>> +
>> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
>> +
>> +	mem_write(mem, 4, 0xaaaaaaaa);
>> +	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == 1), "write");
> 
> Do you think it would be easier to understand the code if TFSR_EL1_TF0 would be
> used here instead of 1? Up to you what you prefer, but if you do decide to use
> a define, please also add TFSR_EL1_TF1, just in case someone decides to expand
> the test some day with an address in the upper virtual address space.
> 
>> +}
>> +
>> +static void mte_async_test(void)
>> +{
>> +	unsigned int *mem = alloc_page();
>> +	unsigned int val = 0;
>> +
>> +	memset(mem, 0xff, PAGE_SIZE);
>> +	mte_init();
>> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
>> +	mte_set_tag(mem, PAGE_SIZE, 0);
>> +	mte_set_tcf(MTE_TCF_ASYNC);
>> +
>> +	mem_read(mem, 5, &val);
>> +	report((val == 0xffffffff) && (get_clear_tfsr() == 1), "read");
>> +
>> +	mem_write(mem, 6, 0xcccccccc);
>> +	report((*mem == 0xcccccccc) && (get_clear_tfsr() == 1), "write");
>> +}
>> +
>> +
>> +static unsigned int mte_version(void)
>> +{
>> +#ifdef CC_HAS_MTE
>> +	uint64_t r;
>> +
>> +	asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
>> +
>> +	return (r >> 8) & 0b1111;

Sorry, if this very tedious but it might be better if we defined some 
constants here instead?

Thanks,

Nikos

>> +#else
>> +	report_info("Compiler lack MTE support");
>> +	return 0;
>> +#endif
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +
>> +	unsigned int version = mte_version();
>> +
>> +	if (version < 2) {
>> +		report_skip("No MTE support, skip...\n");
>> +		return -1;
> 
> Can you change the return to:
> 
> 		return report_summary();
> 
> Explanation below.
> 
>> +	}
>> +
>> +	if (argc < 2)
>> +		report_abort("no test specified");
>> +
>> +	report_prefix_pushf("mte");
> 
> report_prefix_push() (without the 'f' at the end).
> 
>> +
>> +	if (strcmp(argv[1], "sync") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		mte_sync_test();
>> +		report_prefix_pop();
>> +	} else if (strcmp(argv[1], "async") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		if (version < 3) {
>> +			report_skip("No MTE async, skip...\n");
>> +			return -1;
>> +		}
>> +		mte_async_test();
>> +		report_prefix_pop();
>> +
>> +	} else if (strcmp(argv[1], "asymm") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		if (version < 3) {
>> +			report_skip("No MTE asymm, skip...\n");
>> +			return -1;
>> +		}
>> +		mte_asymm_test();
>> +		report_prefix_pop();
>> +
>> +	} else {
>> +		report_abort("Unknown sub-test '%s'", argv[1]);
>> +	}
>> +
>> +	return report_summary();
>> +}
>> diff --git a/arm/run b/arm/run
>> index efdd44ce..b129e4e0 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
>>   	exit 2
>>   fi
>>   
>> -M='-machine virt'
>> +MACHINE="virt"
>> +M="-machine $MACHINE$MACHINE_PROPS"
> 
> Sorry, but I still don't understand what $MACHINE_PROPS does, I can't seem to
> find where it's initialized :(
> 
>>   
>>   if [ "$ACCEL" = "kvm" ]; then
>>   	if $qemu $M,\? | grep -q gic-version; then
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 2bdad67d..9b428c02 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -271,3 +271,22 @@ smp = 2
>>   groups = nodefault
>>   accel = kvm
>>   arch = arm64
>> +
>> +# MTE tests
>> +[mte-sync]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'sync'
>> +arch = arm64
>> +
>> +[mte-async]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'async'
>> +arch = arm64
>> +
>> +[mte-asymm]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'asymm'
>> +arch = arm64
> 
> I think it would be better if the tests are not in the nodefault group. As far
> as I can tell, they are in the nondefault group because not all hardware and KVM
> versions support MTE (please correct me if I'm wrong).
> 
> If the tests are in the nodefault group, then a CI administrator must
> keep track of those machine that have MTE and manually run them, otherwise they
> will never get run, even if the machines support it.
> 
> If you remove them from the nondefault group, with the change I proposed to
> main() the test runner will not mark them as failed on systems that don't
> support MTE:
> 
> $ ./run_tests.sh
> [..]
> SKIP mte-sync (1 tests, 1 skipped)
> SKIP mte-async (1 tests, 1 skipped)
> SKIP mte-asymm (1 tests, 1 skipped)
> 
> but they will get automatically run on systems that support MTE.
> 
> Also, would you mind putting the tests in the mte group:
> 
> 	groups = mte
> 
> so they can be run with ./run_tests.sh -g mte.
> 
> Thanks,
> Alex
> 
>> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
>> index 5c27edb2..9aedd09a 100644
>> --- a/lib/arm64/asm/mmu.h
>> +++ b/lib/arm64/asm/mmu.h
>> @@ -10,6 +10,7 @@
>>   #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
>>   #define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
>>   #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
>> +#define PTE_TAGGED		PTE_ATTRINDX(MT_NORMAL_TAGGED)
>>   
>>   static inline void flush_tlb_all(void)
>>   {
>> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
>> index 8c41fe12..b66b62da 100644
>> --- a/lib/arm64/asm/pgtable-hwdef.h
>> +++ b/lib/arm64/asm/pgtable-hwdef.h
>> @@ -145,6 +145,7 @@
>>   #define TCR_TG1_64K		(UL(3) << 30)
>>   #define TCR_ASID16		(UL(1) << 36)
>>   #define TCR_TBI0		(UL(1) << 37)
>> +#define TCR_TBI1		(UL(1) << 38)
>>   
>>   /*
>>    * Memory types available.
>> @@ -156,5 +157,6 @@
>>   #define MT_NORMAL		4
>>   #define MT_NORMAL_WT		5
>>   #define MT_DEVICE_nGRE		6
>> +#define MT_NORMAL_TAGGED	7
>>   
>>   #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index f214a4f0..60f51dad 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -28,6 +28,7 @@
>>   	.endm
>>   #else
>>   #include <libcflat.h>
>> +#include <bitops.h>
>>   
>>   #define read_sysreg(r) ({					\
>>   	u64 __val;						\
>> @@ -81,7 +82,12 @@ asm(
>>   #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
>>   #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>>   
>> +#define TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
>> +
>> +
>>   /* System Control Register (SCTLR_EL1) bits */
>> +#define SCTLR_EL1_ATA		_BITULL(43)
>> +#define SCTLR_EL1_ATA0		_BITULL(42)
>>   #define SCTLR_EL1_LSMAOE	_BITULL(29)
>>   #define SCTLR_EL1_NTLSMD	_BITULL(28)
>>   #define SCTLR_EL1_EE		_BITULL(25)
>> @@ -99,6 +105,12 @@ asm(
>>   #define SCTLR_EL1_A		_BITULL(1)
>>   #define SCTLR_EL1_M		_BITULL(0)
>>   
>> +#define SCTLR_EL1_TCF_SHIFT	40
>> +#define SCTLR_EL1_TCF_MASK	GENMASK_ULL(41, 40)
>> +
>> +#define SCTLR_EL1_TCF0_SHIFT	38
>> +#define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>> +
>>   #define INIT_SCTLR_EL1_MMU_OFF	\
>>   			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>>   			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
>> -- 
>> 2.25.1
>>

