From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Mon, 28 Nov 2016 22:28:18 -0500
Message-ID: <CAHyh4xhXoFWsbnNNePthWp2-ZAOtCuUVmLn-JKRe4sc=nqrYNw@mail.gmail.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
 <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com> <799d03f5-a929-9547-1ae7-94026b76f116@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <799d03f5-a929-9547-1ae7-94026b76f116@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, will.deacon@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, linux@armlinux.org.uk, julien.grall@arm.com, andre.przywara@arm.com, KVM General <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 28, 2016 at 1:39 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 28/11/16 17:43, Marc Zyngier wrote:
>> Hi Jintack,

Hi Marc,

>>
>> On 28/11/16 16:46, Jintack Lim wrote:
>>> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
>>> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
>>> are 11th and 10th bits respectively when E2H is set.  Current code is
>>> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set, which
>>> may allow guest OS to access physical timer. So, fix it.
>>>
>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>> ---
>>>  arch/arm/include/asm/kvm_timer.h     | 33 +++++++++++++++++++
>>>  arch/arm64/include/asm/kvm_timer.h   | 62 ++++++++++++++++++++++++++++++++++++
>>>  include/clocksource/arm_arch_timer.h |  6 ++--
>>>  virt/kvm/arm/hyp/timer-sr.c          |  8 ++---
>>>  4 files changed, 103 insertions(+), 6 deletions(-)
>>>  create mode 100644 arch/arm/include/asm/kvm_timer.h
>>>  create mode 100644 arch/arm64/include/asm/kvm_timer.h
>>>
>
> [...]
>
>> We could make it nicer (read "faster") by introducing a
>> hyp_alternate_select construct that only returns a value instead
>> of calling a function. I remember writing something like that
>> at some point, and dropping it...
>
> So here's what this could look like (warning, wacky code ahead,
> though I fixed a stupid bug that was present in the previous patch).
> The generated code is quite nice (no branch, only an extra mov
> instruction on the default path)... Of course, completely untested!

This looks much cleaner than my patch.
While we are at it, is it worth to consider that we just need to set
those bits once for VHE case, not for every world switch as an
optimization?

>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index b18e852..d173902 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -121,6 +121,17 @@ typeof(orig) * __hyp_text fname(void)                                      \
>         return val;                                                     \
>  }
>
> +#define hyp_alternate_select_const(fname, orig, alt, cond)             \
> +inline const typeof(orig) __hyp_text fname(void)                       \
> +{                                                                      \
> +       typeof(alt) val = orig;                                         \
> +       asm volatile(ALTERNATIVE("nop           \n",                    \
> +                                "mov   %0, %1  \n",                    \
> +                                cond)                                  \
> +                    : "+r" (val) : "r" (alt));                         \
> +       return val;                                                     \
> +}
> +
>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>  int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index 798866a..7a783af 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -21,11 +21,29 @@
>
>  #include <asm/kvm_hyp.h>
>
> +#ifdef CONFIG_ARM64
> +static hyp_alternate_select_const(cnthclt_shift, 0, 10,
> +                                 ARM64_HAS_VIRT_HOST_EXTN)
> +
> +#else
> +#define cnthclt_shift()                (0)
> +#endif
> +
> +static inline void __hyp_text cnthctl_rmw(u32 clr, u32 set)
> +{
> +       u32 val;
> +       int shift = cnthclt_shift();
> +
> +       val = read_sysreg(cnthctl_el2);
> +       val &= ~(clr << shift);
> +       val |= set << shift;
> +       write_sysreg(val, cnthctl_el2);
> +}
> +
>  /* vcpu is already in the HYP VA space */
>  void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>  {
>         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -       u64 val;
>
>         if (timer->enabled) {
>                 timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
> @@ -36,9 +54,7 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>         write_sysreg_el0(0, cntv_ctl);
>
>         /* Allow physical timer/counter access for the host */
> -       val = read_sysreg(cnthctl_el2);
> -       val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> -       write_sysreg(val, cnthctl_el2);
> +       cnthctl_rmw(0, CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN);
>
>         /* Clear cntvoff for the host */
>         write_sysreg(0, cntvoff_el2);
> @@ -48,16 +64,12 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
>  {
>         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -       u64 val;
>
>         /*
>          * Disallow physical timer access for the guest
>          * Physical counter access is allowed
>          */
> -       val = read_sysreg(cnthctl_el2);
> -       val &= ~CNTHCTL_EL1PCEN;
> -       val |= CNTHCTL_EL1PCTEN;
> -       write_sysreg(val, cnthctl_el2);
> +       cnthctl_rmw(CNTHCTL_EL1PCEN, CNTHCTL_EL1PCTEN);
>
>         if (timer->enabled) {
>                 write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>

