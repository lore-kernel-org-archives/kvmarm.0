From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/5] arm64: KVM: Allow kvm_skip_instr32 to be shared
 between kernel and HYP code
Date: Thu, 1 Sep 2016 13:45:55 +0100
Message-ID: <CAFEAcA-xAd1ghoat-vpudQFepWmPgpVKSM0wyprHTFtr5h4k4w@mail.gmail.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com> <1471610295-1456-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1471610295-1456-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 August 2016 at 13:38, Marc Zyngier <marc.zyngier@arm.com> wrote:
> As we're going to start emulating some instruction while in HYP,
> we need to be able to move the PC forward. Pretty easy for AArch64,
> but quite fidly for AArch32 (think Thumb2 and the IT state).

> +/**
> + * kvm_adjust_itstate - adjust ITSTATE when emulating instructions in IT-block
> + * @vcpu:      The VCPU pointer
> + *
> + * When exceptions occur while instructions are executed in Thumb IF-THEN
> + * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
> + * to do this little bit of work manually. The fields map like this:
> + *
> + * IT[7:0] -> CPSR[26:25],CPSR[15:10]
> + */
> +static inline void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long itbits, cond;
> +       unsigned long cpsr = *vcpu_cpsr(vcpu);
> +       bool is_arm = !(cpsr & COMPAT_PSR_T_BIT);
> +
> +       if (is_arm || !(cpsr & COMPAT_PSR_IT_MASK))
> +               return;
> +
> +       cond = (cpsr & 0xe000) >> 13;
> +       itbits = (cpsr & 0x1c00) >> (10 - 2);
> +       itbits |= (cpsr & (0x3 << 25)) >> 25;
> +
> +       /* Perform ITAdvance (see page A2-52 in ARM DDI 0406C) */
> +       if ((itbits & 0x7) == 0)
> +               itbits = cond = 0;
> +       else
> +               itbits = (itbits << 1) & 0x1f;
> +
> +       cpsr &= ~COMPAT_PSR_IT_MASK;
> +       cpsr |= cond << 13;
> +       cpsr |= (itbits & 0x1c) << (10 - 2);
> +       cpsr |= (itbits & 0x3) << 25;
> +       *vcpu_cpsr(vcpu) = cpsr;
> +}

Does this happen often enough to be worth micro-optimising?
With the code as written we read and then writeback the cond
field into the cpsr most of the time, which you could avoid by
doing the "done with the IT block?" check early:
    if (!(cpsr & 0x06000c00)) {
        cpsr &= ~COMPAT_PSR_IT_MASK;
        return;
    }

I guess the compiler is smart enough to notice that the "& 0x1f"
can be dropped.

thanks
-- PMM
