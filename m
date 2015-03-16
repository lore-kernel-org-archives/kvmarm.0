From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 2/5] hw/intc: arm_gic_kvm.c restore config first
Date: Mon, 16 Mar 2015 12:15:59 +0100
Message-ID: <20150316111559.GA26480@cbox>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
 <1426503716-13931-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426503716-13931-3-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 16, 2015 at 11:01:53AM +0000, Alex Benn=E9e wrote:
> As there is logic to deal with the difference between edge and level
> triggered interrupts in the kernel we must ensure it knows the
> configuration of the IRQs before we restore the pending state.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
> index 1ad3eb0..2f21ae7 100644
> --- a/hw/intc/arm_gic_kvm.c
> +++ b/hw/intc/arm_gic_kvm.c
> @@ -370,6 +370,11 @@ static void kvm_arm_gic_put(GICState *s)
>       * the appropriate CPU interfaces in the kernel) */
>      kvm_dist_put(s, 0x800, 8, s->num_irq, translate_targets);
> =20
> +    /* irq_state[n].trigger -> GICD_ICFGRn
> +     * (restore targets before pending IRQs so we treat level/edge

targets? trigger? configurations?

> +     * correctly */
> +    kvm_dist_put(s, 0xc00, 2, s->num_irq, translate_trigger);
> +
>      /* irq_state[n].pending + irq_state[n].level -> GICD_ISPENDRn */
>      kvm_dist_put(s, 0x280, 1, s->num_irq, translate_clear);
>      kvm_dist_put(s, 0x200, 1, s->num_irq, translate_pending);
> @@ -378,8 +383,6 @@ static void kvm_arm_gic_put(GICState *s)
>      kvm_dist_put(s, 0x380, 1, s->num_irq, translate_clear);
>      kvm_dist_put(s, 0x300, 1, s->num_irq, translate_active);
> =20
> -    /* irq_state[n].trigger -> GICD_ICFRn */
> -    kvm_dist_put(s, 0xc00, 2, s->num_irq, translate_trigger);
> =20
>      /* s->priorityX[irq] -> ICD_IPRIORITYRn */
>      kvm_dist_put(s, 0x400, 8, s->num_irq, translate_priority);
> --=20
> 2.3.2
>=20
