From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/21] arm64: KVM: VHE: Turn VTCR_EL2 setup into a
 reusable macro
Date: Mon, 1 Feb 2016 14:21:57 +0000
Message-ID: <56AF6A05.5020501@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-6-git-send-email-marc.zyngier@arm.com>
 <20160201131300.GH1478@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9FED410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 09:16:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLUFbYe6Dwmi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 09:16:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95323410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 09:16:43 -0500 (EST)
In-Reply-To: <20160201131300.GH1478@cbox>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/16 13:13, Christoffer Dall wrote:
> On Mon, Jan 25, 2016 at 03:53:39PM +0000, Marc Zyngier wrote:
>> On a VHE-capable system, there is no point in setting VTCR_EL2
>> at KVM init time. We can perfectly set it up when the kernel
>> boots, removing the need for a more complicated configuration.
> 
> what's the complicated configuration which is avoided?

With VHE, there is no hyp-init at all, so what we avoid is a weird init
sequence where we have to execute part of this hyp-init, but not all of it.

>>
>> In order to allow this, turn VTCR_EL2 setup into a macro that
>> we'll be able to reuse at boot time.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_mmu.h | 23 +++++++++++++++++++++++
>>  arch/arm64/kvm/hyp-init.S        | 18 +-----------------
>>  2 files changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 7364339..d3e6d7b 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -56,6 +56,29 @@
>>  
>>  #ifdef __ASSEMBLY__
>>  
>> +#include <asm/kvm_arm.h>
>> +
>> +.macro setup_vtcr tmp1, tmp2
>> +	mov	\tmp1, #(VTCR_EL2_FLAGS & 0xffff)
>> +	movk	\tmp1, #(VTCR_EL2_FLAGS >> 16), lsl #16
>> +	/*
>> +	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
>> +	 * VTCR_EL2.
>> +	 */
>> +	mrs	\tmp2, id_aa64mmfr0_el1
>> +	bfi	\tmp1, \tmp2, #16, #3
>> +	/*
>> +	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
>> +	 * VTCR_EL2.
>> +	 */
>> +	mrs	\tmp2, ID_AA64MMFR1_EL1
>> +	ubfx	\tmp2, \tmp2, #5, #1
>> +	lsl	\tmp2, \tmp2, #VTCR_EL2_VS
>> +	orr	\tmp1, \tmp1, \tmp2
>> +
>> +	msr	vtcr_el2, \tmp1
>> +	isb
>> +.endm
> 
> this feels like an awful lot of code in a header file.

interrupt_head.S respectfully disagrees with you ;-).

> Is it crazy to imagine wanting to have different T0SZ for different VMs
> in the future?  In that case, the T0SZ stuff should stay in KVM...

That's a rather compelling argument indeed. I'll see if I can turn the
thing around in a slightly nicer way. How about moving it out of
hyp-init.S altogether, and into C code?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
