From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Wed, 13 Dec 2017 10:08:25 +0100
Message-ID: <f0252a5a-cb81-ce24-5d46-f19fce054b13@redhat.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <b2d0234c-e763-d4c1-02f7-c50cd0914b13@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04AA449D74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:05:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kILMYBY5+QX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 04:04:59 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1563940651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:04:59 -0500 (EST)
In-Reply-To: <b2d0234c-e763-d4c1-02f7-c50cd0914b13@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Jia He <hejianet@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jia He <jia.he@hxt-semitech.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Marc,
On 13/12/17 09:56, Marc Zyngier wrote:
> Hi Jia,
> 
> On 13/12/17 07:00, Jia He wrote:
>> In our Armv8a server (qualcomm Amberwing, non VHE), after applying
>> Christoffer's timer optimizing patchset(Optimize arch timer register
>> handling), the guest is hang during kernel booting.
>>
>> The error root cause might be as follows:
>> 1. in kvm_arch_timer_handler, it reset vtimer->cnt_ctl with current
>> cntv_ctl register value. And then it missed some cases to update timer's
>> irq (irq.level) when kvm_timer_irq_can_fire() is false
>> 2. It causes kvm_vcpu_check_block return 0 instead of -EINTR
>> 	kvm_vcpu_check_block
>> 		kvm_cpu_has_pending_timer
>> 			kvm_timer_is_pending
>> 				kvm_timer_should_fire
>> 3. Thus, the kvm hyp code can not break the loop in kvm_vcpu_block (halt
>> poll process) and the guest is hang forever
>>
>> Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit")
>> Signed-off-by: Jia He <jia.he@hxt-semitech.com>
>> ---
>>  virt/kvm/arm/arch_timer.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index f9555b1..bb86433 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -100,7 +100,6 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>>  	vtimer = vcpu_vtimer(vcpu);
>>  
>>  	if (!vtimer->irq.level) {
>> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>>  		if (kvm_timer_irq_can_fire(vtimer))
>>  			kvm_timer_update_irq(vcpu, true, vtimer);
>>  	}
>>
> 
> Which patches are you looking at? The current code in mainline looks
> like this:
> 
> 	vtimer = vcpu_vtimer(vcpu);
> 
> 	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> 	if (kvm_timer_irq_can_fire(vtimer))
> 		kvm_timer_update_irq(vcpu, true, vtimer);
> 
> I'd suggest you use mainline and report if this doesn't work
the removal of if (!vtimer->irq.level) test happened in:
[PATCH v7 3/8] KVM: arm/arm64: Don't cache the timer IRQ level

which is not upstream.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
