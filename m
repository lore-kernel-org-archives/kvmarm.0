From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/4] arm/arm64: KVM: Keep elrsr/aisr in sync with
 software model
Date: Sat, 28 Feb 2015 13:37:48 +0000
Message-ID: <20150228133748.16899e63@arm.com>
References: <1424878582-26397-1-git-send-email-alex.bennee@linaro.org>
	<1424878582-26397-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424878582-26397-5-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 25 Feb 2015 15:36:22 +0000
Alex Benn=C3=A9e <alex.bennee@linaro.org> wrote:

> From: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> There is an interesting bug in the vgic code, which manifests itself
> when the KVM run loop has a signal pending or needs a vmid generation
> rollover after having disabled interrupts but before actually
> switching to the guest.
>=20
> In this case, we flush the vgic as usual, but we sync back the vgic
> state and exit to userspace before entering the guest.  The
> consequence is that we will be syncing the list registers back to the
> software model using the GICH_ELRSR and GICH_EISR from the last
> execution of the guest, potentially overwriting a list register
> containing an interrupt.
>=20
> This showed up during migration testing where we would capture a stat=
e
> where the VM has masked the arch timer but there were no interrupts,
> resulting in a hung test.
>=20
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Reported-by: Alex Bennee <alex.bennee@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Looks OK to me.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 7042251..e2a676e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -114,6 +114,7 @@ struct vgic_ops {
>  	void	(*sync_lr_elrsr)(struct kvm_vcpu *, int, struct
> vgic_lr); u64	(*get_elrsr)(const struct kvm_vcpu *vcpu);
>  	u64	(*get_eisr)(const struct kvm_vcpu *vcpu);
> +	void	(*clear_eisr)(struct kvm_vcpu *vcpu);
>  	u32	(*get_interrupt_status)(const struct kvm_vcpu
> *vcpu); void	(*enable_underflow)(struct kvm_vcpu *vcpu);
>  	void	(*disable_underflow)(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index a0a7b5d..f9b9c7c 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -72,6 +72,8 @@ static void vgic_v2_sync_lr_elrsr(struct kvm_vcpu
> *vcpu, int lr, {
>  	if (!(lr_desc.state & LR_STATE_MASK))
>  		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr |=3D (1ULL <<
> lr);
> +	else
> +		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr &=3D ~(1ULL <<
> lr); }
> =20
>  static u64 vgic_v2_get_elrsr(const struct kvm_vcpu *vcpu)
> @@ -84,6 +86,11 @@ static u64 vgic_v2_get_eisr(const struct kvm_vcpu
> *vcpu) return vcpu->arch.vgic_cpu.vgic_v2.vgic_eisr;
>  }
> =20
> +static void vgic_v2_clear_eisr(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_eisr =3D 0;
> +}
> +
>  static u32 vgic_v2_get_interrupt_status(const struct kvm_vcpu *vcpu)
>  {
>  	u32 misr =3D vcpu->arch.vgic_cpu.vgic_v2.vgic_misr;
> @@ -148,6 +155,7 @@ static const struct vgic_ops vgic_v2_ops =3D {
>  	.sync_lr_elrsr		=3D vgic_v2_sync_lr_elrsr,
>  	.get_elrsr		=3D vgic_v2_get_elrsr,
>  	.get_eisr		=3D vgic_v2_get_eisr,
> +	.clear_eisr		=3D vgic_v2_clear_eisr,
>  	.get_interrupt_status	=3D vgic_v2_get_interrupt_status,
>  	.enable_underflow	=3D vgic_v2_enable_underflow,
>  	.disable_underflow	=3D vgic_v2_disable_underflow,
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index 3a62d8a..dff0602 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -104,6 +104,8 @@ static void vgic_v3_sync_lr_elrsr(struct kvm_vcpu
> *vcpu, int lr, {
>  	if (!(lr_desc.state & LR_STATE_MASK))
>  		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |=3D (1U << lr);
> +	else
> +		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr &=3D ~(1U <<
> lr); }
> =20
>  static u64 vgic_v3_get_elrsr(const struct kvm_vcpu *vcpu)
> @@ -116,6 +118,11 @@ static u64 vgic_v3_get_eisr(const struct
> kvm_vcpu *vcpu) return vcpu->arch.vgic_cpu.vgic_v3.vgic_eisr;
>  }
> =20
> +static void vgic_v3_clear_eisr(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.vgic_cpu.vgic_v3.vgic_eisr =3D 0;
> +}
> +
>  static u32 vgic_v3_get_interrupt_status(const struct kvm_vcpu *vcpu)
>  {
>  	u32 misr =3D vcpu->arch.vgic_cpu.vgic_v3.vgic_misr;
> @@ -192,6 +199,7 @@ static const struct vgic_ops vgic_v3_ops =3D {
>  	.sync_lr_elrsr		=3D vgic_v3_sync_lr_elrsr,
>  	.get_elrsr		=3D vgic_v3_get_elrsr,
>  	.get_eisr		=3D vgic_v3_get_eisr,
> +	.clear_eisr		=3D vgic_v3_clear_eisr,
>  	.get_interrupt_status	=3D vgic_v3_get_interrupt_status,
>  	.enable_underflow	=3D vgic_v3_enable_underflow,
>  	.disable_underflow	=3D vgic_v3_disable_underflow,
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 3b4ded2..3690c1e 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -980,6 +980,11 @@ static inline u64 vgic_get_eisr(struct kvm_vcpu
> *vcpu) return vgic_ops->get_eisr(vcpu);
>  }
> =20
> +static inline void vgic_clear_eisr(struct kvm_vcpu *vcpu)
> +{
> +	vgic_ops->clear_eisr(vcpu);
> +}
> +
>  static inline u32 vgic_get_interrupt_status(struct kvm_vcpu *vcpu)
>  {
>  	return vgic_ops->get_interrupt_status(vcpu);
> @@ -1019,6 +1024,7 @@ static void vgic_retire_lr(int lr_nr, int irq,
> struct kvm_vcpu *vcpu) vgic_set_lr(vcpu, lr_nr, vlr);
>  	clear_bit(lr_nr, vgic_cpu->lr_used);
>  	vgic_cpu->vgic_irq_lr_map[irq] =3D LR_EMPTY;
> +	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  }
> =20
>  /*
> @@ -1063,6 +1069,7 @@ static void vgic_queue_irq_to_lr(struct
> kvm_vcpu *vcpu, int irq, vlr.state |=3D LR_EOI_INT;
> =20
>  	vgic_set_lr(vcpu, lr_nr, vlr);
> +	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  }
> =20
>  /*
> @@ -1258,6 +1265,14 @@ static bool vgic_process_maintenance(struct
> kvm_vcpu *vcpu) if (status & INT_STATUS_UNDERFLOW)
>  		vgic_disable_underflow(vcpu);
> =20
> +	/*
> +	 * In the next iterations of the vcpu loop, if we sync the
> vgic state
> +	 * after flushing it, but before entering the guest (this
> happens for
> +	 * pending signals and vmid rollovers), then make sure we
> don't pick
> +	 * up any old maintenance interrupts here.
> +	 */
> +	vgic_clear_eisr(vcpu);
> +
>  	return level_pending;
>  }
> =20



--=20
Jazz is not dead. It just smells funny.
