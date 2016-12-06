From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH v3] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Tue, 6 Dec 2016 08:28:13 -0500
Message-ID: <CAHyh4xj4=EMkMUJfBCazhThDrNkWt9zZeEbs8X8-NfxG5UX7wg@mail.gmail.com>
References: <1480620725-9864-1-git-send-email-jintack@cs.columbia.edu>
 <49451f06-10a6-4921-eae6-c37a5510197a@arm.com> <20161206121221.GA3681@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161206121221.GA3681@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, linux@armlinux.org.uk, andre.przywara@arm.com, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, james.morse@arm.com, geoff@infradead.org, Suzuki K Poulose <suzuki.poulose@arm.com>, mark.rutland@arm.com, KVM General <kvm@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
Thanks for the review.

On Tue, Dec 6, 2016 at 7:12 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Tue, Dec 06, 2016 at 11:17:40AM +0000, Marc Zyngier wrote:
>> On 01/12/16 19:32, Jintack Lim wrote:
>> > Current KVM world switch code is unintentionally setting wrong bits to
>> > CNTHCTL_EL2 when E2H == 1, which may allow guest OS to access physical
>> > timer.  Bit positions of CNTHCTL_EL2 are changing depending on
>> > HCR_EL2.E2H bit.  EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is
>> > not set, but they are 11th and 10th bits respectively when E2H is set.
>> >
>> > In fact, on VHE we only need to set those bits once, not for every world
>> > switch. This is because the host kernel runs in EL2 with HCR_EL2.TGE ==
>> > 1, which makes those bits have no effect for the host kernel execution.
>> > So we just set those bits once for guests, and that's it.
>> >
>> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> > ---
>> > v2->v3:
>> > - Perform the initialization including CPU hotplug case.
>> > - Move has_vhe() to asm/virt.h
>> >
>> > v1->v2:
>> > - Skip configuring cnthctl_el2 in world switch path on VHE system.
>> > - Write patch based on linux-next.
>> > ---
>> >  arch/arm/include/asm/virt.h   |  5 +++++
>> >  arch/arm/kvm/arm.c            |  3 +++
>> >  arch/arm64/include/asm/virt.h | 10 ++++++++++
>> >  include/kvm/arm_arch_timer.h  |  1 +
>> >  virt/kvm/arm/arch_timer.c     | 23 +++++++++++++++++++++++
>> >  virt/kvm/arm/hyp/timer-sr.c   | 33 +++++++++++++++++++++------------
>> >  6 files changed, 63 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
>> > index a2e75b8..6dae195 100644
>> > --- a/arch/arm/include/asm/virt.h
>> > +++ b/arch/arm/include/asm/virt.h
>> > @@ -80,6 +80,11 @@ static inline bool is_kernel_in_hyp_mode(void)
>> >     return false;
>> >  }
>> >
>> > +static inline bool has_vhe(void)
>> > +{
>> > +   return false;
>> > +}

This is the one called on 32-bit arm.

>> > +
>> >  /* The section containing the hypervisor idmap text */
>> >  extern char __hyp_idmap_text_start[];
>> >  extern char __hyp_idmap_text_end[];
>> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> > index 8f92efa..13e54e8 100644
>> > --- a/arch/arm/kvm/arm.c
>> > +++ b/arch/arm/kvm/arm.c
>> > @@ -1099,6 +1099,9 @@ static void cpu_init_hyp_mode(void *dummy)
>> >     __cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
>> >     __cpu_init_stage2();
>> >
>> > +   if (is_kernel_in_hyp_mode())
>> > +           kvm_timer_init_vhe();
>> > +
>> >     kvm_arm_init_debug();
>> >  }
>> >
>> > diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>> > index fea1073..b043cfd 100644
>> > --- a/arch/arm64/include/asm/virt.h
>> > +++ b/arch/arm64/include/asm/virt.h
>> > @@ -47,6 +47,7 @@
>> >  #include <asm/ptrace.h>
>> >  #include <asm/sections.h>
>> >  #include <asm/sysreg.h>
>> > +#include <asm/cpufeature.h>
>> >
>> >  /*
>> >   * __boot_cpu_mode records what mode CPUs were booted in.
>> > @@ -80,6 +81,15 @@ static inline bool is_kernel_in_hyp_mode(void)
>> >     return read_sysreg(CurrentEL) == CurrentEL_EL2;
>> >  }
>> >
>> > +static inline bool has_vhe(void)
>> > +{
>> > +#ifdef CONFIG_ARM64_VHE
>>
>> Is there a particular reason why this should be guarded by a #ifdef? All
>> the symbols should always be available, and since this is a static key,
>> the overhead should be really insignificant (provided that you use a
>> non-prehistoric compiler...).
>>
>
> Isn't this code called from a file shared between 32-bit arm and arm64?

This code is only for ARM64. See above for 32-bit arm.

> Does the cpus_have_const_cap work on ARM64?
>
> -Christoffer
>

