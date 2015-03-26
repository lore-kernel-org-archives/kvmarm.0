From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 3/6] hw/intc: arm_gic_kvm.c restore config first
Date: Thu, 26 Mar 2015 17:12:48 +0000
Message-ID: <CAFEAcA9vEAMfAEa4z+mH1a7X0+UtjXba6kbVxHUSh4_Xrq4=Ng@mail.gmail.com>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org> <1427130344-27986-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427130344-27986-4-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 March 2015 at 17:05, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> As there is logic to deal with the difference between edge and level
> triggered interrupts in the kernel we must ensure it knows the
> configuration of the IRQs before we restore the pending state.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
> index 0d20750..e2512f1 100644
> --- a/hw/intc/arm_gic_kvm.c
> +++ b/hw/intc/arm_gic_kvm.c
> @@ -370,6 +370,11 @@ static void kvm_arm_gic_put(GICState *s)
>       * the appropriate CPU interfaces in the kernel) */
>      kvm_dist_put(s, 0x800, 8, s->num_irq, translate_targets);
>
> +    /* irq_state[n].trigger -> GICD_ICFGRn
> +     * (restore targets before pending IRQs so we treat level/edge
> +     * correctly */
> +    kvm_dist_put(s, 0xc00, 2, s->num_irq, translate_trigger);

You don't seem to have acted on Christoffer's query in v4
about this comment...

-- PMM
