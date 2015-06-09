From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 04/10] KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
Date: Tue, 09 Jun 2015 14:21:20 +0100
Message-ID: <87sia16mr3.fsf@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1433783045-8002-5-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> Now that struct vgic_lr supports the LR_HW bit and carries a hwirq
> field, we can encode that information into the list registers.
>
> This patch provides implementations for both GICv2 and GICv3.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |  3 +++
>  include/linux/irqchip/arm-gic.h    |  3 ++-
>  virt/kvm/arm/vgic-v2.c             | 16 +++++++++++++++-
>  virt/kvm/arm/vgic-v3.c             | 21 ++++++++++++++++++---
>  4 files changed, 38 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqch=
ip/arm-gic-v3.h
> index ffbc034..cf637d6 100644
<snip>
> @@ -84,10 +88,17 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu,=
 int lr,
>  	 * Eventually we want to make this configurable, so we may revisit
>  	 * this in the future.
>  	 */
> -	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3=
)
> +	switch (vcpu->kvm->arch.vgic.vgic_model) {
> +	case KVM_DEV_TYPE_ARM_VGIC_V3:
>  		lr_val |=3D ICH_LR_GROUP;
> -	else
> -		lr_val |=3D (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
> +		break;
> +	case  KVM_DEV_TYPE_ARM_VGIC_V2:
> +		if (lr_desc.irq < VGIC_NR_SGIS)
> +			lr_val |=3D (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
> +		break;
> +	default:
> +		BUG();
> +	}
> =20
>  	if (lr_desc.state & LR_STATE_PENDING)
>  		lr_val |=3D ICH_LR_PENDING_BIT;
> @@ -95,6 +106,10 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu,=
 int lr,
>  		lr_val |=3D ICH_LR_ACTIVE_BIT;
>  	if (lr_desc.state & LR_EOI_INT)
>  		lr_val |=3D ICH_LR_EOI;
> +	if (lr_desc.state & LR_HW) {
> +		lr_val |=3D ICH_LR_HW;
> +		lr_val |=3D ((u64)lr_desc.hwirq) << ICH_LR_PHYS_ID_SHIFT;
> +	}
>

Why is the bracketing different for the casting of lr_desc.hwirq
compared to lr_desc.source. Surely the precedence of up-casting before
the shift is the same in both cases?

>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] =3D lr_val;
>  }

--=20
Alex Benn=C3=A9e
