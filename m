From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 2/3] arm: KVM: Implement lazy VFP switching outside of Hyp
 Mode
Date: Mon, 06 Jul 2015 10:54:46 -0700
Message-ID: <559AC0E6.2000107@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <1435203028-23142-3-git-send-email-m.smarduch@samsung.com>
 <20150705193440.GB3869@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DC5657D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 13:43:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMzKgGjsjKQw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 13:43:25 -0400 (EDT)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D14857D04
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 13:43:25 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR200KK3V3GL830@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 06 Jul 2015 13:54:52 -0400 (EDT)
In-reply-to: <20150705193440.GB3869@cbox>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/05/2015 12:34 PM, Christoffer Dall wrote:
> On Wed, Jun 24, 2015 at 08:30:27PM -0700, Mario Smarduch wrote:
>> This patch implements the VFP context switch code called from vcpu_put in
>> Host KVM. In addition it implements the logic to skip setting a VFP trap if one
>> is not needed. Also resets the flag if Host KVM switched registers to trap new
>> guest vfp accesses.
>>
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/kvm/interrupts.S |   49 ++++++++++++++++++++++++++++-----------------
>>  1 file changed, 31 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
>> index 79caf79..0912edd 100644
>> --- a/arch/arm/kvm/interrupts.S
>> +++ b/arch/arm/kvm/interrupts.S
>> @@ -96,6 +96,21 @@ ENTRY(__kvm_flush_vm_context)
>>  	bx	lr
>>  ENDPROC(__kvm_flush_vm_context)
>>  
>> +ENTRY(__kvm_restore_host_vfp_state)
>> +	push    {r3-r7}
>> +
>> +	mov     r1, #0
>> +	str     r1, [r0, #VCPU_VFP_SAVED]
>> +
>> +	add     r7, r0, #VCPU_VFP_GUEST
>> +	store_vfp_state r7
>> +	add     r7, r0, #VCPU_VFP_HOST
>> +	ldr     r7, [r7]
>> +	restore_vfp_state r7
>> +
>> +	pop     {r3-r7}
>> +	bx      lr
>> +ENDPROC(__kvm_restore_host_vfp_state)
> 
> it feels a bit strange to introduce this function here when I cannot see
> how it's called.
> 
> At the very least, could you provide the C equivalent prototype in a
> comment or specify what the input registers are?  E.g.

Yes again that's on a todo list.
> 
> /*
>  * void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
>  */
> 
>>  
>>  /********************************************************************
>>   *  Hypervisor world-switch code
>> @@ -131,7 +146,13 @@ ENTRY(__kvm_vcpu_run)
>>  
>>  	@ Trap coprocessor CRx accesses
>>  	set_hstr vmentry
>> +
>> +	ldr	r1, [vcpu, #VCPU_VFP_SAVED]
>> +	cmp	r1, #1
>> +	beq     skip_guest_vfp_trap
>>  	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>> +skip_guest_vfp_trap:
>> +
>>  	set_hdcr vmentry
>>  
>>  	@ Write configured ID register into MIDR alias
>> @@ -173,18 +194,6 @@ __kvm_vcpu_return:
>>  	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>>  
>>  #ifdef CONFIG_VFPv3
>> -	@ Save floating point registers we if let guest use them.
>> -	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
>> -	bne	after_vfp_restore
>> -
>> -	@ Switch VFP/NEON hardware state to the host's
>> -	add	r7, vcpu, #VCPU_VFP_GUEST
>> -	store_vfp_state r7
>> -	add	r7, vcpu, #VCPU_VFP_HOST
>> -	ldr	r7, [r7]
>> -	restore_vfp_state r7
>> -
>> -after_vfp_restore:
>>  	@ Restore FPEXC_EN which we clobbered on entry
>>  	pop	{r2}
>>  	VFPFMXR FPEXC, r2
>> @@ -363,10 +372,6 @@ hyp_hvc:
>>  	@ Check syndrome register
>>  	mrc	p15, 4, r1, c5, c2, 0	@ HSR
>>  	lsr	r0, r1, #HSR_EC_SHIFT
>> -#ifdef CONFIG_VFPv3
>> -	cmp	r0, #HSR_EC_CP_0_13
>> -	beq	switch_to_guest_vfp
>> -#endif
>>  	cmp	r0, #HSR_EC_HVC
>>  	bne	guest_trap		@ Not HVC instr.
>>  
>> @@ -380,7 +385,10 @@ hyp_hvc:
>>  	cmp     r2, #0
>>  	bne	guest_trap		@ Guest called HVC
>>  
>> -host_switch_to_hyp:
>> +	/*
>> +	 * Getting here means host called HVC, we shift parameters and branch
>> +	 * to Hyp function.
>> +	 */
> 
> not sure this comment change belongs in this patch (but the comment is
> well-written).

I built this patch on top of previous one. But IMO this series
is not ready for upstream yet.

> 
>>  	pop	{r0, r1, r2}
>>  
>>  	/* Check for __hyp_get_vectors */
>> @@ -411,6 +419,10 @@ guest_trap:
>>  
>>  	@ Check if we need the fault information
>>  	lsr	r1, r1, #HSR_EC_SHIFT
>> +#ifdef CONFIG_VFPv3
>> +	cmp	r1, #HSR_EC_CP_0_13
>> +	beq	switch_to_guest_vfp
>> +#endif
>>  	cmp	r1, #HSR_EC_IABT
>>  	mrceq	p15, 4, r2, c6, c0, 2	@ HIFAR
>>  	beq	2f
>> @@ -479,11 +491,12 @@ guest_trap:
>>   */
>>  #ifdef CONFIG_VFPv3
>>  switch_to_guest_vfp:
>> -	load_vcpu			@ Load VCPU pointer to r0
>>  	push	{r3-r7}
>>  
>>  	@ NEON/VFP used.  Turn on VFP access.
>>  	set_hcptr vmexit, (HCPTR_TCP(10) | HCPTR_TCP(11))
>> +	mov	r1, #1
>> +	str	r1, [vcpu, #VCPU_VFP_SAVED]
>>  
>>  	@ Switch VFP/NEON hardware state to the guest's
>>  	add	r7, r0, #VCPU_VFP_HOST
>> -- 
>> 1.7.9.5
>>
> It would probably be easier to just rebase this on the previous series
> and refer to that in the cover letter, but the approach here looks
> otherwise right to me.

What if we used the simplified approach (as Marc mentioned) and
let it run for quite a while and then move this series?
> 
> -Christoffer
> 
