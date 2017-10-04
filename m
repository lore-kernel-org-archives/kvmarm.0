From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH v2 19/31] KVM: arm64: Describe AT instruction
 emulation design
Date: Wed, 4 Oct 2017 10:13:42 +0100
Message-ID: <7335d045-fb58-3235-fadd-6f6b59304c2b@arm.com>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
 <1507000273-3735-17-git-send-email-jintack.lim@linaro.org>
 <59D3CAF2.2030704@arm.com>
 <CAHyh4xgWaPTYn5C-KZKp-wmkCpZ5A--2iemVV5rfG1Opjk1yJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHyh4xgWaPTYn5C-KZKp-wmkCpZ5A--2iemVV5rfG1Opjk1yJw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>, James Morse <james.morse@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 03/10/17 22:11, Jintack Lim wrote:
> Hi James,
> 
> On Tue, Oct 3, 2017 at 1:37 PM, James Morse <james.morse@arm.com> wrote:
>> Hi Jintack,
>>
>> On 03/10/17 04:11, Jintack Lim wrote:
>>> This design overview will help to digest the subsequent patches that
>>> implement AT instruction emulation.
>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 8d04926..d8728cc 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1621,6 +1621,72 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
>>>       { SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
>>>  };
>>>
>>> +/*
>>> + * AT instruction emulation
>>> + *
>>> + * We emulate AT instructions executed in the virtual EL2.
>>
>>> + * Basic strategy for the stage-1 translation emulation is to load proper
>>> + * context, which depends on the trapped instruction and the virtual HCR_EL2,
>>> + * to the EL1 virtual memory control registers and execute S1E[01] instructions
>>> + * in EL2. See below for more detail.
>>
>> What happens if the guest memory containing some stage1-page-table has been
>> unmapped from stage2? (e.g. its swapped to disk).
>>
>> (there is some background to this: I tried to implement the kvm_translate
>> ioctl() using this approach, running 'at s1e1*' from EL2. I ran into problems
>> when parts of the guest's stage1 page tables had been unmapped from stage2.)
>>
>> From memory, I found that the AT instructions would fault-in those pages when
>> run from EL1, but when executing the same instruction at EL2 they just failed
>> without any hint of which IPA needed mapping in.

Let me see if I follow:

AT S1E1 at EL1 should only generate a fault if the page table walking
itself generates a fault (the guest page tables have been swapped out),
and the fault is taken to EL2. At that point, that's a normal
translation fault, which EL2 can easily resolve and restart the AT
instruction. This is in fact no different from a faulting load/store.

Doing the same thing at EL2 would simply indeed indicate a failed
translation, and not generate a fault, which I think is what you're
observing. After all, it is the hypervisor that unmapped those pages, it
might as well properly track what is happening.

It is a bit of an odd case because the AT here is executed at vEL2
(EL1), and trapped to EL2 because of the NV bits. If it wasn't trapped,
everything would just work. In this case, I can't see any other way but
to walk the S1PT by hand, having put all the other vcpus on hold to
avoid concurrent modifications... Yes, this sucks. If only AT could do
partial walks...

The saving grace is that this only happens in the unmapped S1PT case.
The above can be used as a fallback if the AT S1 from EL2 actually fails.

> I think I haven't encountered this case yet, probably because I
> usually don't set a swap partition.
> 
> In fact, I couldn't find pseudocode for AT instructions. If you
> happened to have one, is that behavior you observed described in ARM
> ARM?

See J1.1.5 in the ARMv8 ARM Rev B.a, and the various comments indicating
how this applies to Address Translation instructions. There is also some
description of what is expected from the AT instructions in D4.2.11.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
