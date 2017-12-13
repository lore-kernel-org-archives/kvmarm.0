From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Wed, 13 Dec 2017 10:34:27 +0100
Message-ID: <CAMJs5B_Ah3vS48Juri2hbGp46P8tY22S8F0NypAZ4FtHdDFM0g@mail.gmail.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <b2d0234c-e763-d4c1-02f7-c50cd0914b13@arm.com>
 <f0252a5a-cb81-ce24-5d46-f19fce054b13@redhat.com>
 <daece017-50be-494f-4176-6e5f081edfa2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E721149D28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:30:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JwjpTCsK3UEC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 04:30:58 -0500 (EST)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
 [209.85.192.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0BF149D14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:30:57 -0500 (EST)
Received: by mail-pf0-f196.google.com with SMTP id v26so1086200pfl.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 01:34:28 -0800 (PST)
In-Reply-To: <daece017-50be-494f-4176-6e5f081edfa2@arm.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jia He <jia.he@hxt-semitech.com>, Jia He <hejianet@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 13, 2017 at 10:27 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 13/12/17 09:08, Auger Eric wrote:
>> Marc,
>> On 13/12/17 09:56, Marc Zyngier wrote:
>>> Hi Jia,
>>>
>>> On 13/12/17 07:00, Jia He wrote:
>>>> In our Armv8a server (qualcomm Amberwing, non VHE), after applying
>>>> Christoffer's timer optimizing patchset(Optimize arch timer register
>>>> handling), the guest is hang during kernel booting.
>>>>
>>>> The error root cause might be as follows:
>>>> 1. in kvm_arch_timer_handler, it reset vtimer->cnt_ctl with current
>>>> cntv_ctl register value. And then it missed some cases to update timer's
>>>> irq (irq.level) when kvm_timer_irq_can_fire() is false
>>>> 2. It causes kvm_vcpu_check_block return 0 instead of -EINTR
>>>>     kvm_vcpu_check_block
>>>>             kvm_cpu_has_pending_timer
>>>>                     kvm_timer_is_pending
>>>>                             kvm_timer_should_fire
>>>> 3. Thus, the kvm hyp code can not break the loop in kvm_vcpu_block (halt
>>>> poll process) and the guest is hang forever
>>>>
>>>> Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit")
>>>> Signed-off-by: Jia He <jia.he@hxt-semitech.com>
>>>> ---
>>>>  virt/kvm/arm/arch_timer.c | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>> index f9555b1..bb86433 100644
>>>> --- a/virt/kvm/arm/arch_timer.c
>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>> @@ -100,7 +100,6 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>>>>     vtimer = vcpu_vtimer(vcpu);
>>>>
>>>>     if (!vtimer->irq.level) {
>>>> -           vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>>>>             if (kvm_timer_irq_can_fire(vtimer))
>>>>                     kvm_timer_update_irq(vcpu, true, vtimer);
>>>>     }
>>>>
>>>
>>> Which patches are you looking at? The current code in mainline looks
>>> like this:
>>>
>>>      vtimer = vcpu_vtimer(vcpu);
>>>
>>>      vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>>>      if (kvm_timer_irq_can_fire(vtimer))
>>>              kvm_timer_update_irq(vcpu, true, vtimer);
>>>
>>> I'd suggest you use mainline and report if this doesn't work
>> the removal of if (!vtimer->irq.level) test happened in:
>> [PATCH v7 3/8] KVM: arm/arm64: Don't cache the timer IRQ level
>>
>> which is not upstream.
> Ah, my bad (I have that series in my working tree already...).
>
> I still think Jia's approach to this is not quite right. If you don't
> update the status of the timer by reading the HW value, how can you
> decide whether the timer can fire or not?
>

Exactly.  We need to know the exact kernel source, symptoms, how to
reproduce, and then trace what's going on.  It may be needed to tweak
kvm_timer_is_pending(), but I don't yet see a case where it breaks.

Thanks,
-Christoffer
