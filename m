From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 7/8] arm64: KVM: Handle ARM erratum 1165522 in TLB
 invalidation
Date: Mon, 10 Dec 2018 10:46:16 +0000
Message-ID: <50e6a07d-868b-db43-fd4e-4b6359a5128e@arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-8-marc.zyngier@arm.com>
 <20181210101912.GK30263@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4184A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:46:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bEW3xomsbBLl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:46:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 588064A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:46:22 -0500 (EST)
In-Reply-To: <20181210101912.GK30263@e113682-lin.lund.arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/2018 10:19, Christoffer Dall wrote:
> On Thu, Dec 06, 2018 at 05:31:25PM +0000, Marc Zyngier wrote:
>> In order to avoid TLB corruption whilst invalidating TLBs on CPUs
>> affected by erratum 1165522, we need to prevent S1 page tables
>> from being usable.
>>
>> For this, we set the EL1 S1 MMU on, and also disable the page table
>> walker (by setting the TCR_EL1.EPD* bits to 1).
>>
>> This ensures that once we switch to the EL1/EL0 translation regime,
>> speculated AT instructions won't be able to parse the page tables.
>>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/tlb.c | 66 +++++++++++++++++++++++++++++++---------
>>  1 file changed, 51 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
>> index 7fcc9c1a5f45..ec157543d5a9 100644
>> --- a/arch/arm64/kvm/hyp/tlb.c
>> +++ b/arch/arm64/kvm/hyp/tlb.c
>> @@ -21,12 +21,36 @@
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
>> +		 * allocate IPA->PA walks, so we enable the S1 MMU...
>> +		 */
>> +		val = cxt->tcr = read_sysreg_el1(tcr);
>> +		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
>> +		write_sysreg_el1(val, tcr);
>> +		val = cxt->sctlr = read_sysreg_el1(sctlr);
>> +		val |= SCTLR_ELx_M;
>> +		write_sysreg_el1(val, sctlr);
>> +	}
>>  
>>  	/*
>>  	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
>> @@ -34,6 +58,11 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>>  	 * guest TLBs (EL1/EL0), we need to change one of these two
>>  	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
>>  	 * let's flip TGE before executing the TLB operation.
>> +	 *
>> +	 * ARM erratum 1165522 requires some special handling (again),
>> +	 * as we need to make sure both stages of translation are in
>> +	 * place before clearing TGE. __load_guest_stage2() already
>> +	 * has an ISB in order to deal with this.
>>  	 */
>>  	__load_guest_stage2(kvm);
>>  	val = read_sysreg(hcr_el2);
>> @@ -43,7 +72,7 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>>  }
>>  
>>  static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
>> -						  unsigned long *flags)
>> +						  struct tlb_inv_context *cxt)
>>  {
>>  	__load_guest_stage2(kvm);
>>  	isb();
>> @@ -55,7 +84,7 @@ static hyp_alternate_select(__tlb_switch_to_guest,
>>  			    ARM64_HAS_VIRT_HOST_EXTN);
>>  
>>  static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
>> -						unsigned long flags)
>> +						struct tlb_inv_context *cxt)
>>  {
>>  	/*
>>  	 * We're done with the TLB operation, let's restore the host's
>> @@ -64,11 +93,18 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
>>  	write_sysreg(0, vttbr_el2);
>>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>>  	isb();
>> -	local_irq_restore(flags);
>> +
>> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
>> +		/* Restore the guest's registers to what they were */
> 
> host's ?

Hum... Yes, silly thinko.

[...]

> 
> Otherwise:
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
