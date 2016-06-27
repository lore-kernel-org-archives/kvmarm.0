From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 02/15] arm64: KVM: Kill HYP_PAGE_OFFSET
Date: Mon, 27 Jun 2016 15:20:23 +0100
Message-ID: <57713627.1010800@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-3-git-send-email-marc.zyngier@arm.com>
 <20160627134717.GJ26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 553F649B42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 10:15:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lG6uapJ2T6mX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 10:15:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A91149B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 10:15:18 -0400 (EDT)
In-Reply-To: <20160627134717.GJ26498@cbox>
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

On 27/06/16 14:47, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:22AM +0100, Marc Zyngier wrote:
>> HYP_PAGE_OFFSET is not massively useful. And the way we use it
>> in KERN_HYP_VA is inconsistent with the equivalent operation in
>> EL2, where we use a mask instead.
>>
>> Let's replace the uses of HYP_PAGE_OFFSET with HYP_PAGE_OFFSET_MASK,
>> and get rid of the pointless macro.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_hyp.h | 5 ++---
>>  arch/arm64/include/asm/kvm_mmu.h | 3 +--
>>  2 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index 44eaff7..61d01a9 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -38,11 +38,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>>  
>>  static inline unsigned long __hyp_kern_va(unsigned long v)
>>  {
>> -	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
>> -	asm volatile(ALTERNATIVE("add %0, %0, %1",
>> +	asm volatile(ALTERNATIVE("orr %0, %0, %1",
>>  				 "nop",
>>  				 ARM64_HAS_VIRT_HOST_EXTN)
>> -		     : "+r" (v) : "r" (offset));
>> +		     : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
> 
> for some reason this is hurting my brain.  I can't easily see that the
> two implementations are equivalent.
> 
> I can see that the kernel-to-hyp masking is trivially correct, but are
> we always sure that the upper bits that we mask off are always set?

A kernel address always has the top bits set. That's a given, and a
property of the architecture (bits [63:VA_BITS] are set to one. See
D4.2.1 and the definition of a Virtual Address (top VA subrange).

> 
>>  	return v;
>>  }
>>  
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 00bc277..d162372 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -75,7 +75,6 @@
>>   */
>>  #define HYP_PAGE_OFFSET_SHIFT	VA_BITS
>>  #define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
>> -#define HYP_PAGE_OFFSET		(PAGE_OFFSET & HYP_PAGE_OFFSET_MASK)
>>  
>>  /*
>>   * Our virtual mapping for the idmap-ed MMU-enable code. Must be
>> @@ -109,7 +108,7 @@ alternative_endif
>>  #include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>>  
>> -#define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
>> +#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
>>  
> 
> Why do we have both kern_hyp_va() and KERN_TO_HYP and how are they
> related again?

That's because kern_hyp_va used to be reserved to the assembly code, and
KERN_TO_HYP used in C code. We could (and probably should) unify them.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
