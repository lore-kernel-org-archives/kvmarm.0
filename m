From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 08/55] KVM: arm64: Set virtual EL2 context depending on the
 guest exception level
Date: Fri, 2 Jun 2017 09:48:43 +0100
Message-ID: <178e3aaf-dd25-9590-35d7-c1f2705a5c06@arm.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-9-git-send-email-jintack@cs.columbia.edu>
 <jpgtw3zzcee.fsf@linux.bootlegged.copy>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7806040C5B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 04:44:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s8hDBKcF877t for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 04:44:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF9040BD8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 04:44:50 -0400 (EDT)
In-Reply-To: <jpgtw3zzcee.fsf@linux.bootlegged.copy>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bandan Das <bsd@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/06/17 21:22, Bandan Das wrote:
> Jintack Lim <jintack@cs.columbia.edu> writes:
> 
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> Set up virutal EL2 context to hardware if the guest exception level is
>> EL2.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> ---
>>  arch/arm64/kvm/context.c | 32 ++++++++++++++++++++++++++------
>>  1 file changed, 26 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
>> index 320afc6..acb4b1e 100644
>> --- a/arch/arm64/kvm/context.c
>> +++ b/arch/arm64/kvm/context.c
>> @@ -25,10 +25,25 @@
>>  void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>> +	if (unlikely(vcpu_mode_el2(vcpu))) {
>> +		ctxt->hw_pstate = *vcpu_cpsr(vcpu) & ~PSR_MODE_MASK;
>>  
>> -	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
>> -	ctxt->hw_sys_regs = ctxt->sys_regs;
>> -	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
>> +		/*
>> +		 * We emulate virtual EL2 mode in hardware EL1 mode using the
>> +		 * same stack pointer mode as the guest expects.
>> +		 */
>> +		if ((*vcpu_cpsr(vcpu) & PSR_MODE_MASK) == PSR_MODE_EL2h)
>> +			ctxt->hw_pstate |= PSR_MODE_EL1h;
>> +		else
>> +			ctxt->hw_pstate |= PSR_MODE_EL1t;
>> +
> 
> I see vcpu_mode(el2) does
> return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;
> 
> I can't seem to find this, what's the difference between
> the modes: PSR_MODE_EL2h/EL2t ?

The difference is the stack pointer that is getting used. When the CPU
is at ELxh, it uses SPx at ELx. When at ELxt, it uses SP0 (the userspace
stack pointer). See the definition of SPSR_EL2 in the ARMv8 ARM.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
