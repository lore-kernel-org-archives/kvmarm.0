From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Configure TCR_EL2.PS at runtime
Date: Thu, 11 Feb 2016 13:55:13 +0000
Message-ID: <56BC92C1.8060201@arm.com>
References: <1455130013-28644-1-git-send-email-tchalamarla@caviumnetworks.com>
 <20160211132708.GU5171@cbox> <20160211133401.GV5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F0C49B9F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 08:49:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0VsMGegiRoJD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 08:49:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A92F49B9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 08:49:21 -0500 (EST)
In-Reply-To: <20160211133401.GV5171@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, tchalamarla@caviumnetworks.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/02/16 13:34, Christoffer Dall wrote:
> On Thu, Feb 11, 2016 at 02:27:08PM +0100, Christoffer Dall wrote:
>> On Wed, Feb 10, 2016 at 10:46:53AM -0800, tchalamarla@caviumnetworks.com wrote:
>>> From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
>>>
>>> Setting TCR_EL2.PS to 40 bits is wrong on systems with PS size is
>>> less than 40 bits. and with systems where RAM is at higher address,
>>> this will break KVM.
>>>
>>> This patch sets TCR_EL2.PS at runtime similar to VTCR_EL2.PS
>>>
>>> changes form V2:
>>> 	- Modified subject line and commit message.
>>> 	- Removed TCR_EL2_FLAGS.
>>>
>>> changes from V1:
>>>         - Moved to dynamic configuration.
>>>
>>> Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_arm.h |  2 --
>>>  arch/arm64/kvm/hyp-init.S        | 12 +++++++-----
>>>  2 files changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 738a95f..3776db0 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -107,8 +107,6 @@
>>>  #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
>>>  			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
>>>  
>>> -#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
>>> -
>>>  /* VTCR_EL2 Registers bits */
>>>  #define VTCR_EL2_RES1		(1 << 31)
>>>  #define VTCR_EL2_PS_MASK	(7 << 16)
>>> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
>>> index 3e568dc..b5ab1b0 100644
>>> --- a/arch/arm64/kvm/hyp-init.S
>>> +++ b/arch/arm64/kvm/hyp-init.S
>>> @@ -64,7 +64,7 @@ __do_hyp_init:
>>>  	mrs	x4, tcr_el1
>>>  	ldr	x5, =TCR_EL2_MASK
>>>  	and	x4, x4, x5
>>> -	ldr	x5, =TCR_EL2_FLAGS
>>> +	ldr	x5, =TCR_EL2_RES1
>>>  	orr	x4, x4, x5
>>>  
>>>  #ifndef CONFIG_ARM64_VA_BITS_48
>>> @@ -85,15 +85,17 @@ __do_hyp_init:
>>>  	ldr_l	x5, idmap_t0sz
>>>  	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
>>>  #endif
>>> -	msr	tcr_el2, x4
>>> -
>>> -	ldr	x4, =VTCR_EL2_FLAGS
>>>  	/*
>>>  	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
>>> -	 * VTCR_EL2.
>>> +	 * TCR_EL2 and VTCR_EL2.
>>>  	 */
>>>  	mrs	x5, ID_AA64MMFR0_EL1
>>>  	bfi	x4, x5, #16, #3
>>> +
>>> +	msr	tcr_el2, x4
>>> +
>>> +	ldr	x4, =VTCR_EL2_FLAGS
>>> +	bfi	x4, x5, #16, #3
>>>  	/*
>>>  	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
>>>  	 * VTCR_EL2.
>>> -- 
>>> 2.1.0
>>>
>>
>> This looks reasonable enough for me.  Did we limit Linux to PS=40 bits
>> in the past and have lifted this restriction, or why did we have this
>> limitation for EL2 translations in the past?
>>
> Hmm, just went back and looked at my comments [1] on Suzuki's 16K page
> series, and regarding our stage-2 page table configuration I wrote this:
> 
> <quote>
> ... the constraints of
> this whole thing is, and make sure we agree on this:
> 
> 1. We fix the IPA max width to 40 bits
> 2. We don't support systems with a PARange smaller than 40 bits (do we
>    check this anywhere or document this anywhere?)
>    3. We always assume we are running on a system with PARange of 40
>    bits
>       and we are therefore constrained to use concatination.
> </quote>
> 
> So this change is actually making a bit nervous...  Marc, did you check
> if all the stuff in arch/arm64/include/asm/kvm_mmu.h still holds after
> we relax this?

I believe this still works for the following reasons:

- This only affects the output address of EL2 Stage-1, and basically
only allows EL2 to reach the same memory as the rest of the host kernel.

- Stage-2 translation already does the same thing, for similar reasons.

- We enforce 40bit IPA by not providing page tables above 40 bits (by
setting T0SZ to 64-40=24). This has the effect of denying accesses above
40bit IPA to the guest.

So I'm quite confident that we're safe here.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
