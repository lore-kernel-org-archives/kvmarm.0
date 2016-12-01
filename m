From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH v2] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Thu, 1 Dec 2016 14:28:19 -0500
Message-ID: <CAHyh4xi3zDRYAWPo6+9=iZY-=SbpGhJggTOb2Lf++66=NB3n+w@mail.gmail.com>
References: <1480592310-26079-1-git-send-email-jintack@cs.columbia.edu>
 <f77698be-d30d-53af-0782-3ef6bea3ba4a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F10C404FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:27:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3shwvNOZYXZP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 14:27:31 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53183404D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:27:30 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uB1JQ1La033295
 for <kvmarm@lists.cs.columbia.edu>; Thu, 1 Dec 2016 14:28:22 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id BE26082
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:28:22 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 6840A80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:28:22 -0500 (EST)
Received: from mail-yw0-f200.google.com (mail-yw0-f200.google.com
 [209.85.161.200])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uB1JSMXg025163
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 1 Dec 2016 14:28:22 -0500
Received: by mail-yw0-f200.google.com with SMTP id t125so257741919ywc.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2016 11:28:22 -0800 (PST)
Received: from mail-yw0-f173.google.com (mail-yw0-f173.google.com.
 [209.85.161.173])
 by smtp.gmail.com with ESMTPSA id i137sm562241ywg.48.2016.12.01.11.28.20
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 01 Dec 2016 11:28:20 -0800 (PST)
Received: by mail-yw0-f173.google.com with SMTP id a10so203600593ywa.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2016 11:28:20 -0800 (PST)
In-Reply-To: <f77698be-d30d-53af-0782-3ef6bea3ba4a@arm.com>
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
Cc: KVM General <kvm@vger.kernel.org>, andre.przywara@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Thu, Dec 1, 2016 at 8:30 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Jintack,
>
> On 01/12/16 11:38, Jintack Lim wrote:
>> Current KVM world switch code is unintentionally setting wrong bits to
>> CNTHCTL_EL2 when E2H == 1, which may allow guest OS to access physical
>> timer.  Bit positions of CNTHCTL_EL2 are changing depending on
>> HCR_EL2.E2H bit.  EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is
>> not set, but they are 11th and 10th bits respectively when E2H is set.
>>
>> In fact, on VHE we only need to set those bits once, not for every world
>> switch. This is because the host kernel runs in EL2 with HCR_EL2.TGE ==
>> 1, which makes those bits have no effect for the host kernel execution.
>> So we just set those bits once for guests, and that's it.
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> ---
>> v2: Skip configuring cnthctl_el2 in world switch path on VHE system.
>> This patch is based on linux-next.
>>
>> ---
>>  arch/arm/kvm/arm.c           |  1 +
>>  include/kvm/arm_arch_timer.h |  1 +
>>  virt/kvm/arm/arch_timer.c    | 23 ++++++++++++++++++++++
>>  virt/kvm/arm/hyp/timer-sr.c  | 45 ++++++++++++++++++++++++++++++++------------
>>  4 files changed, 58 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 8f92efa..38c0645 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -1286,6 +1286,7 @@ static void teardown_hyp_mode(void)
>>
>>  static int init_vhe_mode(void)
>>  {
>> +     on_each_cpu(kvm_timer_init_vhe, NULL, 1);
>
> I'm pretty sure this is not going to work with CPU hotplug, as you only
> perform this once and for all at boot time.
>
> I think it would be better if you called this init function as part of
> cpu_init_hyp_mode().

All right. I'll do that.

>
>>       kvm_info("VHE mode initialized successfully\n");
>>       return 0;
>>  }
>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> index dda39d8..5853399 100644
>> --- a/include/kvm/arm_arch_timer.h
>> +++ b/include/kvm/arm_arch_timer.h
>> @@ -76,4 +76,5 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>
>>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>>
>> +void kvm_timer_init_vhe(void *dummy);
>>  #endif
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index 17b8fa5..7a0d85d7 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -24,6 +24,7 @@
>>
>>  #include <clocksource/arm_arch_timer.h>
>>  #include <asm/arch_timer.h>
>> +#include <asm/kvm_hyp.h>
>>
>>  #include <kvm/arm_vgic.h>
>>  #include <kvm/arm_arch_timer.h>
>> @@ -507,3 +508,25 @@ void kvm_timer_init(struct kvm *kvm)
>>  {
>>       kvm->arch.timer.cntvoff = kvm_phys_timer_read();
>>  }
>> +
>> +/*
>> + * On VHE system, we only need to configure trap on physical timer and counter
>> + * accesses in EL0 and EL1 once, not for every world switch.
>> + * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
>> + * and this makes those bits have no effect for the host kernel execution.
>> + */
>> +void kvm_timer_init_vhe(void *dummy)
>> +{
>> +     /* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
>> +     u32 cnthctl_shift = 10;
>> +     u64 val;
>> +
>> +     /*
>> +      * Disallow physical timer access for the guest.
>> +      * Physical counter access is allowed.
>> +      */
>> +     val = read_sysreg(cnthctl_el2);
>> +     val &= ~(CNTHCTL_EL1PCEN << cnthctl_shift);
>> +     val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>> +     write_sysreg(val, cnthctl_el2);
>> +}
>
> If you make this called from cpu_init_hyp_mode(), it will have to be
> guarded with is_kernel_in_hyp_mode().
>
>> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
>> index 798866a..f7fc957 100644
>> --- a/virt/kvm/arm/hyp/timer-sr.c
>> +++ b/virt/kvm/arm/hyp/timer-sr.c
>> @@ -21,6 +21,18 @@
>>
>>  #include <asm/kvm_hyp.h>
>>
>> +#ifdef CONFIG_ARM64
>> +static inline bool has_vhe(void)
>> +{
>> +     if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
>> +             return true;
>> +
>> +     return false;
>> +}
>> +#else
>> +#define has_vhe()    false
>
> Could this now be moved to asm/virt.h, and maybe replace the current
> implementation of is_kernel_in_hyp_mode? The latter may require some
> more hacking around, so I'm not sure this is worth it.

