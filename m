From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC 11/55] KVM: arm64: Emulate taking an exception to the guest
 hypervisor
Date: Tue, 6 Jun 2017 19:16:17 -0400
Message-ID: <CAHyh4xhSbtLEEBV3hnEbL9MMeNM0Ykzdu-U7Xj3KFXMCYLfKwg@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-12-git-send-email-jintack@cs.columbia.edu>
 <jpgtw3sdfzw.fsf@linux.bootlegged.copy>
 <CAHyh4xjvqiXDEa9+vDDc4iOVsEHVZyHUEQ5AqQT65E4BV+b0zA@mail.gmail.com>
 <jpglgp4g48k.fsf@linux.bootlegged.copy>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3F840A74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 19:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w2EQg6FkrSmC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 19:12:14 -0400 (EDT)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20DAD40948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 19:12:13 -0400 (EDT)
Received: by mail-oi0-f53.google.com with SMTP id p7so4942489oif.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 16:16:20 -0700 (PDT)
Received: from mail-ot0-f169.google.com (mail-ot0-f169.google.com.
 [74.125.82.169])
 by smtp.gmail.com with ESMTPSA id j7sm251923oih.3.2017.06.06.16.16.18
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 06 Jun 2017 16:16:18 -0700 (PDT)
Received: by mail-ot0-f169.google.com with SMTP id k4so23989127otd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 16:16:18 -0700 (PDT)
In-Reply-To: <jpglgp4g48k.fsf@linux.bootlegged.copy>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bandan Das <bsd@redhat.com>
Cc: lorenzo.pieralisi@arm.com, KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kevin.brodsky@arm.com, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, geoff@infradead.org, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, wcohen@redhat.com, anna-maria@linutronix.de, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 6, 2017 at 6:07 PM, Bandan Das <bsd@redhat.com> wrote:
> Hi Jintack,
>
> Jintack Lim <jintack.lim@linaro.org> writes:
>
>> Hi Bandan,
>>
>> On Tue, Jun 6, 2017 at 4:21 PM, Bandan Das <bsd@redhat.com> wrote:
>>> Jintack Lim <jintack@cs.columbia.edu> writes:
>>>
>>>> Emulate taking an exception to the guest hypervisor running in the
>>>> virtual EL2 as described in ARM ARM AArch64.TakeException().
>>>
>>> ARM newbie here, I keep thinking of ARM ARM as a typo ;)
>>
>> ARM ARM means ARM Architecture Reference Manual :)
>>
>>> ...
>>>> +static inline int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
>>>> +{
>>>> +     kvm_err("Unexpected call to %s for the non-nesting configuration\n",
>>>> +              __func__);
>>>> +     return -EINVAL;
>>>> +}
>>>> +
>>>> +static inline int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +     kvm_err("Unexpected call to %s for the non-nesting configuration\n",
>>>> +              __func__);
>>>> +     return -EINVAL;
>>>> +}
>>>> +
>>>
>>> I see these function stubs for aarch32 in the patches. I don't see how they
>>> can actually be called though. Is this because eventually, there will be
>>> a virtual el2 mode for aarch32 ?
>>
>> Current RFC doesn't support nested virtualization on 32bit arm
>> architecture and those functions will be never called. Those functions
>> are there for the compilation.
>
> Do you mean that compilation will fail ?

Compilation on 32bit arm architecture will fail without them.

> It seems these functions are
> defined separately in 32/64 bit specific header files. Or is it that
> 64 bit compilation also depends on the 32 bit header file ?

It's only for 32bit architecture. For example, kvm_inject_nested_irq()
is called in virt/kvm/arm/vgic/vgic.c which is shared between 32 and
64 bit.

