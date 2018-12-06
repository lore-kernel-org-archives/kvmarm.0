From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 7/8] arm64: KVM: Handle ARM erratum 1165522 in TLB
 invalidation
Date: Thu, 6 Dec 2018 17:21:38 +0000
Message-ID: <fd785a73-daa2-a6c4-e904-7a15ba245bc0@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
 <20181123184107.39334-8-marc.zyngier@arm.com>
 <b662ad23-68bc-e25d-2ce7-2499af4b358d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB8774A2FB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 12:21:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XDBLbCchNyBU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 12:21:42 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AC94A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 12:21:42 -0500 (EST)
In-Reply-To: <b662ad23-68bc-e25d-2ce7-2499af4b358d@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/11/2018 09:50, James Morse wrote:
> Hi Marc,
> 
> On 23/11/2018 18:41, Marc Zyngier wrote:
>> In order to avoid TLB corruption whilst invalidating TLBs on CPUs
>> affected by erratum 1165522, we need to prevent S1 page tables
>> from being usable.
>>
>> For this, we set the EL1 S1 MMU on, and also disable the page table
>> walker (by setting the TCR_EL1.EPD* bits to 1).
>>
>> This ensures that once we switch to the EL1/EL0 translation regime,
>> speculated AT instructions won't be able to parse the page tables.
> 
> Reviewed-by: James Morse <james.morse@arm.com>
> 
> 
> I think we can ditch an isb or two:
> 
>> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
>> index 7fcc9c1a5f45..0506ced16afc 100644
>> --- a/arch/arm64/kvm/hyp/tlb.c
>> +++ b/arch/arm64/kvm/hyp/tlb.c
>> @@ -21,12 +21,37 @@
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/tlbflush.h>
>>  
>> +struct tlb_inv_context {
>> +	unsigned long	flags;
>> +	u64		tcr;
>> +	u64		sctlr;
>> +};
>> +
>>  static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>> -						 unsigned long *flags)
>> +						 struct tlb_inv_context *cxt)
>>  {
>>  	u64 val;
>>  
>> -	local_irq_save(*flags);
>> +	local_irq_save(cxt->flags);
>> +
>> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
>> +		/*
>> +		 * For CPUs that are affected by ARM erratum 1165522, we
>> +		 * cannot trust stage-1 to be in a correct state at that
>> +		 * point. Since we do not want to force a full load of the
>> +		 * vcpu state, we prevent the EL1 page-table walker to
>> +		 * allocate new TLBs. This is done by setting the EPD bits
>> +		 * in the TCR_EL1 register. We also need to prevent it to
>> +		 * allocate API->PA walks, so we enable the S1 MMU...
> 
> typo: API => IPA
> 
> 
>> +		 */
>> +		val = cxt->tcr = read_sysreg_el1(tcr);
>> +		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
>> +		write_sysreg_el1(val, tcr);
>> +		val = cxt->sctlr = read_sysreg_el1(sctlr);
>> +		val |= SCTLR_ELx_M;
>> +		write_sysreg_el1(val, sctlr);
> 
>> +		isb();
> 
> Could you leave these to be synchronised by the isb() in __load_guest_stage2()?
> An AT speculated here would see HCR_EL2.TGE set and use the EL2&EL0 regime.

Yes, you're right.

> 
>> +	}
>>  
>>  	/*
>>  	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
>> @@ -34,8 +59,13 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>>  	 * guest TLBs (EL1/EL0), we need to change one of these two
>>  	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
>>  	 * let's flip TGE before executing the TLB operation.
>> +	 *
>> +	 * ARM erratum 1165522 requires some special handling (again),
> 
>> +	 * as we need to make sure stage-2 is in place before clearing
>> +	 * TGE.
> 
> Typo: stage-1?
> 
> stage2 remains disabled here, we only call __load_guest_stage2() for the vmid.
> The problem was the EL1:stage-1 being usable and unknown when TGE is cleared.
> 
> 
>>  	 */
>>  	__load_guest_stage2(kvm);
>> +	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
> 
> __load_guest_stage2() already has an isb for this workaround after it writes
> vtcr/vttbr. I think we can just refer to it in the comment and let it
> synchronise the stage1+2 config before we touch hcr_el2 below.

Well spotted, I've dropped that line and hopefully clarified the comment.

> 
> 
>>  	val = read_sysreg(hcr_el2);
>>  	val &= ~HCR_TGE;
>>  	write_sysreg(val, hcr_el2);
> 
> [...]
> 
>> @@ -64,11 +94,19 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
>>  	write_sysreg(0, vttbr_el2);
>>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>>  	isb();
>> -	local_irq_restore(flags);
>> +
>> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
>> +		/* Restore the guest's registers to what they were */
>> +		write_sysreg_el1(cxt->tcr, tcr);
>> +		write_sysreg_el1(cxt->sctlr, sctlr);
> 
>> +		isb();
> 
> Hmm, why do we need this isb?
> 
> We just set TGE, so these registers values no long matter. vcpu_put() would read
> the values we wrote, as would __tlb_switch_to_guest_vhe() above if we re-ran
> this sequence. If we're on our way into the guest, the extra isb in
> __load_guest_stage2() would synchronise them before clearing TGE during
> world-switch.
> 
> I don't think there is a path where we depend on these values being isb'd before
> guest eret.

Absolutely right, I dropped that one to. Yeah, 3 ISB down, profit! ;-)

> (if its just to be robust, I'm all in favour of it!)

No, it was all about being paranoid, thanks for curing that for me!

	M.
-- 
Jazz is not dead. It just smells funny...
