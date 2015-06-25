From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [RESEND PATCH v2 2/2] arm: KVM: keep arm vfp/simd exit handling
 consistent with arm64
Date: Wed, 24 Jun 2015 20:33:57 -0700
Message-ID: <558B76A5.5000308@samsung.com>
References: <1434739306-23417-1-git-send-email-m.smarduch@samsung.com>
 <558AD06F.6090103@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0512C56F31
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:23:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TE4Z1JOgbz0i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 23:23:01 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0D5256F2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:23:01 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQH005OFDWNEZ40@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 24 Jun 2015 23:33:59 -0400 (EDT)
In-reply-to: <558AD06F.6090103@arm.com>
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
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/24/2015 08:44 AM, Marc Zyngier wrote:
> Hi Mario,
> 
> On 19/06/15 19:41, Mario Smarduch wrote:
>> After enhancing arm64 FP/SIMD exit handling, 32-bit VFP exit branch is moved
>> to guest trap handling, keeping exit handling flow for both architectures 
>> consistent.
>>
>> Also replaced an unused label with a comment.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/kvm/interrupts.S |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
>> index 79caf79..16f00f1 100644
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
>> @@ -380,7 +376,7 @@ hyp_hvc:
>>  	cmp     r2, #0
>>  	bne	guest_trap		@ Guest called HVC
>>  
>> -host_switch_to_hyp:
>> +	/* Guest is calling a hyp function, save minimum context branch to it */
>>  	pop	{r0, r1, r2}
>>  
>>  	/* Check for __hyp_get_vectors */
>> @@ -411,6 +407,10 @@ guest_trap:
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
>>
> 
> Two things: I think you can now drop the load_vcpu that is in
> switch_to_guest_vfp (you just executed it in guest_trap). You also have
> an extra store to VCPU_HSR, but I don't think that's a big deal.

I left VCPU_HSR as is.

- Mario

> 
> Thanks,
> 
> 	M.
> 
