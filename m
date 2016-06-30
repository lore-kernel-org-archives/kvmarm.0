From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 12/15] arm: KVM: Simplify HYP init
Date: Thu, 30 Jun 2016 13:31:52 +0100
Message-ID: <57751138.5090307@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-13-git-send-email-marc.zyngier@arm.com>
 <20160628215037.GS26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CE749B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 08:26:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrX08hm+Ts1D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 08:26:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7119549B51
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 08:26:39 -0400 (EDT)
In-Reply-To: <20160628215037.GS26498@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/06/16 22:50, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:32AM +0100, Marc Zyngier wrote:
>> Just like for arm64, we can now make the HYP setup a lot simpler,
>> and we can now initialise it in one go (instead of the two
>> phases we currently have).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h | 15 +++++--------
>>  arch/arm/kvm/init.S             | 49 ++++++++---------------------------------
>>  2 files changed, 14 insertions(+), 50 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 020f4eb..eafbfd5 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -250,18 +250,13 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
>>  	 * code. The init code doesn't need to preserve these
>>  	 * registers as r0-r3 are already callee saved according to
>>  	 * the AAPCS.
>> -	 * Note that we slightly misuse the prototype by casing the
>> +	 * Note that we slightly misuse the prototype by casting the
>>  	 * stack pointer to a void *.
>> -	 *
>> -	 * We don't have enough registers to perform the full init in
>> -	 * one go.  Install the boot PGD first, and then install the
>> -	 * runtime PGD, stack pointer and vectors. The PGDs are always
>> -	 * passed as the third argument, in order to be passed into
>> -	 * r2-r3 to the init code (yes, this is compliant with the
>> -	 * PCS!).
>> -	 */
>>  
>> -	kvm_call_hyp(NULL, 0, boot_pgd_ptr);
>> +	 * The PGDs are always passed as the third argument, in order
>> +	 * to be passed into r2-r3 to the init code (yes, this is
>> +	 * compliant with the PCS!).
>> +	 */
>>  
>>  	kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
>>  }
>> diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
>> index 1f9ae17..b82a99d 100644
>> --- a/arch/arm/kvm/init.S
>> +++ b/arch/arm/kvm/init.S
>> @@ -32,23 +32,13 @@
>>   *       r2,r3 = Hypervisor pgd pointer
>>   *
>>   * The init scenario is:
>> - * - We jump in HYP with four parameters: boot HYP pgd, runtime HYP pgd,
>> - *   runtime stack, runtime vectors
>> - * - Enable the MMU with the boot pgd
>> - * - Jump to a target into the trampoline page (remember, this is the same
>> - *   physical page!)
>> - * - Now switch to the runtime pgd (same VA, and still the same physical
>> - *   page!)
>> + * - We jump in HYP with 3 parameters: runtime HYP pgd, runtime stack,
>> + *   runtime vectors
> 
> probably just call this HYP pgd, HYP stack, and HYP vectors now

Yup.

>>   * - Invalidate TLBs
>>   * - Set stack and vectors
>> + * - Setup the page tables
>> + * - Enable the MMU
>>   * - Profit! (or eret, if you only care about the code).
>> - *
>> - * As we only have four registers available to pass parameters (and we
>> - * need six), we split the init in two phases:
>> - * - Phase 1: r0 = 0, r1 = 0, r2,r3 contain the boot PGD.
>> - *   Provides the basic HYP init, and enable the MMU.
>> - * - Phase 2: r0 = ToS, r1 = vectors, r2,r3 contain the runtime PGD.
>> - *   Switches to the runtime PGD, set stack and vectors.
>>   */
>>  
>>  	.text
>> @@ -68,8 +58,11 @@ __kvm_hyp_init:
>>  	W(b)	.
>>  
>>  __do_hyp_init:
>> -	cmp	r0, #0			@ We have a SP?
>> -	bne	phase2			@ Yes, second stage init
>> +	@ Set stack pointer
>> +	mov	sp, r0
>> +
>> +	@ Set HVBAR to point to the HYP vectors
>> +	mcr	p15, 4, r1, c12, c0, 0	@ HVBAR
>>  
>>  	@ Set the HTTBR to point to the hypervisor PGD pointer passed
>>  	mcrr	p15, 4, rr_lo_hi(r2, r3), c2
>> @@ -114,33 +107,9 @@ __do_hyp_init:
>>   THUMB(	ldr	r2, =(HSCTLR_M | HSCTLR_A | HSCTLR_TE)		)
>>  	orr	r1, r1, r2
>>  	orr	r0, r0, r1
>> -	isb
>>  	mcr	p15, 4, r0, c1, c0, 0	@ HSCR
>> -
>> -	@ End of init phase-1
>> -	eret
>> -
>> -phase2:
>> -	@ Set stack pointer
>> -	mov	sp, r0
>> -
>> -	@ Set HVBAR to point to the HYP vectors
>> -	mcr	p15, 4, r1, c12, c0, 0	@ HVBAR
>> -
>> -	@ Jump to the trampoline page
>> -	ldr	r0, =TRAMPOLINE_VA
>> -	adr	r1, target
>> -	bfi	r0, r1, #0, #PAGE_SHIFT
>> -	ret	r0
>> -
>> -target:	@ We're now in the trampoline code, switch page tables
>> -	mcrr	p15, 4, rr_lo_hi(r2, r3), c2
>>  	isb
>>  
>> -	@ Invalidate the old TLBs
>> -	mcr	p15, 4, r0, c8, c7, 0	@ TLBIALLH
>> -	dsb	ish
> 
> how are we sure there are no stale entries in the TLB beyond the idmap
> region?  Did we take care of this during kernel boot?  What about
> hotplug/suspend stuff?

This is done just before installing the page tables (not visible in this
patch). Hotplug/suspend goes through the same path as well, so it should
be all taken care of.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
