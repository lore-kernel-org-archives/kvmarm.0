From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 08/19] arm64: KVM: Dynamically patch the kernel/hyp VA
 mask
Date: Thu, 15 Feb 2018 13:11:02 +0000
Message-ID: <a663a509-f7e3-bf7f-959d-191ab723c7e2@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-9-marc.zyngier@arm.com> <20180115114719.GI21403@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180115114719.GI21403@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 11:47, Christoffer Dall wrote:
> On Thu, Jan 04, 2018 at 06:43:23PM +0000, Marc Zyngier wrote:
>> So far, we're using a complicated sequence of alternatives to
>> patch the kernel/hyp VA mask on non-VHE, and NOP out the
>> masking altogether when on VHE.
>>
>> THe newly introduced dynamic patching gives us the opportunity
> 
> nit: s/THe/The/
> 
>> to simplify that code by patching a single instruction with
>> the correct mask (instead of the mind bending cummulative masking
>> we have at the moment) or even a single NOP on VHE.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_mmu.h | 45 ++++++--------------
>>  arch/arm64/kvm/Makefile          |  2 +-
>>  arch/arm64/kvm/va_layout.c       | 91 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 104 insertions(+), 34 deletions(-)
>>  create mode 100644 arch/arm64/kvm/va_layout.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 672c8684d5c2..b0c3cbe9b513 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -69,9 +69,6 @@
>>   * mappings, and none of this applies in that case.
>>   */
>>  
>> -#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
>> -#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
>> -
>>  #ifdef __ASSEMBLY__
>>  
>>  #include <asm/alternative.h>
>> @@ -81,28 +78,14 @@
>>   * Convert a kernel VA into a HYP VA.
>>   * reg: VA to be converted.
>>   *
>> - * This generates the following sequences:
>> - * - High mask:
>> - *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
>> - *		nop
>> - * - Low mask:
>> - *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
>> - *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
>> - * - VHE:
>> - *		nop
>> - *		nop
>> - *
>> - * The "low mask" version works because the mask is a strict subset of
>> - * the "high mask", hence performing the first mask for nothing.
>> - * Should be completely invisible on any viable CPU.
>> + * The actual code generation takes place in kvm_update_va_mask, and
>> + * the instructions below are only there to reserve the space and
>> + * perform the register allocation.
> 
> Not just register allocation, but also to tell the generating code which
> registers to use for its operands, right?

That's what I meant by register allocation.

> 
>>   */
>>  .macro kern_hyp_va	reg
>> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>> -	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
>> -alternative_else_nop_endif
>> -alternative_if ARM64_HYP_OFFSET_LOW
>> -	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
>> -alternative_else_nop_endif
>> +alternative_cb kvm_update_va_mask
>> +	and     \reg, \reg, #1
>> +alternative_cb_end
>>  .endm
>>  
>>  #else
>> @@ -113,18 +96,14 @@ alternative_else_nop_endif
>>  #include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>>  
>> +void kvm_update_va_mask(struct alt_instr *alt,
>> +			__le32 *origptr, __le32 *updptr, int nr_inst);
>> +
>>  static inline unsigned long __kern_hyp_va(unsigned long v)
>>  {
>> -	asm volatile(ALTERNATIVE("and %0, %0, %1",
>> -				 "nop",
>> -				 ARM64_HAS_VIRT_HOST_EXTN)
>> -		     : "+r" (v)
>> -		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
>> -	asm volatile(ALTERNATIVE("nop",
>> -				 "and %0, %0, %1",
>> -				 ARM64_HYP_OFFSET_LOW)
>> -		     : "+r" (v)
>> -		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
>> +	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n",
>> +				    kvm_update_va_mask)
>> +		     : "+r" (v));
>>  	return v;
>>  }
>>  
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 87c4f7ae24de..93afff91cb7c 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>>  
>> -kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
>> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
>> new file mode 100644
>> index 000000000000..aee758574e61
>> --- /dev/null
>> +++ b/arch/arm64/kvm/va_layout.c
>> @@ -0,0 +1,91 @@
>> +/*
>> + * Copyright (C) 2017 ARM Ltd.
>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <asm/alternative.h>
>> +#include <asm/debug-monitors.h>
>> +#include <asm/insn.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
>> +#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
>> +
>> +static u64 va_mask;
>> +
>> +static void compute_layout(void)
>> +{
>> +	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
>> +	unsigned long mask = HYP_PAGE_OFFSET_HIGH_MASK;
>> +
>> +	/*
>> +	 * Activate the lower HYP offset only if the idmap doesn't
>> +	 * clash with it,
>> +	 */
> 
> The commentary is a bit strange given the logic below...
> 
>> +	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
>> +		mask = HYP_PAGE_OFFSET_HIGH_MASK;
> 
> ... was the initialization supposed to be LOW_MASK?
> 
> (and does this imply that this was never tested on a system that
> actually used the low mask?)

I must has messed up with a later refactoring, as that code gets
replaced pretty quickly in the series. The full series was definitely
tested on Seattle with 39bit VAs, which is the only configuration I have
that triggers the low mask.

> 
>> +
>> +	va_mask = mask;
>> +}
>> +
>> +static u32 compute_instruction(int n, u32 rd, u32 rn)
>> +{
>> +	u32 insn = AARCH64_BREAK_FAULT;
>> +
>> +	switch (n) {
>> +	case 0:
> 
> hmmm, wonder why we need this n==0 check...

Makes patch splitting a bit easier. I can rework that if that helps.

> 
>> +		insn = aarch64_insn_gen_logical_immediate(AARCH64_INSN_LOGIC_AND,
>> +							  AARCH64_INSN_VARIANT_64BIT,
>> +							  rn, rd, va_mask);
>> +		break;
>> +	}
>> +
>> +	return insn;
>> +}
>> +
>> +void __init kvm_update_va_mask(struct alt_instr *alt,
>> +			       __le32 *origptr, __le32 *updptr, int nr_inst)
>> +{
>> +	int i;
>> +
>> +	/* We only expect a 1 instruction sequence */
> 
> nit: wording is a bit strange, how about
> "We only expect a single instruction in the alternative sequence"

Sure.

> 
>> +	BUG_ON(nr_inst != 1);
>> +
>> +	if (!has_vhe() && !va_mask)
>> +		compute_layout();
>> +
>> +	for (i = 0; i < nr_inst; i++) {
> 
> It's a bit funny to have a loop with the above BUG_ON.
> 
> (I'm beginning to wonder if a future patch expands on this single
> instruction thing, in which case a hint in the commit message would have
> been nice.)

That's indeed what is happening. A further patch expands the single
instruction to a 5 instruction sequence. I'll add a comment to that effect.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
