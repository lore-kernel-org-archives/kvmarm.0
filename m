From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/8] arm64: KVM: Disable virtual timer even if the guest
 is not using it
Date: Thu, 17 Sep 2015 16:28:30 +0100
Message-ID: <55FADC1E.50909@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com> <1442501171-24484-6-git-send-email-marc.zyngier@arm.com> <55FAD607.9040305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55FAD607.9040305@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, =?windows-1252?Q?Alex_Benn=E9?= =?windows-1252?Q?e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/09/15 16:02, Paolo Bonzini wrote:
> 
> 
> On 17/09/2015 16:46, Marc Zyngier wrote:
>> When running a guest with the architected timer disabled (with QEMU and
>> the kernel_irqchip=off option, for example), it is important to make
>> sure the timer gets turned off. Otherwise, the guest may try to
>> enable it anyway, leading to a screaming HW interrupt.
>>
>> The fix is to unconditionally turn off the virtual timer on guest
>> exit.
>>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp.S | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index 39aa322..60a83e2 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -562,8 +562,6 @@
>>  	mrs	x3, cntv_ctl_el0
>>  	and	x3, x3, #3
>>  	str	w3, [x0, #VCPU_TIMER_CNTV_CTL]
>> -	bic	x3, x3, #1		// Clear Enable
>> -	msr	cntv_ctl_el0, x3
>>  
>>  	isb
>>  
>> @@ -571,6 +569,9 @@
>>  	str	x3, [x0, #VCPU_TIMER_CNTV_CVAL]
>>  
>>  1:
>> +	// Disable the virtual timer
>> +	msr	cntv_ctl_el0, xzr
>> +
>>  	// Allow physical timer/counter access for the host
>>  	mrs	x2, cnthctl_el2
>>  	orr	x2, x2, #3
>>
> 
> It looks like here in restore_timer_state:
> 
>         ldr     w2, [x0, #VCPU_TIMER_CNTV_CTL]
>         and     x2, x2, #3
>         msr     cntv_ctl_el0, x2
> 
> the "and" would be unnecessary if kvm_arm_timer_set_reg remembered to 
> do it.  Something like this, which would also make the code more 
> consistent between arm and arm64...
> 
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index 702740d37465..93e322b4d242 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -514,6 +514,7 @@ ARM_BE8(rev	r6, r6  )
>  	beq	1f
>  
>  	mrc	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
> +	and	r2, r2, #3

I don't think we need this. Exposing the ISTATUS bit to the kernel (or
even userspace) is not really a problem (that's actually an interesting
piece of information), and restoring it is not possible since it is
read-only.

We should drop the equivalent 'and' from the arm64 version.

>  	str	r2, [vcpu, #VCPU_TIMER_CNTV_CTL]
>  	bic	r2, #1			@ Clear ENABLE
>  	mcr	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
> @@ -566,7 +567,6 @@ ARM_BE8(rev	r6, r6  )
>  	isb
>  
>  	ldr	r2, [vcpu, #VCPU_TIMER_CNTV_CTL]
> -	and	r2, r2, #3
>  	mcr	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
>  1:
>  .endm
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 10915aaf0b01..bfcd3f3a947b 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -887,7 +887,6 @@ alternative_endif
>  	isb
>  
>  	ldr	w2, [x0, #VCPU_TIMER_CNTV_CTL]
> -	and	x2, x2, #3
>  	msr	cntv_ctl_el0, x2
>  1:
>  .endm
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 98c95f2fcba4..9b03c9f5abbf 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -218,7 +218,7 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  
>  	switch (regid) {
>  	case KVM_REG_ARM_TIMER_CTL:
> -		timer->cntv_ctl = value;
> +		timer->cntv_ctl = value & (ARCH_TIMER_CTRL_IT_MASK | ARCH_TIMER_CTRL_ENABLE);
>  		break;
>  	case KVM_REG_ARM_TIMER_CNT:
>  		vcpu->kvm->arch.timer.cntvoff = kvm_phys_timer_read() - value;
> 

Otherwise looks pretty good. Can you send an updated patch?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
