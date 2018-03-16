From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 19/26] arm64: KVM: Move stashing of x0/x1 into the
 vector code itself
Date: Fri, 16 Mar 2018 16:37:15 +0000
Message-ID: <6f9bb886-d4fa-2272-2bd5-9f440b2f9e8c@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-20-marc.zyngier@arm.com>
 <20180316162257.rvz26fbn3j5jvsku@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C6349F98
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:30:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wLkwpWO+2ZLr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Mar 2018 12:30:34 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 833BA4028A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:30:34 -0400 (EDT)
In-Reply-To: <20180316162257.rvz26fbn3j5jvsku@armageddon.cambridge.arm.com>
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
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/18 16:22, Catalin Marinas wrote:
> On Wed, Mar 14, 2018 at 04:50:42PM +0000, Marc Zyngier wrote:
>> All our useful entry points into the hypervisor are starting by
>> saving x0 and x1 on the stack. Let's move those into the vectors
>> by introducing macros that annotate whether a vector is valid or
>> not, thus indicating whether we want to stash registers or not.
>>
>> The only drawback is that we now also stash registers for el2_error,
>> but this should never happen, and we pop them back right at the
>> start of the handling sequence.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/hyp-entry.S | 56 ++++++++++++++++++++++++------------------
>>  1 file changed, 32 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>> index f36464bd57c5..0f62b5f76aa5 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -55,7 +55,6 @@ ENTRY(__vhe_hyp_call)
>>  ENDPROC(__vhe_hyp_call)
>>  
>>  el1_sync:				// Guest trapped into EL2
>> -	stp	x0, x1, [sp, #-16]!
>>  
>>  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>>  	mrs	x1, esr_el2
>> @@ -137,18 +136,18 @@ alternative_else_nop_endif
>>  	b	__guest_exit
>>  
>>  el1_irq:
>> -	stp     x0, x1, [sp, #-16]!
>>  	ldr	x1, [sp, #16 + 8]
>>  	mov	x0, #ARM_EXCEPTION_IRQ
>>  	b	__guest_exit
>>  
>>  el1_error:
>> -	stp     x0, x1, [sp, #-16]!
>>  	ldr	x1, [sp, #16 + 8]
>>  	mov	x0, #ARM_EXCEPTION_EL1_SERROR
>>  	b	__guest_exit
>>  
>>  el2_error:
>> +	ldp	x0, x1, [sp], #16
>> +
> 
> Nitpick: you don't need a memory access here, just:
> 
> 	add	sp, sp, #16
> 
> (unless el2_error has changed somewhere before this patch)

At this point in the series, I agree. But starting with patch 22, we
start messing with x0 if HARDEN_EL2_VECTORS is valid, meaning we really
need to restore it in order to preserve the guest state.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
