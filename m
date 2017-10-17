From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/10] arm: KVM: Add optimized PIPT icache flushing
Date: Tue, 17 Oct 2017 10:26:31 +0100
Message-ID: <968be34c-fc4c-1a17-d7cf-0e4cc17ef300@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-4-marc.zyngier@arm.com> <20171016200752.GF1845@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C46D749D48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 05:25:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFXYUG2X5YcT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 05:25:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2997B49D1C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 05:25:37 -0400 (EDT)
In-Reply-To: <20171016200752.GF1845@lvm>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/10/17 21:07, Christoffer Dall wrote:
> On Mon, Oct 09, 2017 at 04:20:25PM +0100, Marc Zyngier wrote:
>> Calling __cpuc_coherent_user_range to invalidate the icache on
>> a PIPT icache machine has some pointless overhead, as it starts
>> by cleaning the dcache to the PoU, while we're guaranteed to
>> have already cleaned it to the PoC.
>>
>> As KVM is the only user of such a feature, let's implement some
>> ad-hoc cache flushing in kvm_mmu.h. Should it become useful to
>> other subsystems, it can be moved to a more global location.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_hyp.h |  2 ++
>>  arch/arm/include/asm/kvm_mmu.h | 24 ++++++++++++++++++++++--
>>  2 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
>> index 14b5903f0224..ad541f9ecc78 100644
>> --- a/arch/arm/include/asm/kvm_hyp.h
>> +++ b/arch/arm/include/asm/kvm_hyp.h
>> @@ -69,6 +69,8 @@
>>  #define HIFAR		__ACCESS_CP15(c6, 4, c0, 2)
>>  #define HPFAR		__ACCESS_CP15(c6, 4, c0, 4)
>>  #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
>> +#define BPIALLIS	__ACCESS_CP15(c7, 0, c1, 6)
>> +#define ICIMVAU		__ACCESS_CP15(c7, 0, c5, 1)
>>  #define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
>>  #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
>>  #define TLBIALL		__ACCESS_CP15(c8, 0, c7, 0)
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index f553aa62d0c3..6773dcf21bff 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -37,6 +37,8 @@
>>  
>>  #include <linux/highmem.h>
>>  #include <asm/cacheflush.h>
>> +#include <asm/cputype.h>
>> +#include <asm/kvm_hyp.h>
>>  #include <asm/pgalloc.h>
>>  #include <asm/stage2_pgtable.h>
>>  
>> @@ -157,6 +159,8 @@ static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
>>  						kvm_pfn_t pfn,
>>  						unsigned long size)
>>  {
>> +	u32 iclsz;
>> +
>>  	/*
>>  	 * If we are going to insert an instruction page and the icache is
>>  	 * either VIPT or PIPT, there is a potential problem where the host
>> @@ -182,17 +186,33 @@ static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
>>  	}
>>  
>>  	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
>> +	iclsz = 4 << (read_cpuid(CPUID_CACHETYPE) & 0xf);
>> +
> 
> nit: the 4 here is a bit cryptic, could we say something like (perhaps
> slightly over-explained):
> /*
>  * CTR IminLine contains Log2 of the number of words in the cache line,
>  * so we can get the number of words as 2 << (IminLine - 1).  To get the
>  * number of bytes, we multiply by 4 (the number of bytes in a 32-bit
>  * word), and get 4 << (IminLine).
>  */

Absolutely. I'll fold that in. Thanks.

>>  	while (size) {
>>  		void *va = kmap_atomic_pfn(pfn);
>> +		void *end = va + PAGE_SIZE;
>> +		void *addr = va;
>> +
>> +		do {
>> +			write_sysreg(addr, ICIMVAU);
> 
> Maybe an oddball place to ask this, but I don't recall why we need PoU
> everywhere, would PoC potentially be enough?

PoC is in general stronger than PoU. All we care is for instructions to
be fetched from the point where the icache cannot be distinguished from
the dcache - the definition of the PoU. Also, I don't think there is a
way to invalidate the icache to the PoC.

> 
>> +			addr += iclsz;
>> +		} while (addr < end);
>>  
>> -		__cpuc_coherent_user_range((unsigned long)va,
>> -					   (unsigned long)va + PAGE_SIZE);
>> +		dsb(ishst);
>> +		isb();
> 
> Do we really need this in every iteration of the loop?

The problem is that we need to factor in the interaction with the unmap
below. If we don't enforce the invalidation now, we may unmap the page
before the invalidations are finished, with could lead to a page fault.
If we didn't have to deal with highmem, that would indeed be a good
optimization.

> 
>>  
>>  		size -= PAGE_SIZE;
>>  		pfn++;
>>  
>>  		kunmap_atomic(va);
>>  	}
>> +
>> +	/* Check if we need to invalidate the BTB */
>> +	if ((read_cpuid_ext(CPUID_EXT_MMFR1) >> 24) != 4) {
> 
> Either I'm having a bad day or you meant to shift this 28, not 24?

Oops... That's indeed totally broken. Thanks for noticing it!

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