I can move that to asm/virt.h, but I'll leave is_kernel_in_hyp_mode()
as it is because, as you pointed out in another e-mail,
is_kernel_in_hyp_mode() can be used before setting up the CPU
capabilities (e.g. runs_at_el2()). I'll send out v3 soon.

Thanks,
Jintack

>
>> +#endif
>> +
>>  /* vcpu is already in the HYP VA space */
>>  void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>>  {
>> @@ -35,10 +47,16 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>>       /* Disable the virtual timer */
>>       write_sysreg_el0(0, cntv_ctl);
>>
>> -     /* Allow physical timer/counter access for the host */
>> -     val = read_sysreg(cnthctl_el2);
>> -     val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
>> -     write_sysreg(val, cnthctl_el2);
>> +     /*
>> +      * We don't need to do this for VHE since the host kernel runs in EL2
>> +      * with HCR_EL2.TGE ==1, which makes those bits have no impact.
>> +      */
>> +     if (!has_vhe()) {
>> +             /* Allow physical timer/counter access for the host */
>> +             val = read_sysreg(cnthctl_el2);
>> +             val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
>> +             write_sysreg(val, cnthctl_el2);
>> +     }
>>
>>       /* Clear cntvoff for the host */
>>       write_sysreg(0, cntvoff_el2);
>> @@ -50,14 +68,17 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
>>       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>       u64 val;
>>
>> -     /*
>> -      * Disallow physical timer access for the guest
>> -      * Physical counter access is allowed
>> -      */
>> -     val = read_sysreg(cnthctl_el2);
>> -     val &= ~CNTHCTL_EL1PCEN;
>> -     val |= CNTHCTL_EL1PCTEN;
>> -     write_sysreg(val, cnthctl_el2);
>> +     /* Those bits are already configured at boot on VHE-system */
>> +     if (!has_vhe()) {
>> +             /*
>> +              * Disallow physical timer access for the guest
>> +              * Physical counter access is allowed
>> +              */
>> +             val = read_sysreg(cnthctl_el2);
>> +             val &= ~CNTHCTL_EL1PCEN;
>> +             val |= CNTHCTL_EL1PCTEN;
>> +             write_sysreg(val, cnthctl_el2);
>> +     }
>>
>>       if (timer->enabled) {
>>               write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
>>
>
> Otherwise, this looks good, and the generated code is quite nice.
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
