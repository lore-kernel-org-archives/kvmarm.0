From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v2 2/2] arm: KVM: keep arm vfp/simd exit handling
 consistent with arm64
Date: Thu, 18 Jun 2015 16:49:36 -0700
Message-ID: <55835910.3060601@samsung.com>
References: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
 <1434491452-19177-3-git-send-email-m.smarduch@samsung.com>
 <5582FF76.6060100@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACA4656059
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 19:39:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uy02+dmqkWNM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 19:39:04 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4BEE56057
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 19:39:01 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ500E08ZIU9L90@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 18 Jun 2015 19:49:42 -0400 (EDT)
In-reply-to: <5582FF76.6060100@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/18/2015 10:27 AM, Marc Zyngier wrote:
> On 16/06/15 22:50, Mario Smarduch wrote:
>> After enhancing arm64 FP/SIMD exit handling, FP/SIMD exit branch is moved
>> to guest trap handling. This keeps exiting handling flow between both
>> architectures consistent.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/kvm/interrupts.S |   12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
>> index 79caf79..fca2c56 100644
>> --- a/arch/arm/kvm/interrupts.S
>> +++ b/arch/arm/kvm/interrupts.S
>> @@ -363,10 +363,6 @@ hyp_hvc:
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
>> @@ -406,6 +402,12 @@ THUMB(	orr	lr, #1)
>>  1:	eret
>>  
>>  guest_trap:
>> +#ifdef CONFIG_VFPv3
>> +	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
>> +	cmp	r0, #HSR_EC_CP_0_13
>> +	beq	switch_to_guest_fpsimd
>> +#endif
>> +
>>  	load_vcpu			@ Load VCPU pointer to r0
>>  	str	r1, [vcpu, #VCPU_HSR]
>>  
>> @@ -478,7 +480,7 @@ guest_trap:
>>   * inject an undefined exception to the guest.
>>   */
>>  #ifdef CONFIG_VFPv3
>> -switch_to_guest_vfp:
>> +switch_to_guest_fpsimd:
> 
> Ah, I think I managed to confuse you in my previous comment.
> On ARMv7, we call the floating point stuff VFP.
> On ARMv8, we call it FP/SIMD.

Ah I see, I'll update.
> 
> Not very consistent, I know...
> 
>>  	load_vcpu			@ Load VCPU pointer to r0

How about move it here - then it does not stick out like
before.

guest_trap:
        load_vcpu                       @ Load VCPU pointer to r0
        str     r1, [vcpu, #VCPU_HSR]

        @ Check if we need the fault information
        lsr     r1, r1, #HSR_EC_SHIFT
#ifdef CONFIG_VFPv3
        /* Guest accessed VFP/SIMD registers, save host, restore Guest */
        cmp     r1, #HSR_EC_CP_0_13
        beq     switch_to_guest_vfp
#endif


Regarding "host_switch_to_hyp:" it has no reference but appears
like a clean separator, that's on purpose?

Thanks

> 
> It would be interesting to find out if we can make this load_vcpu part
> of the common sequence (without spilling another register, of course).
> Probably involves moving the exception class to r2.
> 
> Thanks,
> 
> 	M.
> 