>
> Bandan
>
>> Thanks,
>> Jintack
>>
>>>
>>> Bandan
>>>
>>>>  static inline void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu) { };
>>>>  static inline void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu) { };
>>>>  static inline void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt) { };
>>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>>> index 8892c82..0987ee4 100644
>>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>>> @@ -42,6 +42,25 @@
>>>>  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>>>>  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>>>>
>>>> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
>>>> +int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
>>>> +int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>>>> +#else
>>>> +static inline int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
>>>> +{
>>>> +     kvm_err("Unexpected call to %s for the non-nesting configuration\n",
>>>> +              __func__);
>>>> +     return -EINVAL;
>>>> +}
>>>> +
>>>> +static inline int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +     kvm_err("Unexpected call to %s for the non-nesting configuration\n",
>>>> +              __func__);
>>>> +     return -EINVAL;
>>>> +}
>>>> +#endif
>>>> +
>>>>  void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu);
>>>>  void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu);
>>>>  void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt);
>>>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>>>> index 7811d27..b342bdd 100644
>>>> --- a/arch/arm64/kvm/Makefile
>>>> +++ b/arch/arm64/kvm/Makefile
>>>> @@ -34,3 +34,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>>>> +
>>>> +kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
>>>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>>>> new file mode 100644
>>>> index 0000000..59d147f
>>>> --- /dev/null
>>>> +++ b/arch/arm64/kvm/emulate-nested.c
>>>> @@ -0,0 +1,66 @@
>>>> +/*
>>>> + * Copyright (C) 2016 - Columbia University
>>>> + * Author: Jintack Lim <jintack@cs.columbia.edu>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>> + */
>>>> +
>>>> +#include <linux/kvm.h>
>>>> +#include <linux/kvm_host.h>
>>>> +
>>>> +#include <asm/kvm_emulate.h>
>>>> +
>>>> +#include "trace.h"
>>>> +
>>>> +#define      EL2_EXCEPT_SYNC_OFFSET  0x400
>>>> +#define      EL2_EXCEPT_ASYNC_OFFSET 0x480
>>>> +
>>>> +
>>>> +/*
>>>> + *  Emulate taking an exception. See ARM ARM J8.1.2 AArch64.TakeException()
>>>> + */
>>>> +static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
>>>> +                          int exception_offset)
>>>> +{
>>>> +     int ret = 1;
>>>> +     kvm_cpu_context_t *ctxt = &vcpu->arch.ctxt;
>>>> +
>>>> +     /* We don't inject an exception recursively to virtual EL2 */
>>>> +     if (vcpu_mode_el2(vcpu))
>>>> +             BUG();
>>>> +
>>>> +     ctxt->el2_regs[SPSR_EL2] = *vcpu_cpsr(vcpu);
>>>> +     ctxt->el2_regs[ELR_EL2] = *vcpu_pc(vcpu);
>>>> +     ctxt->el2_regs[ESR_EL2] = esr_el2;
>>>> +
>>>> +     /* On an exception, PSTATE.SP = 1 */
>>>> +     *vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
>>>> +     *vcpu_cpsr(vcpu) |=  (PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT);
>>>> +     *vcpu_pc(vcpu) = ctxt->el2_regs[VBAR_EL2] + exception_offset;
>>>> +
>>>> +     trace_kvm_inject_nested_exception(vcpu, esr_el2, *vcpu_pc(vcpu));
>>>> +
>>>> +     return ret;
>>>> +}
>>>> +
>>>> +int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
>>>> +{
>>>> +     return kvm_inject_nested(vcpu, esr_el2, EL2_EXCEPT_SYNC_OFFSET);
>>>> +}
>>>> +
>>>> +int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +     u64 esr_el2 = kvm_vcpu_get_hsr(vcpu);
>>>> +     /* We supports only IRQ and FIQ, so the esr_el2 is not updated. */
>>>> +     return kvm_inject_nested(vcpu, esr_el2, EL2_EXCEPT_ASYNC_OFFSET);
>>>> +}
>>>> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
>>>> index 7fb0008..7c86cfb 100644
>>>> --- a/arch/arm64/kvm/trace.h
>>>> +++ b/arch/arm64/kvm/trace.h
>>>> @@ -167,6 +167,26 @@
>>>>  );
>>>>
>>>>
>>>> +TRACE_EVENT(kvm_inject_nested_exception,
>>>> +     TP_PROTO(struct kvm_vcpu *vcpu, unsigned long esr_el2,
>>>> +              unsigned long pc),
>>>> +     TP_ARGS(vcpu, esr_el2, pc),
>>>> +
>>>> +     TP_STRUCT__entry(
>>>> +             __field(struct kvm_vcpu *,      vcpu)
>>>> +             __field(unsigned long,          esr_el2)
>>>> +             __field(unsigned long,          pc)
>>>> +     ),
>>>> +
>>>> +     TP_fast_assign(
>>>> +             __entry->vcpu = vcpu;
>>>> +             __entry->esr_el2 = esr_el2;
>>>> +             __entry->pc = pc;
>>>> +     ),
>>>> +
>>>> +     TP_printk("vcpu: %p, inject exception to vEL2: ESR_EL2 0x%lx, vector: 0x%016lx",
>>>> +               __entry->vcpu, __entry->esr_el2, __entry->pc)
>>>> +);
>>>>  #endif /* _TRACE_ARM64_KVM_H */
>>>>
>>>>  #undef TRACE_INCLUDE_PATH
>>> _______________________________________________
>>> kvmarm mailing list
>>> kvmarm@lists.cs.columbia.edu
>>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
