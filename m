From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 10/10] KVM: arm/arm64: Emulate the EL1 phys timer
 register access
Date: Mon, 30 Jan 2017 12:08:06 -0500
Message-ID: <CAHyh4xhgNYjpyaGz=UtFfC+smh6CVZgJ530WWmwwmpg=Bi799A@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-11-git-send-email-jintack@cs.columbia.edu>
 <86lgtt98gs.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA6340194
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:07:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZsD54Ta4+dwR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 12:07:52 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86A840190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:07:52 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UH5j5A053834
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:08:10 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B894285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:08:10 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id E938A89
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:08:08 -0500 (EST)
Received: from mail-ua0-f198.google.com (mail-ua0-f198.google.com
 [209.85.217.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UH88lv046526
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:08:08 -0500
Received: by mail-ua0-f198.google.com with SMTP id j94so204253528uad.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:08:08 -0800 (PST)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com.
 [209.85.213.41])
 by smtp.gmail.com with ESMTPSA id 31sm5093092uat.27.2017.01.30.09.08.07
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 30 Jan 2017 09:08:07 -0800 (PST)
Received: by mail-vk0-f41.google.com with SMTP id x75so219767211vke.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:08:07 -0800 (PST)
In-Reply-To: <86lgtt98gs.fsf@arm.com>
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
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Sun, Jan 29, 2017 at 10:44 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Fri, Jan 27 2017 at 01:05:00 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>> Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
>> Now VMs are able to use the EL1 physical timer.
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> ---
>>  arch/arm64/kvm/sys_regs.c    | 32 +++++++++++++++++++++++++++++---
>>  include/kvm/arm_arch_timer.h |  2 ++
>>  virt/kvm/arm/arch_timer.c    |  2 +-
>>  3 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index fd9e747..adf009f 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -824,7 +824,14 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>>               struct sys_reg_params *p,
>>               const struct sys_reg_desc *r)
>>  {
>> -     kvm_inject_undefined(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> +     u64 now = kvm_phys_timer_read();
>> +
>> +     if (p->is_write)
>> +             ptimer->cnt_cval = p->regval + now;
>> +     else
>> +             p->regval = ptimer->cnt_cval - now;
>> +
>>       return true;
>>  }
>>
>> @@ -832,7 +839,20 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
>>               struct sys_reg_params *p,
>>               const struct sys_reg_desc *r)
>>  {
>> -     kvm_inject_undefined(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> +
>> +     if (p->is_write) {
>> +             /* ISTATUS bit is read-only */
>> +             ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
>> +     } else {
>> +             u64 now = kvm_phys_timer_read();
>> +
>> +             p->regval = ptimer->cnt_ctl;
>> +             /* Set ISTATUS bit if it's expired */
>> +             if (ptimer->cnt_cval <= now)
>> +                     p->regval |= ARCH_TIMER_CTRL_IT_STAT;
>> +     }
>
> Shouldn't we take the ENABLE bit into account? The ARMv8 ARM version I
> have at hand (version h) seems to indicate that we should, but we should
> check with the latest and greatest...

Thanks! I was not clear about this. I have ARM ARM version k, and it
says that 'When the value of the ENABLE bit is 0, the ISTATUS field is
UNKNOWN.' So I thought the istatus value doesn't matter if ENABLE is
0, and just set istatus bit regardless of ENABLE bit. If this is not
what the manual meant, then I'm happy to fix this.

Thanks,
Jintack

>
>> +
>>       return true;
>>  }
>>
>> @@ -840,7 +860,13 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>>               struct sys_reg_params *p,
>>               const struct sys_reg_desc *r)
>>  {
>> -     kvm_inject_undefined(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> +
>> +     if (p->is_write)
>> +             ptimer->cnt_cval = p->regval;
>> +     else
>> +             p->regval = ptimer->cnt_cval;
>> +
>>       return true;
>>  }
>>
>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> index a364593..fec99f2 100644
>> --- a/include/kvm/arm_arch_timer.h
>> +++ b/include/kvm/arm_arch_timer.h
>> @@ -74,6 +74,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
>>  void kvm_timer_schedule(struct kvm_vcpu *vcpu);
>>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>>
>> +u64 kvm_phys_timer_read(void);
>> +
>>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>>
>>  void kvm_timer_init_vhe(void);
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index b366bb2..9eec063 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -40,7 +40,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>>       vcpu_vtimer(vcpu)->active_cleared_last = false;
>>  }
>>
>> -static u64 kvm_phys_timer_read(void)
>> +u64 kvm_phys_timer_read(void)
>>  {
>>       return timecounter->cc->read(timecounter->cc);
>>  }
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny.
>
