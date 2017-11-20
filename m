From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH] KVM: arm/arm64: Don't enable/disable physical timer
 access on VHE
Date: Mon, 20 Nov 2017 15:38:02 -0500
Message-ID: <CAHyh4xgxSb97NH6+5WeDxFdan=KVpLcsyO=GeuUGvfrUpuFjrQ@mail.gmail.com>
References: <20171120111637.26215-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120111637.26215-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 20, 2017 at 6:16 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> After the timer optimization rework we accidentally end up calling
> physical timer enable/disable functions on VHE systems, which is neither
> needed nor correct, since the CNTHCTL_EL2 register format is
> different when HCR_EL2.E2H is set.
>
> The CNTHCTL_EL2 is initialized when CPUs become online in
> kvm_timer_init_vhe() and we don't have to call these functions on VHE
> systems, which also allows us to inline the non-VHE functionality.
>
> Reported-by: Jintack Lim <jintack@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Jintack Lim <jintack@cs.columbia.edu>

Thanks,
Jintack

> ---
>  include/kvm/arm_arch_timer.h |  3 ---
>  virt/kvm/arm/arch_timer.c    |  6 ------
>  virt/kvm/arm/hyp/timer-sr.c  | 48 ++++++++++++++++++--------------------------
>  3 files changed, 20 insertions(+), 37 deletions(-)
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 01ee473517e2..6e45608b2399 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -93,7 +93,4 @@ void kvm_timer_init_vhe(void);
>  #define vcpu_vtimer(v) (&(v)->arch.timer_cpu.vtimer)
>  #define vcpu_ptimer(v) (&(v)->arch.timer_cpu.ptimer)
>
> -void enable_el1_phys_timer_access(void);
> -void disable_el1_phys_timer_access(void);
> -
>  #endif
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4151250ce8da..190c99ed1b73 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -479,9 +479,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>
>         vtimer_restore_state(vcpu);
>
> -       if (has_vhe())
> -               disable_el1_phys_timer_access();
> -
>         /* Set the background timer for the physical timer emulation. */
>         phys_timer_emulate(vcpu);
>  }
> @@ -510,9 +507,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>         if (unlikely(!timer->enabled))
>                 return;
>
> -       if (has_vhe())
> -               enable_el1_phys_timer_access();
> -
>         vtimer_save_state(vcpu);
>
>         /*
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index f39861639f08..f24404b3c8df 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -27,42 +27,34 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
>         write_sysreg(cntvoff, cntvoff_el2);
>  }
>
> -void __hyp_text enable_el1_phys_timer_access(void)
> -{
> -       u64 val;
> -
> -       /* Allow physical timer/counter access for the host */
> -       val = read_sysreg(cnthctl_el2);
> -       val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> -       write_sysreg(val, cnthctl_el2);
> -}
> -
> -void __hyp_text disable_el1_phys_timer_access(void)
> -{
> -       u64 val;
> -
> -       /*
> -        * Disallow physical timer access for the guest
> -        * Physical counter access is allowed
> -        */
> -       val = read_sysreg(cnthctl_el2);
> -       val &= ~CNTHCTL_EL1PCEN;
> -       val |= CNTHCTL_EL1PCTEN;
> -       write_sysreg(val, cnthctl_el2);
> -}
> -
>  void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
>  {
>         /*
>          * We don't need to do this for VHE since the host kernel runs in EL2
>          * with HCR_EL2.TGE ==1, which makes those bits have no impact.
>          */
> -       if (!has_vhe())
> -               enable_el1_phys_timer_access();
> +       if (!has_vhe()) {
> +               u64 val;
> +
> +               /* Allow physical timer/counter access for the host */
> +               val = read_sysreg(cnthctl_el2);
> +               val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +               write_sysreg(val, cnthctl_el2);
> +       }
>  }
>
>  void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -       if (!has_vhe())
> -               disable_el1_phys_timer_access();
> +       if (!has_vhe()) {
> +               u64 val;
> +
> +               /*
> +                * Disallow physical timer access for the guest
> +                * Physical counter access is allowed
> +                */
> +               val = read_sysreg(cnthctl_el2);
> +               val &= ~CNTHCTL_EL1PCEN;
> +               val |= CNTHCTL_EL1PCTEN;
> +               write_sysreg(val, cnthctl_el2);
> +       }
>  }
> --
> 2.14.2
>
>
